/// Model & logika bisnis Sistem Parkir Ocean Mall Penajam.

enum VehicleType { motor, mobil }

extension VehicleTypeX on VehicleType {
  String get label => this == VehicleType.motor ? 'Motor' : 'Mobil';

  /// Tarif per jam sesuai ketentuan soal.
  int get hourlyRate => this == VehicleType.motor ? 2000 : 5000;
}

/// Kategori kunjungan parkir (pengkategorian tambahan).
enum VisitCategory { harian, member, valet }

extension VisitCategoryX on VisitCategory {
  String get label {
    switch (this) {
      case VisitCategory.harian:
        return 'Harian';
      case VisitCategory.member:
        return 'Member';
      case VisitCategory.valet:
        return 'Valet';
    }
  }
}

class ParkingEntry {
  ParkingEntry({
    required this.plate,
    required this.type,
    required this.entryTime,
    this.category = VisitCategory.harian,
    this.exitTime,
  });

  final String plate; // plat nomor (dinormalisasi uppercase)
  final VehicleType type;
  final VisitCategory category;
  final DateTime entryTime;
  DateTime? exitTime;

  bool get isActive => exitTime == null;

  /// Durasi parkir dalam jam, dibulatkan ke atas, minimal 1 jam.
  int get billedHours {
    final end = exitTime ?? DateTime.now();
    final minutes = end.difference(entryTime).inMinutes;
    final hours = (minutes / 60).ceil();
    return hours < 1 ? 1 : hours;
  }

  Duration get duration => (exitTime ?? DateTime.now()).difference(entryTime);

  /// Total biaya = jam terhitung x tarif per jam.
  int get totalFee => billedHours * type.hourlyRate;

  /// Berapa hari kendaraan datang parkir (1 = hari yang sama).
  int get dayCount {
    final end = exitTime ?? DateTime.now();
    final startDay = DateTime(entryTime.year, entryTime.month, entryTime.day);
    final endDay = DateTime(end.year, end.month, end.day);
    return endDay.difference(startDay).inDays + 1;
  }
}

/// Filter kategori waktu untuk daftar.
enum TimeFilter { semua, kurangDari1Jam, satuTigaJam, lebihDari3Jam }

extension TimeFilterX on TimeFilter {
  String get label {
    switch (this) {
      case TimeFilter.semua:
        return 'Semua Waktu';
      case TimeFilter.kurangDari1Jam:
        return '< 1 Jam';
      case TimeFilter.satuTigaJam:
        return '1 - 3 Jam';
      case TimeFilter.lebihDari3Jam:
        return '> 3 Jam';
    }
  }

  bool matches(ParkingEntry e) {
    final mins = e.duration.inMinutes;
    switch (this) {
      case TimeFilter.semua:
        return true;
      case TimeFilter.kurangDari1Jam:
        return mins < 60;
      case TimeFilter.satuTigaJam:
        return mins >= 60 && mins <= 180;
      case TimeFilter.lebihDari3Jam:
        return mins > 180;
    }
  }
}
