# Overview
Sample to work with Serverless framework locally using localstack

## Pre-requisites

* node 12 or later
* python 3
* aws cli
* [Install localstack](https://github.com/localstack/localstack#installing)
* docker (Docker Desktop for Mac)
* serverless framework

## How to use ?

* Clone the repository
```
git clone https://github.com/pawarrchetan/localstack.git
```

* Change directory to `localstack-s3`
```
cd localstack-lambda
```

* Start localstack container using `docker-compose`
```
TMPDIR=/private$TMPDIR docker-compose up -d
```

* Install the required packages
```
yarn --ignore-scripts
```

* Create the pre-requsite resources for the serverless deployment
```
chmod +x ./bin/localstack-entrypoint.sh
./bin/localstack-enrtypoint.sh
```

* Deploy the serverless stack to the localstack
```
serverless deploy --stage local  --profile localstack
```

* You can check the invocation of the localstack deployed lambda function using 
```
serverless invoke --function currentTime --log --profile localstack --stage local
```

## References

* [Localstack](https://github.com/localstack/localstack)