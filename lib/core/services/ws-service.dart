import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  late WebSocketChannel _channel;

  void connect({required String url}) {
    _channel = WebSocketChannel.connect(Uri.parse(url));
  }

  void send(String message) {
    _channel.sink.add(message);
  }

  Stream<String> get stream => _channel.stream.cast<String>();

  void disconnect() {
    _channel.sink.close();
  }
}
