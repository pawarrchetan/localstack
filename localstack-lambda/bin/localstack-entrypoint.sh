#!/usr/bin/env bash
printf "Configuring localstack components..."

readonly LOCALSTACK_S3_URL=http://localhost:4566
readonly LOCALSTACK_SQS_URL=http://localhost:4566

sleep 5;

set -x

aws configure set default.region us-east-1
aws configure set region us-east-1 --profile localstack

#Backup aws configs
cp ~/.aws/config ~/.aws/config-bkp
cp ~/.aws/credentials ~/.aws/credentials-bkp

echo "[localstack]" >> ~/.aws/credentials
echo "aws_access_key_id = foo" >> ~/.aws/credentials
echo "aws_secret_access_key = bar" >> ~/.aws/credentials

echo "[localstack]" >> ~/.aws/config
echo "region = us-east-1" >> ~/.aws/config
echo "output = json" >> ~/.aws/config

aws --endpoint $LOCALSTACK_SQS_URL sqs create-queue --queue-name blockchain-local-engine-cancel --profile localstack
aws --endpoint $LOCALSTACK_SQS_URL sqs create-queue --queue-name blockchain-local-engine-input.fifo --attributes FifoQueue=true,MessageGroupId=blockchain --profile localstack
aws --endpoint $LOCALSTACK_SQS_URL sqs create-queue --queue-name blockchain-local-engine-output.fifo --attributes FifoQueue=true,MessageGroupId=blockchain --profile localstack
aws --endpoint-url=$LOCALSTACK_S3_URL s3api create-bucket --bucket blockchain-s3-local-bitcoin --profile localstack
aws --endpoint-url=$LOCALSTACK_S3_URL s3api create-bucket --bucket blockchain-s3-local-ziliqa --profile localstack
aws --endpoint-url=$LOCALSTACK_S3_URL s3api create-bucket --bucket blockchain-s3-local-xrp --profile localstack
aws --endpoint-url=$LOCALSTACK_S3_URL s3api create-bucket --bucket blockchain-s3-local-ada --profile localstack
aws --endpoint-url=$LOCALSTACK_S3_URL s3api create-bucket --bucket blockchain-s3-local-eth --profile localstack
aws --endpoint-url=$LOCALSTACK_S3_URL s3api create-bucket --bucket nyc-tlc --profile localstack

printf "Sample data begin..."
# create tmp directory to put sample data after chunking
mkdir -p /tmp/localstack/data
# aws s3 cp --debug "s3://nyc-tlc/trip data/yellow_tripdata_2018-04.csv" /tmp/localstack --no-sign-request --region us-east-1
aws --endpoint-url=$LOCALSTACK_S3_URL s3api create-bucket --bucket nyc-tlc  --profile localstack
# Create lambda deploy bucket for our simple http endpoint example
aws --endpoint-url=$LOCALSTACK_S3_URL s3api create-bucket --bucket simple-http-endpoint-local-deploy --profile localstack
# Grant bucket public read
aws --endpoint-url=$LOCALSTACK_S3_URL s3api put-bucket-acl --bucket nyc-tlc --acl public-read --profile localstack
aws --endpoint-url=$LOCALSTACK_S3_URL s3api put-bucket-acl --bucket simple-http-endpoint-local-deploy --acl public-read --profile localstack
# Create a folder inside the bucket
aws --endpoint-url=$LOCALSTACK_S3_URL s3api put-object --bucket nyc-tlc --key "trip data/" --profile localstack
aws --endpoint-url=$LOCALSTACK_S3_URL s3 sync /tmp/localstack "s3://nyc-tlc/trip data" --cli-connect-timeout 0 --profile localstack
# Display bucket content
aws --endpoint-url=$LOCALSTACK_S3_URL s3 ls "s3://nyc-tlc/trip data" --profile localstack

set +x

# This is the localstack dashboard, its pretty useless so get ready to learn how to use AWS Cli well!
printf "Localstack dashboard : http://localhost:8080/#!/infra"