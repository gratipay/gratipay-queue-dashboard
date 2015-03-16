#gratipay-queue-dashboard

Please see [this issue](https://github.com/gratipay/inside.gratipay.com/issues/157) as to what this is all about.

#Tech

- Sinatra
- Octokit
- Heroku
- Rspec

#Development

Generate a new access token at <https://github.com/settings/tokens/new> with scope set to:

- repo
- read:org

Keep the generated access token handy

    cp .env.sample .env
    vim .env # Replace the token
    bundle install
    rspec

If everything passes, good. If not, file an issue
