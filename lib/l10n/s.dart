import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 's_en.dart';
import 's_it.dart';

/// Callers can lookup localized strings with an instance of S
/// returned by `S.of(context)`.
///
/// Applications need to include `S.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/s.dart';
///
/// return MaterialApp(
///   localizationsDelegates: S.localizationsDelegates,
///   supportedLocales: S.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the S.supportedLocales
/// property.
abstract class S {
  S(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static S? of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  static const LocalizationsDelegate<S> delegate = _SDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('it')
  ];

  /// No description provided for @addPerson.
  ///
  /// In en, this message translates to:
  /// **'Add person'**
  String get addPerson;

  /// No description provided for @enterName.
  ///
  /// In en, this message translates to:
  /// **'Enter name'**
  String get enterName;

  /// No description provided for @enterNameError.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid name'**
  String get enterNameError;

  /// No description provided for @enterCost.
  ///
  /// In en, this message translates to:
  /// **'Enter cost'**
  String get enterCost;

  /// No description provided for @enterCostError.
  ///
  /// In en, this message translates to:
  /// **'Enter a numerical amount'**
  String get enterCostError;

  /// No description provided for @addPersonDesc.
  ///
  /// In en, this message translates to:
  /// **'Add some people to start calculating'**
  String get addPersonDesc;

  /// No description provided for @removePersonDescription.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove this person?'**
  String get removePersonDescription;

  /// No description provided for @calculate.
  ///
  /// In en, this message translates to:
  /// **'Calculate'**
  String get calculate;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @pay.
  ///
  /// In en, this message translates to:
  /// **'pays'**
  String get pay;

  /// No description provided for @spent.
  ///
  /// In en, this message translates to:
  /// **'spent'**
  String get spent;

  /// No description provided for @hasToPay.
  ///
  /// In en, this message translates to:
  /// **'has to pay'**
  String get hasToPay;

  /// No description provided for @shouldReceive.
  ///
  /// In en, this message translates to:
  /// **'should receive'**
  String get shouldReceive;

  /// No description provided for @solution.
  ///
  /// In en, this message translates to:
  /// **'SOLUTION'**
  String get solution;

  /// No description provided for @enteredCosts.
  ///
  /// In en, this message translates to:
  /// **'ENTERED COSTS'**
  String get enteredCosts;

  /// No description provided for @debitors.
  ///
  /// In en, this message translates to:
  /// **'DEBITORS'**
  String get debitors;

  /// No description provided for @creditors.
  ///
  /// In en, this message translates to:
  /// **'CREDITORS'**
  String get creditors;

  /// No description provided for @to.
  ///
  /// In en, this message translates to:
  /// **'{val,plural,other{to}}'**
  String to(num val);

  /// No description provided for @enterNameErrorLength.
  ///
  /// In en, this message translates to:
  /// **'{val,plural,other{The name cannot exceed {val} characters}}'**
  String enterNameErrorLength(num val);

  /// No description provided for @enterCostErrorLength.
  ///
  /// In en, this message translates to:
  /// **'{val,plural,other{The cost cannot exceed {val} characters}}'**
  String enterCostErrorLength(num val);

  /// No description provided for @costPerPerson.
  ///
  /// In en, this message translates to:
  /// **'{count,plural,other{Cost per person ({count})}}'**
  String costPerPerson(num count);
}

class _SDelegate extends LocalizationsDelegate<S> {
  const _SDelegate();

  @override
  Future<S> load(Locale locale) {
    return SynchronousFuture<S>(lookupS(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'it'].contains(locale.languageCode);

  @override
  bool shouldReload(_SDelegate old) => false;
}

S lookupS(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return SEn();
    case 'it': return SIt();
  }

  throw FlutterError(
    'S.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
