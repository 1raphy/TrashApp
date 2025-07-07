import 'package:flutter/material.dart';
import '../models/user.dart';

class SetorSampahPage extends StatefulWidget {
  final User user;

  SetorSampahPage({required this.user});

  @override
  _SetorSampahPageState createState() => _SetorSampahPageState();
}

class _SetorSampahPageState extends State<SetorSampahPage> {
  String selectedJenisSampah = 'Plastik';
  double beratSampah = 0.0;
  String selectedMetodePenjemputan = 'Antar Sendiri';
  String alamatPenjemputan = '';
  String catatanTambahan = '';

  final List<Map<String, dynamic>> jenisSampah = [
    {
      'name': 'Plastik',
      'price': 3000,
      'icon': Icons.recycling,
      'color': Colors.green,
    },
    {
      'name': 'Kertas',
      'price': 2000,
      'icon': Icons.description,
      'color': Colors.blue,
    },
    {'name': 'Logam', 'price': 8000, 'icon': Icons.build, 'color': Colors.grey},
    {
      'name': 'Kaca',
      'price': 1500,
      'icon': Icons.wine_bar,
      'color': Colors.amber,
    },
    {
      'name': 'Elektronik',
      'price': 5000,
      'icon': Icons.phone_android,
      'color': Colors.purple,
    },
    {
      'name': 'Organik',
      'price': 1000,
      'icon': Icons.eco,
      'color': Colors.orange,
    },
  ];

  final List<String> metodePenjemputan = [
    'Antar Sendiri',
    'Dijemput di Rumah',
    'Titik Kumpul Terdekat',
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderCard(),
          SizedBox(height: 20),
          _buildJenisSampahSection(),
          SizedBox(height: 20),
          _buildBeratSampahSection(),
          SizedBox(height: 20),
          _buildMetodePenjemputanSection(),
          SizedBox(height: 20),
          _buildRingkasanSection(),
          SizedBox(height: 20),
          _buildSubmitButton(),
        ],
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green[400]!, Colors.green[600]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.3),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.recycling, color: Colors.white, size: 30),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Setor Sampah',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text(
            'Tukar sampah Anda dengan saldo yang bermanfaat',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildJenisSampahSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pilih Jenis Sampah',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        SizedBox(height: 15),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 10,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: jenisSampah.map((sampah) {
              return ListTile(
                leading: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: sampah['color'].withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(sampah['icon'], color: sampah['color'], size: 20),
                ),
                title: Text(
                  sampah['name'],
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text('Rp ${sampah['price']}/kg'),
                trailing: Radio<String>(
                  value: sampah['name'],
                  groupValue: selectedJenisSampah,
                  onChanged: (String? value) {
                    setState(() {
                      selectedJenisSampah = value!;
                    });
                  },
                  activeColor: Colors.green[600],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildBeratSampahSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Berat Sampah (kg)',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        SizedBox(height: 15),
        Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 10,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Berat: ${beratSampah.toStringAsFixed(1)} kg',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    'Estimasi: Rp ${_calculateEstimatedPrice()}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.green[600],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              Slider(
                value: beratSampah,
                min: 0.0,
                max: 50.0,
                divisions: 100,
                activeColor: Colors.green[600],
                onChanged: (double value) {
                  setState(() {
                    beratSampah = value;
                  });
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('0 kg', style: TextStyle(color: Colors.grey[600])),
                  Text('50 kg', style: TextStyle(color: Colors.grey[600])),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMetodePenjemputanSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Metode Penjemputan',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        SizedBox(height: 15),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 10,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              ...metodePenjemputan.map((metode) {
                return ListTile(
                  title: Text(metode),
                  trailing: Radio<String>(
                    value: metode,
                    groupValue: selectedMetodePenjemputan,
                    onChanged: (String? value) {
                      setState(() {
                        selectedMetodePenjemputan = value!;
                      });
                    },
                    activeColor: Colors.green[600],
                  ),
                );
              }).toList(),
              if (selectedMetodePenjemputan == 'Dijemput di Rumah') ...[
                Divider(),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: TextField(
                    onChanged: (value) {
                      alamatPenjemputan = value;
                    },
                    decoration: InputDecoration(
                      labelText: 'Alamat Penjemputan',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.green[600]!),
                      ),
                    ),
                    maxLines: 3,
                  ),
                ),
              ],
              Divider(),
              Padding(
                padding: EdgeInsets.all(16),
                child: TextField(
                  onChanged: (value) {
                    catatanTambahan = value;
                  },
                  decoration: InputDecoration(
                    labelText: 'Catatan Tambahan (Opsional)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.green[600]!),
                    ),
                  ),
                  maxLines: 2,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRingkasanSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ringkasan Setoran',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        SizedBox(height: 15),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 10,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildRingkasanItem('Jenis Sampah', selectedJenisSampah),
              _buildRingkasanItem(
                'Berat',
                '${beratSampah.toStringAsFixed(1)} kg',
              ),
              _buildRingkasanItem('Metode', selectedMetodePenjemputan),
              _buildRingkasanItem(
                'Estimasi Saldo',
                'Rp ${_calculateEstimatedPrice()}',
              ),
              if (selectedMetodePenjemputan == 'Dijemput di Rumah')
                _buildRingkasanItem('Biaya Penjemputan', '- Rp 5.000'),
              Divider(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Saldo:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  Text(
                    'Rp ${_calculateFinalPrice()}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRingkasanItem(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    bool isValid =
        beratSampah > 0 &&
        (selectedMetodePenjemputan != 'Dijemput di Rumah' ||
            alamatPenjemputan.isNotEmpty);

    return Container(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isValid ? _submitSetoran : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green[600],
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 5,
        ),
        child: Text(
          'Konfirmasi Setoran',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  String _calculateEstimatedPrice() {
    var sampah = jenisSampah.firstWhere(
      (s) => s['name'] == selectedJenisSampah,
    );
    int price = (beratSampah * sampah['price']).round();
    return price.toString();
  }

  String _calculateFinalPrice() {
    var sampah = jenisSampah.firstWhere(
      (s) => s['name'] == selectedJenisSampah,
    );
    int price = (beratSampah * sampah['price']).round();

    if (selectedMetodePenjemputan == 'Dijemput di Rumah') {
      price -= 5000;
    }

    return price.toString();
  }

  void _submitSetoran() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green[600]),
              SizedBox(width: 8),
              Text('Setoran Berhasil'),
            ],
          ),
          content: Text(
            'Setoran sampah Anda telah berhasil dicatat. Saldo akan ditambahkan setelah verifikasi.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Reset form
                setState(() {
                  beratSampah = 0.0;
                  selectedJenisSampah = 'Plastik';
                  selectedMetodePenjemputan = 'Antar Sendiri';
                  alamatPenjemputan = '';
                  catatanTambahan = '';
                });
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
