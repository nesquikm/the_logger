import 'package:the_logger/src/models/models.dart';

/// A set of [MaskingString] instances.
typedef MaskingStrings = Set<MaskingString>;

/// An extension on [Set] that allows masking a string with all
/// the [MaskingString] instances in the set.
extension MaskingStringsMask on MaskingStrings {
  /// Mask the input string with all the [MaskingString] instances in the set.
  String mask(String input) {
    return fold(
      input,
      (result, maskingString) => maskingString.mask(result),
    );
  }
}
