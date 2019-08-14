class Boolean {
  static final no = Boolean._(0);
  static final yes = Boolean._(1);

  Boolean._(this.value): assert(value != null);

  final int value;

  @override
  String toString() => value.toString();
}

class Integer {
  Integer(this.value): assert(value != null);

  final int value;

  @override
  String toString() => value.toString();
}