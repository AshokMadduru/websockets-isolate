import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketManger {
  static final WebSocketManger _socketManger = WebSocketManger._internal();
  late WebSocketChannel _channel;

  factory WebSocketManger() {
    return _socketManger;
  }

  WebSocketManger._internal() {
    _createChannel();
  }

  _createChannel() {
    print('_createChannel called');
    // _channel = WebSocketChannel.connect(
    //   // Uri.parse('wss://echo.websocket.org'),
    //   Uri.parse('wss://free-abc.piesocket.com/v3/1?api_key=QwyjNmdvDDEYpmBejQsv7H05wJlFf6ZLyvLBrRRY&notify_self'),
    // );

    _channel = IOWebSocketChannel.connect(
        Uri.parse(
            'ws://10.0.2.2:8760'), pingInterval: const Duration(seconds: 40)
    );

    // _channel = IOWebSocketChannel.connect(Uri.parse('wss://glibchat-backend-vudaqlstaq-uc.a.run.app/ws/v1'));
  }

  static WebSocketManger get socketManger => _socketManger;

  WebSocketChannel get channel => _channel;

  restart() {
    _createChannel();
  }
}