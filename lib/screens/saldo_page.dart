import 'package:flutter/material.dart';
import '../models/user.dart';

class SaldoPage extends StatefulWidget {
  final User user;

  SaldoPage({required this.user});

  @override
  _SaldoPageState createState() => _SaldoPageState();
}

class _SaldoPageState extends State<SaldoPage> {
  final TextEditingController _withdrawController = TextEditingController();
  double currentBalance = 125000.0; // Saldo saat ini

  // Data dummy untuk riwayat transaksi saldo
  final List<Map<String, dynamic>> _transactions = [
    {
      'type': 'deposit',
      'amount': 25000.0,
      'description': 'Setor sampah plastik 2 kg',
      'date': '2024-01-07 14:30',
      'status': 'completed',
    },
    {
      'type': 'withdrawal',
      'amount': 50000.0,
      'description': 'Penarikan saldo ke rekening',
      'date': '2024-01-06 10:15',
      'status': 'completed',
    },
    {
      'type': 'deposit',
      'amount': 30000.0,
      'description': 'Setor sampah kertas 3 kg',
      'date': '2024-01-05 16:45',
      'status': 'completed',
    },
    {
      'type': 'deposit',
      'amount': 15000.0,
      'description': 'Setor sampah logam 1.5 kg',
      'date': '2024-01-04 11:20',
      'status': 'completed',
    },
    {
      'type': 'withdrawal',
      'amount': 75000.0,
      'description': 'Penarikan saldo ke e-wallet',
      'date': '2024-01-03 09:30',
      'status': 'completed',
    },
  ];

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
              Text('Saldo tersedia: Rp ${_formatCurrency(currentBalance)}'),
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
                'Minimal penarikan: Rp 50.000',
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

  void _processWithdraw() {
    if (_withdrawController.text.isEmpty) {
      _showMessage('Masukkan jumlah penarikan');
      return;
    }

    double amount =
        double.tryParse(_withdrawController.text.replaceAll(',', '')) ?? 0;

    if (amount < 50000) {
      _showMessage('Minimal penarikan Rp 50.000');
      return;
    }

    if (amount > currentBalance) {
      _showMessage('Saldo tidak mencukupi');
      return;
    }

    setState(() {
      currentBalance -= amount;
      _transactions.insert(0, {
        'type': 'withdrawal',
        'amount': amount,
        'description': 'Penarikan saldo ke rekening',
        'date': DateTime.now().toString().substring(0, 16),
        'status': 'completed',
      });
    });

    Navigator.of(context).pop();
    _withdrawController.clear();
    _showMessage('Penarikan berhasil diproses');
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
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
    return SingleChildScrollView(
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
            'Rp ${_formatCurrency(currentBalance)}',
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
          child: Column(
            children: _transactions.map((transaction) {
              return Column(
                children: [
                  _buildTransactionItem(transaction),
                  if (transaction != _transactions.last) Divider(height: 1),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionItem(Map<String, dynamic> transaction) {
    bool isDeposit = transaction['type'] == 'deposit';
    Color color = isDeposit ? Colors.green : Colors.orange;
    IconData icon = isDeposit ? Icons.add : Icons.remove;
    String sign = isDeposit ? '+' : '-';

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
        transaction['description'],
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
      ),
      subtitle: Text(
        transaction['date'],
        style: TextStyle(color: Colors.grey[600], fontSize: 12),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '$sign Rp ${_formatCurrency(transaction['amount'])}',
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
