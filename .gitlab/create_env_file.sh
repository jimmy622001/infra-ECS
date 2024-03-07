export TF_VAR_aws_access_key_id=$AWS_ACCESS_KEY_ID
export TF_VAR_aws_secret_access_key=$AWS_SECRET_ACCESS_KEY
export TF_VAR_region=$AWS_DEFAULT_REGION
export TF_VAR_sha1=$CI_COMMIT_SHA
env | grep -e AWS -e TF_VAR > .env.$1
