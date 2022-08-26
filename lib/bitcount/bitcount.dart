import 'package:encrypto_flutter/bitcount/native.dart'
    if (dart.library.js) 'package:encrypto_flutter/bitcount/js.dart' as impl;

/// Extends [int] with [bitCount] method that returns number of one-bits.
extension BitCountInt on int {
  /// Returns number of one-bits.
  ///
  /// NOTE: in JS is safe to use with up to 53 bits. See [int].
  int bitCount() {
    return impl.bitCount(this);
  }
}
