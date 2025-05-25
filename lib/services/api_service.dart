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
        // Cek apakah response body kosong atau null
        if (response.body.isEmpty) {
          return []; // Kembalikan list kosong jika response body kosong
        }
        
        // Cek apakah response body hanya berisi "null" atau respons kosong
        final bodyTrim = response.body.trim();
        if (bodyTrim == 'null' || bodyTrim == '[]' || bodyTrim == 'false' || bodyTrim == '""') {
          return []; // Kembalikan list kosong
        }
        
        try {
          final List<dynamic> data = json.decode(response.body);
          return data.map((item) => Donasi.fromJson(item)).toList();
        } catch (e) {
          // Error parsing JSON, kembalikan list kosong
          print('Error parsing JSON: $e');
          return [];
        }
      } else {
        // Server mengembalikan status code error
        print('Failed to load donasi: ${response.statusCode}');
        return []; // Kembalikan list kosong daripada throw exception
      }
    } catch (e) {
      // Tangkap semua error dan kembalikan list kosong
      print('Error fetching donasi: $e');
      return []; // Kembalikan list kosong daripada throw exception
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
      print('Error adding donasi: $e');
      return false;
    }
  }

  // Tambah donasi baru (untuk backward compatibility)
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
      print('Error updating donasi: $e');
      return false;
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
      print('Error deleting donasi: $e');
      return false;
    }
  }
  
  // Get donasi by id
  static Future<Donasi?> getDonasiById(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/read_single.php?id=$id'),
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Donasi.fromJson(data);
      } else {
        print('Failed to fetch donasi: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching donasi: $e');
      return null;
    }
  }
}