class Doctor {
  final String name;
  final String specialization;
  final Map<String, String> availability;
  final String hospital;

  Doctor({
    required this.name,
    required this.specialization,
    required this.availability,
    required this.hospital,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      name: json['name'],
      specialization: json['specialization'],
      availability: Map<String, String>.from(json['availability']),
      hospital: json['hospital'],
    );
  }
}
