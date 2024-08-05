module "vpc" {
  source          = "../modules/vpc"
  region          = var.region
  project_name    = var.project_name
  vpc_cidr        = var.vpc_cidr
  pub_sub_1a_cidr = var.pub_sub_1a_cidr
  pub_sub_2b_cidr = var.pub_sub_2b_cidr
  pri_sub_3a_cidr = var.pri_sub_3a_cidr
  pri_sub_4b_cidr = var.pri_sub_4b_cidr
  pri_sub_5a_cidr = var.pri_sub_5a_cidr
  pri_sub_6b_cidr = var.pri_sub_6b_cidr
}

module "nat" {
  source        = "../modules/nat"
  vpc_id        = module.vpc.vpc_id
  igw_id        = module.vpc.igw_id
  pub_sub_1a_id = module.vpc.pub_sub_1a_id
  pub_sub_2b_id = module.vpc.pub_sub_2b_id
  pri_sub_3a_id = module.vpc.pri_sub_3a_id
  pri_sub_4b_id = module.vpc.pri_sub_4b_id
  pri_sub_5a_id = module.vpc.pri_sub_5a_id
  pri_sub_6b_id = module.vpc.pri_sub_6b_id
}

module "key" {
  source = "../modules/key"
}

module "sg" {
  source = "../modules/security-group"
  vpc_id = module.vpc.vpc_id
}

module "alb" {
  source        = "../modules/alb"
  vpc_id        = module.vpc.vpc_id
  alb_sg_id     = module.sg.alb_sg_id
  project_name  = module.vpc.project_name
  pub_sub_1a_id = module.vpc.pub_sub_1a_id
  pub_sub_2b_id = module.vpc.pub_sub_2b_id
}

module "asg" {
  source        = "../modules/asg"
  project_name  = module.vpc.project_name
  client_sg_id  = module.sg.client_sg_id
  pri_sub_3a_id = module.vpc.pri_sub_3a_id
  pri_sub_4b_id = module.vpc.pri_sub_4b_id
  tg_arn        = module.alb.tg_arn
  key_name      = module.key.key_name
}

module "rds" {
  source        = "../modules/rds"
  db_sg_id      = module.sg.db_sg_id
  pri_sub_5a_id = module.vpc.pri_sub_5a_id
  pri_sub_6b_id = module.vpc.pri_sub_6b_id
  db_username   = var.db_username
  db_password   = var.db_password
}

module "cloudfront" {
  source                  = "../modules/cloudfront"
  certificate_domain_name = var.certificate_domain_name
  alb_domain_name         = module.alb.alb_dns_name
  additional_domain_name  = var.additional_domain_name
  project_name            = module.vpc.project_name
}

module "route53" {
  source                    = "../modules/route53"
  cloudfront_domain_name    = module.cloudfront.cloudfront_domain_name
  cloudfront_hosted_zone_id = module.cloudfront.cloudfront_hosted_zone_id
}