class MaintenanceModel {
  final bool isEnabled;

  const MaintenanceModel({required this.isEnabled});

  factory MaintenanceModel.fromMap(Map<String, dynamic> map) {
    return MaintenanceModel(
      isEnabled: map['isEnabled'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {'isEnabled': isEnabled};
  }

  @override
  String toString() => 'MaintenanceModel(isEnabled: $isEnabled)';
}