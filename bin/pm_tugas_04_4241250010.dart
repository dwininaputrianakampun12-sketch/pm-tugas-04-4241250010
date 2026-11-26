
import 'package:pm_tugas_04_4241250010/parkiran.dart';

Future<void> main() async {
  final parkiran = Parkiran(3);

  // Listener untuk menampilkan kejadian parkir
  parkiran.kejadian.listen(print);

  final waktuMasuk = DateTime(2026, 11, 26, 8, 0);

  // Polimorfisme: satu List berisi berbagai jenis kendaraan
  final List<Kendaraan> kendaraan = [
    Motor('BK 1234 AB', waktuMasuk),
    Mobil('BK 88 UN', waktuMasuk),
    MobilMember('BK 7 MIPA', waktuMasuk),
    Truk('BK 9999 TR', waktuMasuk),
  ];

  // Tiga kendaraan pertama berhasil masuk
  for (final k in kendaraan.take(3)) {
    await parkiran.masuk(k);
  }

  // Kendaraan keempat ditolak karena parkiran penuh
  try {
    await parkiran.masuk(kendaraan[3]);
  } on ParkirPenuh catch (e) {
    print('Ditolak: $e');
  }

  // Kendaraan keluar setelah waktu tertentu
  final waktuKeluar = DateTime(2026, 11, 26, 9, 0);

  for (final k in kendaraan.take(3)) {
    await parkiran.keluar(k.plat, waktuKeluar);
  }

  print('Pendapatan: Rp${parkiran.pendapatan}');

  await parkiran.tutup();
}
