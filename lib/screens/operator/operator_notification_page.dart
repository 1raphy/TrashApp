import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trasav/models/notification.dart';
import 'package:trasav/models/user.dart';
import 'package:trasav/services/operator_notification_service.dart';

class OperatorNotificationPage extends StatefulWidget {
  final User user;

  OperatorNotificationPage({required this.user});

  @override
  _OperatorNotificationPageState createState() =>
      _OperatorNotificationPageState();
}

class _OperatorNotificationPageState extends State<OperatorNotificationPage> {
  final OperatorNotificationService _notificationService =
      OperatorNotificationService();
  List<NotificationModel> notifications = [];
  bool isLoading = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  Future<void> _fetchNotifications() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    try {
      final fetchedNotifications = await _notificationService
          .getOperatorNotifications();
      setState(() {
        notifications = fetchedNotifications;
        isLoading = false;
      });
      print('Operator notifications fetched: ${notifications.length}');
    } catch (e) {
      setState(() {
        errorMessage = 'Gagal memuat notifikasi: $e';
        isLoading = false;
      });
      print('Error fetching operator notifications: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage!),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.fixed,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.green[600],
        title: Row(
          children: [
            Icon(Icons.notifications, color: Colors.white),
            SizedBox(width: 8),
            Text(
              'Notifikasi Operator',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage != null
          ? Center(
              child: Text(errorMessage!, style: TextStyle(color: Colors.red)),
            )
          : notifications.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_off,
                    size: 60,
                    color: Colors.grey[400],
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Belum ada notifikasi',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: _fetchNotifications,
              child: ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final notification = notifications[index];
                  return _buildNotificationCard(notification);
                },
              ),
            ),
    );
  }

  Widget _buildNotificationCard(NotificationModel notification) {
    IconData icon;
    Color statusColor;
    String title;

    switch (notification.type) {
      case 'registrasi':
        icon = Icons.person_add;
        statusColor = Colors.blue;
        title = 'Registrasi Nasabah #${notification.userId}';
        break;
      case 'setoran':
        icon = notification.status == 'disetujui'
            ? Icons.check_circle
            : Icons.cancel;
        statusColor = notification.status == 'disetujui'
            ? Colors.green
            : Colors.red;
        title =
            'Setoran #${notification.setoranSampahId} ${notification.status == 'disetujui'
                ? 'Disetujui'
                : notification.status == 'ditolak'
                ? 'Ditolak'
                : 'Pending'}';
        break;
      case 'penarikan':
        icon = Icons.monetization_on;
        statusColor = Colors.orange;
        title = 'Penarikan #${notification.penarikanSaldoId}';
        break;
      default:
        icon = Icons.notifications;
        statusColor = Colors.grey;
        title = 'Notifikasi #${notification.id}';
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
            color: statusColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: statusColor, size: 24),
        ),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8),
            Text(
              notification.message,
              style: TextStyle(color: Colors.grey[600]),
            ),
            SizedBox(height: 4),
            Text(
              DateFormat('yyyy-MM-dd HH:mm').format(notification.createdAt),
              style: TextStyle(color: Colors.grey[500], fontSize: 12),
            ),
          ],
        ),
        onTap: () {
          _showNotificationDetail(notification);
        },
      ),
    );
  }

  void _showNotificationDetail(NotificationModel notification) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Detail Notifikasi'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID Notifikasi: ${notification.id}'),
            Text('Tipe: ${notification.type.capitalize()}'),
            Text('Status: ${notification.status.capitalize()}'),
            Text('Pesan: ${notification.message}'),
            if (notification.user != null) ...[
              Divider(),
              Text('Nasabah:'),
              Text('Nama: ${notification.user!.name}'),
              Text('Email: ${notification.user!.email}'),
            ],
            if (notification.setoranSampah != null) ...[
              Divider(),
              Text('Detail Setoran:'),
              Text('ID Setoran: ${notification.setoranSampah!.id}'),
              Text(
                'Jenis Sampah: ${notification.setoranSampah!.jenisSampah?.namaSampah ?? 'Unknown'}',
              ),
              Text(
                'Berat: ${notification.setoranSampah!.beratKg.toStringAsFixed(1)} kg',
              ),
              Text(
                'Total Harga: Rp ${notification.setoranSampah!.totalHarga.toStringAsFixed(0)}',
              ),
              Text(
                'Metode Penjemputan: ${notification.setoranSampah!.metodePenjemputan}',
              ),
              if (notification.setoranSampah!.alamatPenjemputan != null)
                Text(
                  'Alamat: ${notification.setoranSampah!.alamatPenjemputan}',
                ),
              if (notification.setoranSampah!.catatanTambahan != null)
                Text('Catatan: ${notification.setoranSampah!.catatanTambahan}'),
            ],
            if (notification.penarikanSaldo != null) ...[
              Divider(),
              Text('Detail Penarikan:'),
              Text('ID Penarikan: ${notification.penarikanSaldo!.id}'),
              Text(
                'Jumlah: Rp ${notification.penarikanSaldo!.jumlah.toStringAsFixed(0)}',
              ),
              // Text('Status: ${notification.penarikanSaldo!.status?.capitalize() ?? 'Unknown'}'),
            ],
            Text(
              'Tanggal: ${DateFormat('yyyy-MM-dd HH:mm').format(notification.createdAt)}',
            ),
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

// Ekstensi untuk mengkapitalisasi string
extension StringExtension on String {
  String capitalize() {
    return isNotEmpty ? this[0].toUpperCase() + substring(1) : this;
  }
}
