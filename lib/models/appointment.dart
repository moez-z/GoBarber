enum Status { confirmed, checkedIn, completed, cancelled }

class Appointment {
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
    required this.priceMillimes,
    this.status = Status.confirmed,
  });
  final String id, customerId, customerName, barberId, barberName, serviceId, serviceName;
  final DateTime start;
  final int minutes, priceMillimes;
  Status status;

  DateTime get end => start.add(Duration(minutes: minutes));

  Appointment copyWithId(String newId) => Appointment(
        id: newId,
        customerId: customerId,
        customerName: customerName,
        barberId: barberId,
        barberName: barberName,
        serviceId: serviceId,
        serviceName: serviceName,
        start: start,
        minutes: minutes,
        priceMillimes: priceMillimes,
        status: status,
      );
}
