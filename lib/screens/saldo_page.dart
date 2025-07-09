import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trasav/models/user.dart';
import 'package:trasav/services/setoran_sampah_service.dart';
import 'package:trasav/services/penarikan_saldo_service.dart';

class SaldoPage extends StatefulWidget {
  final User user;

  SaldoPage({required this.user});

  @override
  _SaldoPageState createState() => _SaldoPageState();
}

class _SaldoPageState extends State<SaldoPage> {
  final TextEditingController _withdrawController = TextEditingController();
  final SetoranSampahService _setoranService = SetoranSampahService();
  final PenarikanSaldoService _penarikanService = PenarikanSaldoService();
  List<Map<String, Object>> _transactions = []; // Ubah ke Map<String, Object>
  double _totalWithdrawn = 0.0;
  bool isLoading = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchTransactions();
  }

  Future<void> _fetchTransactions() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    try {
      final setoranList = await _setoranService.getSetoranSampah(
        userId: widget.user.id,
      );
      final penarikanList = await _penarikanService.getPenarikanSaldo(
        userId: widget.user.id,
      );

      // Hitung total saldo yang ditarik
      final totalWithdrawn = penarikanList.fold<double>(
        0.0,
        (sum, p) => sum + p.jumlah,
      );

      final transactions = [
        ...setoranList
            .where((s) => s.status.toLowerCase() == 'disetujui')
            .map(
              (s) => <String, Object>{
                'type': 'deposit',
                'amount': s.totalHarga as double, // Pastikan double
                'description':
                    'Setor ${s.jenisSampah?.namaSampah ?? 'sampah'} ${s.beratKg.toStringAsFixed(1)} kg',
                'date': s.createdAt as DateTime, // Pastikan DateTime
                'status': 'completed',
              },
            ),
        ...penarikanList.map(
          (p) => <String, Object>{
            'type': 'withdrawal',
            'amount': p.jumlah as double, // Pastikan double
            'description': 'Penarikan saldo ke rekening',
            'date': p.createdAt is String
                ? DateTime.parse(p.createdAt as String)
                : p.createdAt as DateTime, // Tangani String atau DateTime
            'status': 'completed',
          },
        ),
      ]..sort((a, b) => (b['date'] as DateTime).compareTo(a['date'] as DateTime));

      setState(() {
        _transactions = transactions;
        _totalWithdrawn = totalWithdrawn;
        isLoading = false;
      });
      print('Total Saldo Ditarik: Rp $_totalWithdrawn');
      print('Transactions: $_transactions');
    } catch (e) {
      setState(() {
        errorMessage = 'Gagal memuat riwayat transaksi: $e';
        isLoading = false;
      });
      print('Error fetching transactions: $e');
    }
  }

  Future<void> _refreshUserBalance() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };
      final response = await http.get(
        Uri.parse('http://10.0.2.2:8000/api/users/${widget.user.id}'),
        headers: headers,
      );

      print('Refresh User Balance Response Status: ${response.statusCode}');
      print('Refresh User Balance Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final updatedUser = User.fromJson(data['data'] ?? data);
        setState(() {
          widget.user.depositBalance = updatedUser.depositBalance;
        });
      } else {
        throw Exception('Gagal memuat data pengguna: ${response.body}');
      }
    } catch (e) {
      print('Error refreshing user balance: $e');
      _showMessage('Gagal memperbarui saldo: $e');
    }
  }

  @override
  void dispose() {
    _withdrawController.dispose();
    super.dispose();
  }

  void _showWithdrawDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Tarik Saldo',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Saldo tersedia: Rp ${_formatCurrency(widget.user.depositBalance)}',
              ),
              SizedBox(height: 8),
              Text(
                'Total ditarik: Rp ${_formatCurrency(_totalWithdrawn)}',
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _withdrawController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Jumlah penarikan',
                  prefixText: 'Rp ',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.green[600]!),
                  ),
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Minimal penarikan: Rp 20.000',
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop();
                _withdrawController.clear();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[600],
                foregroundColor: Colors.white,
              ),
              child: Text('Tarik'),
              onPressed: () {
                _processWithdraw();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _processWithdraw() async {
    if (_withdrawController.text.isEmpty) {
      _showMessage('Masukkan jumlah penarikan');
      return;
    }

    double amount =
        double.tryParse(_withdrawController.text.replaceAll(',', '')) ?? 0;

    if (amount < 20000) {
      _showMessage('Minimal penarikan Rp 20.000');
      return;
    }

    if (amount > widget.user.depositBalance) {
      _showMessage('Saldo tidak mencukupi');
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final penarikan = await _penarikanService.createPenarikanSaldo(
        userId: widget.user.id,
        jumlah: amount,
      );
      await _refreshUserBalance(); // Perbarui saldo dari backend
      setState(() {
        _transactions.insert(0, <String, Object>{
          'type': 'withdrawal',
          'amount': penarikan.jumlah as double, // Pastikan double
          'description': 'Penarikan saldo ke rekening',
          'date': penarikan.createdAt is String
              ? DateTime.parse(penarikan.createdAt as String)
              : penarikan.createdAt as DateTime, // Tangani String atau DateTime
          'status': 'completed',
        });
        _totalWithdrawn +=
            penarikan.jumlah; // Perbarui total saldo yang ditarik
        isLoading = false;
      });
      print(
        'Penarikan: jumlah=${penarikan.jumlah}, createdAt=${penarikan.createdAt}, type=${penarikan.createdAt.runtimeType}',
      );
      Navigator.of(context).pop();
      _withdrawController.clear();
      _showMessage('Penarikan berhasil diproses');
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      _showMessage('Gagal melakukan penarikan: $e');
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: message.contains('Gagal')
            ? Colors.red[600]
            : Colors.green[600],
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  String _formatCurrency(double amount) {
    return amount
        .toStringAsFixed(0)
        .replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        );
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
          : SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSaldoCard(),
                  SizedBox(height: 20),
                  _buildQuickActions(),
                  SizedBox(height: 20),
                  _buildTransactionHistory(),
                ],
              ),
            ),
    );
  }

  Widget _buildSaldoCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24),
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
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.account_balance_wallet, color: Colors.white, size: 28),
              SizedBox(width: 12),
              Text(
                'Saldo Anda',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Text(
            'Rp ${_formatCurrency(widget.user.depositBalance)}',
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Tersedia untuk ditarik',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          SizedBox(height: 8),
          Text(
            'Total ditarik: Rp ${_formatCurrency(_totalWithdrawn)}',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Diperbarui: ${DateTime.now().toString().substring(0, 16)}',
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Aksi Cepat',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        SizedBox(height: 15),
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                'Tarik Saldo',
                Icons.money,
                Colors.green[600]!,
                _showWithdrawDialog,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _buildActionButton(
                'Riwayat Lengkap',
                Icons.history,
                Colors.blue[600]!,
                () => _showMessage('Fitur dalam pengembangan'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
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
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionHistory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Riwayat Transaksi',
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
          child: _transactions.isEmpty
              ? Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Tidak ada riwayat transaksi',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                )
              : Column(
                  children: _transactions.asMap().entries.map((entry) {
                    final transaction = entry.value;
                    final isLast = entry.key == _transactions.length - 1;
                    return Column(
                      children: [
                        _buildTransactionItem(transaction),
                        if (!isLast) Divider(height: 1),
                      ],
                    );
                  }).toList(),
                ),
        ),
      ],
    );
  }

  Widget _buildTransactionItem(Map<String, Object> transaction) {
    bool isDeposit = transaction['type'] == 'deposit';
    Color color = isDeposit ? Colors.green : Colors.orange;
    IconData icon = isDeposit ? Icons.add : Icons.remove;
    String sign = isDeposit ? '+' : '-';
    DateTime date = transaction['date'] as DateTime;

    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(
        transaction['description'] as String,
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
      ),
      subtitle: Text(
        date.toString().substring(0, 16),
        style: TextStyle(color: Colors.grey[600], fontSize: 12),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '$sign Rp ${_formatCurrency(transaction['amount'] as double)}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: color,
            ),
          ),
          SizedBox(height: 2),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              'Selesai',
              style: TextStyle(
                color: Colors.green[600],
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
