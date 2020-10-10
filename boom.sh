#!/bin/bash

#drop this into your docker image using a COPY in your dockerfile
#docker run -it -v /mnt/c/Users/paul_bryant/source/cloudsploit-dev/cs-volume:/tmp cloudsploit-aws-image:latest /bin/bash

set -ex

OUTFILE=~/.aws/credentials

CREDENTIALSFILE=creds.txt

setVarsFunction() {
   ACCOUNT=$(echo "$line" | awk '{print$1}')
   AWS_ACCESS_KEY_ID="$(read -ra PARTS <<< "${line}" && echo "${PARTS[1]}")"
   AWS_SECRET_ACCESS_KEY="$(read -ra PARTS <<< "${line}" && echo "${PARTS[2]}")"
   echo "$ACCOUNT"
   echo "$AWS_ACCESS_KEY_ID"
   echo "$AWS_SECRET_ACCESS_KEY"
}

generateAwsCredentialsFunction() {
	tee $OUTFILE <<EOF 
[default]
aws_access_key_id = $AWS_ACCESS_KEY_ID
aws_secret_access_key = $AWS_SECRET_ACCESS_KEY
region = us-west-2
output = json
EOF
}

cloudsploitRunFunction() {
	./index.js --csv="$ACCOUNT".csv --json="$ACCOUNT".json --junit="$ACCOUNT".xml --console=text
}

main() {
	while read -r line; do
		setVarsFunction
		generateAwsCredentialsFunction
	done <$CREDENTIALSFILE
}

main
