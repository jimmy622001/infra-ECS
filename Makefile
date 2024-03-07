.DEFAULT_GOAL := help

########################################################################################################################
## Constants
########################################################################################################################

DOCKER_IMAGE = public.ecr.aws/t9z0a2g1/nc/infrastructure-runner:latest
REMOTE_STATE_S3_BUCKET = risklick-ch-terraform-state
INFRA_WORKING_DIR = /infra
SERVICE_NAME = infrastructure

.PHONY: docker.shell init plan deploy

########################################################################################################################
## Docker commands
########################################################################################################################

docker.shell: ## Start the infrastructure Docker container and open an interactive shell
	docker run --env-file .env.$(environment) -v $(PWD):/terraform -it $(DOCKER_IMAGE) /bin/sh

.PHONY docker.remove_containers:
docker.remove_containers: ## Remove stopped Docker containers
	docker rm $(shell docker ps -a -q)

.PHONY docker.remove_images:
docker.remove_images: ## Remove all unused Docker images without force
	docker rmi $(shell docker images -q)

########################################################################################################################
## Terraform commands
########################################################################################################################

init: ## Run Terraform init for the specified environment/layer
	docker run --net=host \
		--env-file .env.$(environment) \
        -v $(PWD):/terraform \
        -i $(DOCKER_IMAGE) \
        sh -c 'cd /terraform/infra/layers/$(layer) && \
			terraform init -input=false \
				-backend-config='bucket=$(REMOTE_STATE_S3_BUCKET)' \
				-backend-config='key=$(SERVICE_NAME)/$(environment)/terraform-$(layer).tfstate' \
				-backend-config='region=eu-west-1' \
		        -force-copy'

plan: ## Run Terraform plan for the specified environment/layer
ifeq ($(destroy), true)
	$(eval DESTROY_FLAG := -destroy)
else
	$(eval DESTROY_FLAG := )
endif
ifeq ($(layer), common)
	$(eval COMMAND := terraform plan $(DESTROY_FLAG) -out=infrastructure.tf.plan)
else
	$(eval COMMAND := terraform plan $(DESTROY_FLAG) -out=infrastructure.tf.plan --var-file=../../variables/$(environment)/$(layer).tfvars)
endif
	docker run --net=host \
			-e TF_VAR_s3_bucket_prefix='$(SERVICE_NAME)' \
    		--env-file .env.$(environment) \
            -v $(PWD):/terraform \
            -i $(DOCKER_IMAGE) \
            sh -c 'cd /terraform/infra/layers/$(layer) && $(COMMAND)'

apply: ## Run Terraform apply for the specified environment/layer
ifndef GITLAB_CI
	$(error This command can not be executed locally and must only be run by Gitlab)
endif
ifeq ($(destroy), true)
	$(eval DESTROY_FLAG := -destroy)
else
	$(eval DESTROY_FLAG := )
endif
	docker run --net=host \
			-e TF_VAR_s3_bucket_prefix='$(SERVICE_NAME)' \
    		--env-file .env.$(environment) \
            -v $(PWD):/terraform \
            -i $(DOCKER_IMAGE) \
            sh -c 'cd /terraform/infra/layers/$(layer) && terraform apply $(DESTROY_FLAG) -auto-approve infrastructure.tf.plan && rm -rf infrastructure.tf.plan'

deploy: init plan apply ## Deploy Terraform layer for the specified environment
