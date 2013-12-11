(function() {
  var Pocket, qs, request;

  qs = require('qs');

  request = require('request');

  Pocket = (function() {
    function Pocket() {}

    Pocket.apiHost = 'https://getpocket.com';

    Pocket.requestTokenUri = '/v3/oauth/request';

    Pocket.authorizeUri = '/auth/authorize';

    Pocket.accessTokenUri = '/v3/oauth/authorize';

    Pocket.init = function(consumer_key, redirect_uri) {
      Pocket.consumer_key = consumer_key;
      return Pocket.redirect_uri = redirect_uri;
    };

    Pocket.getRequestTokenUrl = function() {
      return "" + Pocket.apiHost + Pocket.requestTokenUri;
    };

    Pocket.getAuthorizeUrl = function() {
      return "" + Pocket.apiHost + Pocket.authorizeUri;
    };

    Pocket.getAccessTokenUrl = function() {
      return "" + Pocket.apiHost + Pocket.accessTokenUri;
    };

    return Pocket;

  })();

  module.exports = Pocket;

}).call(this);
