import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trasav/services/setoran_sampah_service.dart';
// import 'package:trasav/models/setoran_sampah.dart';
import 'package:trasav/models/jenis_sampah.dart';
import '../models/user.dart';

class RiwayatPage extends StatefulWidget {
  final User user;

  RiwayatPage({required this.user});

  @override
  _RiwayatPageState createState() => _RiwayatPageState();
}

class _RiwayatPageState extends State<RiwayatPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final _service = SetoranSampahService();
  String selectedFilter = 'Semua';
  List<dynamic> transactions = [];
  List<JenisSampah> jenisSampahList = [];
  bool isLoading = false;
  String? errorMessage;

  final List<String> filters = ['Semua', 'Pending', 'Disetujui', 'Ditolak'];

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
    _tabController = TabController(length: 2, vsync: this);
    _fetchData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _fetchData() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    try {
      final setoran = await _service.getSetoranSampah();
      final penarikan = await _service.getPenarikanSaldo(); // Hapus userId
      final jenisSampah = await _service.getJenisSampah();
      setState(() {
        jenisSampahList = jenisSampah;
        transactions = [
          ...setoran.map((s) => {'type': 'Setoran', 'data': s}),
          ...penarikan.map((p) => {'type': 'Penarikan', 'data': p}),
        ]..sort((a, b) => b['data'].createdAt.compareTo(a['data'].createdAt));
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Gagal memuat data: $e';
        isLoading = false;
      });
      print('Error fetching data: $e');
    }
  }

  List<dynamic> get filteredTransactions {
    if (selectedFilter == 'Semua') {
      return transactions;
    }
    return transactions.where((tx) {
      if (tx['type'] == 'Penarikan') {
        return false;
      }
      final status = tx['data'].status?.toString().toLowerCase() ?? '';
      print(
        'Filtering tx: ${tx['data'].id}, status: $status, filter: $selectedFilter',
      );
      return status == selectedFilter.toLowerCase();
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage != null
          ? Center(
              child: Text(errorMessage!, style: TextStyle(color: Colors.red)),
            )
          : Column(
              children: [
                _buildHeader(),
                SizedBox(height: 16),
                _buildStatsRow(),
                SizedBox(height: 16),
                _buildFilterRow(),
                SizedBox(height: 16),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [_buildTransactionList(), _buildMonthlyReport()],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildHeader() {
    return Container(
      margin: EdgeInsets.all(16),
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
        children: [
          Row(
            children: [
              Icon(Icons.history, color: Colors.white, size: 40),
              SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Riwayat Transaksi',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Pantau semua aktivitas setoran dan penarikan',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              labelColor: Colors.green[600],
              unselectedLabelColor: Colors.white,
              tabs: [
                Tab(text: 'Transaksi'),
                Tab(text: 'Laporan'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    int totalTransactions = transactions.length;
    int pendingCount = transactions
        .where(
          (tx) =>
              tx['type'] == 'Setoran' &&
              (tx['data'].status?.toString().toLowerCase() ?? '') == 'pending',
        )
        .length;
    int approvedCount = transactions
        .where(
          (tx) =>
              tx['type'] == 'Setoran' &&
              (tx['data'].status?.toString().toLowerCase() ?? '') ==
                  'disetujui',
        )
        .length;
    double totalIncome = transactions
        .where((tx) => tx['type'] == 'Setoran')
        .fold(0.0, (sum, tx) => sum + (tx['data'].totalHarga ?? 0.0));

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              totalTransactions.toString(),
              'Total Transaksi',
              Icons.receipt_long,
              Colors.green,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: _buildStatCard(
              pendingCount.toString(),
              'Pending',
              Icons.schedule,
              Colors.orange,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: _buildStatCard(
              approvedCount.toString(),
              'Disetujui',
              Icons.check_circle,
              Colors.green,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: _buildStatCard(
              'Rp ${(totalIncome / 1000).toStringAsFixed(0)}K',
              'Total Pendapatan',
              Icons.monetization_on,
              Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String value,
    String label,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
          Icon(icon, color: color, size: 20),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          Text(
            label,
            style: TextStyle(fontSize: 10, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterRow() {
    return Container(
      height: 40,
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = selectedFilter == filter;

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
                  color: isSelected ? Colors.green[600]! : Colors.grey[300]!,
                ),
              ),
              child: Text(
                filter,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey[700],
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTransactionList() {
    if (filteredTransactions.isEmpty) {
      return Center(
        child: Text(
          'Tidak ada transaksi',
          style: TextStyle(color: Colors.grey[600]),
        ),
      );
    }
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: filteredTransactions.length,
      itemBuilder: (context, index) {
        final transaction = filteredTransactions[index];
        return _buildTransactionCard(transaction);
      },
    );
  }

  Widget _buildTransactionCard(Map<String, dynamic> transaction) {
    final isSetoran = transaction['type'] == 'Setoran';
    final data = transaction['data'];
    print(
      'Processing transaction: id=${data.id}, type=${transaction['type']}, jenisSampahId=${data.jenisSampahId}',
    );

    JenisSampah? jenisSampah;
    try {
      final jenisSampahId = (data.jenisSampahId is int)
          ? data.jenisSampahId
          : int.tryParse(data.jenisSampahId?.toString() ?? '0') ?? 0;
      jenisSampah = isSetoran
          ? jenisSampahList.firstWhere(
              (s) => s.id == jenisSampahId,
              orElse: () =>
                  JenisSampah(id: 0, namaSampah: 'Unknown', hargaPerKg: 0),
            )
          : null;
    } catch (e) {
      print(
        'Error finding JenisSampah: $e, jenisSampahId: ${data.jenisSampahId}',
      );
      jenisSampah = JenisSampah(id: 0, namaSampah: 'Unknown', hargaPerKg: 0);
    }

    Color statusColor;
    String statusText;
    if (isSetoran) {
      switch (data.status?.toString().toLowerCase() ?? '') {
        case 'disetujui':
          statusColor = Colors.green;
          statusText = 'Disetujui';
          break;
        case 'pending':
          statusColor = Colors.orange;
          statusText = 'Pending';
          break;
        case 'ditolak':
          statusColor = Colors.red;
          statusText = 'Ditolak';
          break;
        default:
          statusColor = Colors.grey;
          statusText = data.status?.toString() ?? 'Unknown';
      }
    } else {
      statusColor = Colors.blue;
      statusText = 'Selesai';
    }

    return Container(
      margin: EdgeInsets.only(bottom: 12),
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
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        leading: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color:
                (isSetoran
                        ? (jenisSampahAttributes[jenisSampah!
                                  .namaSampah]?['color'] ??
                              Colors.green)
                        : Colors.blue)
                    .withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            isSetoran
                ? (jenisSampahAttributes[jenisSampah!.namaSampah]?['icon'] ??
                      Icons.recycling)
                : Icons.monetization_on,
            color: isSetoran
                ? (jenisSampahAttributes[jenisSampah!.namaSampah]?['color'] ??
                      Colors.green)
                : Colors.blue,
            size: 24,
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              transaction['type'],
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                statusText,
                style: TextStyle(
                  color: statusColor,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8),
            if (isSetoran)
              Text(
                '${jenisSampah!.namaSampah} - ${data.beratKg.toStringAsFixed(1)} kg',
                style: TextStyle(color: Colors.grey[600]),
              ),
            SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('yyyy-MM-dd HH:mm').format(data.createdAt),
                  style: TextStyle(color: Colors.grey[500], fontSize: 12),
                ),
                Text(
                  isSetoran
                      ? '+Rp ${data.totalHarga.toStringAsFixed(0)}'
                      : '-Rp ${data.jumlah.toStringAsFixed(0)}',
                  style: TextStyle(
                    color: isSetoran ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ],
        ),
        onTap: () {
          _showTransactionDetail(transaction);
        },
      ),
    );
  }

  Widget _buildMonthlyReport() {
    final totalSetoranKg = transactions
        .where((tx) => tx['type'] == 'Setoran')
        .fold<double>(0.0, (sum, tx) => sum + (tx['data'].beratKg ?? 0.0));
    final totalPendapatan = transactions
        .where((tx) => tx['type'] == 'Setoran')
        .fold<double>(0.0, (sum, tx) => sum + (tx['data'].totalHarga ?? 0.0));
    final totalPenarikan = transactions
        .where((tx) => tx['type'] == 'Penarikan')
        .fold<double>(0.0, (sum, tx) => sum + (tx['data'].jumlah ?? 0.0));
    final totalTransaksi = transactions.length;

    final Map<String, double> komposisiSampah = {};
    for (var tx in transactions.where((tx) => tx['type'] == 'Setoran')) {
      JenisSampah? jenisSampah;
      try {
        final jenisSampahId = (tx['data'].jenisSampahId is int)
            ? tx['data'].jenisSampahId
            : int.tryParse(tx['data'].jenisSampahId?.toString() ?? '0') ?? 0;
        print(
          'Processing report: tx ${tx['data'].id}, jenisSampahId: $jenisSampahId',
        );
        jenisSampah = jenisSampahList.firstWhere(
          (s) => s.id == jenisSampahId,
          orElse: () =>
              JenisSampah(id: 0, namaSampah: 'Unknown', hargaPerKg: 0),
        );
      } catch (e) {
        print(
          'Error finding JenisSampah in report: $e, jenisSampahId: ${tx['data'].jenisSampahId}',
        );
        jenisSampah = JenisSampah(id: 0, namaSampah: 'Unknown', hargaPerKg: 0);
      }
      komposisiSampah[jenisSampah.namaSampah] =
          (komposisiSampah[jenisSampah.namaSampah] ?? 0.0) +
          (tx['data'].beratKg ?? 0.0);
    }
    final totalBerat = komposisiSampah.values.fold<double>(
      0.0,
      (sum, v) => sum + v,
    );
    final komposisiPersen = komposisiSampah.map(
      (key, value) => MapEntry(
        key,
        totalBerat > 0 ? (value / totalBerat * 100).toStringAsFixed(0) : '0',
      ),
    );

    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMonthlyStats(
            totalSetoranKg: totalSetoranKg,
            totalPendapatan: totalPendapatan,
            totalPenarikan: totalPenarikan,
            totalTransaksi: totalTransaksi,
          ),
          SizedBox(height: 20),
          _buildWasteTypeChart(komposisiPersen),
          SizedBox(height: 20),
          _buildMonthlyTrend(),
        ],
      ),
    );
  }

  Widget _buildMonthlyStats({
    required double totalSetoranKg,
    required double totalPendapatan,
    required double totalPenarikan,
    required int totalTransaksi,
  }) {
    return Container(
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
          Text(
            'Laporan Bulan Ini',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildReportItem(
                  'Total Setoran',
                  '${totalSetoranKg.toStringAsFixed(1)} kg',
                  Icons.eco,
                  Colors.green,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: _buildReportItem(
                  'Total Pendapatan',
                  'Rp ${totalPendapatan.toStringAsFixed(0)}',
                  Icons.monetization_on,
                  Colors.green,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildReportItem(
                  'Transaksi',
                  '$totalTransaksi kali',
                  Icons.receipt,
                  Colors.green,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: _buildReportItem(
                  'Penarikan',
                  'Rp ${totalPenarikan.toStringAsFixed(0)}',
                  Icons.money,
                  Colors.green,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReportItem(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildWasteTypeChart(Map<String, String> komposisiPersen) {
    return Container(
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
          Text(
            'Komposisi Sampah',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 20),
          ...komposisiPersen.entries.map((entry) {
            final attributes =
                jenisSampahAttributes[entry.key] ??
                {'icon': Icons.recycling, 'color': Colors.green};
            return _buildWasteTypeItem(
              entry.key,
              '${entry.value}%',
              attributes['color'],
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildWasteTypeItem(String type, String percentage, Color color) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              type,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ),
          Text(
            percentage,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlyTrend() {
    return Container(
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
          Text(
            'Tren Bulanan',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 20),
          Container(
            height: 200,
            child: Center(
              child: Text(
                'Grafik tren akan ditampilkan di sini\n(Memerlukan library chart seperti fl_chart)',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showTransactionDetail(Map<String, dynamic> transaction) {
    final isSetoran = transaction['type'] == 'Setoran';
    final data = transaction['data'];
    JenisSampah? jenisSampah;
    try {
      final jenisSampahId = (data.jenisSampahId is int)
          ? data.jenisSampahId
          : int.tryParse(data.jenisSampahId?.toString() ?? '0') ?? 0;
      print('Transaction detail: id=${data.id}, jenisSampahId=$jenisSampahId');
      jenisSampah = isSetoran
          ? jenisSampahList.firstWhere(
              (s) => s.id == jenisSampahId,
              orElse: () =>
                  JenisSampah(id: 0, namaSampah: 'Unknown', hargaPerKg: 0),
            )
          : null;
    } catch (e) {
      print(
        'Error finding JenisSampah in detail: $e, jenisSampahId: ${data.jenisSampahId}',
      );
      jenisSampah = JenisSampah(id: 0, namaSampah: 'Unknown', hargaPerKg: 0);
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Detail Transaksi'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID: ${data.id}'),
            Text('Jenis: ${transaction['type']}'),
            if (isSetoran) Text('Jenis Sampah: ${jenisSampah!.namaSampah}'),
            if (isSetoran) Text('Berat: ${data.beratKg.toStringAsFixed(1)} kg'),
            Text(
              'Jumlah: Rp ${(isSetoran ? data.totalHarga : data.jumlah).toStringAsFixed(0)}',
            ),
            Text(
              'Status: ${isSetoran ? (data.status?.toString() ?? 'Unknown') : 'Selesai'}',
            ),
            Text(
              'Tanggal: ${DateFormat('yyyy-MM-dd HH:mm').format(data.createdAt)}',
            ),
            if (isSetoran && data.metodePenjemputan != null)
              Text('Metode Penjemputan: ${data.metodePenjemputan}'),
            if (isSetoran && data.alamatPenjemputan != null)
              Text('Alamat Penjemputan: ${data.alamatPenjemputan}'),
            if (isSetoran && data.catatanTambahan != null)
              Text('Catatan: ${data.catatanTambahan}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Tutup'),
          ),
        ],
      ),
    );
  }
}
