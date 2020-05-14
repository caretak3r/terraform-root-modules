####Create a Terraform Remote State Bucket and bootstrap your account

Although we will use Terraform to create the remote state bucket, the state used for the composition root which creates it will not be managed with remote state, since a chicken-and-egg problem exists. Instead, we will abandon this state by writing it to /dev/null - also protecting against rogue accidental terraform destroy operations which could be catastrophic for future management.

It is worth nothing that Terraform Enterprise does not require this step, since it manages state storage internally.