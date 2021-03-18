# Overview
Sample to work with S3 locally using localstack

## Pre-requisites

* node 12 or later
* python 3
* aws cli
* [Install localstack](https://github.com/localstack/localstack#installing)
* docker (Docker Desktop for Mac)

## How to use ?

* Clone the repository
```
git clone https://github.com/pawarrchetan/localstack.git
```

* Change directory to `localstack-s3`
```
cd localstack-s3
```

* Start localstack container using `docker-compose`
```
TMPDIR=/private$TMPDIR docker-compose up -d
```

* Install the required packages
```
yarn --ignore-scripts
```

* Create a local S3 bucket
```
aws --endpoint-url=http://localhost:4566 s3 mb s3://demo-bucket
```

* Push the image file to the S3 bucket
```
node test-ipload.js
```

* Check the uploaded file in the local S3 bucket
```
aws --endpoint-url=http://localhost:4566 s3 ls s3://demo-bucket/
```

## References

* [Localstack](https://github.com/localstack/localstack)