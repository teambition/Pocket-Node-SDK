qs = require('qs')
request = require('request')
pocket = require('./api')

redirect = (res, ret) ->
  if ret.access_token
    res.cookie 'access_token', ret.access_token
  res.json(ret)
  
authorize = (req, res, next) ->

  requestTokenUrl = pocket.getRequestTokenUrl()
  authorizeUrl = pocket.getAuthorizeUrl()

  request.post(
    headers: {'content-type' : 'application/x-www-form-urlencoded'}
    url: requestTokenUrl
    body: qs.stringify({
      consumer_key: pocket.consumer_key
      redirect_uri: pocket.redirect_uri
    })
  , (err, resp, result) ->
    try
      result = qs.parse(result)
      ri = "#{pocket.redirect_uri}?code=#{result.code}"
      ri += "&state=#{req.query.token}" if req.query.token
      ri = encodeURIComponent(ri)
      url = "#{authorizeUrl}?request_token=#{result.code}&redirect_uri=#{ri}"
      res.redirect(url)
    catch e
      next(e)
  )


authCallback = (req, res, next, options) ->
  request.post(
    headers: {'content-type' : 'application/x-www-form-urlencoded'}
    url: pocket.getAccessTokenUrl()
    body: qs.stringify({
      consumer_key: pocket.consumer_key
      code: req.query.code
    })
    timeout: 10*1000
  , (err, resp, result) ->
    try
      if resp.statusCode isnt 200
        ret = message: result
      else ret = qs.parse(result)
      ret.refer = options.refer
    catch e
      ret = err or e
    options.afterSuccess(ret, req, res, next)
  )


module.exports = (options = {}) ->

  options.authorizeUri or= '/pocket/authorize'
  options.pocketCallback or= '/pocket/callback'
  options.refer or= 'pocket'
  options.afterSuccess or= (ret, req, res) ->
    redirect(res, ret)

  (req, res, next) ->
    switch req.path
      when options.authorizeUri
        authorize(req, res, next)
      when options.pocketCallback
        authCallback(req, res, next, options)
      else next()


