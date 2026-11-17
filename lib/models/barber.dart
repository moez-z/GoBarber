class Barber {
  const Barber({
    required this.id,
    required this.userId,
    required this.name,
    required this.specialty,
    required this.shop,
    this.rating = 5.0,
    this.reviews = 0,
    this.open = 9,
    this.close = 19,
  });
  final String id, userId, name, specialty, shop;
  final double rating;
  final int reviews;

  /// Opening and closing hour (24h).
  final int open, close;
}
