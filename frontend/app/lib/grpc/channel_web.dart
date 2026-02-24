import 'package:grpc/grpc_web.dart';

Object createChannelImpl(Uri uri) {
  // For browsers: use gRPC-Web over HTTP(S).
  return GrpcWebClientChannel.xhr(uri);
}

