class JenisSampah {
  final int id;
  final String namaSampah;
  final double hargaPerKg;
  final DateTime createdAt;
  final DateTime updatedAt;

  JenisSampah({
    required this.id,
    required this.namaSampah,
    required this.hargaPerKg,
    required this.createdAt,
    required this.updatedAt,
  });

  factory JenisSampah.fromJson(Map<String, dynamic> json) {
    return JenisSampah(
      id: json['id'],
      namaSampah: json['nama_sampah'],
      hargaPerKg: double.parse(json['harga_per_kg'].toString()),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'nama_sampah': namaSampah, 'harga_per_kg': hargaPerKg};
  }
}
