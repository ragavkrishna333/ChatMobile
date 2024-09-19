// import 'dart:async';

// import 'package:web_socket_channel/io.dart';
// import 'package:web_socket_channel/web_socket_channel.dart';

// class SocketService {
//   StreamSubscription? subscription;
//   static final WebSocketChannel channel =
//       IOWebSocketChannel.connect('ws://192.168.2.124:29096/chatAppws');

//   Stream<dynamic> socketStream = channel.stream.asBroadcastStream();
//   Future<void> connect() async {
//     try {
//       channel.sink;
//     } catch (e) {
//       // Handle connection errors
//     }
//   }

//   void listenToSocket(Function(String) onMessage) {

//     subscription = channel.stream.listen((message) {
//       onMessage(message);
//     });
//   }

//   Future<void> closeSocket() async {
//     await subscription?.cancel();
//     await channel.sink.close();
//   }
//   // void disconnect() {
//   //   channel.sink.close();
//   // }

//   void subscribe(String data) {
//     channel.sink.add(data);
//   }
// }
// import 'dart:async';
// import 'package:web_socket_channel/io.dart';
// import 'package:web_socket_channel/web_socket_channel.dart';

// class SocketService {
//   // Singleton setup
//   static final SocketService _instance = SocketService._internal();
//   factory SocketService() => _instance;
//   SocketService._internal();

//   // WebSocket connection setup
//   static final WebSocketChannel channel =
//       IOWebSocketChannel.connect('ws://192.168.2.124:29096/chatAppws');

//   StreamSubscription? subscription;
//   Stream<dynamic> socketStream = channel.stream.asBroadcastStream();

//   Future<void> connect() async {
//     try {
//       channel.sink;
//     } catch (e) {
//       // Handle connection errors
//     }
//   }

//   void listenToSocket(Function(String) onMessage) {
//     subscription?.cancel(); // Cancel any previous subscription
//     subscription = socketStream.listen((message) {
//       onMessage(message);
//     });
//   }

//   Future<void> closeSocket() async {
//     await subscription?.cancel();
//     await channel.sink.close();
//   }

//   void subscribe(String data) {
//     channel.sink.add(data);
//   }
// }
import 'dart:async';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class SocketService {
  // Singleton setup
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;
  SocketService._internal();

  // WebSocket connection setup
  WebSocketChannel? channel;
  StreamSubscription? subscription;
  Stream<dynamic>? socketStream;

  Future<void> connect() async {
    try {
      channel =
          IOWebSocketChannel.connect('ws://192.168.2.124:29096/chatAppws');
      socketStream = channel!.stream.asBroadcastStream();
    } catch (e) {
      // Handle connection errors
      print('Connection error: $e');
    }
  }

  void listenToSocket(Function(String) onMessage) {
    subscription?.cancel(); // Cancel any previous subscription
    subscription = socketStream?.listen((message) {
      onMessage(message);
    });
  }

  Future<void> closeSocket() async {
    await subscription?.cancel();
    await channel?.sink.close();
  }

  void subscribe(String data) {
    channel?.sink.add(data);
  }
}
