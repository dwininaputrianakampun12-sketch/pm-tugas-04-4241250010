import 'dart:async';
abstract class Kendaraan {
  final String plat;
  final DateTime waktuMasuk;

  Kendaraan(this.plat, this.waktuMasuk);

  String get jenis;
  int get tarifPerJam;

  int biaya(DateTime keluar) {
    final durasi = keluar.difference(waktuMasuk).inMinutes;
    final jam = (durasi / 60).ceil();
    final totalJam = jam < 1 ? 1 : jam;

    return totalJam * tarifPerJam;
  }
}

class Motor extends Kendaraan {
  Motor(super.plat, super.waktuMasuk);

  @override
  String get jenis => 'Motor';

  @override
  int get tarifPerJam => 6000;
}

class Mobil extends Kendaraan {
  Mobil(super.plat, super.waktuMasuk);

  @override
  String get jenis => 'Mobil';

  @override
  int get tarifPerJam => 15000;
}

class Truk extends Kendaraan {
  Truk(super.plat, super.waktuMasuk);

  @override
  String get jenis => 'Truk';

  @override
  int get tarifPerJam => 20000;
}

mixin Berlangganan on Kendaraan {
  @override
  int biaya(DateTime keluar) {
    return (super.biaya(keluar) * 0.5).round();
  }
}

class MobilMember extends Mobil with Berlangganan {
  MobilMember(super.plat, super.waktuMasuk);
}

class ParkirPenuh implements Exception {
  final String pesan;

  ParkirPenuh(this.pesan);

  @override
  String toString() => pesan;
}


class Parkiran {
  final int kapasitas;
  final List<Kendaraan> _kendaraan = [];
  int _pendapatan = 0;

  final StreamController<String> _kejadian =
      StreamController<String>.broadcast();

  Parkiran(this.kapasitas);

  Stream<String> get kejadian => _kejadian.stream;

  int get sisa => kapasitas - _kendaraan.length;

  int get pendapatan => _pendapatan;

  Future<void> masuk(Kendaraan kendaraan) async {
    await Future.delayed(
      const Duration(milliseconds: 500),
    );

    if (sisa <= 0) {
      throw ParkirPenuh('Parkiran penuh (kapasitas $kapasitas)');
    }

    _kendaraan.add(kendaraan);

    _kejadian.add(
      'MASUK ${kendaraan.jenis} ${kendaraan.plat} (sisa $sisa)',
    );
  }

  Future<void> keluar(
    String plat,
    DateTime waktuKeluar,
  ) async {
    await Future.delayed(
      const Duration(milliseconds: 500),
    );

    final index = _kendaraan.indexWhere(
      (k) => k.plat == plat,
    );

    if (index == -1) {
      throw StateError('Kendaraan $plat tidak ditemukan');
    }

    final kendaraan = _kendaraan[index];
    final biaya = kendaraan.biaya(waktuKeluar);

    _kendaraan.removeAt(index);
    _pendapatan += biaya;

    _kejadian.add(
      'KELUAR ${kendaraan.jenis} ${kendaraan.plat} '
      'bayar Rp$biaya',
    );
  }

  Future<void> tutup() => _kejadian.close();
}
