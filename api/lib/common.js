(function() {
  var addToProto, copy, partial, partialr, toProto,
    __slice = Array.prototype.slice;

  toProto = exports.toProto = function(method) {
    return function() {
      Array.prototype.unshift.call(arguments, this);
      return method.apply(null, arguments);
    };
  };

  addToProto = exports.addToProto = function(Class, name, method) {
    if (Class.prototype[name]) return;
    return Object.defineProperty(Class.prototype, name, {
      value: toProto(method)
    });
  };

  copy = exports.copy = function(obj) {
    var innerCopy, prop, value;
    innerCopy = {};
    for (prop in obj) {
      value = obj[prop];
      innerCopy[prop] = value;
    }
    return innerCopy;
  };

  partial = exports.partial = function() {
    var applied, args, f;
    f = arguments[0], args = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
    return applied = function() {
      var finalArgs;
      finalArgs = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      return f.apply(null, args.concat(finalArgs));
    };
  };

  partialr = exports.partialr = function() {
    var applied, args, f;
    f = arguments[0], args = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
    return applied = function() {
      var finalArgs;
      finalArgs = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      return f.apply(null, finalArgs.concat(args));
    };
  };

  addToProto(Function, "partial", partial);

  addToProto(Function, "partialr", partialr);

}).call(this);
