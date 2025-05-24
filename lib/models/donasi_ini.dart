class Donasi {
  final int id;
  final String nama;        // Added this field
  final String title;       // Kept original field
  final String description; // Kept original field
  final String imageUrl;    // Kept original field
  final String foto;        // Added this field
  final double target;      // Kept original field
  final double current;     // Kept original field
  final double nominal;     // Added this field
  final String pesan;       // Added this field
  final double progress;    // Added this field
  final DateTime deadline;  // Kept original field
  final bool isEmergency;   // Kept original field

  Donasi({
    required this.id,
    required this.nama,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.foto,
    required this.target,
    required this.current,
    required this.nominal,
    required this.pesan,
    required this.progress,
    required this.deadline,
    this.isEmergency = false,
  });

  // Factory constructor to parse from JSON
  factory Donasi.fromJson(Map<String, dynamic> json) {
    return Donasi(
      id: json['id'],
      nama: json['nama'] ?? json['title'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      foto: json['foto'] ?? json['imageUrl'] ?? '',
      target: (json['target'] ?? 0).toDouble(),
      current: (json['current'] ?? 0).toDouble(),
      nominal: (json['nominal'] ?? 0).toDouble(),
      pesan: json['pesan'] ?? '',
      progress: (json['progress'] ?? 0).toDouble(),
      deadline: json['deadline'] != null ? DateTime.parse(json['deadline']) : DateTime.now().add(const Duration(days: 30)),
      isEmergency: json['isEmergency'] ?? false,
    );
  }
}