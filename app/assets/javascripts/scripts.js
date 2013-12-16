$(function() {
  $("#status_body").blur(function() {
    console.log(7);
  });

  $("#status-form").submit(function(e) {
    e.preventDefault();

    var group_id = $("#group_id").val();
    var $statusBody = $("#status_body");
    var status_body_val = $statusBody.val();

    if ($("#status_tracking").is(':checked')) {
      var status_tracking = 1;
    } else {
      var status_tracking = 0;
    }

    $.ajax({
      url: "/groups/" + group_id + "/statuses",
      type: "POST",
      dataType: "json",
      data: {
        status: {
          body: status_body_val,
          tracking: status_tracking
        },
        group_id: group_id
      },
      success: function(results) {
        if (results.status == "ok") {
          console.log(results.username);

          var $groupStatusList = $(".group-status-list");
          var $listItem = $("<div class='group-status-list-item'>");

          var $listItemBody = $("<div class='group-status-list-item-body-regular'>");
          $listItemBody.html(status_body_val);

          $listItem.append($listItemBody);

          $groupStatusList.prepend($listItem);

          $statusBody.val("");
        } else {
          // tell the user that an error occurred
        }
      }
    });
  });
});
