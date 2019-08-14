import 'dart:convert';

final stripedBase64 = const Base64Codec().fuse(const StripWhitespaceCodec());

class StripWhitespaceCodec extends Codec<String, String> {
  const StripWhitespaceCodec() : super();

  @override
  final Converter<String, String> encoder = const _NoOpConverter<String>();

  @override
  final Converter<String, String> decoder = const _StripWhitespaceConverter();
}

class _StripWhitespaceConverter extends Converter<String, String> {
  static final _whitespace = new RegExp(r'\s+');

  const _StripWhitespaceConverter() : super();

  @override
  String convert(String input) => input.replaceAll(_whitespace, '');
}

class _NoOpConverter<T> extends Converter<T, T> {
  const _NoOpConverter() : super();

  @override
  T convert(T input) => input;
}