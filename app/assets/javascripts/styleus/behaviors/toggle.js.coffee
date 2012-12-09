namespace 'styleus.toggle', (exports) ->
  config = exports.config =
    toggleSelector: 'toggle'

  exports.install = (root) ->
    $root = $(root or document)
    $root.on 'click', "[data-#{config.toggleSelector}]", (event) ->
      event.preventDefault()
      link =  $(event.target)
      target = link.data(config.toggleSelector)
      $(target).show()
      false