import 'package:intl/intl.dart' as intl;

import 's.dart';

/// The translations for English (`en`).
class SEn extends S {
  SEn([String locale = 'en']) : super(locale);

  @override
  String get addPerson => 'Add person';

  @override
  String get enterName => 'Enter name';

  @override
  String get enterNameError => 'Enter a valid name';

  @override
  String get enterCost => 'Enter cost';

  @override
  String get enterCostError => 'Enter a numerical amount';

  @override
  String get addPersonDesc => 'Add some people to start calculating';

  @override
  String get removePersonDescription => 'Are you sure you want to remove this person?';

  @override
  String get calculate => 'Calculate';

  @override
  String get close => 'Close';

  @override
  String get total => 'Total';

  @override
  String get confirm => 'Confirm';

  @override
  String get cancel => 'Cancel';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get pay => 'pays';

  @override
  String get spent => 'spent';

  @override
  String get hasToPay => 'has to pay';

  @override
  String get shouldReceive => 'should receive';

  @override
  String get solution => 'SOLUTION';

  @override
  String get enteredCosts => 'ENTERED COSTS';

  @override
  String get debitors => 'DEBITORS';

  @override
  String get creditors => 'CREDITORS';

  @override
  String to(num val) {
    return intl.Intl.pluralLogic(
      val,
      locale: localeName,
      other: 'to',
    );
  }

  @override
  String enterNameErrorLength(num val) {
    return intl.Intl.pluralLogic(
      val,
      locale: localeName,
      other: 'The name cannot exceed $val characters',
    );
  }

  @override
  String enterCostErrorLength(num val) {
    return intl.Intl.pluralLogic(
      val,
      locale: localeName,
      other: 'The cost cannot exceed $val characters',
    );
  }

  @override
  String costPerPerson(num count) {
    return intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Cost per person ($count)',
    );
  }
}
