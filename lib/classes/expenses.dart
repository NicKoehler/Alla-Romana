import 'package:alla_romana/classes/pair.dart';

class Expenses {
  late List<Pair> people;
  Expenses() {
    people = [];
  }

  void addAll(List<Pair> pairs) {
    people.addAll(pairs);
  }
}
