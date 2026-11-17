class Service {
  const Service({
    required this.id,
    required this.name,
    required this.minutes,
    required this.priceMillimes,
    this.desc = '',
  });
  final String id, name, desc;
  final int minutes;

  /// Price in millimes (1 TND = 1000 millimes).
  final int priceMillimes;
}
