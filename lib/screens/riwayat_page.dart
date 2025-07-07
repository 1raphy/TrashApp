import 'package:flutter/material.dart';
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
  String selectedFilter = 'Semua';

  final List<String> filters = ['Semua', 'Pending', 'Approved', 'Rejected'];

  final List<Map<String, dynamic>> transactions = [
    {
      'id': 'TRX001',
      'type': 'Setoran',
      'wasteType': 'Plastik',
      'weight': '2.5 kg',
      'amount': 6250,
      'status': 'Approved',
      'date': '2024-01-15',
      'time': '14:30',
      'icon': Icons.recycling,
      'color': Colors.green,
    },
    {
      'id': 'TRX002',
      'type': 'Penarikan',
      'wasteType': '-',
      'weight': '-',
      'amount': -100000,
      'status': 'Approved',
      'date': '2024-01-14',
      'time': '10:15',
      'icon': Icons.money,
      'color': Colors.blue,
    },
    {
      'id': 'TRX003',
      'type': 'Setoran',
      'wasteType': 'Kertas',
      'weight': '3.0 kg',
      'amount': 4500,
      'status': 'Pending',
      'date': '2024-01-13',
      'time': '16:20',
      'icon': Icons.description,
      'color': Colors.orange,
    },
    {
      'id': 'TRX004',
      'type': 'Setoran',
      'wasteType': 'Logam',
      'weight': '1.2 kg',
      'amount': 6000,
      'status': 'Approved',
      'date': '2024-01-12',
      'time': '09:45',
      'icon': Icons.build,
      'color': Colors.grey,
    },
    {
      'id': 'TRX005',
      'type': 'Setoran',
      'wasteType': 'Kaca',
      'weight': '0.8 kg',
      'amount': 2400,
      'status': 'Rejected',
      'date': '2024-01-11',
      'time': '11:30',
      'icon': Icons.kitchen,
      'color': Colors.amber,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get filteredTransactions {
    if (selectedFilter == 'Semua') {
      return transactions;
    }
    return transactions.where((tx) => tx['status'] == selectedFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
    );
  }

  Widget _buildHeader() {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue[400]!, Colors.blue[600]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
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
              labelColor: Colors.blue[600],
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
        .where((tx) => tx['status'] == 'Pending')
        .length;
    int approvedCount = transactions
        .where((tx) => tx['status'] == 'Approved')
        .length;
    double totalIncome = transactions
        .where((tx) => tx['amount'] > 0)
        .fold(0.0, (sum, tx) => sum + tx['amount']);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              totalTransactions.toString(),
              'Total Transaksi',
              Icons.receipt_long,
              Colors.purple,
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
              'Approved',
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
              Colors.blue,
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
            blurRadius: 5,
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
                color: isSelected ? Colors.blue[600] : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? Colors.blue[600]! : Colors.grey[300]!,
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
    Color statusColor;
    switch (transaction['status']) {
      case 'Approved':
        statusColor = Colors.green;
        break;
      case 'Pending':
        statusColor = Colors.orange;
        break;
      case 'Rejected':
        statusColor = Colors.red;
        break;
      default:
        statusColor = Colors.grey;
    }

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        leading: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: transaction['color'].withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            transaction['icon'],
            color: transaction['color'],
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
                transaction['status'],
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
            if (transaction['wasteType'] != '-')
              Text(
                '${transaction['wasteType']} - ${transaction['weight']}',
                style: TextStyle(color: Colors.grey[600]),
              ),
            SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${transaction['date']} ${transaction['time']}',
                  style: TextStyle(color: Colors.grey[500], fontSize: 12),
                ),
                Text(
                  '${transaction['amount'] > 0 ? '+' : ''}Rp ${transaction['amount'].abs().toString()}',
                  style: TextStyle(
                    color: transaction['amount'] > 0
                        ? Colors.green
                        : Colors.red,
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
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMonthlyStats(),
          SizedBox(height: 20),
          _buildWasteTypeChart(),
          SizedBox(height: 20),
          _buildMonthlyTrend(),
        ],
      ),
    );
  }

  Widget _buildMonthlyStats() {
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
                  '15.5 kg',
                  Icons.eco,
                  Colors.green,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: _buildReportItem(
                  'Total Pendapatan',
                  'Rp 245.000',
                  Icons.monetization_on,
                  Colors.blue,
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
                  '12 kali',
                  Icons.receipt,
                  Colors.purple,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: _buildReportItem(
                  'Penarikan',
                  'Rp 100.000',
                  Icons.money,
                  Colors.orange,
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

  Widget _buildWasteTypeChart() {
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
          _buildWasteTypeItem('Plastik', '40%', Colors.green),
          _buildWasteTypeItem('Kertas', '25%', Colors.blue),
          _buildWasteTypeItem('Logam', '20%', Colors.grey),
          _buildWasteTypeItem('Kaca', '15%', Colors.amber),
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
                'Grafik tren akan ditampilkan di sini\n(Memerlukan library chart)',
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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Detail Transaksi'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID: ${transaction['id']}'),
            Text('Jenis: ${transaction['type']}'),
            if (transaction['wasteType'] != '-')
              Text('Jenis Sampah: ${transaction['wasteType']}'),
            if (transaction['weight'] != '-')
              Text('Berat: ${transaction['weight']}'),
            Text('Jumlah: Rp ${transaction['amount'].abs()}'),
            Text('Status: ${transaction['status']}'),
            Text('Tanggal: ${transaction['date']} ${transaction['time']}'),
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
