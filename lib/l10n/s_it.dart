import 'package:intl/intl.dart' as intl;

import 's.dart';

/// The translations for Italian (`it`).
class SIt extends S {
  SIt([String locale = 'it']) : super(locale);

  @override
  String get addPerson => 'Aggiungi una persona';

  @override
  String get enterName => 'Inserire il nome';

  @override
  String get enterNameError => 'Inserire un nome valido';

  @override
  String get enterCost => 'Inserire il costo';

  @override
  String get enterCostError => 'Inserire un importo numerico';

  @override
  String get addPersonDesc => 'Aggiungi delle persone per iniziare a calcolare i costi';

  @override
  String get removePersonDescription => 'Sei sicuro di voler rimuovere questa persona?';

  @override
  String get calculate => 'Calcola';

  @override
  String get close => 'Chiudi';

  @override
  String get total => 'Totale';

  @override
  String get confirm => 'Conferma';

  @override
  String get cancel => 'Annulla';

  @override
  String get yes => 'Si';

  @override
  String get no => 'No';

  @override
  String get pay => 'paga';

  @override
  String get spent => 'ha speso';

  @override
  String get hasToPay => 'deve pagare';

  @override
  String get shouldReceive => 'deve ricevere';

  @override
  String get solution => 'SOLUZIONE';

  @override
  String get enteredCosts => 'COSTI INSERITI';

  @override
  String get debitors => 'DEBITORI';

  @override
  String get creditors => 'CREDITORI';

  @override
  String to(num val) {
    return intl.Intl.pluralLogic(
      val,
      locale: localeName,
      one: 'ad',
      other: 'a',
    );
  }

  @override
  String enterNameErrorLength(num val) {
    return intl.Intl.pluralLogic(
      val,
      locale: localeName,
      other: 'Il nome non può superare i $val caratteri',
    );
  }

  @override
  String enterCostErrorLength(num val) {
    return intl.Intl.pluralLogic(
      val,
      locale: localeName,
      other: 'Il costo non può superare i $val caratteri',
    );
  }

  @override
  String costPerPerson(num count) {
    return intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Costo a persona ($count)',
    );
  }
}
