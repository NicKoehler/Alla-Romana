import 'package:decimal/decimal.dart';
import 'package:alla_romana/utils/regex.dart';

class Pair {
  String name;
  Decimal cost;
  Pair(this.name, this.cost);

  @override
  String toString() {
    return "${cost.toStringAsFixed(2)} $name";
  }

  static Pair fromString(String element) {
    final match = regexPair.firstMatch(element)!;
    return Pair(
      match[2]!,
      Decimal.parse(
        match[1]!,
      ),
    );
  }
}
