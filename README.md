Welcome to the isolates-sockets-poc wiki!

This POC is about implementing and testing websockets inside isolates. To test how the data will be passed/returned between flutter's main isolate and different isolate. 

From isolate's documentation:

`When the isolate receives the pause command, it stops
  processing events from the event loop queue.
  It may still add new events to the queue in response to, e.g., timers
  or receive-port messages. When the isolate is resumed,
  it starts handling the already enqueued events.`

Also tested this with some sample code and results matched the same. Isolate receive port queues events when paused and processed once resumed. 

**Stress test** 

Around 1,00,000 events were sent to isolate in paused state with 20ms delay between each event, isolate queued all the events without errors and processed once resumed even after 33min(total delay between events)
