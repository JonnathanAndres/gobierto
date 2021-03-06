'use strict';

var ssMembersCard = Class.extend({
  init: function(divClass, city_id) {
    this.container = divClass;
    this.tbiToken = window.populateData.token;
    this.url = window.populateData.endpoint + '/datasets/ds-afiliados-ss-municipio.json?sort_desc_by=date&with_metadata=true&limit=5&filter_by_location_id=' + city_id;
  },
  getData: function() {
    var data = d3.json(this.url)
      .header('authorization', 'Bearer ' + this.tbiToken)

    d3.queue()
      .defer(data.get)
      .await(function (error, jsonData) {
        if (error) throw error;
        
        var value = jsonData.data[0].value;

        new SimpleCard(this.container, jsonData, value, 'ss_members');
      }.bind(this));
  },
  render: function() {
    this.getData();
  }
});
