class User {
  final String phoneNumber;

  User({
    required this.phoneNumber,
  });

  Map<String, dynamic> toMap() {
    return {
      'phone_number': phoneNumber,
    };
  }

  static User fromMap(Map<String, dynamic> map) {
    return User(
      phoneNumber: map['phone_number'],
    );
  }
}

class Prescription {
  final int? id;
  final String phoneNumber;
  final String medicineName;
  final String dosage;
  final String duration;
  final String date;

  Prescription({
    this.id,
    required this.phoneNumber,
    required this.medicineName,
    required this.dosage,
    required this.duration,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'phone_number': phoneNumber,
      'medicine_name': medicineName,
      'dosage': dosage,
      'duration': duration,
      'date': date,
    };
  }

  static Prescription fromMap(Map<String, dynamic> map) {
    return Prescription(
      id: map['id'],
      phoneNumber: map['phone_number'],
      medicineName: map['medicine_name'],
      dosage: map['dosage'],
      duration: map['duration'],
      date: map['date'],
    );
  }
}
