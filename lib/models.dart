enum Role { customer, barber, admin }

enum Status { confirmed, checkedIn, completed, cancelled }

class AppUser {
  final String id, name, email, password;
  final Role role;
  AppUser(this.id, this.name, this.email, this.password, this.role);
}

class Barber {
  final String id, userId, name, specialty, shop;
  final double rating;
  final int reviews, open, close; // open/close = shop hours (24h)
  Barber(this.id, this.userId, this.name, this.specialty, this.shop,
      [this.rating = 5.0, this.reviews = 0, this.open = 9, this.close = 19]);
}

class Service {
  final String id, name, desc;
  final int minutes;
  final double price;
  Service(this.id, this.name, this.minutes, this.price, this.desc);
}

class Appointment {
  final String id, customerId, customerName, barberId, barberName;
  final String serviceId, serviceName;
  final DateTime start;
  final int minutes;
  final double price;
  Status status;
  Appointment({
    required this.id,
    required this.customerId,
    required this.customerName,
    required this.barberId,
    required this.barberName,
    required this.serviceId,
    required this.serviceName,
    required this.start,
    required this.minutes,
    required this.price,
    this.status = Status.confirmed,
  });
  DateTime get end => start.add(Duration(minutes: minutes));
}
