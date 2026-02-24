// This is a generated file - do not edit.
//
// Generated from tempconv/v1/tempconv.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'package:protobuf/protobuf.dart' as $pb;

import 'tempconv.pb.dart' as $0;

export 'tempconv.pb.dart';

/// TempConv provides basic temperature conversions.
@$pb.GrpcServiceName('tempconv.v1.TempConvService')
class TempConvServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  TempConvServiceClient(super.channel, {super.options, super.interceptors});

  /// Convert Celsius to Fahrenheit.
  $grpc.ResponseFuture<$0.TemperatureReply> celsiusToFahrenheit(
    $0.TemperatureRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$celsiusToFahrenheit, request, options: options);
  }

  /// Convert Fahrenheit to Celsius.
  $grpc.ResponseFuture<$0.TemperatureReply> fahrenheitToCelsius(
    $0.TemperatureRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$fahrenheitToCelsius, request, options: options);
  }

  // method descriptors

  static final _$celsiusToFahrenheit =
      $grpc.ClientMethod<$0.TemperatureRequest, $0.TemperatureReply>(
          '/tempconv.v1.TempConvService/CelsiusToFahrenheit',
          ($0.TemperatureRequest value) => value.writeToBuffer(),
          $0.TemperatureReply.fromBuffer);
  static final _$fahrenheitToCelsius =
      $grpc.ClientMethod<$0.TemperatureRequest, $0.TemperatureReply>(
          '/tempconv.v1.TempConvService/FahrenheitToCelsius',
          ($0.TemperatureRequest value) => value.writeToBuffer(),
          $0.TemperatureReply.fromBuffer);
}

@$pb.GrpcServiceName('tempconv.v1.TempConvService')
abstract class TempConvServiceBase extends $grpc.Service {
  $core.String get $name => 'tempconv.v1.TempConvService';

  TempConvServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.TemperatureRequest, $0.TemperatureReply>(
        'CelsiusToFahrenheit',
        celsiusToFahrenheit_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.TemperatureRequest.fromBuffer(value),
        ($0.TemperatureReply value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.TemperatureRequest, $0.TemperatureReply>(
        'FahrenheitToCelsius',
        fahrenheitToCelsius_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.TemperatureRequest.fromBuffer(value),
        ($0.TemperatureReply value) => value.writeToBuffer()));
  }

  $async.Future<$0.TemperatureReply> celsiusToFahrenheit_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.TemperatureRequest> $request) async {
    return celsiusToFahrenheit($call, await $request);
  }

  $async.Future<$0.TemperatureReply> celsiusToFahrenheit(
      $grpc.ServiceCall call, $0.TemperatureRequest request);

  $async.Future<$0.TemperatureReply> fahrenheitToCelsius_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.TemperatureRequest> $request) async {
    return fahrenheitToCelsius($call, await $request);
  }

  $async.Future<$0.TemperatureReply> fahrenheitToCelsius(
      $grpc.ServiceCall call, $0.TemperatureRequest request);
}
