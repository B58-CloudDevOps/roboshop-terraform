vault_token := $(shell echo $$vault_token)

dev-apply:
	terraform init -backend-config=env-dev/state.tfvars
	terraform apply -auto-approve -var-file=env-dev/main.tfvars