import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/donasi_ini.dart';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2/bantoo_api'; // Sesuaikan dengan URL server Anda

  // Get semua donasi
  static Future<List<Donasi>> getDonasi() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/read.php'));
      
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => Donasi.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load donasi: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Tambahkan method tambahDonasi
  static Future<bool> tambahDonasi({
    String? nama,
    String? title,
    String? description,
    double? targetAmount,
    double? collectedAmount,
    String? foto,
    String? imageUrl,
    double? target,
    double? current,
    double? nominal,
    String? pesan,
    double? progress,
    String? deadline,
    bool? isEmergency,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/create.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'nama': nama,
          'title': title,
          'description': description,
          'target_amount': targetAmount,
          'collected_amount': collectedAmount,
          'foto': foto,
          'image_url': imageUrl,
          'target': target,
          'current': current,
          'nominal': nominal,
          'pesan': pesan,
          'progress': progress,
          'deadline': deadline,
          'is_emergency': isEmergency,
        }),
      );
      
      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Error adding donasi: $e');
    }
  }

  // Tambah donasi baru (ini adalah method existing yang mungkin sudah ada)
  static Future<bool> addDonasi({
    String? nama,
    String? title,
    String? description,
    double? targetAmount,
    double? collectedAmount,
    String? foto,
    String? imageUrl,
    double? target,
    double? current,
    double? nominal,
    String? pesan,
    double? progress,
    String? deadline,
    bool? isEmergency,
  }) async {
    // Panggil tambahDonasi untuk menjaga konsistensi
    return tambahDonasi(
      nama: nama,
      title: title,
      description: description,
      targetAmount: targetAmount,
      collectedAmount: collectedAmount,
      foto: foto,
      imageUrl: imageUrl,
      target: target,
      current: current,
      nominal: nominal,
      pesan: pesan,
      progress: progress,
      deadline: deadline,
      isEmergency: isEmergency,
    );
  }

  // Update donasi
  static Future<bool> updateDonasi({
    required int id,
    String? nama,
    String? title,
    String? description,
    double? targetAmount,
    double? collectedAmount,
    String? foto,
    String? imageUrl,
    double? target,
    double? current,
    double? nominal,
    String? pesan,
    double? progress,
    String? deadline,
    bool? isEmergency,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/update.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'id': id,
          'nama': nama,
          'title': title,
          'description': description,
          'target_amount': targetAmount,
          'collected_amount': collectedAmount,
          'foto': foto,
          'image_url': imageUrl,
          'target': target,
          'current': current,
          'nominal': nominal,
          'pesan': pesan,
          'progress': progress,
          'deadline': deadline,
          'is_emergency': isEmergency,
        }),
      );
      
      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Error updating donasi: $e');
    }
  }

  // Delete donasi
  static Future<bool> deleteDonasi(int id) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/delete.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'id': id}),
      );
      
      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Error deleting donasi: $e');
    }
  }

  // Mock data untuk donasi (jika API belum siap)
  static List<Donasi> _mockDonasi() {
    return [
      Donasi(
        id: 1,
        nama: 'Bantuan Gempa Aceh',
        title: 'Bantuan Gempa Aceh',
        description: 'Bantuan untuk korban gempa di Aceh',
        targetAmount: 100000000,
        collectedAmount: 75000000,
        foto: 'assets/images/gempa_aceh.jpg',
        imageUrl: 'https://example.com/images/gempa_aceh.jpg',
        target: 100000000,
        current: 75000000,
        nominal: 0,
        pesan: '',
        progress: 0.75,
        deadline: '2025-06-30',
        isEmergency: true,
      ),
      Donasi(
        id: 2,
        nama: 'Bantuan Banjir Jakarta',
        title: 'Bantuan Banjir Jakarta',
        description: 'Bantuan untuk korban banjir di Jakarta',
        targetAmount: 50000000,
        collectedAmount: 25000000,
        foto: 'assets/images/banjir_jakarta.jpg',
        imageUrl: 'https://example.com/images/banjir_jakarta.jpg',
        target: 50000000,
        current: 25000000,
        nominal: 0,
        pesan: '',
        progress: 0.5,
        deadline: '2025-07-15',
        isEmergency: true,
      ),
    ];
  }

  // Get mock donasi (jika API belum siap)
  static Future<List<Donasi>> getMockDonasi() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    return _mockDonasi();
  }
}