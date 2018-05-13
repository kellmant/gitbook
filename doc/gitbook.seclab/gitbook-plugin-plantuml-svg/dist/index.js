'use strict';

var _ = require('lodash');
var path = require('path');
var rp = require('request-promise');

var _require = require('js-base64'),
    Base64 = _require.Base64;

var _require2 = require('./constants'),
    SERVICE_URL = _require2.SERVICE_URL,
    OUTPUT_TEMPLATE = _require2.OUTPUT_TEMPLATE;

function getContentPath(kwargs) {
  var rel = kwargs.relativeTo;
  var basePath = rel ? _.isString(rel.path) ? path.dirname(rel.path) : rel : '.';
  var absPath = path.resolve(basePath, kwargs.src);

  return path.relative(this.resolve('.'), absPath);
}

function loadUmlContent() {
  var _ref = arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : {},
      _ref$kwargs = _ref.kwargs,
      kwargs = _ref$kwargs === undefined ? {} : _ref$kwargs,
      body = _ref.body;

  if (kwargs.src) {
    return this.readFileAsString(getContentPath.call(this, kwargs));
  }
  return Promise.resolve(body);
}

function trimContent(content) {
  var indexFrom = content.indexOf('@startuml');
  var indexTo = content.lastIndexOf('@enduml') + 7;

  if (indexFrom < 0 || indexTo < 0) {
    throw new Error('Invalid PlantUML content');
  }
  return content.slice(indexFrom, indexTo);
}

function renderUml(content) {
  return (this.rpMock || rp).post({
    url: SERVICE_URL,
    body: content
  }).then(Base64.encode).then(OUTPUT_TEMPLATE);
}

module.exports = {
  blocks: {
    uml: {
      process: function process(block) {
        return loadUmlContent.call(this, block).then(trimContent).then(renderUml.bind(this));
      }
    }
  }
};