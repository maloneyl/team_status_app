$(function() {

  /* Activating Best In Place */
  // jQuery(".best_in_place").best_in_place();

  // $('.best_in_place').bind("ajax:success", function () {$(this).closest('tr').effect('highlight'); });
  // $('.best_in_place').bind("ajax:success", function(){ alert('Agenda updated for '+$(this).data('agendaBody')); });

  $("#individual-agenda").on("click", editAgenda);

  function editAgenda() {
    var $this = $(this);
    console.log($this);
    var groupId = $this.data("group-id");
    var agendaId = $this.data("agenda-id");
    var agendaBody = $this.data("agenda-body");
    var url = "/groups/" + groupId + "/agendas/" + agendaId;

    $this.html('<textarea name="agenda[body]" placeholder="' + agendaBody + '"</textarea>');

    $.ajax({
      url: url,
      type: 'PUT',
      success: function() {
        console.log('Updated!');
      },
      error: function() {
        console.log('Error!');
      }
    })


  }

})
