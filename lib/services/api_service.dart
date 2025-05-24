import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/donasi_ini.dart';

class ApiService {
  static const String baseUrl = "http://10.0.2.2/bantoo_api";

  /* ────────────────  DONASI  ──────────────── */

  /// Ambil daftar donasi.
  ///   • Jika server mengirim **array** langsung → `[ {...}, {...} ]`
  ///   • Atau objek dengan key **data**        → `{ "data": [ {...} ] }`
  static Future<List<Donasi>> getDonasi() async {
    final response = await http.get(Uri.parse("$baseUrl/read.php"));
    if (response.statusCode != 200) {
      throw Exception("Gagal memuat donasi");
    }

    final decoded = jsonDecode(response.body);

    // 1. Respon berupa array → langsung konversi
    if (decoded is List) {
      return decoded.map((e) => Donasi.fromJson(e)).toList();
    }

    // 2. Respon berupa objek yang memiliki key 'data' berupa array
    if (decoded is Map && decoded['data'] is List) {
      return (decoded['data'] as List)
          .map((e) => Donasi.fromJson(e))
          .toList();
    }

    // 3. Format tak dikenal
    throw Exception("Format respon tak dikenali: $decoded");
  }

 static Future<bool> tambahDonasi(
    String nama, String nominal, String pesan,
    {String foto = '', double progress = 0}) async {
  final res = await http.post(Uri.parse("$baseUrl/create.php"), body: {
    "nama": nama,
    "nominal": nominal,
    "pesan": pesan,
    "foto": foto,
    "progress": progress.toString(),
  });
  return res.statusCode == 200;
}

static Future<bool> updateDonasi(
    String id, String nama, String nominal, String pesan,
    {String foto = '', double progress = 0}) async {
  final res = await http.post(Uri.parse("$baseUrl/update.php"), body: {
    "id": id,
    "nama": nama,
    "nominal": nominal,
    "pesan": pesan,
    "foto": foto,
    "progress": progress.toString(),
  });
  return res.statusCode == 200;
}


  static Future<bool> deleteDonasi(String id) async {
    final res = await http.post(Uri.parse("$baseUrl/delete.php"), body: {
      "id": id,
    });
    return res.statusCode == 200;
  }

  /* ────────────────  AUTH  ──────────────── */

  static Future<bool> loginUser(String email, String password) async {
    final res = await http.post(Uri.parse("$baseUrl/login_user.php"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}));
    final json = jsonDecode(res.body);
    return json['success'] == true;
  }

  static Future<bool> registerUser(String email, String password) async {
    final res = await http.post(Uri.parse("$baseUrl/register_user.php"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}));
    final json = jsonDecode(res.body);
    return json['success'] == true;
  }
  
}