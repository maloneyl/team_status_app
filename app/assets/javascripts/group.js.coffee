# $(document).ready ->
#   $("#new_status").on("ajax:success", (e, data, status, xhr) ->
#     $("#new_status").append xhr.responseText
#   ).bind "ajax:error", (e, xhr, status, error) ->
#     $("#new_status").append "<p>ERROR</p>"

#   $("a[data-remote]").on "ajax:success", (e, data, status, xhr) ->
#     alert "The post was deleted."
#     $('#group-statuses-list').html("<%=j render partial: 'groups/statuses' %>")

