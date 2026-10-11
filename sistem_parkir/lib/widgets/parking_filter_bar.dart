import 'package:flutter/material.dart';

import '../models/parking_entry.dart';
import '../theme.dart';

/// Bar pencarian plat + filter jenis kendaraan dan kategori waktu.
class ParkingFilterBar extends StatelessWidget {
  const ParkingFilterBar({
    super.key,
    required this.searchController,
    required this.searchQuery,
    required this.filterType,
    required this.timeFilter,
    required this.onSearchChanged,
    required this.onSearchCleared,
    required this.onTypeChanged,
    required this.onTimeFilterChanged,
  });

  final TextEditingController searchController;
  final String searchQuery;
  final VehicleType? filterType;
  final TimeFilter timeFilter;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onSearchCleared;
  final ValueChanged<VehicleType?> onTypeChanged;
  final ValueChanged<TimeFilter> onTimeFilterChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 4),
      child: Column(children: [
        TextField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: 'Cari plat nomor...',
            prefixIcon: const Icon(Icons.search, color: AppColors.ocean),
            suffixIcon: searchQuery.isEmpty
                ? null
                : IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: onSearchCleared,
                  ),
            isDense: true,
          ),
          onChanged: onSearchChanged,
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(children: [
            _typeChip(null, 'Semua Jenis', Icons.apps),
            _typeChip(VehicleType.motor, 'Motor', Icons.two_wheeler),
            _typeChip(VehicleType.mobil, 'Mobil', Icons.directions_car),
            const VerticalDivider(),
            ...TimeFilter.values.map((t) => Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: ChoiceChip(
                    avatar: const Icon(Icons.schedule, size: 18),
                    label: Text(t.label),
                    selected: timeFilter == t,
                    selectedColor: AppColors.oceanLight,
                    onSelected: (_) => onTimeFilterChanged(t),
                  ),
                )),
          ]),
        ),
      ]),
    );
  }

  Widget _typeChip(VehicleType? type, String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: FilterChip(
        avatar: Icon(icon, size: 18),
        label: Text(label),
        selected: filterType == type,
        selectedColor: AppColors.mintGreen,
        onSelected: (_) => onTypeChanged(type),
      ),
    );
  }
}
