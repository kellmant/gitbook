'use strict';

module.exports = {
  OUTPUT_TEMPLATE: function OUTPUT_TEMPLATE(str) {
    return '<object data="data:image/svg+xml;base64,' + str + '" type="image/svg+xml"></object>';
  },
  SERVICE_URL: 'https://plantuml-service.herokuapp.com/svg'
};