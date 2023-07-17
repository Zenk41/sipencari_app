import 'package:flutter/material.dart';
import 'package:sipencari_app/shared/shared.dart';

void main() {
  runApp(MaterialApp(
    home: Tips1(),
  ));
}

class Tips1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Tips & Trik', style: TextStyle(color: Colors.black)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new),
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Tips & Trik',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16.0),
              Text(
                'Menemukan Kehilangan',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16.0),
              Text(
                'Kehilangan barang bisa menjadi frustrasi, tetapi dengan tips dan trik berikut, Anda dapat meningkatkan peluang menemukan barang yang hilang. Ikuti langkah-langkah berikut untuk memiliki peluang lebih baik dalam menemukan barang yang Anda cari:',
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 16.0),
              ListTile(
                leading: CircleAvatar(
                  child: Text(
                    '1',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  backgroundColor: primaryColor,
                ),
                title: Text('Tenang dan Telusuri Kembali Langkah Anda:'),
                subtitle: Text(
                  '- Bernapaslah dalam-dalam dan tetap tenang. Panik bisa membuat Anda sulit berpikir dengan jelas.\n'
                  '- Mulailah dengan mengingat kembali dan mengunjungi tempat-tempat di mana Anda terakhir ingat memiliki barang tersebut. Mulai dari lokasi yang paling terkini dan mundur.',
                ),
              ),
              ListTile(
                leading: CircleAvatar(
                  child: Text(
                    '2',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  backgroundColor: primaryColor,
                ),
                title: Text('Gunakan Pendekatan Pencarian Sistematis:'),
                subtitle: Text(
                  '- Bagi area tersebut menjadi bagian-bagian dan telusuri setiap bagian secara menyeluruh sebelum melanjutkan ke bagian berikutnya.\n'
                  '- Periksa semua tempat biasa di mana Anda sering menyimpan barang serupa. Kadang-kadang, kita melewatkan tempat-tempat yang jelas.',
                ),
              ),
              ListTile(
                leading: CircleAvatar(
                  child: Text(
                    '3',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  backgroundColor: primaryColor,
                ),
                title: Text('Minta Bantuan:'),
                subtitle: Text(
                  '- Mintalah bantuan dari keluarga, teman, atau rekan kerja. Mereka mungkin ingat melihat atau mengambil barang tersebut.\n'
                  '- Jika Anda kehilangan barang di tempat umum atau tempat kerja, beri tahu staf atau petugas keamanan. Mereka mungkin memiliki bagian penemuan dan penyerahan barang hilang atau dapat membantu Anda dalam pencarian.',
                ),
              ),
              ListTile(
                leading: CircleAvatar(
                  child: Text(
                    '4',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  backgroundColor: primaryColor,
                ),
                title: Text('Manfaatkan Teknologi:'),
                subtitle: Text(
                  '- Manfaatkan teknologi sebanyak mungkin. Jika Anda memiliki smartphone atau smartwatch, periksa apakah ada fitur pelacakan yang tersedia. Beberapa perangkat dapat membantu menemukan barang yang hilang melalui koneksi GPS atau Bluetooth.\n'
                  '- Pertimbangkan penggunaan aplikasi atau perangkat khusus yang dirancang untuk melacak barang yang hilang. Mereka sering dilengkapi dengan fitur peringatan keberadaan atau pelacakan lokasi.',
                ),
              ),
              ListTile(
                leading: CircleAvatar(
                  child: Text(
                    '5',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  backgroundColor: primaryColor,
                ),
                title: Text('Perluas Pencarian Anda:'),
                subtitle: Text(
                  '- Jika Anda masih belum menemukan barang setelah pencarian awal, perluas jangkauan Anda. Periksa ruangan lain, saku, tas, atau bahkan kendaraan Anda.\n'
                  '- Pikirkan tentang aktivitas apa yang Anda lakukan atau tempat yang Anda kunjungi saat terakhir kali memiliki barang tersebut. Terkadang, mengingat kembali aktivitas Anda dapat memicu ingatan Anda.',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
