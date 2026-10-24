import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Memuat data tanggal bahasa Indonesia untuk package intl.
  await initializeDateFormatting('id_ID');
  runApp(const AplikasiKartuIdentitas());
}

/// Widget akar aplikasi (StatelessWidget karena tidak menyimpan data sendiri).
class AplikasiKartuIdentitas extends StatelessWidget {
  const AplikasiKartuIdentitas({super.key});

  @override
  Widget build(BuildContext context) {
    final dasar = ThemeData(
      colorSchemeSeed: const Color(0xFF0B6B45),
      useMaterial3: true,
    );

    return MaterialApp(
      title: 'Kartu Identitas Mahasiswa',
      debugShowCheckedModeBanner: false,
      // Font Poppins dari package google_fonts untuk seluruh aplikasi.
      theme: dasar.copyWith(
        textTheme: GoogleFonts.poppinsTextTheme(dasar.textTheme),
      ),
      home: const HalamanKartu(),
    );
  }
}

/// Palet warna kartu untuk mode terang dan gelap.
class PaletKartu {
  final Color latar;
  final Color teksUtama;
  final Color teksSekunder;
  final Color garis;
  final Color aksen;
  final Color headerLatar;
  final Color headerTeks;

  const PaletKartu({
    required this.latar,
    required this.teksUtama,
    required this.teksSekunder,
    required this.garis,
    required this.aksen,
    required this.headerLatar,
    required this.headerTeks,
  });

  static const terang = PaletKartu(
    latar: Color(0xFFFFFFFF),
    teksUtama: Color(0xFF14201A),
    teksSekunder: Color(0xFF5B6B63),
    garis: Color(0xFFE2E8E4),
    aksen: Color(0xFF0B6B45),
    headerLatar: Color(0xFF0B6B45),
    headerTeks: Color(0xFFFFFFFF),
  );

  static const gelap = PaletKartu(
    latar: Color(0xFF16201B),
    teksUtama: Color(0xFFF1F5F2),
    teksSekunder: Color(0xFF9DB0A5),
    garis: Color(0xFF2B3A32),
    aksen: Color(0xFF4CC38A),
    headerLatar: Color(0xFF0E3B28),
    headerTeks: Color(0xFFF1F5F2),
  );
}

/// Halaman utama bersifat StatefulWidget karena menyimpan status tema kartu.
class HalamanKartu extends StatefulWidget {
  const HalamanKartu({super.key});

  @override
  State<HalamanKartu> createState() => _HalamanKartuState();
}

class _HalamanKartuState extends State<HalamanKartu> {
  // Status tema kartu: false = terang, true = gelap.
  bool _modeGelap = false;

  void _gantiTema() {
    setState(() {
      _modeGelap = !_modeGelap;
    });
  }

  @override
  Widget build(BuildContext context) {
    final palet = _modeGelap ? PaletKartu.gelap : PaletKartu.terang;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kartu Identitas Digital'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _KartuMahasiswa(palet: palet),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: _gantiTema,
                    icon: Icon(
                      _modeGelap ? Icons.light_mode : Icons.dark_mode,
                    ),
                    label: Text(
                      _modeGelap ? 'Ubah ke Mode Terang' : 'Ubah ke Mode Gelap',
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Mode saat ini: ${_modeGelap ? 'Gelap' : 'Terang'}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Kartu identitas. Berupa StatelessWidget karena hanya menerima palet dari induk.
class _KartuMahasiswa extends StatelessWidget {
  final PaletKartu palet;

  const _KartuMahasiswa({required this.palet});

  @override
  Widget build(BuildContext context) {
    // Format tanggal bahasa Indonesia memakai package intl.
    final tanggalCetak =
        DateFormat('EEEE, d MMMM y', 'id_ID').format(DateTime.now());

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: palet.latar,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: palet.garis),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Bagian kepala kartu
          Container(
            color: palet.headerLatar,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                Icon(Icons.school, color: palet.headerTeks, size: 32),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'KARTU TANDA MAHASISWA',
                        style: TextStyle(
                          color: palet.headerTeks,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Universitas Warmadewa',
                        style: TextStyle(
                          color: palet.headerTeks,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Bagian foto dan identitas utama
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _FotoProfil(palet: palet),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'I Made Oka Wali Putra',
                        style: TextStyle(
                          color: palet.teksUtama,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'NIM 202463121004',
                        style: TextStyle(
                          color: palet.aksen,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Teknik Komputer',
                        style: TextStyle(
                          color: palet.teksSekunder,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Container(height: 1, color: palet.garis),

          // Bagian data diri
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _BarisInfo(
                  palet: palet,
                  ikon: Icons.apartment,
                  label: 'Fakultas',
                  nilai: 'Teknik dan Perencanaan',
                ),
                const SizedBox(height: 14),
                _BarisInfo(
                  palet: palet,
                  ikon: Icons.groups,
                  label: 'Kelas',
                  nilai: 'K2 Teknik Komputer',
                ),
                const SizedBox(height: 14),
                _BarisInfo(
                  palet: palet,
                  ikon: Icons.location_on_outlined,
                  label: 'Asal',
                  nilai:
                      'Banjar Tabu, Desa Songan A, Kintamani, Bangli, Bali, Indonesia',
                ),
                const SizedBox(height: 14),
                _BarisInfo(
                  palet: palet,
                  ikon: Icons.calendar_today,
                  label: 'Angkatan',
                  nilai: '2024',
                ),
                const SizedBox(height: 14),
                _BarisInfo(
                  palet: palet,
                  ikon: Icons.email_outlined,
                  label: 'Email',
                  nilai: 'madeoka08123@gmail.com',
                ),
                const SizedBox(height: 14),
                _BarisInfo(
                  palet: palet,
                  ikon: Icons.code,
                  label: 'GitHub',
                  nilai: 'github.com/deoka1',
                ),
              ],
            ),
          ),

          Container(height: 1, color: palet.garis),

          // Bagian tanggal cetak kartu
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              children: [
                Icon(Icons.print_outlined, size: 16, color: palet.teksSekunder),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Dicetak: $tanggalCetak',
                    style: TextStyle(color: palet.teksSekunder, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Foto profil. Jika berkas gambar belum tersedia, tampil ikon pengganti.
class _FotoProfil extends StatelessWidget {
  final PaletKartu palet;

  const _FotoProfil({required this.palet});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 96,
      height: 120,
      decoration: BoxDecoration(
        color: palet.garis,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: palet.aksen, width: 2),
      ),
      clipBehavior: Clip.antiAlias,
      child: Image.asset(
        'assets/foto.jpg',
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Icon(Icons.person, size: 56, color: palet.teksSekunder);
        },
      ),
    );
  }
}

/// Satu baris data diri: ikon di kiri, label dan nilai di kanan.
class _BarisInfo extends StatelessWidget {
  final PaletKartu palet;
  final IconData ikon;
  final String label;
  final String nilai;

  const _BarisInfo({
    required this.palet,
    required this.ikon,
    required this.label,
    required this.nilai,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: Color.alphaBlend(palet.aksen.withAlpha(31), palet.latar),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(ikon, size: 20, color: palet.aksen),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(color: palet.teksSekunder, fontSize: 12),
              ),
              Text(
                nilai,
                style: TextStyle(
                  color: palet.teksUtama,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
