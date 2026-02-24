// This is a generated file - do not edit.
//
// Generated from tempconv/v1/tempconv.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class TemperatureRequest extends $pb.GeneratedMessage {
  factory TemperatureRequest({
    $core.double? value,
  }) {
    final result = create();
    if (value != null) result.value = value;
    return result;
  }

  TemperatureRequest._();

  factory TemperatureRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TemperatureRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TemperatureRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'tempconv.v1'),
      createEmptyInstance: create)
    ..aD(1, _omitFieldNames ? '' : 'value')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TemperatureRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TemperatureRequest copyWith(void Function(TemperatureRequest) updates) =>
      super.copyWith((message) => updates(message as TemperatureRequest))
          as TemperatureRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TemperatureRequest create() => TemperatureRequest._();
  @$core.override
  TemperatureRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static TemperatureRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TemperatureRequest>(create);
  static TemperatureRequest? _defaultInstance;

  /// Input value in the source unit for the RPC.
  @$pb.TagNumber(1)
  $core.double get value => $_getN(0);
  @$pb.TagNumber(1)
  set value($core.double value) => $_setDouble(0, value);
  @$pb.TagNumber(1)
  $core.bool hasValue() => $_has(0);
  @$pb.TagNumber(1)
  void clearValue() => $_clearField(1);
}

class TemperatureReply extends $pb.GeneratedMessage {
  factory TemperatureReply({
    $core.double? value,
  }) {
    final result = create();
    if (value != null) result.value = value;
    return result;
  }

  TemperatureReply._();

  factory TemperatureReply.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TemperatureReply.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TemperatureReply',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'tempconv.v1'),
      createEmptyInstance: create)
    ..aD(1, _omitFieldNames ? '' : 'value')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TemperatureReply clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TemperatureReply copyWith(void Function(TemperatureReply) updates) =>
      super.copyWith((message) => updates(message as TemperatureReply))
          as TemperatureReply;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TemperatureReply create() => TemperatureReply._();
  @$core.override
  TemperatureReply createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static TemperatureReply getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TemperatureReply>(create);
  static TemperatureReply? _defaultInstance;

  /// Output value in the target unit for the RPC.
  @$pb.TagNumber(1)
  $core.double get value => $_getN(0);
  @$pb.TagNumber(1)
  set value($core.double value) => $_setDouble(0, value);
  @$pb.TagNumber(1)
  $core.bool hasValue() => $_has(0);
  @$pb.TagNumber(1)
  void clearValue() => $_clearField(1);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
