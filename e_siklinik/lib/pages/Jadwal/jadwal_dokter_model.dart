class JadwalDokter {
  final int id;
  final String hari;
  final String jadwalMulaiTugas;
  final String jadwalSelesaiTugas;
  final int dokterId;
  final String createdAt;
  final String updatedAt;

  JadwalDokter({
    required this.id,
    required this.hari,
    required this.jadwalMulaiTugas,
    required this.jadwalSelesaiTugas,
    required this.dokterId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory JadwalDokter.fromJson(Map<String, dynamic> json) {
    return JadwalDokter(
      id: json['id'],
      hari: json['hari'],
      jadwalMulaiTugas: json['jadwal_mulai_tugas'],
      jadwalSelesaiTugas: json['jadwal_selesai_tugas'],
      dokterId: json['dokter_id'],
      createdAt: json['created_at'].toString(),
      updatedAt: json['updated_at'].toString(),
    );
  }
}
