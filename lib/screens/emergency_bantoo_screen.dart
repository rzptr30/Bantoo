import 'package:flutter/material.dart';
import '../models/donasi_ini.dart';
import '../services/api_service.dart';

class EmergencyBantooScreen extends StatefulWidget {
  const EmergencyBantooScreen({super.key});  // Gunakan super parameter

  @override
  State<EmergencyBantooScreen> createState() => _EmergencyBantooScreenState();
}

class _EmergencyBantooScreenState extends State<EmergencyBantooScreen> {
  late Future<List<Donasi>> futureDonasi;

  @override
  void initState() {
    super.initState();
    futureDonasi = ApiService.getDonasi();
  }

  void _refresh() {
    setState(() {
      futureDonasi = ApiService.getDonasi();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency Bantoo'),
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: () async => _refresh(),
        child: FutureBuilder<List<Donasi>>(
          future: futureDonasi,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            final data = snapshot.data ?? [];
            if (data.isEmpty) {
              return const Center(child: Text('Belum ada donasi emergency'));
            }
            
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: data.length,
              itemBuilder: (context, index) {
                final donasi = data[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image section
                      Image.network(
                        donasi.imageUrl ?? donasi.foto ?? 'https://via.placeholder.com/400x200?text=Bantoo',
                        height: 180,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          height: 180,
                          width: double.infinity,
                          color: Colors.grey[300],
                          child: const Center(
                            child: Icon(Icons.image, size: 50, color: Colors.grey),
                          ),
                        ),
                      ),
                      
                      // Content section
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              donasi.title ?? donasi.nama ?? 'Untitled Campaign',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            
                            // Progress bar and amount
                            LinearProgressIndicator(
                              value: donasi.progressPercentage ?? 0,
                              backgroundColor: Colors.grey[200],
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).primaryColor,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Rp ${(donasi.collectedAmount ?? donasi.current ?? 0).toStringAsFixed(0)}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                Text(
                                  'dari Rp ${(donasi.targetAmount ?? donasi.target ?? 0).toStringAsFixed(0)}',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            
                            // Description
                            Text(
                              donasi.description ?? donasi.pesan ?? 'No description available',
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 16),
                            
                            // Action buttons
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () {
                                      // View detail action
                                    },
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                    ),
                                    child: const Text('Lihat Detail'),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      // Donate action
                                    },
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                    ),
                                    child: const Text('Donasi Sekarang'),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}