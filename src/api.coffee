
qs = require('qs')
request = require('request')

class Pocket

  apiHost: 'https://getpocket.com'
  requestTokenUri: '/v3/oauth/request'
  authorizeUri: '/auth/authorize'
  accessTokenUri: '/v3/oauth/authorize'
  retrieveUri: '/v3/get'
  addUri: '/v3/add'
  modifyUri: '/v3/send'

  constructor: (consumer_key, redirect_uri) ->
    @consumer_key = consumer_key
    @redirect_uri = redirect_uri

  getUrl: (apiType) ->
    return "#{@apiHost}#{@["#{apiType}Uri"]}"

  getRequestTokenUrl: ->
    return @getUrl("requestToken")

  getAuthorizeUrl: ->
    return @getUrl("authorize")

  getAccessTokenUrl: ->
    return @getUrl("accessToken")

  # state	string		See below for valid values
  # favorite	0 or 1		See below for valid values
  # tag	string		See below for valid values
  # contentType	string		See below for valid values
  # sort	string		See below for valid values
  # detailType	string		See below for valid values
  # search	string		Only return items whose title or url contain the search string
  # domain	string		Only return items from a particular domain
  # since	timestamp		Only return items modified since the given since unix timestamp
  # count	integer		Only return count number of items
  # offset	integer		Used only with count; start returning from offset position of results
  get: (conditions = {}, callback = ->) ->

    if typeof conditions is 'function'
      callback = conditions
      conditions = {}

    conditions.consumer_key = @consumer_key

    unless conditions.access_token
      throw new Error("access_token is required")

    url = makeUrl(@getUrl('retrieve'), conditions)
    request.get(url, (err, resp, ret) ->
      try
        ret = JSON.parse(ret)
      catch e
        err or= e

      callback(err, ret)
    )

  # url	string		The URL of the item you want to save
  # title	string	optional	This can be included for cases where an item does not have a title, which is typical for image or PDF URLs. If Pocket detects a title from the content of the page, this parameter will be ignored.
  # tags	string	optional	A comma-separated list of tags to apply to the item
  # tweet_id	string	optional	If you are adding Pocket support to a Twitter client, please send along a reference to the tweet status id. This allows Pocket to show the original tweet alongside the article.
  # consumer_key	string		Your application's Consumer Key
  # access_token	string		The user's Pocket access token
  add: (data = {}, callback = ->) ->

    data.consumer_key = @consumer_key

    request.post(
      headers: {'content-type' : 'application/x-www-form-urlencoded'}
      url: @getUrl('add')
      body: qs.stringify(data)
    , (err, resp, ret) ->
      try
        ret = JSON.parse(ret)
      catch e
        err or= e
      callback(null, {})
    )

  # consumer_key	string		Your application's Consumer Key
  # access_token	string		The user's Pocket access token
  # actions	array		JSON array of actions. See below for details
  #   Basic Actions
  #    add - Add a new item to the user's list
  #    archive - Move an item to the user's archive
  #    readd - Re-add (unarchive) an item to the user's list
  #    favorite - Mark an item as a favorite
  #    unfavorite - Remove an item from the user's favorites
  #    delete - Permanently remove an item from the user's account
  #   Tagging Actions
  #    tags_add - Add one or more tags to an item
  #    tags_remove - Remove one or more tags from an item
  #    tags_replace - Replace all of the tags for an item with one or more provided tags
  #    tags_clear - Remove all tags from an item
  #    tag_rename - Rename a tag; this affects all items with this tag
  send: (data, callback = ->) ->

    {actions, access_token} = data
    url = makeUrl(@getUrl('modify'), {consumer_key: @consumer_key, access_token: access_token})
    url += '&actions=' + encodeURIComponent(JSON.stringify(actions))
    request.get(url, (err, resp, ret) ->
      try
        ret = JSON.parse(ret)
      catch e
        err or= e
      callback(null, {})
    )

makeUrl = (prefix, query) ->
  query = qs.stringify(query) if typeof query isnt 'string'
  "#{prefix}?#{query}"

extend = (a, b) ->
  for key, val of b
    a[key] = val
  return a


pocket = new Pocket
pocket.Pocket = Pocket
pocket.init = (consumer_key, redirect_uri) ->
  unless consumer_key
    throw new Error("consumer_key is required")
  pocket.consumer_key = consumer_key
  pocket.redirect_uri = redirect_uri

module.exports = pocket