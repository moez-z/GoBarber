// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get tagline => 'Réservez votre fauteuil. Gérez votre journée.';

  @override
  String get signIn => 'Se connecter';

  @override
  String get createAccount => 'Créer un compte';

  @override
  String get fullName => 'Nom complet';

  @override
  String get email => 'E-mail';

  @override
  String get password => 'Mot de passe';

  @override
  String get haveAccount => 'J’ai déjà un compte';

  @override
  String get newCustomer => 'Nouveau client ? Créez un compte';

  @override
  String get demoAccounts => 'COMPTES DE DÉMONSTRATION (DEBUG)';

  @override
  String get roleCustomer => 'Client';

  @override
  String get roleEmployee => 'Barbier';

  @override
  String get roleOwner => 'Propriétaire';

  @override
  String get rolePlatformAdmin => 'Admin plateforme';

  @override
  String get language => 'Langue';

  @override
  String get languageFr => 'Français';

  @override
  String get languageAr => 'العربية';

  @override
  String get signOut => 'Déconnexion';

  @override
  String get retry => 'Réessayer';

  @override
  String get errWrongCredentials => 'E-mail ou mot de passe incorrect.';

  @override
  String get errInvalidInput =>
      'Informations invalides ou e-mail déjà utilisé. Vérifiez les champs (e-mail valide, mot de passe de 6 caractères minimum).';

  @override
  String get errSlotTaken => 'Ce créneau vient d’être réservé.';

  @override
  String get errUnknown => 'Une erreur est survenue. Veuillez réessayer.';

  @override
  String get navExplore => 'Explorer';

  @override
  String get navAppointments => 'Rendez-vous';

  @override
  String get titleAppointments => 'Mes rendez-vous';

  @override
  String hello(String name) {
    return 'Bonjour, $name';
  }

  @override
  String get findBarber => 'Trouvez votre barbier';

  @override
  String get searchHint => 'Rechercher un barbier ou un salon...';

  @override
  String fromPrice(String price) {
    return 'À partir de $price';
  }

  @override
  String nextSlot(String when) {
    return 'Prochain : $when';
  }

  @override
  String get fullyBooked => 'Complet cette semaine';

  @override
  String get viewSlots => 'Voir les créneaux';

  @override
  String get noBarber => 'Aucun barbier trouvé.';

  @override
  String rating(String rating, int count) {
    return '★ $rating ($count avis)';
  }

  @override
  String get selectService => 'Choisir le service';

  @override
  String get chooseDate => 'Choisir la date';

  @override
  String get availableTime => 'Heures disponibles';

  @override
  String get noOpenings => 'Aucun créneau libre ce jour-là.';

  @override
  String minutesShort(int minutes) {
    return '$minutes min';
  }

  @override
  String get pickATime => 'Choisir une heure';

  @override
  String confirmBooking(String price, String when) {
    return 'Confirmer • $price • $when';
  }

  @override
  String booked(String when, String name) {
    return 'Réservé $when avec $name';
  }

  @override
  String tabUpcoming(int count) {
    return 'À venir ($count)';
  }

  @override
  String tabPast(int count) {
    return 'Passés ($count)';
  }

  @override
  String get noUpcoming => 'Aucun rendez-vous à venir.';

  @override
  String get noHistory => 'Aucun historique pour le moment.';

  @override
  String get confirmedSession => 'Rendez-vous confirmé';

  @override
  String sessionDetails(String service, int minutes, String price) {
    return '$service • $minutes min • $price (à régler sur place)';
  }

  @override
  String withBarber(String name) {
    return 'avec $name';
  }

  @override
  String get cancelAppointment => 'Annuler le rendez-vous';

  @override
  String get rebook => 'Réserver à nouveau';

  @override
  String get mySchedule => 'Mon planning';

  @override
  String get statBooked => 'Réservés';

  @override
  String get statEstDaily => 'CA estimé';

  @override
  String get statOpenings => 'Créneaux libres';

  @override
  String nClients(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count clients',
      one: '1 client',
      zero: 'Aucun client',
    );
    return '$_temp0';
  }

  @override
  String get nextInChair => 'Prochain sur le fauteuil';

  @override
  String get inTheChair => 'Sur le fauteuil';

  @override
  String get checkIn => 'Arrivée';

  @override
  String get complete => 'Terminer';

  @override
  String get cancel => 'Annuler';

  @override
  String get timeline => 'Agenda de la journée';

  @override
  String get noAppointmentsDay => 'Aucun rendez-vous ce jour-là.';

  @override
  String get noBarberProfile =>
      'Aucun profil de barbier n’est lié à ce compte.';

  @override
  String get statusConfirmed => 'Confirmé';

  @override
  String get statusCheckedIn => 'Sur le fauteuil';

  @override
  String get statusCompleted => 'Terminé';

  @override
  String get statusCancelled => 'Annulé';

  @override
  String get ownerTitle => 'Mon salon';

  @override
  String get navOverview => 'Aperçu';

  @override
  String get navBarbers => 'Barbiers';

  @override
  String get navServices => 'Services';

  @override
  String get statCustomers => 'Clients';

  @override
  String get statBarbers => 'Barbiers';

  @override
  String get statBookings => 'Réservations';

  @override
  String get statRevenue => 'Revenus';

  @override
  String get latestAppointments => 'Derniers rendez-vous';

  @override
  String get newBarber => 'Nouveau barbier';

  @override
  String get newService => 'Nouveau service';

  @override
  String get fieldName => 'Nom';

  @override
  String get fieldSpecialty => 'Spécialité';

  @override
  String get fieldShop => 'Salon';

  @override
  String get fieldMinutes => 'Durée (minutes)';

  @override
  String get fieldPrice => 'Prix (DT)';

  @override
  String get add => 'Ajouter';

  @override
  String get platformTitle => 'Administration de la plateforme';

  @override
  String get platformSoon =>
      'Les outils de la plateforme (validation des salons, modération, statistiques) arriveront dans une prochaine phase.';

  @override
  String whenToday(String time) {
    return 'Aujourd’hui, $time';
  }

  @override
  String whenTomorrow(String time) {
    return 'Demain, $time';
  }

  @override
  String whenOther(String date, String time) {
    return '$date, $time';
  }

  @override
  String get forgotPassword => 'Mot de passe oublié ?';

  @override
  String get resetTitle => 'Réinitialiser le mot de passe';

  @override
  String get resetIntro =>
      'Saisissez votre e-mail. Nous vous enverrons un lien pour choisir un nouveau mot de passe.';

  @override
  String get resetSend => 'Envoyer le lien';

  @override
  String get resetSent =>
      'Si un compte existe pour cet e-mail, un lien de réinitialisation vient d’être envoyé. Pensez à vérifier vos courriers indésirables.';

  @override
  String get backToSignIn => 'Retour à la connexion';

  @override
  String get passwordRules =>
      'Au moins 8 caractères, avec une lettre et un chiffre.';

  @override
  String get fieldRequired => 'Champ obligatoire.';

  @override
  String get fieldInvalidEmail => 'Adresse e-mail invalide.';

  @override
  String get fieldNameShort => 'Nom trop court.';

  @override
  String get fieldPasswordShort => '8 caractères minimum.';

  @override
  String get fieldPasswordWeak => 'Ajoutez au moins une lettre et un chiffre.';

  @override
  String get errInvalidEmail => 'Adresse e-mail invalide.';

  @override
  String get errWeakPassword =>
      'Mot de passe trop faible : 8 caractères minimum, avec une lettre et un chiffre.';

  @override
  String get errEmailInUse => 'Un compte existe déjà avec cet e-mail.';

  @override
  String get errNetwork => 'Problème de connexion. Vérifiez votre réseau.';

  @override
  String get errTooMany => 'Trop de tentatives. Réessayez plus tard.';

  @override
  String get errUserDisabled => 'Ce compte est désactivé.';

  @override
  String get errUnavailable =>
      'La connexion n’est pas disponible sur cette plateforme.';

  @override
  String verifyBanner(String email) {
    return 'Vérifiez votre e-mail ($email) pour sécuriser votre compte.';
  }

  @override
  String get verifyResend => 'Renvoyer l’e-mail';

  @override
  String get verifyRefresh => 'J’ai vérifié';

  @override
  String get verifySent => 'E-mail de vérification envoyé.';

  @override
  String get verifyNotYet => 'Pas encore vérifié.';
}
