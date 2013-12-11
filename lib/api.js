(function() {
  var Pocket, qs, request;

  qs = require('qs');

  request = require('request');

  Pocket = (function() {
    Pocket.prototype.requestTokenUrl = 'https://getpocket.com/v3/oauth/request';

    Pocket.prototype.authorizeUrl = 'https://getpocket.com/auth/authorize';

    Pocket.prototype.accessTokenUrl = 'https://getpocket.com/v3/oauth/authorize';

    function Pocket(consumer_key, callback) {
      this.consumer_key = consumer_key;
      this.callback = callback;
    }

    Pocket.prototype.authorizeRoute = function(req, res) {
      return this.authorize(function(err, r) {
        if (err) {
          return res.send(err);
        }
        return res.redirect(r.redirect);
      });
    };

    Pocket.prototype.authorize = function(callback) {
      var _this = this;
      return request.post({
        headers: {
          'content-type': 'application/x-www-form-urlencoded'
        },
        url: this.requestTokenUrl,
        body: qs.stringify({
          consumer_key: this.consumer_key,
          redirect_uri: this.callback
        })
      }, function(err, resp, result) {
        var e, ri;
        try {
          result = qs.parse(result);
          ri = encodeURIComponent("" + _this.callback + "?code=" + result.code);
          return callback(null, {
            redirect: "" + _this.authorizeUrl + "?request_token=" + result.code + "&redirect_uri=" + ri
          });
        } catch (_error) {
          e = _error;
          return callback(e);
        }
      });
    };

    Pocket.prototype.getAccessToken = function(code, callback) {
      return request.post({
        headers: {
          'content-type': 'application/x-www-form-urlencoded'
        },
        url: this.accessTokenUrl,
        body: qs.stringify({
          consumer_key: this.consumer_key,
          code: code
        })
      }, function(err, resp, result) {
        var e;
        try {
          return callback(null, qs.parse(result));
        } catch (_error) {
          e = _error;
          return callback(e);
        }
      });
    };

    return Pocket;

  })();

  Pocket.getPocket = function(options) {
    return new Pocket(options.consumer_key, options.callback);
  };

  module.exports = Pocket;

}).call(this);
