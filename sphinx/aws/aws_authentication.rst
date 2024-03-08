AWS Authentication
###########################


Notes to be Organized and Completed
---------------------------------------

Authentication
.........................

* Give EC2 instance a role, access to S3, etc, NOT an AWS key, pass instance profile
  (contains role, role contains privileges. Role must have permission to read secret)
* Role, create

  * What kind of thing, service, i.e. EC2, lambda, SAML assertion?
  * What permissions?  Can use or edit AWS managed permissions policy, What can it do,
    JSON defines,
  * Trust relationship, AssumeRole
  * User can get roles through Group or permission/policy document directly
  * Access Advisor - see what has been used or not, and pare down the permissions

* Security group (ports, inbound, outbound)

  * Can include all traffic from another SG, need to do that for both SGs

* Parameter store (cheaper) stores less secret info, define config for a project,
  need read parameter policy on the role using it, no additional charge for standard
  parameters, up to 10k, less than 4k,

  * Secure parameters , will encrypt them, can use KMS key, need to add to your policy doc
  * Can make public parameters

* Secrets - 0.40/mo per secret 0.05/10,000 accesses
* Temporary credentials with IAM Roles?  Vs Access keys for long-term access?
* Identities = AWS resources (EC2 instance, lambda functions)
* Secrets for roles/identities for initiating contact/processes

  * https://docs.aws.amazon.com/secretsmanager/latest/userguide/hardcoded.html
  * APIkey/secret, user/password, private key, token, certificate …
  * Create a role to manage the secrets
  * Create a role to retrieve secrets - grant the role permission to access only select
    secrets, give that role to the code/process of interest

Questions remaining
---------------------------------------
* Roles for “workload”
* Travis: How to assign broad privileges to a process, run it, then identify the minimum
  privileges it needs?
* Temporary access roles vs static
* Access Control ???