import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/parking_entry.dart';
import '../theme.dart';
import '../widgets/entry_form.dart';
import '../widgets/parking_cards.dart';
import '../widgets/parking_filter_bar.dart';
import '../widgets/summary_header.dart';

final _rupiah =
    NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
final _fmtDate = DateFormat('dd MMM yyyy', 'id_ID');
final _fmtTime = DateFormat('HH:mm');

class ParkingHomePage extends StatefulWidget {
  const ParkingHomePage({super.key});

  @override
  State<ParkingHomePage> createState() => _ParkingHomePageState();
}

class _ParkingHomePageState extends State<ParkingHomePage> {
  // ---------- STATE DATA ----------
  final List<ParkingEntry> _entries = [];

  // ---------- STATE FORM ----------
  final TextEditingController _plateCtrl = TextEditingController();
  VehicleType _selectedType = VehicleType.motor;
  VisitCategory _selectedCategory = VisitCategory.harian;

  // ---------- STATE FILTER & PENCARIAN ----------
  final TextEditingController _searchCtrl = TextEditingController();
  String _searchQuery = '';
  VehicleType? _filterType; // null = semua jenis
  TimeFilter _timeFilter = TimeFilter.semua;

  @override
  void initState() {
    super.initState();
    _seedSamples();
  }

  /// Contoh data awal agar tampilan langsung terisi.
  void _seedSamples() {
    final now = DateTime.now();
    _entries.addAll([
      ParkingEntry(
          plate: 'KT 1234 AB',
          type: VehicleType.motor,
          category: VisitCategory.harian,
          entryTime: now.subtract(const Duration(minutes: 35))),
      ParkingEntry(
          plate: 'KT 5678 CD',
          type: VehicleType.mobil,
          category: VisitCategory.member,
          entryTime: now.subtract(const Duration(hours: 2, minutes: 10))),
      ParkingEntry(
          plate: 'KT 9012 EF',
          type: VehicleType.motor,
          category: VisitCategory.harian,
          entryTime: now.subtract(const Duration(hours: 4, minutes: 5))),
      ParkingEntry(
          plate: 'KT 3456 GH',
          type: VehicleType.mobil,
          category: VisitCategory.valet,
          entryTime: now.subtract(const Duration(hours: 1, minutes: 50))),
      // contoh histori (sudah keluar)
      ParkingEntry(
        plate: 'KT 7890 IJ',
        type: VehicleType.mobil,
        category: VisitCategory.harian,
        entryTime: now.subtract(const Duration(hours: 6)),
        exitTime: now.subtract(const Duration(hours: 2, minutes: 30)),
      ),
      ParkingEntry(
        plate: 'KT 2468 KL',
        type: VehicleType.motor,
        category: VisitCategory.member,
        entryTime: now.subtract(const Duration(hours: 5)),
        exitTime: now.subtract(const Duration(hours: 3, minutes: 15)),
      ),
    ]);
  }

  // ---------- LOGIKA ----------
  List<ParkingEntry> get _active => _entries.where((e) => e.isActive).toList();
  List<ParkingEntry> get _history => _entries.where((e) => !e.isActive).toList();

  int get _totalIncome => _history.fold(0, (sum, e) => sum + e.totalFee);

  Iterable<ParkingEntry> _applyFilters(List<ParkingEntry> source) {
    return source.where((e) {
      if (_filterType != null && e.type != _filterType) return false;
      if (!_timeFilter.matches(e)) return false;
      if (_searchQuery.isNotEmpty &&
          !e.plate.toLowerCase().contains(_searchQuery.toLowerCase())) {
        return false;
      }
      return true;
    });
  }

  void _checkIn() {
    final plate = _plateCtrl.text.trim().toUpperCase();

    // Validasi 1: plat tidak boleh kosong.
    if (plate.isEmpty) {
      _showSnack('Plat nomor kendaraan tidak boleh kosong!', isError: true);
      return;
    }
    // Validasi 2: plat yang sama tidak boleh masuk dua kali saat masih aktif.
    if (_active.any((e) => e.plate == plate)) {
      _showSnack('Kendaraan $plate masih berada di area parkir!',
          isError: true);
      return;
    }

    setState(() {
      _entries.insert(
        0,
        ParkingEntry(
          plate: plate,
          type: _selectedType,
          category: _selectedCategory,
          entryTime: DateTime.now(),
        ),
      );
      _plateCtrl.clear();
    });
    DefaultTabController.of(context).animateTo(0);
    _showSnack('Kendaraan $plate tercatat masuk.');
  }

  void _checkOut(ParkingEntry entry) {
    setState(() => entry.exitTime = DateTime.now());
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(children: [
          Icon(Icons.receipt_long, color: AppColors.ocean),
          SizedBox(width: 8),
          Text('Struk Parkir'),
        ]),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InfoRow('Plat Nomor', entry.plate),
            InfoRow('Jenis', entry.type.label),
            InfoRow('Kategori', entry.category.label),
            InfoRow('Masuk',
                '${_fmtDate.format(entry.entryTime)} • ${_fmtTime.format(entry.entryTime)}'),
            InfoRow('Keluar',
                '${_fmtDate.format(entry.exitTime!)} • ${_fmtTime.format(entry.exitTime!)}'),
            InfoRow('Durasi',
                '${entry.billedHours} jam (${entry.dayCount} hari kunjungan)'),
            const Divider(height: 20),
            InfoRow('Tarif', '${_rupiah.format(entry.type.hourlyRate)}/jam'),
            InfoRow('TOTAL', _rupiah.format(entry.totalFee), bold: true),
          ],
        ),
        actions: [
          FilledButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.check_circle),
            label: const Text('Selesai'),
          ),
        ],
      ),
    );
  }

  void _showSnack(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: isError ? AppColors.danger : AppColors.primaryGreen,
      behavior: SnackBarBehavior.floating,
    ));
  }

  // ---------- UI ----------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Sistem Parkir Ocean Mall Penajam',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              Text('Log Durasi & Tarif Parkir',
                  style: TextStyle(fontSize: 12, color: Colors.white70)),
            ],
          ),
          actions: const [
            Padding(
              padding: EdgeInsets.only(right: 16),
              child: Icon(Icons.directions_boat, color: Colors.white),
            ),
          ],
          bottom: TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: AppColors.oceanLight,
            tabs: [
              Tab(
                  icon: const Icon(Icons.local_parking),
                  text: 'Aktif (${_active.length})'),
              Tab(
                  icon: const Icon(Icons.history),
                  text: 'Histori (${_history.length})'),
            ],
          ),
        ),
        body: Column(
          children: [
            SummaryHeader(
              activeCount: _active.length,
              finishedCount: _history.length,
              totalIncome: _totalIncome,
            ),
            EntryForm(
              plateController: _plateCtrl,
              selectedType: _selectedType,
              selectedCategory: _selectedCategory,
              onTypeChanged: (t) => setState(() => _selectedType = t),
              onCategoryChanged: (c) =>
                  setState(() => _selectedCategory = c),
              onSubmit: _checkIn,
            ),
            ParkingFilterBar(
              searchController: _searchCtrl,
              searchQuery: _searchQuery,
              filterType: _filterType,
              timeFilter: _timeFilter,
              onSearchChanged: (v) => setState(() => _searchQuery = v),
              onSearchCleared: () => setState(() {
                _searchCtrl.clear();
                _searchQuery = '';
              }),
              onTypeChanged: (t) => setState(() => _filterType = t),
              onTimeFilterChanged: (t) => setState(() => _timeFilter = t),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildList(_applyFilters(_active).toList(), isActive: true),
                  _buildList(_applyFilters(_history).toList(), isActive: false),
                ],
              ),
            ),
          ],
        ),
      );
  }
  Widget _buildList(List<ParkingEntry> items, {required bool isActive}) {
    // Keterangan bila plat yang dicari ternyata sudah keluar.
    final exitedMatch = isActive &&
        _searchQuery.isNotEmpty &&
        _history.any(
            (e) => e.plate.toLowerCase().contains(_searchQuery.toLowerCase()));
    if (items.isEmpty) {
      return Column(children: [
        if (exitedMatch) _exitedBanner(),
        Expanded(
          child: Center(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Icon(Icons.inbox_outlined,
                  size: 56, color: Colors.grey.shade400),
              const SizedBox(height: 8),
              Text(isActive ? 'Tidak ada kendaraan aktif' : 'Belum ada histori',
                  style: const TextStyle(color: AppColors.textMuted)),
            ]),
          ),
        ),
      ]);
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
      itemCount: items.length + (exitedMatch ? 1 : 0),
      itemBuilder: (_, i) {
        if (exitedMatch && i == 0) return _exitedBanner();
        final e = items[exitedMatch ? i - 1 : i];
        return isActive
            ? ActiveParkingCard(entry: e, onCheckOut: _checkOut)
            : HistoryParkingCard(entry: e);
      },
    );
  }

  Widget _exitedBanner() {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 4, 0, 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.oceanLight.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.ocean),
      ),
      child: Row(children: [
        const Icon(Icons.info_outline, color: AppColors.ocean),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            'Plat "$_searchQuery" sudah keluar dari area parkir. Lihat detailnya di tab Histori.',
            style: const TextStyle(color: AppColors.textDark),
          ),
        ),
      ]),
    );
  }

  @override
  void dispose() {
    _plateCtrl.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }
}
