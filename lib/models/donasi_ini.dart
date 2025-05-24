class Donasi {
  final String id;
  final String nama;
  final String nominal;      // simpan String supaya tidak ubah kode lama
  final String pesan;

  /// URL gambar kampanye
  final String foto;

  /// Persentase progress (0-100)
  final double progress;

  Donasi({
    required this.id,
    required this.nama,
    required this.nominal,
    required this.pesan,
    required this.foto,
    required this.progress,
  });

  /* ───────────────────────────────────────────────────────── factory ── */
  factory Donasi.fromJson(Map<String, dynamic> json) {
    // placeholder jika gambar kosong / null
    const placeholder =
        'https://via.placeholder.com/300x180.png?text=No+Image';

    return Donasi(
      id: json['id'].toString(),
      nama: json['nama'] ?? '',
      nominal: json['nominal']?.toString() ?? '0',
      pesan: json['pesan'] ?? '',
      foto: (json['foto'] as String?)?.trim().isNotEmpty == true
          ? json['foto']
          : placeholder,
      progress: _parseProgress(json['progress']),
    );
  }

  // helper agar progress apa pun bentuknya (null/int/double/String) → double
  static double _parseProgress(dynamic v) {
    if (v == null) return 0;
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString()) ?? 0;
  }

  /* ───────────────────────────────────────────────────────── toJson ── */
  Map<String, dynamic> toJson() => {
        'id': id,
        'nama': nama,
        'nominal': nominal,
        'pesan': pesan,
        'foto': foto,
        'progress': progress,
      };
}
