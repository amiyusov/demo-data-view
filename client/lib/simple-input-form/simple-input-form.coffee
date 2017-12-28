Template.simpleInputForm.helpers
  isActive: -> "active" if @value?.length

Template.simpleInputForm.events
  "submit form": ( ev, tpl ) ->
    ev.preventDefault()
    ev.stopPropagation()
    value = $( ev.target ).serializeJSON().value?.trim()
    tpl.data.action tpl.data.name, value

  "reset form": ( ev, tpl ) ->
    ev.stopPropagation()

  "focus input": ( ev, tpl ) ->
    tpl.$(ev.target).removeClass( "invalid" ).val tpl.data.value if tpl.data.required

  "change": ( ev, tpl ) -> tpl.data.onChange? ev.target.name, ev.val

