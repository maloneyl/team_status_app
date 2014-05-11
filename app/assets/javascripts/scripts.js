$(function() {

  $(".individual-agenda-editable").on("dblclick", editAgenda);

  $(".remove-from-group").on("click", removeGroupMember);

  $(".delete-status-link").on("click", removeStatus);

  $(".update-status-tracking-link").on("click", updateStatusTracking);

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

    // for re-editing
    if (typeof agendaBodyNewVal == 'undefined') {
      var agendaBody = $this.data("agenda-body");
    } else {
      var agendaBody = agendaBodyNewVal;
    }

    var url = "/groups/" + groupId + "/agendas/" + agendaId;
    var inputbox = "<textarea rows='3' cols='30' id='agenda_body' name='agenda[name]'>";
    $this.html(inputbox + agendaBody + "</textarea>");
    $("#agenda_body").focus(); // makes it possible to type in the box...

    $("#agenda_body").blur(function() {
      agendaBodyNewVal = $("#agenda_body").val();

      // update displayed text
      if (agendaBodyNewVal === "") {
        $this.html("<div class='content'>(None entered yet.)</div>");
      } else {
        $this.html("<div class='content'>" + agendaBodyNewVal + "</div>");
      }

      // update on server only if agenda actually got changed
      if (agendaBodyNewVal !== agendaBody) {
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
      }
    });
  };

  function removeGroupMember() {
    var $this = $(this);
    var groupId = $this.data('group-id');
    var memberId = $this.data('member-id');
    var url = '/groups/' + groupId + '/remove_member/' + memberId;

    if (confirm("Are you sure?")) {
      $.ajax({
        url: url,
        type: 'PUT',
        dataType: "json",
        success: function() {
          console.log('Removed!');
          $this.closest("li").hide();
        },
        error: function() {
          console.log('Error!');
        }
      })
    }
    return false;
  }

  function removeStatus() {
    var $this = $(this);
    var groupId = $this.data('group-id');
    var statusId = $this.data('status-id');
    var url = '/groups/' + groupId + '/statuses/' + statusId;

    if (confirm("Are you sure? All its associated data will be gone!")) {
      $.ajax({
        url: url,
        type: 'DELETE',
        dataType: "json",
        success: function() {
          console.log('Removed!');
          $this.closest(".panel").hide();
        },
        error: function() {
          console.log('Error!');
        }
      })
    }
    return false;
  }

  function updateStatusTracking() {
    var $this = $(this);
    var groupId = $this.data('group-id');
    var statusId = $this.data('status-id');
    var url = '/groups/' + groupId + '/statuses/' + statusId + '/switch_tracking';

    if (confirm("Are you sure you'd like to stop time-tracking for this status?")) {
      $.ajax({
        url: url,
        type: 'PUT',
        dataType: "json",
        success: function() {
          console.log('Timer stopped!');
          $this.closest('div').find('.in-progress').removeClass().addClass('tracking-label done').text('done');
          $this.hide();
        },
        error: function() {
          console.log('Error!');
        }
      })
    }
    return false;
  }
});
