import 'package:flutter/material.dart';
import 'package:sipencari_app/shared/shared.dart';

void main() {
  runApp(MaterialApp(
    home: Tips2(),
  ));
}

class Tips2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Tips & Trik',style: TextStyle(color: Colors.black)),
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
                'Menyimpan Barang dan Barang Bawaan dengan Aman',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16.0),
              Text(
                'Berikut adalah beberapa tips dan trik untuk menyimpan barang dan barang bawaan Anda dengan aman. Dengan mengikuti langkah-langkah ini, Anda dapat melindungi barang berharga dan menjaga keamanan:',
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
                title: Text('Pilih Tempat yang Aman:'),
                subtitle: Text(
                  '- Pilih tempat yang aman dan terkunci untuk menyimpan barang berharga Anda.\n'
                  '- Pertimbangkan menggunakan brankas, laci yang terkunci, atau ruangan yang dilengkapi sistem keamanan.',
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
                title: Text('Gunakan Pengaman Tambahan:'),
                subtitle: Text(
                  '- Gunakan pengaman tambahan seperti gembok, kunci khusus, atau kode akses untuk melindungi pintu atau tempat penyimpanan.\n'
                  '- Pastikan pengaman tambahan yang Anda gunakan memiliki kualitas yang baik dan sesuai dengan kebutuhan Anda.',
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
                title: Text('Ciptakan Sistem Organisasi:'),
                subtitle: Text(
                  '- Buat sistem organisasi yang baik untuk menyimpan barang-barang Anda.\n'
                  '- Gunakan label atau kotak penyimpanan yang jelas untuk memudahkan Anda menemukan barang dengan cepat dan mencegah kekacauan.',
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
                title: Text('Hindari Tempat yang Rentan:'),
                subtitle: Text(
                  '- Hindari menyimpan barang berharga Anda di tempat yang rentan seperti dekat jendela, pintu belakang, atau area yang mudah dijangkau oleh orang lain.\n'
                  '- Pastikan tempat penyimpanan Anda tidak mudah ditemukan oleh orang asing.',
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
                title: Text('Selalu Awasi Barang Bawaan Anda:'),
                subtitle: Text(
                  '- Jaga barang bawaan Anda selalu di dekat Anda dan jangan biarkan mereka tanpa pengawasan.\n'
                  '- Hindari meletakkan barang berharga di luar jangkauan atau mengabaikan mereka di tempat umum.',
                ),
              ),
              ListTile(
                leading: CircleAvatar(
                  child: Text(
                    '6',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  backgroundColor: primaryColor,
                ),
                title: Text('Gunakan Tas yang Aman:'),
                subtitle: Text(
                  '- Gunakan tas dengan sistem kunci atau ritsleting yang kuat untuk mencegah pencurian.\n'
                  '- Pertimbangkan menggunakan tas dengan fitur keamanan tambahan seperti lapisan tahan tusukan atau kantung tersembunyi.',
                ),
              ),
              ListTile(
                leading: CircleAvatar(
                  child: Text(
                    '7',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  backgroundColor: primaryColor,
                ),
                title: Text('Bagi Barang Berharga:'),
                subtitle: Text(
                  '- Jika Anda membawa barang berharga seperti paspor, kartu kredit, atau uang tunai, sebaiknya simpan mereka di tempat yang terpisah.\n'
                  '- Hindari menyimpan semua barang berharga di satu tempat untuk mengurangi risiko kehilangan semua barang tersebut jika terjadi pencurian.',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
