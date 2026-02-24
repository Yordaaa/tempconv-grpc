import 'package:grpc/grpc.dart';

Object createChannelImpl(Uri uri) {
  final port = uri.hasPort ? uri.port : (uri.scheme == 'https' ? 443 : 80);
  return ClientChannel(
    uri.host,
    port: port,
    options: const ChannelOptions(credentials: ChannelCredentials.insecure()),
  );
}

