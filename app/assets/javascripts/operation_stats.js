var operationStats = {
  operation_data: null,

  initialize: function (data) {
    this.operation_data = data;
    var that = this;
    $.each(this.operation_data, function(id, op_data) {
      that.addOperationData(op_data);
    });
  },
  
  addOperationData: function(_data) {
    var $op_content = $("<div>", {class: "operation_content"});

    $.each(_data, function(attr_name, value) {
      $op_content.append("<div>" + attr_name + ": " + value + "</div>");
    });

    $("#operation_stats_container").prepend($op_content);
  }
}
