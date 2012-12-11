jQuery($(document).ready ->
  install = ->
    styleus.toggle.install()
    styleus.sampleContent.install()

  $(document).on 'dom:changed', install

  install()
)