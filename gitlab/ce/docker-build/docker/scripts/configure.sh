#!/bin/bash

GITLAB_API_URL='http://localhost:80/api/v3/'

function strip_quotes()
{
	echo "${1:1:-1}"
}

# Wait till connection can be established
until curl -s -X POST -F login=root -F password="$GITLAB_ROOT_PASSWORD" "$GITLAB_API_URL/session"
do
  echo "Waiting for establishing TCP connection"
  sleep 3
done

# Wait for HTTP OK response
echo "Waiting for HTTP OK response from GitLab"
curl --retry 60 --retry-delay 3 -s -X POST -F login=root -F password="$GITLAB_ROOT_PASSWORD" "$GITLAB_API_URL/session"

# Wait for full initialization
echo "Grace period to allow GitLab to perform full initialization"
sleep 60

# Get token for root user
echo "Get API token for root user"
ROOT_TOKEN=$(strip_quotes `curl -s -X POST -F login=root -F password="$GITLAB_ROOT_PASSWORD" "$GITLAB_API_URL/session" | jq .private_token`)

# Create user
echo "Create user"
GITLAB_USER_ID=`curl -s -X POST --header "PRIVATE-TOKEN: $ROOT_TOKEN" -F email="$GITLAB_DEFAULT_USER_EMAIL" -F username="$GITLAB_DEFAULT_USER_USERNAME" -F password="$GITLAB_DEFAULT_USER_PASSWORD" -F name="$GITLAB_DEFAULT_USER_FULLNAME" -F confirm=false -F projects_limit="$GITLAB_DEFAULT_USER_PROJECT_LIMIT" "$GITLAB_API_URL/users" | jq .id`

# Create group
echo "Create group"
GITLAB_GROUP_ID=`curl -s -X POST --header "PRIVATE-TOKEN: $ROOT_TOKEN" -F name="$GITLAB_DEFAULT_GROUP_NAME" -F path="$GITLAB_DEFAULT_GROUP_PATH" -F description="$GITLAB_DEFAULT_GROUP_DESCRIPTION" "$GITLAB_API_URL/groups" | jq .id`

# Add user to group and make him owner
echo "Add user to group"
curl -s -X POST --header "PRIVATE-TOKEN: $ROOT_TOKEN" -F id="$GITLAB_GROUP_ID" -F user_id="$GITLAB_USER_ID" -F access_level=50 "$GITLAB_API_URL/groups/$GITLAB_GROUP_ID/members"
