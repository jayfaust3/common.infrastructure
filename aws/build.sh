#!/usr/bin/env bash
docker-compose -f "docker-compose.yml" up -d --build

echo "Creating S3 Buckets...."

AWS_ACCESS_KEY_ID=fake AWS_SECRET_ACCESS_KEY=fake AWS_DEFAULT_REGION=us-east-1 aws --endpoint-url http://localhost:4566 s3api create-bucket --bucket saint-bucket
AWS_ACCESS_KEY_ID=fake AWS_SECRET_ACCESS_KEY=fake AWS_DEFAULT_REGION=us-east-1 aws --endpoint-url http://localhost:4566 s3api create-bucket --bucket models-bucket
AWS_ACCESS_KEY_ID=fake AWS_SECRET_ACCESS_KEY=fake AWS_DEFAULT_REGION=us-east-1 aws --endpoint-url http://localhost:4566 s3api create-bucket --bucket column-transformers-bucket

echo "S3 Buckets Created"

echo "Creating DynamoDB Tables"

AWS_ACCESS_KEY_ID=fake AWS_SECRET_ACCESS_KEY=fake AWS_DEFAULT_REGION=us-east-1 aws dynamodb --endpoint-url http://localhost:4566 create-table \
--table-name permissions \
--attribute-definitions \
  AttributeName=entity_id,AttributeType=S \
  AttributeName=scope,AttributeType=S \
--key-schema \
  AttributeName=entity_id,KeyType=HASH \
  AttributeName=scope,KeyType=RANGE \
--provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5

AWS_ACCESS_KEY_ID=fake AWS_SECRET_ACCESS_KEY=fake AWS_DEFAULT_REGION=us-east-1 aws dynamodb --endpoint-url http://localhost:4566 create-table \
--table-name saints \
--attribute-definitions \
  AttributeName=partitionKey,AttributeType=S \
  AttributeName=sortKey,AttributeType=S \
--key-schema \
  AttributeName=partitionKey,KeyType=HASH \
  AttributeName=sortKey,KeyType=RANGE \
--provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5 \
--stream-specification \
  StreamViewType=NEW_AND_OLD_IMAGES,StreamEnabled=true

# If the container restarts the stream is deleted, toggling stream off and back on on the table rebuilds it
# AWS_ACCESS_KEY_ID=fake AWS_SECRET_ACCESS_KEY=fake AWS_DEFAULT_REGION=us-east-1 aws dynamodb --endpoint-url http://localhost:4566 update-table \
# --table-name saints \
# --stream-specification \
#   StreamEnabled=false

# AWS_ACCESS_KEY_ID=fake AWS_SECRET_ACCESS_KEY=fake AWS_DEFAULT_REGION=us-east-1 aws dynamodb --endpoint-url http://localhost:4566 update-table \
# --table-name saints \
# --stream-specification \
#   StreamViewType=NEW_AND_OLD_IMAGES,StreamEnabled=true

# handy commands

# AWS_ACCESS_KEY_ID=fake AWS_SECRET_ACCESS_KEY=fake AWS_DEFAULT_REGION=us-east-1 aws dynamodbstreams --endpoint-url http://localhost:4566 list-streams

# AWS_ACCESS_KEY_ID=fake AWS_SECRET_ACCESS_KEY=fake AWS_DEFAULT_REGION=us-east-1 aws dynamodb --endpoint-url http://localhost:4566 delete-table \
# --table-name saints

# AWS_ACCESS_KEY_ID=fake AWS_SECRET_ACCESS_KEY=fake AWS_DEFAULT_REGION=us-east-1 aws dynamodb --endpoint-url http://localhost:4566 list-tables

echo "DynamoDB Tables Created"

# Redshift

# echo "Creating Redshift Cluster"

# AWS_ACCESS_KEY_ID=fake AWS_SECRET_ACCESS_KEY=fake AWS_DEFAULT_REGION=us-east-1 aws redshift --endpoint-url http://localhost:4566 create-cluster \
# --node-type dc2.large --cluster-identifier analytics-cluster --db-name analytics --master-username adminuser --master-user-password Password%1

# echo "Redshift Cluster Created"

# echo "Creating Redshift Table(s)"

# CLUSTER_IDENTIFIER="analytics-cluster"
# DATABASE_NAME="analytics"
# SCHEMA_NAME="saint"
# TABLE_NAME="saint_lake"
# TABLE_DEFINITION="(
#   system_id BIGINT IDENTITY(1,1) PRIMARY KEY,
#   id VARCHAR(24) NOT NULL,
#   created_date TIMESTAMP NOT NULL,
#   modified_date TIMESTAMP NOT NULL,
#   active BOOL NOT NULL,
#   name VARCHAR(100) NOT NULL,
#   year_of_birth INT NOT NULL,
#   year_of_death INT NOT NULL,
#   region VARCHAR(100) NOT NULL,
#   martyred BOOL NOT NULL,
#   notes TEXT NULL,
#   has_avatar BOOL NOT NULL
# );"

# AWS_ACCESS_KEY_ID=fake AWS_SECRET_ACCESS_KEY=fake AWS_DEFAULT_REGION=us-east-1 aws redshift-data --endpoint-url http://localhost:4566 execute-statement \
# --cluster-identifier $CLUSTER_IDENTIFIER \
# --database $DATABASE_NAME \
# --sql "CREATE TABLE IF NOT EXISTS $SCHEMA_NAME.$TABLE_NAME $TABLE_DEFINITION" \
# --debug

# echo "Redshift Table(s) Created"
