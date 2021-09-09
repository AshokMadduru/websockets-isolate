import 'package:flutter/material.dart';
import 'package:isolate_sockets/web_socket_manager.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'dart:isolate';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  @override
  void initState() {
    super.initState();
    // IOSocketManger.socketManger.socket;
    start();
  }



  @override
  void dispose() {
    super.dispose();
    WebSocketManger.socketManger.channel.sink.close();
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
    print("sending message: random number: $_counter");
    // print(WebSocketManger.socketManger.)
    WebSocketManger.socketManger.channel.sink.add("random number: $_counter");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }


  // Start the isolate
  void start() async {
    ReceivePort  receiverPort = ReceivePort();   // Port for isolate to receive message.
    Isolate isolate;
    isolate = await Isolate.spawn(myIsolate, receiverPort.sendPort);
    receiverPort.listen((data){
      if (data is SendPort) {
        SendPort mainToIsolateStream = data;
        // completer.complete(mainToIsolateStream);
      } else {
        print('[isolateToMainStream] $data');
      }
      // print('Receiving: '+ data + ', ');

    });

  }
}

void myIsolate(SendPort isolateToMainStream) {
  ReceivePort mainToIsolateStream = ReceivePort();
  isolateToMainStream.send(mainToIsolateStream.sendPort);

  mainToIsolateStream.listen((data) {
    print('[mainToIsolateStream] $data');
  });

  isolateToMainStream.send('This is from myIsolate()');

  WebSocketManger.socketManger.channel;
  listenFromServer(isolateToMainStream);
}

listenFromServer(isolateToMainStream) {
  WebSocketManger.socketManger.channel.stream.listen((event) {
    print("Got response from web socket server: $event");
  }, onError: handleError, onDone: handleDone(), cancelOnError: false);

  WebSocketManger.socketManger.channel.sink.add("hello world ");
}

void handleError(Object error, StackTrace stackTrace) {
  print("Got error from web socket socket: $error");
}

handleDone() {
  print("Got done from web socket socket");
}
