$(function() {

  $(".individual-agenda-editable").on("click", editAgenda);

  $(".remove-from-group").on("click", removeGroupMember);
  $(".delete-status-link").on("click", removeStatus);
  $(".group-status-list-item-tracking-link").on("click", updateStatusTracking);

  // $("#status-form").submit(function(e) {
  //   e.preventDefault();

  //   var groupId = $("#group_id").val();
  //   var $statusBody = $("#status_body");
  //   var statusBodyVal = $statusBody.val();

  //   if ($("#status_tracking").is(':checked')) {
  //     var statusTracking = 1;
  //   } else {
  //     var statusTracking = 0;
  //   }

  //   $.ajax({
  //     url: "/groups/" + groupId + "/statuses",
  //     type: "POST",
  //     dataType: "json",
  //     data: {
  //       status: {
  //         body: statusBodyVal,
  //         tracking: statusTracking
  //       },
  //       group_id: groupId
  //     },
  //     success: function(response) {
  //       if (response.status == "ok") {
  //         console.log(response.username);
  //         // still need to reconstruct the view

  //         // no-go:
  //         // $(".group-status-list").load("/groups/" + groupId + "/get_statuses")

  //         // var $groupStatusList = $(".group-status-list");
  //         // var $listItem = $("<div class='group-status-list-item'>");

  //         // var $listItemBody = $("<div class='group-status-list-item-body-regular'>");
  //         // $listItemBody.html(status_body_val);

  //         // $listItem.append($listItemBody);

  //         // $groupStatusList.prepend($listItem);

  //         // $statusBody.val("");
  //       } else {
  //         // tell the user that an error occurred
  //       }
  //     }
  //   });
  // });

  function editAgenda() {
    var $this = $(this);
    var groupId = $this.data("group-id");
    var agendaId = $this.data("agenda-id");
    var agendaBody = $this.data("agenda-body");
    var url = "/groups/" + groupId + "/agendas/" + agendaId;
    var inputbox = "<textarea rows='3' cols='30' id='agenda_body' name='agenda[name]'>";
    $this.html(inputbox + agendaBody + "</textarea>");
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
  };

  function removeGroupMember() {
    var $this = $(this);
    var groupId = $this.data('group-id');
    var memberId = $this.data('member-id');
    var url = '/groups/' + groupId + '/remove_member/' + memberId;

    $.ajax({
      url: url,
      type: 'PUT',
      dataType: "json",
      success: function() {
        console.log('Removed!');
        $this.closest(".group-members-list-item-regular").hide();
      },
      error: function() {
        console.log('Error!');
      }
    })
  }

  function removeStatus() {
    var $this = $(this);
    var groupId = $this.data('group-id');
    var statusId = $this.data('status-id');
    var url = '/groups/' + groupId + '/statuses/' + statusId;

    $.ajax({
      url: url,
      type: 'DELETE',
      dataType: "json",
      success: function() {
        console.log('Removed!');
        $this.closest(".group-status-list-item").hide();
      },
      error: function() {
        console.log('Error!');
      }
    })
  }

  function updateStatusTracking() {
    var $this = $(this);
    var groupId = $this.data('group-id');
    var statusId = $this.data('status-id');
    var url = '/groups/' + groupId + '/statuses/' + statusId + '/switch_tracking';

    $.ajax({
      url: url,
      type: 'PUT',
      dataType: "json",
      success: function() {
        console.log('Timer stopped!');
        $this.closest('div').find('.group-status-list-item-in-progress').removeClass().addClass('group-status-list-item-done').text('done');
        $this.hide();
      },
      error: function() {
        console.log('Error!');
      }
    })
  }

});
