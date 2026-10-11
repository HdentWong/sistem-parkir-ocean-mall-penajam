import 'package:flutter/material.dart';

import '../models/parking_entry.dart';
import '../theme.dart';

/// Form pencatatan kendaraan masuk.
class EntryForm extends StatelessWidget {
  const EntryForm({
    super.key,
    required this.plateController,
    required this.selectedType,
    required this.selectedCategory,
    required this.onTypeChanged,
    required this.onCategoryChanged,
    required this.onSubmit,
  });

  final TextEditingController plateController;
  final VehicleType selectedType;
  final VisitCategory selectedCategory;
  final ValueChanged<VehicleType> onTypeChanged;
  final ValueChanged<VisitCategory> onCategoryChanged;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Catat Kendaraan Masuk',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 10),
            TextField(
              controller: plateController,
              textCapitalization: TextCapitalization.characters,
              decoration: const InputDecoration(
                labelText: 'Plat Nomor',
                hintText: 'cth: KT 1234 AB',
                prefixIcon: Icon(Icons.pin_outlined),
              ),
              onSubmitted: (_) => onSubmit(),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: SegmentedButton<VehicleType>(
                segments: const [
                  ButtonSegment(
                      value: VehicleType.motor,
                      icon: Icon(Icons.two_wheeler),
                      label: Text('Motor')),
                  ButtonSegment(
                      value: VehicleType.mobil,
                      icon: Icon(Icons.directions_car),
                      label: Text('Mobil')),
                ],
                selected: {selectedType},
                onSelectionChanged: (s) => onTypeChanged(s.first),
              ),
            ),
            const SizedBox(height: 10),
            Row(children: [
              Expanded(
                child: DropdownButtonFormField<VisitCategory>(
                  initialValue: selectedCategory,
                  decoration: const InputDecoration(
                    labelText: 'Kategori Kunjungan',
                    prefixIcon: Icon(Icons.category_outlined),
                  ),
                  items: VisitCategory.values
                      .map((c) =>
                          DropdownMenuItem(value: c, child: Text(c.label)))
                      .toList(),
                  onChanged: (v) {
                    if (v != null) onCategoryChanged(v);
                  },
                ),
              ),
              const SizedBox(width: 10),
              FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                ),
                onPressed: onSubmit,
                icon: const Icon(Icons.login),
                label: const Text('Masuk'),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
