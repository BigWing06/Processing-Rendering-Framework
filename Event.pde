import java.util.concurrent.Callable;
@FunctionalInterface
  interface Condition { // Used to store a condition and node; Evaluate runs the code
  boolean evaluate(EventData event, Node n);
}
@FunctionalInterface
  interface EventCall { // Stores EventData to be evaluated
  void evaluate(EventData e);
}
HashMap<String, Condition> eventMap = new HashMap<String, Condition>(); // Stores the conditions for all event types to run

public class EventManager {
  List<String> vitalEvents = Arrays.asList(new String[]{"MouseHover", "MouseLeave"}); // The events that need to be run every process loop
  HashMap<String, ArrayList<Event>> events = new HashMap<String, ArrayList<Event>>(); // The HashMap that contains all of the events
  ArrayList<Event> eventsList = new ArrayList<Event>(); // The events as a list
  
  EventManager() { // The constructor; Generates event map
    eventMap.put("KeyPressed", (event, node)->event.k!=null);
    eventMap.put("KeyReleased", (event, node)->event.k!=null);
    eventMap.put("MousePressed", (event, node)->event.mouseBtn!=null&&node.checkCollision(event.mousePos));
    eventMap.put("MouseReleased", (event, node)->event.mouseBtn!=null&&node.checkCollision(event.mousePos));
    eventMap.put("MouseHover", (event, node)->node.checkCollision(event.mousePos)&&node.mouseOver==false);
    eventMap.put("MouseLeave", (event, node)->!node.checkCollision(event.mousePos)&&node.mouseOver==true);
  }
  
  void evaluateVitalEvents() { // Loops through vital events and runs them if the condition is true
    for (String event : vitalEvents) {
      this.runEventType(new EventData(event).setMousePos(new Vector2(mouseX,mouseY)));
    }
  }
  
  void createEvent(Event event_) {// Creates a new Event
    if (!events.keySet().contains(event_.name)) {
      events.put(event_.name, new ArrayList<Event>());
    }
    events.get(event_.name).add(event_);
    eventsList.add(event_);
  }
  
  void removeEvent(Event event_) { // Removes an Event
    if (eventsList.contains(event_)) {
      events.remove(event_.name);
      eventsList.remove(event_);
    } else {
      throw new RuntimeException("ERROR ON REMOVE EVENT: Event not in list");
    }
  }
  
  void runEventType(EventData event_) { // Runs all of a specific event type if the condition is true
    if (events.keySet().contains(event_.type)) {
      for (Event event : events.get(event_.type)) {
        event.listen(event_);
      }
    }
  }
}

public class Event {
  Node node; // The Node the event is attached to
  String name; // The type of event
  EventCall method; // The method to be called if the condition is true
  Condition condition; // The condition that is checked
  
  Event(Node node_, String name_, EventCall method_) { // The constructor; Sets variables
    if (!eventMap.keySet().contains(name_)) {
      throw new RuntimeException("Invalid Event Type: " + name_);
    }
    this.node=node_;
    this.name=name_;
    this.method = method_;
    this.condition = eventMap.get(name_);
  }
  
  void listen(EventData event) { // Checks to see if the condition is true, if it is run the method attached
    if (condition.evaluate(event, this.node)) {
      this.method.evaluate(event);
      if(this.node.vitalEventDefaults.keySet().contains(event.type)){
      this.node.vitalEventDefaults.get(event.type).run();
      }
    }
  }
}
