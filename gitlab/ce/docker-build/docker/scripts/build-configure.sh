if [ -z "$MAX_REQUESTS_PER_MINUTE" ]; then
	MAX_REQUESTS_PER_MINUTE=120
fi
echo "gitlab_rails['rate_limit_requests_per_period'] = $MAX_REQUESTS_PER_MINUTE" >> /assets/gitlab.rb
