
import 'package:pm_tugas_04_4241250010/parkiran.dart';
import 'package:test/test.dart';

void main() {
  final waktuMasuk = DateTime(2026, 11, 26, 8, 0);
  final waktuKeluar = DateTime(2026, 11, 26, 9, 0);

  test('Biaya parkir motor selama satu jam', () {
    final motor = Motor('BK 1234 AB', waktuMasuk);

    expect(motor.biaya(waktuKeluar), 6000);
  });

  test('Member mendapatkan diskon 50 persen', () {
    final member = MobilMember('BK 7 MIPA', waktuMasuk);

    expect(member.biaya(waktuKeluar), 7500);
  });

  test('Parkiran menolak kendaraan ketika penuh', () async {
    final parkiran = Parkiran(1);

    await parkiran.masuk(Motor('BK 1234 AB', waktuMasuk));

    expect(
      () => parkiran.masuk(Mobil('BK 88 UN', waktuMasuk)),
      throwsA(isA<ParkirPenuh>()),
    );

    await parkiran.tutup();
  });
}

