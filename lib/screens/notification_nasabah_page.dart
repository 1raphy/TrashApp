import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trasav/models/notification.dart';
import 'package:trasav/models/user.dart';
import 'package:trasav/services/notification_service.dart';

class NotificationNasabahPage extends StatefulWidget {
  final User user;

  NotificationNasabahPage({required this.user});

  @override
  _NotificationNasabahPageState createState() =>
      _NotificationNasabahPageState();
}

class _NotificationNasabahPageState extends State<NotificationNasabahPage> {
  final NotificationService _notificationService = NotificationService();
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
      final fetchedNotifications = await _notificationService.getNotifications(
        userId: widget.user.id,
      );
      setState(() {
        notifications = fetchedNotifications;
        isLoading = false;
      });
      print('Notifications fetched: ${notifications.length}');
    } catch (e) {
      setState(() {
        errorMessage = 'Gagal memuat notifikasi: $e';
        isLoading = false;
      });
      print('Error fetching notifications: $e');
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
              'Notifikasi',
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
    final isApproved = notification.status == 'disetujui';
    final statusColor = isApproved ? Colors.green : Colors.red;
    final statusIcon = isApproved ? Icons.check_circle : Icons.cancel;
    final statusText = isApproved ? 'Disetujui' : 'Ditolak';

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
          child: Icon(statusIcon, color: statusColor, size: 24),
        ),
        title: Text(
          'Setoran #$notification.setoranSampahId $statusText',
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
    final isApproved = notification.status == 'disetujui';
    final setoran = notification.setoranSampah;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Detail Notifikasi'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID Notifikasi: ${notification.id}'),
            Text('Status: ${isApproved ? 'Disetujui' : 'Ditolak'}'),
            Text('Pesan: ${notification.message}'),
            if (setoran != null) ...[
              Divider(),
              Text('Detail Setoran:'),
              Text('ID Setoran: ${setoran.id}'),
              Text(
                'Jenis Sampah: ${setoran.jenisSampah?.namaSampah ?? 'Unknown'}',
              ),
              Text('Berat: ${setoran.beratKg.toStringAsFixed(1)} kg'),
              Text('Total Harga: Rp ${setoran.totalHarga.toStringAsFixed(0)}'),
              Text('Metode Penjemputan: ${setoran.metodePenjemputan}'),
              if (setoran.alamatPenjemputan != null)
                Text('Alamat: ${setoran.alamatPenjemputan}'),
              if (setoran.catatanTambahan != null)
                Text('Catatan: ${setoran.catatanTambahan}'),
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
