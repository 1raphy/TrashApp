import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:trasav/services/setoran_sampah_service.dart';
import 'package:trasav/models/setoran_sampah.dart';
import '../models/user.dart';

class SetorSampahPage extends StatefulWidget {
  final User user;

  SetorSampahPage({required this.user});

  @override
  _SetorSampahPageState createState() => _SetorSampahPageState();
}

class _SetorSampahPageState extends State<SetorSampahPage> {
  final _service = SetoranSampahService();
  List<JenisSampah> jenisSampahList = [];
  String selectedJenisSampahId = '';
  double beratSampah = 0.0;
  String selectedMetodePenjemputan = 'Antar Sendiri';
  String alamatPenjemputan = '';
  String catatanTambahan = '';
  bool isLoading = false;
  String? errorMessage;

  // Data statis untuk icon dan color (karena tidak ada di backend)
  final Map<String, Map<String, dynamic>> jenisSampahAttributes = {
    'Plastik': {'icon': Icons.recycling, 'color': Colors.green},
    'Kertas': {'icon': Icons.description, 'color': Colors.blue},
    'Logam': {'icon': Icons.build, 'color': Colors.grey},
    'Kaca': {'icon': Icons.wine_bar, 'color': Colors.amber},
    'Elektronik': {'icon': Icons.phone_android, 'color': Colors.purple},
    'Organik': {'icon': Icons.eco, 'color': Colors.orange},
  };

  @override
  void initState() {
    super.initState();
    _fetchJenisSampah();
  }

  Future<void> _fetchJenisSampah() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    try {
      final jenisSampah = await _service.getJenisSampah();
      setState(() {
        jenisSampahList = jenisSampah;
        if (jenisSampah.isNotEmpty) {
          selectedJenisSampahId = jenisSampah[0].id.toString();
        }
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage != null
          ? Center(child: Text('Error: $errorMessage'))
          : SingleChildScrollView(
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
            children: jenisSampahList.map((sampah) {
              final attributes =
                  jenisSampahAttributes[sampah.namaSampah] ??
                  {'icon': Icons.recycling, 'color': Colors.green};
              return ListTile(
                leading: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: attributes['color'].withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    attributes['icon'],
                    color: attributes['color'],
                    size: 20,
                  ),
                ),
                title: Text(
                  sampah.namaSampah,
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text('Rp ${sampah.hargaPerKg}/kg'),
                trailing: Radio<String>(
                  value: sampah.id.toString(),
                  groupValue: selectedJenisSampahId,
                  onChanged: (String? value) {
                    setState(() {
                      selectedJenisSampahId = value!;
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
    final metodePenjemputan = ['Antar Sendiri', 'Dijemput di Rumah'];
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
    final selectedSampah = jenisSampahList.firstWhere(
      (s) => s.id.toString() == selectedJenisSampahId,
      orElse: () => JenisSampah(id: 0, namaSampah: '', hargaPerKg: 0),
    );

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
              _buildRingkasanItem('Jenis Sampah', selectedSampah.namaSampah),
              _buildRingkasanItem(
                'Berat',
                '${beratSampah.toStringAsFixed(1)} kg',
              ),
              _buildRingkasanItem('Metode', selectedMetodePenjemputan),
              _buildRingkasanItem(
                'Estimasi Saldo',
                'Rp ${_calculateEstimatedPrice()}',
              ),
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
                    'Rp ${_calculateEstimatedPrice()}',
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
    final sampah = jenisSampahList.firstWhere(
      (s) => s.id.toString() == selectedJenisSampahId,
      orElse: () => JenisSampah(id: 0, namaSampah: '', hargaPerKg: 0),
    );
    int price = (beratSampah * sampah.hargaPerKg).round();
    return price.toString();
  }

  Future<void> _submitSetoran() async {
    setState(() {
      isLoading = true;
    });
    try {
      final setoran = await _service.createSetoranSampah(
        jenisSampahId: int.parse(selectedJenisSampahId),
        beratKg: beratSampah,
        metodePenjemputan: selectedMetodePenjemputan,
        alamatPenjemputan: selectedMetodePenjemputan == 'Dijemput di Rumah'
            ? alamatPenjemputan
            : null,
        catatanTambahan: catatanTambahan.isNotEmpty ? catatanTambahan : null,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Setoran berhasil: Rp ${setoran.totalHarga}')),
      );
      setState(() {
        beratSampah = 0.0;
        selectedJenisSampahId = jenisSampahList.isNotEmpty
            ? jenisSampahList[0].id.toString()
            : '';
        selectedMetodePenjemputan = 'Antar Sendiri';
        alamatPenjemputan = '';
        catatanTambahan = '';
        isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal menyimpan setoran: $e')));
      setState(() {
        isLoading = false;
      });
    }
  }
}
