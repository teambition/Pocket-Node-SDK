# Node SDK for [Pocket](http://getpocket.com)
This is a headless sdk for integrating with pocket app, including add new articles, modify exist articles and fetch articles, etc.

## Install

First, install the pocket sdk with [npm](http://npmjs.org).
```
npm install pocket-sdk
```

## How to use
```
pocket = require('pocket-sdk')

consumer_key = 'your consumer_key'
redirect_uri = 'your redirect_uri'

pocket.init(consumer_key, redirect_uri)

# required access token
pocket.get({
  access_token: access_token
}, (err, ret) ->
  # ret: { status: 1, complete: 1, list: {} ]
)

pocket.add({
  url: '',
  title: '',
  tags: '',
  tweet_id: ''
}, (err, ret) ->
  # ret: { item: {}, status:1 }
)

pocket.send([actions], (err, ret) ->
  # ret: { action_results:[true], status: 1 }
)

```

## Use pocket.oauth middleware

- Supported Options
  - authorizeUri: `/pocket/authorize`
  - pocketCallback: `/pocket/callback`
  - refer: `pocket`
  - afterSuccess: (req, res) ->

```
pocket.init(consumer_key, redirect_uri)

app.configure ->
  app.use(express.bodyParser())
  app.use(express.query())
  app.use(express.cookieParser())
  app.use(app.router)

  app.use(pocket.oauth({
    afterSuccess: (token, req, res, next) ->
        # TODO: callback
        # token: { access_token: '', username: ''}
        pocket.setAccessToken(token.access_token)
        next()
  }))

```
## Develop

First, install module dependencies with `npm install`. If you don't have grunt-cli installed, run `npm install -g grunt-cli`.

Then, whenever you modified the source code in src folder, run `grunt` to compile before use. Or, just run `grunt watch` to let grunt compile the source code automatically when editing.
