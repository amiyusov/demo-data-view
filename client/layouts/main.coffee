Meteor.startup ->
  BlazeLayout.setRoot "#content"
  BlazeLayout.render "mainComponentLayout", componentData: component: 'deedBrowser'