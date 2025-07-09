import 'package:flutter/material.dart';
import 'package:trasav/models/setoran_sampah.dart';
import 'package:trasav/models/user.dart';
import 'package:trasav/services/setoran_sampah_service.dart';

class RiwayatSetoranPage extends StatefulWidget {
  final User user;

  RiwayatSetoranPage({required this.user});

  @override
  _RiwayatSetoranPageState createState() => _RiwayatSetoranPageState();
}

class _RiwayatSetoranPageState extends State<RiwayatSetoranPage> {
  final SetoranSampahService _service = SetoranSampahService();
  String selectedFilter = 'Semua';
  List<String> filterOptions = ['Semua', 'Pending', 'Diverifikasi', 'Ditolak'];
  List<SetoranSampah> setoranData = [];
  bool isLoading = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchSetoranData();
  }

  Future<void> _fetchSetoranData() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    try {
      final setorans = await _service.getSetoranSampah();
      setState(() {
        setoranData = setorans;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Gagal memuat data setoran: $e';
        isLoading = false;
      });
      print('Error fetching setoran data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage != null
          ? Center(
              child: Text(errorMessage!, style: TextStyle(color: Colors.red)),
            )
          : Column(
              children: [
                _buildHeader(),
                _buildFilterSection(),
                Expanded(child: _buildSetoranList()),
              ],
            ),
      // floatingActionButton: _buildFloatingActionButton(),
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
          Icon(Icons.history, color: Colors.green[600], size: 24),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Riwayat Setoran',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              Text(
                'Kelola dan verifikasi setoran sampah',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
          Spacer(),
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.green[600]),
            onPressed: _fetchSetoranData,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Filter Status',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: filterOptions.map((filter) {
                bool isSelected = selectedFilter == filter;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedFilter = filter;
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 8),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.green[600] : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected
                            ? Colors.green[600]!
                            : Colors.grey[300]!,
                      ),
                    ),
                    child: Text(
                      filter,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.grey[600],
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSetoranList() {
    List<SetoranSampah> filteredData = setoranData.where((setoran) {
      if (selectedFilter == 'Semua') return true;
      String displayStatus = _getDisplayStatus(setoran.status);
      return displayStatus.toLowerCase() == selectedFilter.toLowerCase();
    }).toList();

    if (filteredData.isEmpty) {
      return Center(
        child: Text(
          'Tidak ada data setoran',
          style: TextStyle(color: Colors.grey[600]),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16),
      itemCount: filteredData.length,
      itemBuilder: (context, index) {
        final setoran = filteredData[index];
        return _buildSetoranCard(setoran);
      },
    );
  }

  Widget _buildSetoranCard(SetoranSampah setoran) {
    String displayStatus = _getDisplayStatus(setoran.status);
    Color statusColor = _getStatusColor(displayStatus);
    IconData statusIcon = _getStatusIcon(displayStatus);

    return Card(
      margin: EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _showSetoranDetail(setoran),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.recycling, color: Colors.green[600]),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'ST${setoran.id.toString().padLeft(3, '0')}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Spacer(),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: statusColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    statusIcon,
                                    size: 12,
                                    color: statusColor,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    displayStatus,
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: statusColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        Text(
                          setoran.user?.name ?? 'Unknown',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                        Text(
                          setoran.jenisSampah?.namaSampah ?? 'Unknown',
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
                  Icon(Icons.scale, size: 16, color: Colors.grey[600]),
                  SizedBox(width: 4),
                  Text(
                    '${setoran.beratKg.toStringAsFixed(1)} kg',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  SizedBox(width: 16),
                  Icon(
                    Icons.monetization_on,
                    size: 16,
                    color: Colors.green[600],
                  ),
                  SizedBox(width: 4),
                  Text(
                    'Rp ${setoran.totalHarga.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.green[600],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Spacer(),
                  Text(
                    setoran.createdAt.toString().substring(0, 10),
                    style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                  ),
                ],
              ),
              if (setoran.status.toLowerCase() == 'pending' &&
                  widget.user.role == 'operator') ...[
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _verifySetoran(setoran.id, true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[600],
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text('Verifikasi'),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _verifySetoran(setoran.id, false),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red[600],
                          side: BorderSide(color: Colors.red[600]!),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text('Tolak'),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _getDisplayStatus(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Pending';
      case 'disetujui':
        return 'Diverifikasi';
      case 'ditolak':
        return 'Ditolak';
      default:
        return 'Unknown';
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange[600]!;
      case 'diverifikasi':
        return Colors.green[600]!;
      case 'ditolak':
        return Colors.red[600]!;
      default:
        return Colors.grey[600]!;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Icons.hourglass_empty;
      case 'diverifikasi':
        return Icons.check_circle;
      case 'ditolak':
        return Icons.cancel;
      default:
        return Icons.help;
    }
  }

  void _showSetoranDetail(SetoranSampah setoran) {
    String displayStatus = _getDisplayStatus(setoran.status);
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Detail Setoran',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              SizedBox(height: 16),
              _buildDetailRow(
                'ID Setoran',
                'ST${setoran.id.toString().padLeft(3, '0')}',
              ),
              _buildDetailRow('Nasabah', setoran.user?.name ?? 'Unknown'),
              _buildDetailRow(
                'Kategori',
                setoran.jenisSampah?.namaSampah ?? 'Unknown',
              ),
              _buildDetailRow(
                'Berat',
                '${setoran.beratKg.toStringAsFixed(1)} kg',
              ),
              _buildDetailRow(
                'Harga',
                'Rp ${setoran.totalHarga.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
              ),
              _buildDetailRow(
                'Tanggal',
                setoran.createdAt.toString().substring(0, 10),
              ),
              _buildDetailRow('Status', displayStatus),
              _buildDetailRow('Metode Penjemputan', setoran.metodePenjemputan),
              if (setoran.alamatPenjemputan != null)
                _buildDetailRow(
                  'Alamat Penjemputan',
                  setoran.alamatPenjemputan!,
                ),
              if (setoran.catatanTambahan != null)
                _buildDetailRow('Catatan Tambahan', setoran.catatanTambahan!),
              if (setoran.status.toLowerCase() == 'pending' &&
                  widget.user.role == 'operator') ...[
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _verifySetoran(setoran.id, true);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[600],
                          foregroundColor: Colors.white,
                        ),
                        child: Text('Verifikasi'),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _verifySetoran(setoran.id, false);
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red[600],
                          side: BorderSide(color: Colors.red[600]!),
                        ),
                        child: Text('Tolak'),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(': ', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[800],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _verifySetoran(int id, bool approve) async {
    try {
      final status = approve ? 'disetujui' : 'ditolak';
      await _service.updateStatusSetoranSampah(id, status);
      await _fetchSetoranData();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            approve ? 'Setoran berhasil diverifikasi' : 'Setoran ditolak',
          ),
          backgroundColor: approve ? Colors.green[600] : Colors.red[600],
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal memperbarui status: $e'),
          backgroundColor: Colors.red[600],
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  // Widget _buildFloatingActionButton() {
  //   if (widget.user.role != 'operator') return SizedBox.shrink();
  //   return FloatingActionButton.extended(
  //     onPressed: _showAddSetoranDialog,
  //     backgroundColor: Colors.green[600],
  //     label: Text('Tambah Setoran', style: TextStyle(color: Colors.white)),
  //     icon: Icon(Icons.add, color: Colors.white),
  //   );
  // }

  // void _showAddSetoranDialog() {
  //   showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: Text('Tambah Setoran Manual'),
  //       content: Text(
  //         'Fitur untuk menambah setoran manual akan diimplementasikan di sini.',
  //       ),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.pop(context),
  //           child: Text('OK'),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
