import 'package:socket_io_client/socket_io_client.dart' as io;

import '../../../core/constants/api_constants.dart';

class SocketService {
  static late io.Socket socket;

  static void connect() {
    socket = io.io(
      ApiConstants.socketUrl,

      io.OptionBuilder().setTransports(['websocket']).build(),
    );

    socket.connect();
  }

  static void disconnect() {
    socket.disconnect();
  }
}
