import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
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
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('fr')
  ];

  /// No description provided for @tagline.
  ///
  /// In fr, this message translates to:
  /// **'Réservez votre fauteuil. Gérez votre journée.'**
  String get tagline;

  /// No description provided for @signIn.
  ///
  /// In fr, this message translates to:
  /// **'Se connecter'**
  String get signIn;

  /// No description provided for @createAccount.
  ///
  /// In fr, this message translates to:
  /// **'Créer un compte'**
  String get createAccount;

  /// No description provided for @fullName.
  ///
  /// In fr, this message translates to:
  /// **'Nom complet'**
  String get fullName;

  /// No description provided for @email.
  ///
  /// In fr, this message translates to:
  /// **'E-mail'**
  String get email;

  /// No description provided for @password.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe'**
  String get password;

  /// No description provided for @haveAccount.
  ///
  /// In fr, this message translates to:
  /// **'J’ai déjà un compte'**
  String get haveAccount;

  /// No description provided for @newCustomer.
  ///
  /// In fr, this message translates to:
  /// **'Nouveau client ? Créez un compte'**
  String get newCustomer;

  /// No description provided for @demoAccounts.
  ///
  /// In fr, this message translates to:
  /// **'COMPTES DE DÉMONSTRATION'**
  String get demoAccounts;

  /// No description provided for @roleCustomer.
  ///
  /// In fr, this message translates to:
  /// **'Client'**
  String get roleCustomer;

  /// No description provided for @roleEmployee.
  ///
  /// In fr, this message translates to:
  /// **'Barbier'**
  String get roleEmployee;

  /// No description provided for @roleOwner.
  ///
  /// In fr, this message translates to:
  /// **'Propriétaire'**
  String get roleOwner;

  /// No description provided for @rolePlatformAdmin.
  ///
  /// In fr, this message translates to:
  /// **'Admin plateforme'**
  String get rolePlatformAdmin;

  /// No description provided for @language.
  ///
  /// In fr, this message translates to:
  /// **'Langue'**
  String get language;

  /// No description provided for @languageFr.
  ///
  /// In fr, this message translates to:
  /// **'Français'**
  String get languageFr;

  /// No description provided for @languageAr.
  ///
  /// In fr, this message translates to:
  /// **'العربية'**
  String get languageAr;

  /// No description provided for @signOut.
  ///
  /// In fr, this message translates to:
  /// **'Déconnexion'**
  String get signOut;

  /// No description provided for @retry.
  ///
  /// In fr, this message translates to:
  /// **'Réessayer'**
  String get retry;

  /// No description provided for @errWrongCredentials.
  ///
  /// In fr, this message translates to:
  /// **'E-mail ou mot de passe incorrect.'**
  String get errWrongCredentials;

  /// No description provided for @errInvalidInput.
  ///
  /// In fr, this message translates to:
  /// **'Informations invalides ou e-mail déjà utilisé. Vérifiez les champs (e-mail valide, mot de passe de 6 caractères minimum).'**
  String get errInvalidInput;

  /// No description provided for @errSlotTaken.
  ///
  /// In fr, this message translates to:
  /// **'Ce créneau vient d’être réservé.'**
  String get errSlotTaken;

  /// No description provided for @errUnknown.
  ///
  /// In fr, this message translates to:
  /// **'Une erreur est survenue. Veuillez réessayer.'**
  String get errUnknown;

  /// No description provided for @navExplore.
  ///
  /// In fr, this message translates to:
  /// **'Explorer'**
  String get navExplore;

  /// No description provided for @navAppointments.
  ///
  /// In fr, this message translates to:
  /// **'Rendez-vous'**
  String get navAppointments;

  /// No description provided for @titleAppointments.
  ///
  /// In fr, this message translates to:
  /// **'Mes rendez-vous'**
  String get titleAppointments;

  /// No description provided for @hello.
  ///
  /// In fr, this message translates to:
  /// **'Bonjour, {name}'**
  String hello(String name);

  /// No description provided for @findBarber.
  ///
  /// In fr, this message translates to:
  /// **'Trouvez votre barbier'**
  String get findBarber;

  /// No description provided for @searchHint.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher un barbier ou un salon...'**
  String get searchHint;

  /// No description provided for @fromPrice.
  ///
  /// In fr, this message translates to:
  /// **'À partir de {price}'**
  String fromPrice(String price);

  /// No description provided for @nextSlot.
  ///
  /// In fr, this message translates to:
  /// **'Prochain : {when}'**
  String nextSlot(String when);

  /// No description provided for @fullyBooked.
  ///
  /// In fr, this message translates to:
  /// **'Complet cette semaine'**
  String get fullyBooked;

  /// No description provided for @viewSlots.
  ///
  /// In fr, this message translates to:
  /// **'Voir les créneaux'**
  String get viewSlots;

  /// No description provided for @noBarber.
  ///
  /// In fr, this message translates to:
  /// **'Aucun barbier trouvé.'**
  String get noBarber;

  /// No description provided for @rating.
  ///
  /// In fr, this message translates to:
  /// **'★ {rating} ({count} avis)'**
  String rating(String rating, int count);

  /// No description provided for @selectService.
  ///
  /// In fr, this message translates to:
  /// **'Choisir le service'**
  String get selectService;

  /// No description provided for @chooseDate.
  ///
  /// In fr, this message translates to:
  /// **'Choisir la date'**
  String get chooseDate;

  /// No description provided for @availableTime.
  ///
  /// In fr, this message translates to:
  /// **'Heures disponibles'**
  String get availableTime;

  /// No description provided for @noOpenings.
  ///
  /// In fr, this message translates to:
  /// **'Aucun créneau libre ce jour-là.'**
  String get noOpenings;

  /// No description provided for @minutesShort.
  ///
  /// In fr, this message translates to:
  /// **'{minutes} min'**
  String minutesShort(int minutes);

  /// No description provided for @pickATime.
  ///
  /// In fr, this message translates to:
  /// **'Choisir une heure'**
  String get pickATime;

  /// No description provided for @confirmBooking.
  ///
  /// In fr, this message translates to:
  /// **'Confirmer • {price} • {when}'**
  String confirmBooking(String price, String when);

  /// No description provided for @booked.
  ///
  /// In fr, this message translates to:
  /// **'Réservé {when} avec {name}'**
  String booked(String when, String name);

  /// No description provided for @tabUpcoming.
  ///
  /// In fr, this message translates to:
  /// **'À venir ({count})'**
  String tabUpcoming(int count);

  /// No description provided for @tabPast.
  ///
  /// In fr, this message translates to:
  /// **'Passés ({count})'**
  String tabPast(int count);

  /// No description provided for @noUpcoming.
  ///
  /// In fr, this message translates to:
  /// **'Aucun rendez-vous à venir.'**
  String get noUpcoming;

  /// No description provided for @noHistory.
  ///
  /// In fr, this message translates to:
  /// **'Aucun historique pour le moment.'**
  String get noHistory;

  /// No description provided for @confirmedSession.
  ///
  /// In fr, this message translates to:
  /// **'Rendez-vous confirmé'**
  String get confirmedSession;

  /// No description provided for @sessionDetails.
  ///
  /// In fr, this message translates to:
  /// **'{service} • {minutes} min • {price} (à régler sur place)'**
  String sessionDetails(String service, int minutes, String price);

  /// No description provided for @withBarber.
  ///
  /// In fr, this message translates to:
  /// **'avec {name}'**
  String withBarber(String name);

  /// No description provided for @cancelAppointment.
  ///
  /// In fr, this message translates to:
  /// **'Annuler le rendez-vous'**
  String get cancelAppointment;

  /// No description provided for @rebook.
  ///
  /// In fr, this message translates to:
  /// **'Réserver à nouveau'**
  String get rebook;

  /// No description provided for @mySchedule.
  ///
  /// In fr, this message translates to:
  /// **'Mon planning'**
  String get mySchedule;

  /// No description provided for @statBooked.
  ///
  /// In fr, this message translates to:
  /// **'Réservés'**
  String get statBooked;

  /// No description provided for @statEstDaily.
  ///
  /// In fr, this message translates to:
  /// **'CA estimé'**
  String get statEstDaily;

  /// No description provided for @statOpenings.
  ///
  /// In fr, this message translates to:
  /// **'Créneaux libres'**
  String get statOpenings;

  /// No description provided for @nClients.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =0{Aucun client} =1{1 client} other{{count} clients}}'**
  String nClients(int count);

  /// No description provided for @nextInChair.
  ///
  /// In fr, this message translates to:
  /// **'Prochain sur le fauteuil'**
  String get nextInChair;

  /// No description provided for @inTheChair.
  ///
  /// In fr, this message translates to:
  /// **'Sur le fauteuil'**
  String get inTheChair;

  /// No description provided for @checkIn.
  ///
  /// In fr, this message translates to:
  /// **'Arrivée'**
  String get checkIn;

  /// No description provided for @complete.
  ///
  /// In fr, this message translates to:
  /// **'Terminer'**
  String get complete;

  /// No description provided for @cancel.
  ///
  /// In fr, this message translates to:
  /// **'Annuler'**
  String get cancel;

  /// No description provided for @timeline.
  ///
  /// In fr, this message translates to:
  /// **'Agenda de la journée'**
  String get timeline;

  /// No description provided for @noAppointmentsDay.
  ///
  /// In fr, this message translates to:
  /// **'Aucun rendez-vous ce jour-là.'**
  String get noAppointmentsDay;

  /// No description provided for @noBarberProfile.
  ///
  /// In fr, this message translates to:
  /// **'Aucun profil de barbier n’est lié à ce compte.'**
  String get noBarberProfile;

  /// No description provided for @statusConfirmed.
  ///
  /// In fr, this message translates to:
  /// **'Confirmé'**
  String get statusConfirmed;

  /// No description provided for @statusCheckedIn.
  ///
  /// In fr, this message translates to:
  /// **'Sur le fauteuil'**
  String get statusCheckedIn;

  /// No description provided for @statusCompleted.
  ///
  /// In fr, this message translates to:
  /// **'Terminé'**
  String get statusCompleted;

  /// No description provided for @statusCancelled.
  ///
  /// In fr, this message translates to:
  /// **'Annulé'**
  String get statusCancelled;

  /// No description provided for @ownerTitle.
  ///
  /// In fr, this message translates to:
  /// **'Mon salon'**
  String get ownerTitle;

  /// No description provided for @navOverview.
  ///
  /// In fr, this message translates to:
  /// **'Aperçu'**
  String get navOverview;

  /// No description provided for @navBarbers.
  ///
  /// In fr, this message translates to:
  /// **'Barbiers'**
  String get navBarbers;

  /// No description provided for @navServices.
  ///
  /// In fr, this message translates to:
  /// **'Services'**
  String get navServices;

  /// No description provided for @statCustomers.
  ///
  /// In fr, this message translates to:
  /// **'Clients'**
  String get statCustomers;

  /// No description provided for @statBarbers.
  ///
  /// In fr, this message translates to:
  /// **'Barbiers'**
  String get statBarbers;

  /// No description provided for @statBookings.
  ///
  /// In fr, this message translates to:
  /// **'Réservations'**
  String get statBookings;

  /// No description provided for @statRevenue.
  ///
  /// In fr, this message translates to:
  /// **'Revenus'**
  String get statRevenue;

  /// No description provided for @latestAppointments.
  ///
  /// In fr, this message translates to:
  /// **'Derniers rendez-vous'**
  String get latestAppointments;

  /// No description provided for @newBarber.
  ///
  /// In fr, this message translates to:
  /// **'Nouveau barbier'**
  String get newBarber;

  /// No description provided for @newService.
  ///
  /// In fr, this message translates to:
  /// **'Nouveau service'**
  String get newService;

  /// No description provided for @fieldName.
  ///
  /// In fr, this message translates to:
  /// **'Nom'**
  String get fieldName;

  /// No description provided for @fieldSpecialty.
  ///
  /// In fr, this message translates to:
  /// **'Spécialité'**
  String get fieldSpecialty;

  /// No description provided for @fieldShop.
  ///
  /// In fr, this message translates to:
  /// **'Salon'**
  String get fieldShop;

  /// No description provided for @fieldMinutes.
  ///
  /// In fr, this message translates to:
  /// **'Durée (minutes)'**
  String get fieldMinutes;

  /// No description provided for @fieldPrice.
  ///
  /// In fr, this message translates to:
  /// **'Prix (DT)'**
  String get fieldPrice;

  /// No description provided for @add.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter'**
  String get add;

  /// No description provided for @platformTitle.
  ///
  /// In fr, this message translates to:
  /// **'Administration de la plateforme'**
  String get platformTitle;

  /// No description provided for @platformSoon.
  ///
  /// In fr, this message translates to:
  /// **'Les outils de la plateforme (validation des salons, modération, statistiques) arriveront dans une prochaine phase.'**
  String get platformSoon;

  /// No description provided for @whenToday.
  ///
  /// In fr, this message translates to:
  /// **'Aujourd’hui, {time}'**
  String whenToday(String time);

  /// No description provided for @whenTomorrow.
  ///
  /// In fr, this message translates to:
  /// **'Demain, {time}'**
  String whenTomorrow(String time);

  /// No description provided for @whenOther.
  ///
  /// In fr, this message translates to:
  /// **'{date}, {time}'**
  String whenOther(String date, String time);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
