class EventModel {
  final double baseRate;
  final int minGuests;
  final int maxGuests;
  final String currency;
  final String description;
  final bool isActive;
  final List<String> packageIncludes;

  const EventModel({
    required this.baseRate,
    required this.minGuests,
    required this.maxGuests,
    required this.currency,
    required this.description,
    required this.isActive,
    required this.packageIncludes,
  });

  factory EventModel.fromMap(Map<String, dynamic> map) {
    return EventModel(
      baseRate: (map['baseRate'] as num?)?.toDouble() ?? 0,
      minGuests: (map['minGuests'] as num?)?.toInt() ?? 0,
      maxGuests: (map['maxGuests'] as num?)?.toInt() ?? 0,
      currency: map['currency'] as String? ?? 'USD',
      description: map['description'] as String? ?? '',
      isActive: map['isActive'] as bool? ?? false,
      packageIncludes:
          (map['packageIncludes'] as List?)?.whereType<String>().toList() ?? [],
    );
  }
}
