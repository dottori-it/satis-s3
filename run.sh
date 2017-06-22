#!/bin/sh
set -e

## Download the existing repo from S3
aws s3 sync s3://$S3_BUCKET/$S3_PATH /build/output
rm /build/output/include/*

## Rebuild the repo
if [ ! -z "$GITHUB_AUTH" ]; then
	echo "Configuring Composer GitHub auth..."
	composer config -g github-oauth.github.com "$GITHUB_AUTH"
fi
/bin/sh /satis/bin/docker-entrypoint.sh build /build/satis.json /build/output

## Purge unused package files
## TODO: decide when enabling satis purge (https://github.com/composer/satis#purge)
# php /satis/bin/satis purge /build/satis.json /build/output

## Push it back to S3
aws s3 sync --delete /build/output s3://$S3_BUCKET/$S3_PATH