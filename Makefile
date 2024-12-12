vault_token := $(shell echo $vault_token)

dev-apply:
    "rm -rf .terraform*",
	terraform init -backend-config=env-dev/state.tfvars
	terraform apply -auto-approve -var-file=env-dev/main.tfvars -var vault_token=$$vault_token

qa-apply:
	terraform init -backend-config=env-qa/state.tfvars
	terraform apply -auto-approve -var-file=env-qa/main.tfvars  -var vault_token=$$vault_token

prod-apply:
	terraform init -backend-config=env-prod/state.tfvars
	terraform apply -auto-approve -var-file=env-prod/main.tfvars  -var vault_token=$$vault_token

dev-destroy:
	terraform init -backend-config=env-dev/state.tfvars
	terraform destroy -auto-approve -var-file=env-dev/main.tfvars -var vault_token=$$vault_token