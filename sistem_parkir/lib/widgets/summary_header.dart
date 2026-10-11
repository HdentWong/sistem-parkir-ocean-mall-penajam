import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../theme.dart';

/// Header ringkasan: kendaraan aktif, selesai hari ini, dan pendapatan.
class SummaryHeader extends StatelessWidget {
  const SummaryHeader({
    super.key,
    required this.activeCount,
    required this.finishedCount,
    required this.totalIncome,
  });

  final int activeCount;
  final int finishedCount;
  final int totalIncome;

  @override
  Widget build(BuildContext context) {
    final rupiah =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.ocean, AppColors.primaryGreen],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _item(Icons.directions_car, '$activeCount', 'Kendaraan Aktif'),
          _item(Icons.today, '$finishedCount', 'Selesai Hari Ini'),
          _item(Icons.payments, rupiah.format(totalIncome), 'Pendapatan'),
        ],
      ),
    );
  }

  Widget _item(IconData icon, String value, String label) {
    return Column(children: [
      Icon(icon, color: Colors.white, size: 26),
      const SizedBox(height: 4),
      Text(value,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
      Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11)),
    ]);
  }
}
