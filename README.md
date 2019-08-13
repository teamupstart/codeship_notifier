![Alt text](https://cloud.githubusercontent.com/assets/599844/11598476/e95d8e32-9a76-11e5-8596-7439ae5f5170.png)

Codeship API docs: https://codeship.com/documentation/integrations/api/

Github API (Status): https://developer.github.com/v3/repos/statuses/

Whomever uses it, will need to:

1 - Set the current environment variables with proper values:
- CODESHIP_API_KEY
- GITHUB_ACCESS_KEY
- GITHUB_WEBHOOK_SECRET

2 - Will have to config github to send a webhook to the server running this app (so this app knows when to add the notification in github)

3 - Set codeship's webhook to ping this app after a build finishes (so this app know when to update the status in github)
