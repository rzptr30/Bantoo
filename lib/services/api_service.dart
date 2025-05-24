import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/donasi_ini.dart';

class ApiService {
  // Base URL for your API
  static const String baseUrl = 'https://your-api-url.com/api';

  // Get donations list
  static Future<List<Donasi>> getDonasi() async {
    // For demo purposes, return mock data
    await Future.delayed(const Duration(seconds: 1));
    
    return [
      Donasi(
        id: 1,
        nama: 'Bantuan untuk Korban Banjir',
        title: 'Bantuan untuk Korban Banjir',
        description: 'Membantu korban banjir di Jawa Tengah',
        imageUrl: 'assets/images/donasi_1.jpg',
        foto: 'assets/images/donasi_1.jpg',
        target: 50000000,
        current: 25000000,
        nominal: 25000000,
        pesan: 'Semoga bantuan ini bermanfaat',
        progress: 50.0,
        deadline: DateTime.now().add(const Duration(days: 15)),
        isEmergency: true,
      ),
      Donasi(
        id: 2,
        nama: 'Bantuan Pendidikan Anak',
        title: 'Bantuan Pendidikan Anak',
        description: 'Bantuan biaya sekolah untuk anak kurang mampu',
        imageUrl: 'assets/images/donasi_2.jpg',
        foto: 'assets/images/donasi_2.jpg',
        target: 30000000,
        current: 10000000,
        nominal: 10000000,
        pesan: 'Untuk pendidikan anak-anak',
        progress: 33.3,
        deadline: DateTime.now().add(const Duration(days: 30)),
        isEmergency: true,
      ),
      Donasi(
        id: 3,
        nama: 'Pembangunan Masjid',
        title: 'Pembangunan Masjid',
        description: 'Bantuan untuk pembangunan masjid di desa terpencil',
        imageUrl: 'assets/images/donasi_3.jpg',
        foto: 'assets/images/donasi_3.jpg',
        target: 100000000,
        current: 45000000,
        nominal: 45000000,
        pesan: 'Untuk pembangunan masjid',
        progress: 45.0,
        deadline: DateTime.now().add(const Duration(days: 60)),
        isEmergency: false,
      ),
    ];
  }

  // Add a new donation
  static Future<Donasi> tambahDonasi({
    required String nama,
    required double nominal,
    required String pesan,
    required String foto,
    double progress = 0.0,
  }) async {
    // For demo purposes, simulate API call
    await Future.delayed(const Duration(seconds: 1));
    
    // Create a new Donasi object with the current date + random ID
    return Donasi(
      id: DateTime.now().millisecondsSinceEpoch,
      nama: nama,
      title: nama,
      description: pesan,
      imageUrl: foto,
      foto: foto,
      target: nominal * 2, // Just for demo
      current: nominal,
      nominal: nominal,
      pesan: pesan,
      progress: progress,
      deadline: DateTime.now().add(const Duration(days: 30)),
    );
  }

  // Update an existing donation
  static Future<Donasi> updateDonasi(
    int id, {
    required String nama,
    required double nominal,
    required String pesan,
    required String foto,
    required double progress,
  }) async {
    // For demo purposes, simulate API call
    await Future.delayed(const Duration(seconds: 1));
    
    // Return updated Donasi object
    return Donasi(
      id: id,
      nama: nama,
      title: nama,
      description: pesan,
      imageUrl: foto,
      foto: foto,
      target: nominal * 2, // Just for demo
      current: nominal,
      nominal: nominal,
      pesan: pesan,
      progress: progress,
      deadline: DateTime.now().add(const Duration(days: 30)),
    );
  }

  // Delete a donation
  static Future<bool> deleteDonasi(int id) async {
    // For demo purposes, simulate API call
    await Future.delayed(const Duration(seconds: 1));
    
    // Return success
    return true;
  }
}