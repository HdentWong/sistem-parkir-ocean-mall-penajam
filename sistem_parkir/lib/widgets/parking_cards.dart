import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/parking_entry.dart';
import '../theme.dart';

final _rupiah =
    NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
final _fmtDate = DateFormat('dd MMM yyyy', 'id_ID');
final _fmtTime = DateFormat('HH:mm');

/// Baris label–nilai, dipakai di struk dan detail histori.
class InfoRow extends StatelessWidget {
  const InfoRow(this.label, this.value, {super.key, this.bold = false});

  final String label;
  final String value;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontWeight: bold ? FontWeight.bold : FontWeight.normal,
      fontSize: bold ? 16 : 14,
      color: AppColors.textDark,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textMuted)),
          Flexible(child: Text(value, style: style, textAlign: TextAlign.right)),
        ],
      ),
    );
  }
}

/// Kartu kendaraan yang sedang parkir, dengan tombol proses keluar.
class ActiveParkingCard extends StatelessWidget {
  const ActiveParkingCard({super.key, required this.entry, required this.onCheckOut});

  final ParkingEntry entry;
  final ValueChanged<ParkingEntry> onCheckOut;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: VehicleAvatar(type: entry.type),
        title: Text(entry.plate,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${entry.type.label} • ${entry.category.label}'),
            Row(children: [
              const Icon(Icons.access_time, size: 14, color: AppColors.ocean),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  'Masuk ${_fmtTime.format(entry.entryTime)} WITA • ${_fmtDate.format(entry.entryTime)}',
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ]),
            Text(
              'Durasi berjalan: ${entry.duration.inHours}j ${entry.duration.inMinutes % 60}m',
              style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
            ),
          ],
        ),
        isThreeLine: true,
        trailing: FilledButton.tonalIcon(
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.oceanLight,
            foregroundColor: AppColors.textDark,
          ),
          onPressed: () => onCheckOut(entry),
          icon: const Icon(Icons.logout, size: 18),
          label: const Text('Keluar'),
        ),
      ),
    );
  }
}

/// Kartu histori kendaraan yang sudah selesai, dapat dibuka detailnya.
class HistoryParkingCard extends StatelessWidget {
  const HistoryParkingCard({super.key, required this.entry});

  final ParkingEntry entry;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpansionTile(
        leading: VehicleAvatar(type: entry.type),
        title: Text(entry.plate,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        subtitle: Text(
            '${entry.type.label} • ${entry.category.label} • Total ${_rupiah.format(entry.totalFee)}'),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        children: [
          const InfoRow('Status', 'Sudah Keluar'),
          InfoRow('Masuk',
              '${_fmtDate.format(entry.entryTime)} • ${_fmtTime.format(entry.entryTime)} WITA'),
          InfoRow('Keluar',
              '${_fmtDate.format(entry.exitTime!)} • ${_fmtTime.format(entry.exitTime!)} WITA'),
          InfoRow('Durasi Terhitung', '${entry.billedHours} jam'),
          InfoRow('Hari Kunjungan', '${entry.dayCount} hari'),
          InfoRow('Tarif', '${_rupiah.format(entry.type.hourlyRate)}/jam'),
          InfoRow('Total Dibayar', _rupiah.format(entry.totalFee), bold: true),
        ],
      ),
    );
  }
}

/// Avatar ikon sesuai jenis kendaraan.
class VehicleAvatar extends StatelessWidget {
  const VehicleAvatar({super.key, required this.type});

  final VehicleType type;

  @override
  Widget build(BuildContext context) {
    final isMotor = type == VehicleType.motor;
    return CircleAvatar(
      backgroundColor: isMotor ? AppColors.mintGreen : AppColors.oceanLight,
      child: Icon(
        isMotor ? Icons.two_wheeler : Icons.directions_car,
        color: isMotor ? AppColors.primaryGreen : AppColors.ocean,
      ),
    );
  }
}
