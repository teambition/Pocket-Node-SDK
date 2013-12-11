qs = require('qs')
request = require('request')
pocket = require('./api')

redirect = (res, url) ->
  res.writeHead(302, {Location: url})
  res.end()

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
      ri = encodeURIComponent("#{pocket.redirect_uri}?code=#{result.code}")
      res.redirect("#{authorizeUrl}?request_token=#{result.code}&redirect_uri=#{ri}")
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
  , (err, resp, result) ->
    return next(result) if resp.statusCode isnt 200

    try
      ret = qs.parse(result)
      ret.refer = options.refer
      req.body.ret = ret
      options.afterSuccess(req, res, (err) ->
        return next(err) if err
        redirect(res, req.headers.referer or '/')
      )
    catch e
      return next(e)
  )


module.exports = auth = (options = {}) ->

  options.authorizeUri or= '/pocket/authorize'
  options.pocketCallback or= '/pocket/callback'
  options.refer or= 'pocket'
  options.afterSuccess or= () ->

  return auth = (req, res, next) ->
    switch req.path
      when options.authorizeUri
        authorize(req, res, next)
      when options.pocketCallback
        authCallback(req, res, next, options)
      else next()


