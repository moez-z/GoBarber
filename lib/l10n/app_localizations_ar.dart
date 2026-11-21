// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get tagline => 'احجز كرسيك. نظّم نهارك.';

  @override
  String get signIn => 'دخول';

  @override
  String get createAccount => 'إنشاء حساب';

  @override
  String get fullName => 'الاسم الكامل';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get password => 'كلمة السر';

  @override
  String get haveAccount => 'عندي حساب';

  @override
  String get newCustomer => 'حريف جديد؟ أنشئ حساب';

  @override
  String get demoAccounts => 'حسابات تجريبية (للتطوير فقط)';

  @override
  String get roleCustomer => 'حريف';

  @override
  String get roleEmployee => 'حلّاق';

  @override
  String get roleOwner => 'صاحب الصالون';

  @override
  String get rolePlatformAdmin => 'إدارة المنصة';

  @override
  String get language => 'اللغة';

  @override
  String get languageFr => 'Français';

  @override
  String get languageAr => 'العربية';

  @override
  String get signOut => 'خروج';

  @override
  String get retry => 'عاود جرّب';

  @override
  String get errWrongCredentials => 'الإيميل ولا كلمة السر غالطين.';

  @override
  String get errInvalidInput =>
      'المعطيات غالطة ولا الإيميل مستعمل. ثبّت في الخانات (إيميل صحيح، كلمة سر من 6 حروف على الأقل).';

  @override
  String get errSlotTaken => 'الموعد هذا تحجز توّا.';

  @override
  String get errUnknown => 'صار مشكل. عاود جرّب.';

  @override
  String get navExplore => 'اكتشف';

  @override
  String get navAppointments => 'المواعيد';

  @override
  String get titleAppointments => 'مواعيدي';

  @override
  String hello(String name) {
    return 'مرحبا $name';
  }

  @override
  String get findBarber => 'لوّج على حلّاقك';

  @override
  String get searchHint => 'لوّج على حلّاق ولا صالون...';

  @override
  String fromPrice(String price) {
    return 'من $price';
  }

  @override
  String nextSlot(String when) {
    return 'أقرب موعد: $when';
  }

  @override
  String get fullyBooked => 'كل المواعيد محجوزة السيمانة هاذي';

  @override
  String get viewSlots => 'شوف المواعيد';

  @override
  String get noBarber => 'ما لقينا حتى حلّاق.';

  @override
  String rating(String rating, int count) {
    return '★ $rating ($count تقييم)';
  }

  @override
  String get selectService => 'اختار الخدمة';

  @override
  String get chooseDate => 'اختار النهار';

  @override
  String get availableTime => 'الأوقات الفارغة';

  @override
  String get noOpenings => 'ما فما حتى وقت فارغ في النهار هذا.';

  @override
  String minutesShort(int minutes) {
    return '$minutes دق';
  }

  @override
  String get pickATime => 'اختار وقت';

  @override
  String confirmBooking(String price, String when) {
    return 'تأكيد • $price • $when';
  }

  @override
  String booked(String when, String name) {
    return 'تم الحجز $when مع $name';
  }

  @override
  String tabUpcoming(int count) {
    return 'القادمة ($count)';
  }

  @override
  String tabPast(int count) {
    return 'السابقة ($count)';
  }

  @override
  String get noUpcoming => 'ما عندك حتى موعد جاي.';

  @override
  String get noHistory => 'ما عندك حتى موعد قبل.';

  @override
  String get confirmedSession => 'موعد مؤكّد';

  @override
  String sessionDetails(String service, int minutes, String price) {
    return '$service • $minutes دق • $price (الدفع في الصالون)';
  }

  @override
  String withBarber(String name) {
    return 'مع $name';
  }

  @override
  String get cancelAppointment => 'إلغاء الموعد';

  @override
  String get rebook => 'احجز عاود';

  @override
  String get mySchedule => 'برنامجي';

  @override
  String get statBooked => 'محجوز';

  @override
  String get statEstDaily => 'المداخيل المتوقعة';

  @override
  String get statOpenings => 'أوقات فارغة';

  @override
  String nClients(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count حرفاء',
      two: 'زوز حرفاء',
      one: 'حريف واحد',
      zero: 'ما فما حتى حريف',
    );
    return '$_temp0';
  }

  @override
  String get nextInChair => 'الجاي على الكرسي';

  @override
  String get inTheChair => 'على الكرسي';

  @override
  String get checkIn => 'وصل';

  @override
  String get complete => 'كمّل';

  @override
  String get cancel => 'إلغاء';

  @override
  String get timeline => 'برنامج النهار';

  @override
  String get noAppointmentsDay => 'ما فما حتى موعد في النهار هذا.';

  @override
  String get noBarberProfile => 'ما فما حتى بروفيل حلّاق مربوط بالحساب هذا.';

  @override
  String get statusConfirmed => 'مؤكّد';

  @override
  String get statusCheckedIn => 'على الكرسي';

  @override
  String get statusCompleted => 'مكتمل';

  @override
  String get statusCancelled => 'ملغى';

  @override
  String get ownerTitle => 'صالوني';

  @override
  String get navOverview => 'نظرة عامة';

  @override
  String get navBarbers => 'الحلّاقة';

  @override
  String get navServices => 'الخدمات';

  @override
  String get statCustomers => 'الحرفاء';

  @override
  String get statBarbers => 'الحلّاقة';

  @override
  String get statBookings => 'الحجوزات';

  @override
  String get statRevenue => 'المداخيل';

  @override
  String get latestAppointments => 'آخر المواعيد';

  @override
  String get newBarber => 'حلّاق جديد';

  @override
  String get newService => 'خدمة جديدة';

  @override
  String get fieldName => 'الاسم';

  @override
  String get fieldSpecialty => 'الاختصاص';

  @override
  String get fieldShop => 'الصالون';

  @override
  String get fieldMinutes => 'المدة (دقائق)';

  @override
  String get fieldPrice => 'السعر (د.ت)';

  @override
  String get add => 'زيد';

  @override
  String get platformTitle => 'إدارة المنصة';

  @override
  String get platformSoon =>
      'أدوات إدارة المنصة (قبول الصالونات، المراجعة، الإحصائيات) جايين في مرحلة جاية.';

  @override
  String whenToday(String time) {
    return 'اليوم، $time';
  }

  @override
  String whenTomorrow(String time) {
    return 'غدوة، $time';
  }

  @override
  String whenOther(String date, String time) {
    return '$date، $time';
  }

  @override
  String get forgotPassword => 'نسيت كلمة السر؟';

  @override
  String get resetTitle => 'إعادة تعيين كلمة السر';

  @override
  String get resetIntro =>
      'اكتب الإيميل متاعك وباش نبعثولك رابط باش تختار كلمة سر جديدة.';

  @override
  String get resetSend => 'ابعث الرابط';

  @override
  String get resetSent =>
      'إذا فما حساب بالإيميل هذا، تبعثلو رابط إعادة التعيين. شوف زادة في الرسائل غير المرغوب فيها.';

  @override
  String get backToSignIn => 'رجوع للدخول';

  @override
  String get passwordRules => '8 خانات على الأقل، فيهم حرف ورقم.';

  @override
  String get fieldRequired => 'الخانة هاذي لازمة.';

  @override
  String get fieldInvalidEmail => 'الإيميل موش صحيح.';

  @override
  String get fieldNameShort => 'الاسم قصير برشا.';

  @override
  String get fieldPasswordShort => '8 خانات على الأقل.';

  @override
  String get fieldPasswordWeak => 'لازم فيها حرف ورقم.';

  @override
  String get errInvalidEmail => 'الإيميل موش صحيح.';

  @override
  String get errWeakPassword =>
      'كلمة السر ضعيفة: 8 خانات على الأقل، فيها حرف ورقم.';

  @override
  String get errEmailInUse => 'فما حساب بالإيميل هذا من قبل.';

  @override
  String get errNetwork => 'مشكل في الكونيكسيون. ثبّت في الإنترنت متاعك.';

  @override
  String get errTooMany => 'برشا محاولات. عاود جرّب مبعد.';

  @override
  String get errUserDisabled => 'الحساب هذا موقوف.';

  @override
  String get errUnavailable => 'الدخول موش متاح على المنصة هاذي.';

  @override
  String verifyBanner(String email) {
    return 'أكّد الإيميل متاعك ($email) باش نحميو حسابك.';
  }

  @override
  String get verifyResend => 'عاود ابعث الإيميل';

  @override
  String get verifyRefresh => 'تأكدت';

  @override
  String get verifySent => 'تبعث إيميل التأكيد.';

  @override
  String get verifyNotYet => 'باقي ما تأكدش.';
}
