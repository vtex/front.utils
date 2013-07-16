(function() {
  var utils,
    __hasProp = {}.hasOwnProperty,
    __slice = [].slice;

  utils = {
    formatCurrency: function(value, options) {
      var decimalPart, decimalSeparator, thousandsSeparator, wholePart, _ref;
      if (options == null) {
        options = {};
      }
      value = this._fixValue(value, options);
      decimalSeparator = options.decimalSeparator || this._getDecimalSeparator();
      thousandsSeparator = options.thousandsSeparator || this._getThousandsSeparator();
      _ref = value.split('.'), wholePart = _ref[0], decimalPart = _ref[1];
      wholePart = wholePart.replace(/\B(?=(\d{3})+(?!\d))/g, thousandsSeparator);
      return wholePart + decimalSeparator + decimalPart;
    },
    intAsCurrency: function(value, options) {
      if (options == null) {
        options = {};
      }
      return (options.currencySymbol || this._getCurrencySymbol()) + utils.formatCurrency(value / 100, options);
    },
    pad: function(str, max) {
      if ((str + "").length >= max) {
        return str;
      }
      return utils.pad("0" + str, max);
    },
    readCookie: function(name) {
      var ARRcookies, key, pair, value, _i, _len;
      ARRcookies = document.cookie.split(";");
      for (_i = 0, _len = ARRcookies.length; _i < _len; _i++) {
        pair = ARRcookies[_i];
        key = pair.substr(0, pair.indexOf("=")).replace(/^\s+|\s+$/g, "");
        value = pair.substr(pair.indexOf("=") + 1);
        if (key === name) {
          return unescape(value);
        }
      }
    },
    getCookieValue: function(cookie, name) {
      var key, subcookie, subcookies, value, _i, _len;
      subcookies = cookie.split("&");
      for (_i = 0, _len = subcookies.length; _i < _len; _i++) {
        subcookie = subcookies[_i];
        key = subcookie.substr(0, subcookie.indexOf("="));
        value = subcookie.substr(subcookie.indexOf("=") + 1);
        if (key === name) {
          return unescape(value);
        }
      }
    },
    urlParams: function() {
      var decode, match, params, pl, query, search;
      params = {};
      match = void 0;
      pl = /\+/g;
      search = /([^&=]+)=?([^&]*)/g;
      decode = function(s) {
        return decodeURIComponent(s.replace(pl, " "));
      };
      query = window.location.search.substring(1);
      while (match = search.exec(query)) {
        params[decode(match[1])] = decode(match[2]);
      }
      return params;
    },
    dateFromISO8601: function(isostr) {
      var part1, parts;
      parts = isostr.match(/\d+/g);
      part1 = parts[1] - 1;
      return new Date(parts[0], part1, parts[2], parts[3], parts[4], parts[5]);
    },
    capitalizeWord: function(word) {
      if (word == null) {
        word = '';
      }
      return word.charAt(0).toUpperCase() + word.slice(1);
    },
    capitalize: function(word) {
      if (word == null) {
        word = '';
      }
      return capitalizeWord(word);
    },
    capitalizeSentence: function(sentence) {
      var newWords, oldWords, word;
      if (sentence == null) {
        sentence = '';
      }
      oldWords = sentence.toLowerCase().split(' ');
      newWords = (function() {
        var _i, _len, _results;
        _results = [];
        for (_i = 0, _len = oldWords.length; _i < _len; _i++) {
          word = oldWords[_i];
          _results.push(this.capitalizeWord(word));
        }
        return _results;
      }).call(this);
      return newWords.join(' ');
    },
    maskString: function(str, mask) {
      var applyMask, argString, fixedCharsReg, maskStr, o;
      maskStr = mask.mask || mask;
      applyMask = function(valueArray, maskArray, fixedCharsReg) {
        var i;
        i = 0;
        while (i < valueArray.length) {
          if (maskArray[i] && fixedCharsReg.test(maskArray[i]) && maskArray[i] !== valueArray[i]) {
            valueArray.splice(i, 0, maskArray[i]);
          }
          i++;
        }
        return valueArray;
      };
      o = {
        mask: maskStr,
        fixedChars: '[(),.:/ -]'
      };
      argString = typeof str === "string" ? str : String(str);
      fixedCharsReg = new RegExp(o.fixedChars);
      return applyMask(argString.split(""), o.mask.split(""), fixedCharsReg).join("").substring(0, o.mask.split("").length);
    },
    maskInfo: function(info) {
      var maskRegex, maskText;
      maskRegex = /\*/g;
      maskText = '<span class="masked-info">*</span>';
      if (info) {
        return info.replace(maskRegex, maskText);
      } else {
        return info;
      }
    },
    plainChars: function(str) {
      var plain, regex, specialChars;
      if (str == null) {
        return;
      }
      specialChars = "ąàáäâãåæćęèéëêìíïîłńòóöôõøśùúüûñçżź";
      plain = "aaaaaaaaceeeeeiiiilnoooooosuuuunczz";
      regex = new RegExp("[" + specialChars + "]", 'g');
      str += "";
      return str.replace(regex, function(char) {
        return plain.charAt(specialChars.indexOf(char));
      });
    },
    sanitize: function(str) {
      return this.plainChars(str.replace(/\s/g, '').replace(/\/|\\/g, '-').replace(/\(|\)|\'|\"/g, '').toLowerCase().replace(/\,/g, 'V').replace(/\./g, 'P'));
    },
    spacesToHyphens: function(str) {
      return str.replace(/\ /g, '-');
    },
    hash: function(str) {
      var char, charcode, hashed, _i, _len;
      hashed = 0;
      for (_i = 0, _len = str.length; _i < _len; _i++) {
        char = str[_i];
        charcode = char.charCodeAt(0);
        hashed = ((hashed << 5) - hashed) + charcode;
        hashed = hashed & hashed;
      }
      return hashed;
    },
    mapObj: function(obj, f) {
      var k, obj2, v;
      obj2 = {};
      for (k in obj) {
        if (!__hasProp.call(obj, k)) continue;
        v = obj[k];
        obj2[k] = f(k, v);
      }
      return obj2;
    },
    _getCurrencySymbol: function() {
      var _ref, _ref1;
      return ((_ref = window.vtex) != null ? (_ref1 = _ref.i18n) != null ? _ref1.getCurrencySymbol() : void 0 : void 0) || 'R$ ';
    },
    _getDecimalSeparator: function() {
      var _ref, _ref1;
      return ((_ref = window.vtex) != null ? (_ref1 = _ref.i18n) != null ? _ref1.getDecimalSeparator() : void 0 : void 0) || ',';
    },
    _getThousandsSeparator: function() {
      var _ref, _ref1;
      return ((_ref = window.vtex) != null ? (_ref1 = _ref.i18n) != null ? _ref1.getThousandsSeparator() : void 0 : void 0) || '.';
    },
    _fixValue: function(value, options) {
      if (options == null) {
        options = {};
      }
      if (options.absolute && value < 0) {
        value = -value;
      }
      value = value.toFixed(2);
      return value;
    },
    _extend: function() {
      var obj, prop, source, sources, _i, _len;
      obj = arguments[0], sources = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
      for (_i = 0, _len = sources.length; _i < _len; _i++) {
        source = sources[_i];
        if (source) {
          for (prop in source) {
            obj[prop] = source[prop];
          }
        }
      }
      return obj;
    }
  };

  if (window._) {
    window._.mixin(utils);
  } else {
    window._ = utils;
    window._.extend = utils._extend;
  }

}).call(this);
