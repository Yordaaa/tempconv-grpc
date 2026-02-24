import 'channel_stub.dart'
    if (dart.library.html) 'channel_web.dart'
    if (dart.library.io) 'channel_io.dart';

/// Returns a platform-appropriate gRPC channel object.
///
/// - Web: `GrpcWebClientChannel`
/// - IO: `ClientChannel`
///
/// We keep the return type as `Object` because `grpc`'s web channel type does
/// not share a public common interface with `ClientChannel`.
Object createChannel(Uri uri) => createChannelImpl(uri);

