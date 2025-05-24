import 'package:flutter/material.dart';
import '../models/donasi_ini.dart';
import '../services/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refresh,
          ),
        ],
      ),
      body: Column(
        children: [
          // User greeting card
          Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: const AssetImage('assets/images/avatar.png'),
                    radius: 30,
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Welcome, rzptr30',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Last login: 2025-05-24 16:38:02',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          // Donations list
          Expanded(
            child: FutureBuilder<List<Donasi>>(
              future: futureDonasi,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final donasiList = snapshot.data ?? [];
                
                if (donasiList.isEmpty) {
                  return const Center(child: Text('Belum ada donasi'));
                }

                return ListView.builder(
                  itemCount: donasiList.length,
                  itemBuilder: (context, index) {
                    final donasi = donasiList[index];
                    return DonasiCard(donasi: donasi); // Fix this line to pass the donasi correctly
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/tambah-donasi').then((_) => _refresh());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

// Add this class to fix the missing parameter error
class DonasiCard extends StatelessWidget {
  final Donasi donasi;
  
  const DonasiCard({
    Key? key,
    required this.donasi,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage(donasi.foto),
                  radius: 25,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        donasi.nama,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'Rp ${donasi.nominal.toStringAsFixed(0)} - ${donasi.pesan}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    try {
                      await ApiService.deleteDonasi(donasi.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Donasi berhasil dihapus')),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: $e')),
                      );
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: donasi.progress / 100,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${donasi.progress.toStringAsFixed(1)}% funded',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/detail-donasi',
                      arguments: donasi,
                    );
                  },
                  child: const Text('VIEW DETAILS'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/edit-donasi',
                      arguments: donasi,
                    );
                  },
                  child: const Text('EDIT'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}