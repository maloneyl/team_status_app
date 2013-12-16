$(function() {
  $("#status_body").blur(function() {
    console.log(7);
  });

  $("#status-form").submit(function(e) {
    e.preventDefault();

    var groupId = $("#group_id").val();
    var $statusBody = $("#status_body");
    var statusBodyVal = $statusBody.val();

    if ($("#status_tracking").is(':checked')) {
      var statusTracking = 1;
    } else {
      var statusTracking = 0;
    }

    $.ajax({
      url: "/groups/" + group_id + "/statuses",
      type: "POST",
      dataType: "json",
      data: {
        status: {
          body: statusBodyVal,
          tracking: statusTracking
        },
        group_id: groupId
      },
      success: function(response) {
        if (response.status == "ok") {
          console.log(response.username);
          $(".group-status-list").load("/groups/" + groupId + "/refresh_statuses")
          // var $groupStatusList = $(".group-status-list");
          // var $listItem = $("<div class='group-status-list-item'>");

          // var $listItemBody = $("<div class='group-status-list-item-body-regular'>");
          // $listItemBody.html(status_body_val);

          // $listItem.append($listItemBody);

          // $groupStatusList.prepend($listItem);

          // $statusBody.val("");
        } else {
          // tell the user that an error occurred
        }
      }
    });
  });

    /* Activating Best In Place */
  // jQuery(".best_in_place").best_in_place();

  // $('.best_in_place').bind("ajax:success", function () {$(this).closest('tr').effect('highlight'); });
  // $('.best_in_place').bind("ajax:success", function(){ alert('Agenda updated for '+$(this).data('agendaBody')); });

  $(".individual-agenda-editable").on("click", editAgenda);

  function editAgenda() {
    var $this = $(this);
    console.log($this);
    var groupId = $this.data("group-id");
    console.log(groupId);
    var agendaId = $this.data("agenda-id");
    console.log(agendaId);
    var agendaBody = $this.data("agenda-body");
    console.log(agendaBody);
    var url = "/groups/" + groupId + "/agendas/" + agendaId;

    var inputbox = "<input type='text' id='agenda_body' name='agenda[name]' value='" + agendaBody + "'>";
    $this.html(inputbox);
    $("#agenda_body").focus(); // makes it possible to type in the box...

    $("#agenda_body").blur(function() {
      agendaBodyNewVal = $("#agenda_body").val();
      $this.text(agendaBodyNewVal);

      $.ajax({
        url: url,
        type: 'PUT',
        dataType: "json",
        data: {
          agenda: {
            body: agendaBodyNewVal
          },
          group_id: groupId
        },
        success: function() {
          console.log('Updated!');
        },
        error: function() {
          console.log('Error!');
        }
      })

    });




  }

});
