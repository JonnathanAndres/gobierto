this.GobiertoAdmin.PersonEventsController = (function() {
  function PersonEventsController() {}

  PersonEventsController.prototype.edit = function(wrapper, namespace) {
    GobiertoAdmin.dynamic_content_component.handle(wrapper, namespace);
  };

  return PersonEventsController;
})();

this.GobiertoAdmin.person_events_controller = new GobiertoAdmin.PersonEventsController;
