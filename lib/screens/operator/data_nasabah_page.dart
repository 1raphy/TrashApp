import 'package:flutter/material.dart';
import '../../models/user.dart';

class DataNasabahPage extends StatefulWidget {
  final User user;

  DataNasabahPage({required this.user});

  @override
  _DataNasabahPageState createState() => _DataNasabahPageState();
}

class _DataNasabahPageState extends State<DataNasabahPage> {
  TextEditingController _searchController = TextEditingController();
  String searchQuery = '';

  // Data dummy untuk nasabah
  List<Map<String, dynamic>> nasabahData = [
    {
      'id': 'NSB001',
      'nama': 'Budi Santoso',
      'email': 'budi.santoso@email.com',
      'telepon': '081234567890',
      'alamat': 'Jl. Merdeka No. 123, Jakarta',
      'saldo': 125000,
      'totalSetoran': 15,
      'tanggalDaftar': '2024-01-10',
      'status': 'Aktif',
      'avatar': 'https://via.placeholder.com/50',
    },
    {
      'id': 'NSB002',
      'nama': 'Siti Aminah',
      'email': 'siti.aminah@email.com',
      'telepon': '081234567891',
      'alamat': 'Jl. Sudirman No. 456, Jakarta',
      'saldo': 89000,
      'totalSetoran': 12,
      'tanggalDaftar': '2024-01-08',
      'status': 'Aktif',
      'avatar': 'https://via.placeholder.com/50',
    },
    {
      'id': 'NSB003',
      'nama': 'Ahmad Wijaya',
      'email': 'ahmad.wijaya@email.com',
      'telepon': '081234567892',
      'alamat': 'Jl. Gatot Subroto No. 789, Jakarta',
      'saldo': 45000,
      'totalSetoran': 8,
      'tanggalDaftar': '2024-01-05',
      'status': 'Aktif',
      'avatar': 'https://via.placeholder.com/50',
    },
    {
      'id': 'NSB004',
      'nama': 'Rina Susanti',
      'email': 'rina.susanti@email.com',
      'telepon': '081234567893',
      'alamat': 'Jl. Thamrin No. 012, Jakarta',
      'saldo': 0,
      'totalSetoran': 2,
      'tanggalDaftar': '2024-01-03',
      'status': 'Tidak Aktif',
      'avatar': 'https://via.placeholder.com/50',
    },
    {
      'id': 'NSB005',
      'nama': 'Joko Priyono',
      'email': 'joko.priyono@email.com',
      'telepon': '081234567894',
      'alamat': 'Jl. Kuningan No. 345, Jakarta',
      'saldo': 78000,
      'totalSetoran': 10,
      'tanggalDaftar': '2024-01-01',
      'status': 'Aktif',
      'avatar': 'https://via.placeholder.com/50',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          _buildHeader(),
          _buildSearchSection(),
          _buildStatsSection(),
          Expanded(child: _buildNasabahList()),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.people, color: Colors.green[600], size: 24),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Data Nasabah',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              Text(
                'Kelola data nasabah bank sampah',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          Spacer(),
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.green[600]),
            onPressed: () {
              setState(() {
                // Refresh data
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSearchSection() {
    return Container(
      padding: EdgeInsets.all(16),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          setState(() {
            searchQuery = value;
          });
        },
        decoration: InputDecoration(
          hintText: 'Cari nasabah...',
          prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
          suffixIcon: searchQuery.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      searchQuery = '';
                    });
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.green[600]!),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }

  Widget _buildStatsSection() {
    int totalNasabah = nasabahData.length;
    int nasabahAktif = nasabahData.where((n) => n['status'] == 'Aktif').length;
    int totalSaldo = nasabahData.fold(0, (sum, n) => sum + (n['saldo'] as int));

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              totalNasabah.toString(),
              'Total Nasabah',
              Icons.people,
              Colors.blue,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: _buildStatCard(
              nasabahAktif.toString(),
              'Nasabah Aktif',
              Icons.people_alt,
              Colors.green,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: _buildStatCard(
              'Rp ${totalSaldo.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
              'Total Saldo',
              Icons.monetization_on,
              Colors.orange,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
      String value, String label, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildNasabahList() {
    List<Map<String, dynamic>> filteredData = nasabahData.where((nasabah) {
      if (searchQuery.isEmpty) return true;
      return nasabah['nama']
              .toLowerCase()
              .contains(searchQuery.toLowerCase()) ||
          nasabah['email'].toLowerCase().contains(searchQuery.toLowerCase()) ||
          nasabah['telepon'].contains(searchQuery);
    }).toList();

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: filteredData.length,
      itemBuilder: (context, index) {
        final nasabah = filteredData[index];
        return _buildNasabahCard(nasabah);
      },
    );
  }

  Widget _buildNasabahCard(Map<String, dynamic> nasabah) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _showNasabahDetail(nasabah),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.green[100],
                    child: Text(
                      nasabah['nama'][0].toUpperCase(),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[600],
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              nasabah['id'],
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Spacer(),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: nasabah['status'] == 'Aktif'
                                    ? Colors.green.withOpacity(0.1)
                                    : Colors.red.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                nasabah['status'],
                                style: TextStyle(
                                  fontSize: 10,
                                  color: nasabah['status'] == 'Aktif'
                                      ? Colors.green[600]
                                      : Colors.red[600],
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        Text(
                          nasabah['nama'],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                        Text(
                          nasabah['email'],
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.phone, size: 16, color: Colors.grey[600]),
                  SizedBox(width: 4),
                  Text(
                    nasabah['telepon'],
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
              SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                  SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      nasabah['alamat'],
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.monetization_on,
                            size: 14, color: Colors.green[600]),
                        SizedBox(width: 4),
                        Text(
                          'Rp ${nasabah['saldo'].toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.green[600],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.recycling,
                            size: 14, color: Colors.blue[600]),
                        SizedBox(width: 4),
                        Text(
                          '${nasabah['totalSetoran']} setoran',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.blue[600],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  Text(
                    'Bergabung: ${nasabah['tanggalDaftar']}',
                    style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showNasabahDetail(Map<String, dynamic> nasabah) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: EdgeInsets.all(20),
          width: MediaQuery.of(context).size.width * 0.9,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.green[100],
                    child: Text(
                      nasabah['nama'][0].toUpperCase(),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[600],
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          nasabah['nama'],
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                        Text(
                          nasabah['id'],
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              SizedBox(height: 20),
              _buildDetailSection('Informasi Kontak', [
                {'label': 'Email', 'value': nasabah['email']},
                {'label': 'Telepon', 'value': nasabah['telepon']},
                {'label': 'Alamat', 'value': nasabah['alamat']},
              ]),
              SizedBox(height: 16),
              _buildDetailSection('Informasi Akun', [
                {'label': 'Status', 'value': nasabah['status']},
                {'label': 'Tanggal Daftar', 'value': nasabah['tanggalDaftar']},
                {
                  'label': 'Saldo',
                  'value':
                      'Rp ${nasabah['saldo'].toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}'
                },
                {
                  'label': 'Total Setoran',
                  'value': '${nasabah['totalSetoran']} kali'
                },
              ]),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _showEditNasabahDialog(nasabah);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[600],
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text('Edit'),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _showDeleteConfirmation(nasabah);
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red[600],
                        side: BorderSide(color: Colors.red[600]!),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text('Hapus'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailSection(String title, List<Map<String, String>> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        SizedBox(height: 8),
        ...items
            .map((item) => Padding(
                  padding: EdgeInsets.only(bottom: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 100,
                        child: Text(
                          item['label']!,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                      Text(
                        ': ',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                      Expanded(
                        child: Text(
                          item['value']!,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[800],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ))
            .toList(),
      ],
    );
  }

  void _showEditNasabahDialog(Map<String, dynamic> nasabah) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Nasabah'),
        content: Text('Fitur edit nasabah akan diimplementasikan di sini.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Data nasabah berhasil diupdate'),
                  backgroundColor: Colors.green[600],
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(Map<String, dynamic> nasabah) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Hapus Nasabah'),
        content: Text(
            'Apakah Anda yakin ingin menghapus nasabah ${nasabah['nama']}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                nasabahData.removeWhere((n) => n['id'] == nasabah['id']);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Nasabah berhasil dihapus'),
                  backgroundColor: Colors.red[600],
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red[600]),
            child: Text('Hapus', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      onPressed: () {
        _showAddNasabahDialog();
      },
      backgroundColor: Colors.green[600],
      label: Text('Tambah Nasabah', style: TextStyle(color: Colors.white)),
      icon: Icon(Icons.person_add, color: Colors.white),
    );
  }

  void _showAddNasabahDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Tambah Nasabah Baru'),
        content: Text(
            'Fitur untuk menambah nasabah baru akan diimplementasikan di sini.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Nasabah baru berhasil ditambahkan'),
                  backgroundColor: Colors.green[600],
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: Text('Simpan'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
