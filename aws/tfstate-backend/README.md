# Using Terraform

_([inside the shell](#run-the-shell))_

**NOTE:** Before provisioning AWS resources with Terraform, you need to create a `tfstate-backend` first. This is an S3 bucket that is used to store the Terraform state and a DynamoDB table for state locking.

You need to do it only once per account during the cold-start.

```bash
make -C /conf/tfstate-backend init
```

After `tfstate-backend` has been provisioned, you can just run `init-terraform` from any project folder to reattach the remote state.

# Bootstrap Process

Perform these steps in each account, the very first time, in order to setup the tfstate bucket. 

## Create

Provision the bucket:
```
make init
```

Follow the instructions at the end. Ensure the environment variables have been set in the `Dockerfile`.
They look something like this:
```
ENV TF_BUCKET="cpco-staging-terraform-state"
ENV TF_BUCKET_REGION="us-west-2"
ENV TF_DYNAMODB_TABLE="cpco-staging-terraform-state-lock"
```

## Destroy

To destroy the state bucket, first make sure all services in the account have already been destroyed. 

Then run:
```
make destroy
```

**NOTE:** This will only work if the state was previously initialized with `force_destroy=true`. If not, set `force_destroy=true`, rerun `terraform apply`, then run `make destroy`.
