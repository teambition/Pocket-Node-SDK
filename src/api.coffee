
class Pocket

  @apiHost: 'https://getpocket.com'
  @requestTokenUri: '/v3/oauth/request'
  @authorizeUri: '/auth/authorize'
  @accessTokenUri: '/v3/oauth/authorize'

  @init: (consumer_key, redirect_uri) ->
    Pocket.consumer_key = consumer_key
    Pocket.redirect_uri = redirect_uri

  @getRequestTokenUrl: ->
    return "#{Pocket.apiHost}#{Pocket.requestTokenUri}"

  @getAuthorizeUrl: ->
    return "#{Pocket.apiHost}#{Pocket.authorizeUri}"

  @getAccessTokenUrl: ->
    return "#{Pocket.apiHost}#{Pocket.accessTokenUri}"

module.exports = Pocket