OnRuby =
  showHide: ->
    $(".toggle").click (event) ->
      event.preventDefault()
      name = $(this).attr("name")
      $(".toggle_" + name).slideToggle()

  displayUsers: ->
    func = ->
      jQuery.each $(".imagelist img"), ->
        src = $(this).attr("src")
        dataSrc = $(this).attr("data-src")
        $(this).attr "src", dataSrc  if src isnt dataSrc
    setTimeout func, 500

  close: ->
    $(".close").click (event) ->
      event.preventDefault()
      $(this).parent().fadeOut()

  reload: ->
    $(".jobs").filter(":hidden").first().show()  if $(".jobs").filter(":visible").size() is 0
    $(".reload").click (event) ->
      event.preventDefault()
      first = $(".jobs").filter(":visible")
      first.hide()
      if first.next().length > 0
        first.next().fadeIn()
      else
        $(".jobs").filter(":hidden").first().fadeIn()

  moreList: ->
    for list in $("ul.more-list")
      do (list) ->
        preview_size = $(list).data('preview-size') || 4
        elements = $(list).find "li"
        if elements.size() > preview_size
          elements.slice(preview_size).hide()
          link = $("<i class='fa fa-chevron-down pull-left'></i><a class='more' href='#'>" + I18n.showMore + "</a>")
          container = $("<p></p>").append link
          container.insertAfter list
          link.click (event) ->
            event.preventDefault()
            link.hide()
            elements.filter(":hidden").fadeIn()

$ ->
  OnRuby.reload()
  OnRuby.close()
  OnRuby.showHide()
  OnRuby.moreList()
  OnRuby.displayUsers()
