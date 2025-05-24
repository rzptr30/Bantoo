import 'package:flutter/material.dart';
import '../models/donasi_ini.dart';
import '../services/api_service.dart';
import '../widgets/widgets.dart';   // barrel file

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late Future<List<Donasi>> futureDonasi;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    futureDonasi = ApiService.getDonasi();
  }

  /* ───── helper ───── */
  void _refresh() => setState(() => futureDonasi = ApiService.getDonasi());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /* ───────────  APP BAR  ─────────── */
      appBar: dashboardAppBar(onRefresh: _refresh),

      /* ───────────  BODY  ─────────── */
      body: RefreshIndicator(
        onRefresh: () async => _refresh(),
        child: CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(child: GreetingCard()),
            const SliverToBoxAdapter(child: SearchBarDash()),

            /* ── Section 1 : Campaign Emergency ── */
            const SectionHeader(title: 'Emergency Bantoo!'),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 230,
                child: FutureBuilder<List<Donasi>>(
                  future: futureDonasi,
                  builder: (context, snap) {
                    if (snap.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snap.hasError) {
                      return Center(child: Text('Error: ${snap.error}'));
                    }
                    final data = snap.data ?? [];
                    if (data.isEmpty) {
                      return const Center(child: Text('Belum ada donasi'));
                    }
                    return ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: data.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (_, i) => CampaignCard(donasi: data[i]),
                    );
                  },
                ),
              ),
            ),

            /* ── Section 2 : Event ── */
            const SectionHeader(title: 'The Event Is About To Expire'),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 310,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: 3,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (_, i) => EventCard(
                    title: 'Pelatihan One Day Thousand Smiles',
                    subtitle: 'Surabaya, Jawa Timur • 14/05/2025',
                    imageAsset: 'assets/images/event_$i.jpg',
                  ),
                ),
              ),
            ),

            /* ── Section 3 : Category chips ── */
            const SectionHeader(title: 'Choose Bantoo Favourite Category'),
            const SliverToBoxAdapter(child: CategoryChips()),

            /* ── Section 4 : Banner ajakan ── */
            const SectionHeader(title: 'Ask For New Campaign'),
            const SliverToBoxAdapter(child: BannerAddCampaign()),

            /* ── Footer ── */
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Center(
                  child: Text(
                    '© 2025 Bantoo — All rights reserved',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      /* ───────────  BOTTOM NAV  ─────────── */
      bottomNavigationBar: mainBottomBar(
        current: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
      ),
    );
  }
}
