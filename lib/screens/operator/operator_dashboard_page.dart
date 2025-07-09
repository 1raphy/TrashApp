import 'package:flutter/material.dart';
import '../../models/user.dart';

class OperatorDashboardPage extends StatefulWidget {
  final User user;

  OperatorDashboardPage({required this.user});

  @override
  _OperatorDashboardPageState createState() => _OperatorDashboardPageState();
}

class _OperatorDashboardPageState extends State<OperatorDashboardPage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildWelcomeCard(),
          SizedBox(height: 20),
          _buildQuickActions(),
          SizedBox(height: 20),
          _buildStatsCards(),
          SizedBox(height: 20),
          _buildRecentActivity(),
        ],
      ),
    );
  }

  Widget _buildWelcomeCard() {
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
              Icon(Icons.eco, color: Colors.white, size: 30),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Dashboard',
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
            'Selamat datang, ${widget.user.name}!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 5),
          Text(
            'Kelola data bank sampah dengan mudah',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          SizedBox(height: 15),
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.white, size: 18),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Sistem operasional normal',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
              ],
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
              child: _buildActionCard(
                'Tambah Kategori',
                Icons.add_circle_outline,
                Colors.green[500]!,
                () => _showAddCategoryDialog(),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: _buildActionCard(
                'Verifikasi Setoran',
                Icons.check_circle_outline,
                Colors.blue[500]!,
                () => _showVerifyDialog(),
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                'Proses Penarikan',
                Icons.money_off,
                Colors.orange[500]!,
                () => _showProcessWithdrawalDialog(),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: _buildActionCard(
                'Laporan Harian',
                Icons.assessment,
                Colors.purple[500]!,
                () => _showDailyReportDialog(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(
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
                fontSize: 12,
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

  Widget _buildStatsCards() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Statistik Hari Ini',
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
              child: _buildStatCard(
                '23',
                'Setoran Baru',
                Icons.recycling,
                Colors.green,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: _buildStatCard(
                '8',
                'Penarikan Pending',
                Icons.money_off,
                Colors.orange,
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                '145',
                'Total Nasabah',
                Icons.people,
                Colors.blue,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: _buildStatCard(
                '12',
                'Kategori Sampah',
                Icons.category,
                Colors.purple,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String value,
    String label,
    IconData icon,
    Color color,
  ) {
    return Container(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildRecentActivity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Aktivitas Terbaru',
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
              _buildActivityItem(
                'Setoran plastik - Budi Santoso',
                '2.5 kg • Rp 7.500',
                '5 menit lalu',
                Icons.recycling,
                Colors.green,
              ),
              Divider(height: 1),
              _buildActivityItem(
                'Penarikan saldo - Siti Aminah',
                'Rp 150.000',
                '15 menit lalu',
                Icons.money_off,
                Colors.orange,
              ),
              Divider(height: 1),
              _buildActivityItem(
                'Kategori baru ditambahkan',
                'Kardus bekas',
                '1 jam lalu',
                Icons.add_circle,
                Colors.blue,
              ),
              Divider(height: 1),
              _buildActivityItem(
                'Nasabah baru terdaftar',
                'Ahmad Wijaya',
                '2 jam lalu',
                Icons.person_add,
                Colors.purple,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActivityItem(
    String title,
    String subtitle,
    String time,
    IconData icon,
    Color color,
  ) {
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
        title,
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
      ),
      subtitle: Text(subtitle),
      trailing: Text(
        time,
        style: TextStyle(color: Colors.grey[500], fontSize: 12),
      ),
    );
  }

  void _showAddCategoryDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Tambah Kategori Sampah'),
        content: Text(
          'Fitur tambah kategori sampah akan membuka halaman kategori.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showVerifyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Verifikasi Setoran'),
        content: Text('Menampilkan daftar setoran yang perlu diverifikasi.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showProcessWithdrawalDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Proses Penarikan'),
        content: Text('Menampilkan daftar penarikan yang perlu diproses.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showDailyReportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Laporan Harian'),
        content: Text('Menampilkan laporan aktivitas harian.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../models/user.dart';
// import '../../services/operator_notification_service.dart';
// import '../../models/notification.dart';

// class OperatorDashboardPage extends StatefulWidget {
//   final User user;

//   OperatorDashboardPage({required this.user});

//   @override
//   _OperatorDashboardPageState createState() => _OperatorDashboardPageState();
// }

// class _OperatorDashboardPageState extends State<OperatorDashboardPage> {
//   Map<String, dynamic>? _stats;
//   List<NotificationModel> _notifications = [];
//   bool _isLoadingStats = true;
//   bool _isLoadingNotifications = true;
//   String? _errorMessage;

//   @override
//   void initState() {
//     super.initState();
//     _fetchStats();
//     _fetchNotifications();
//   }

//   Future<void> _fetchStats() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final token = prefs.getString('auth_token') ?? '';
//       final response = await http.get(
//         Uri.parse('http://10.0.2.2:8000/api/operator-stats'),
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Accept': 'application/json',
//         },
//       );

//       if (response.statusCode == 200) {
//         setState(() {
//           _stats = jsonDecode(response.body);
//           _isLoadingStats = false;
//         });
//       } else {
//         setState(() {
//           _errorMessage = 'Gagal memuat statistik: ${response.body}';
//           _isLoadingStats = false;
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _errorMessage = 'Error memuat statistik: $e';
//         _isLoadingStats = false;
//       });
//     }
//   }

//   Future<void> _fetchNotifications() async {
//     try {
//       final service = OperatorNotificationService();
//       final notifications = await service.getOperatorNotifications();
//       setState(() {
//         _notifications = notifications;
//         _isLoadingNotifications = false;
//       });
//     } catch (e) {
//       setState(() {
//         _errorMessage = 'Error memuat notifikasi: $e';
//         _isLoadingNotifications = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       padding: EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildWelcomeCard(),
//           SizedBox(height: 20),
//           _buildStatsCards(),
//           SizedBox(height: 20),
//           _buildRecentActivity(),
//         ],
//       ),
//     );
//   }

//   Widget _buildWelcomeCard() {
//     return Container(
//       width: double.infinity,
//       padding: EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [Colors.green[400]!, Colors.green[600]!],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.green.withOpacity(0.3),
//             blurRadius: 10,
//             offset: Offset(0, 5),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Icon(Icons.eco, color: Colors.white, size: 30),
//               SizedBox(width: 10),
//               Expanded(
//                 child: Text(
//                   'Dashboard',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 10),
//           Text(
//             'Selamat datang, ${widget.user.name}!',
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 16,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           SizedBox(height: 5),
//           Text(
//             'Kelola data bank sampah dengan mudah',
//             style: TextStyle(color: Colors.white70, fontSize: 14),
//           ),
//           SizedBox(height: 15),
//           Container(
//             padding: EdgeInsets.all(10),
//             decoration: BoxDecoration(
//               color: Colors.white.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Row(
//               children: [
//                 Icon(Icons.info_outline, color: Colors.white, size: 18),
//                 SizedBox(width: 8),
//                 Expanded(
//                   child: Text(
//                     'Sistem operasional normal',
//                     style: TextStyle(color: Colors.white, fontSize: 14),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildStatsCards() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Statistik Hari Ini',
//           style: TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//             color: Colors.grey[800],
//           ),
//         ),
//         SizedBox(height: 15),
//         _isLoadingStats
//             ? Center(child: CircularProgressIndicator())
//             : _errorMessage != null
//             ? Text(_errorMessage!, style: TextStyle(color: Colors.red))
//             : Column(
//                 children: [
//                   Row(
//                     children: [
//                       Expanded(
//                         child: _buildStatCard(
//                           _stats?['setoran_baru']?.toString() ?? '0',
//                           'Setoran Baru',
//                           Icons.recycling,
//                           Colors.green,
//                         ),
//                       ),
//                       SizedBox(width: 10),
//                       Expanded(
//                         child: _buildStatCard(
//                           _stats?['penarikan_pending']?.toString() ?? '0',
//                           'Penarikan Pending',
//                           Icons.money_off,
//                           Colors.orange,
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 10),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: _buildStatCard(
//                           _stats?['total_nasabah']?.toString() ?? '0',
//                           'Total Nasabah',
//                           Icons.people,
//                           Colors.blue,
//                         ),
//                       ),
//                       SizedBox(width: 10),
//                       Expanded(
//                         child: _buildStatCard(
//                           _stats?['kategori_sampah']?.toString() ?? '0',
//                           'Kategori Sampah',
//                           Icons.category,
//                           Colors.purple,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//       ],
//     );
//   }

//   Widget _buildStatCard(
//     String value,
//     String label,
//     IconData icon,
//     Color color,
//   ) {
//     return Container(
//       padding: EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(15),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             blurRadius: 10,
//             offset: Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Icon(icon, color: color, size: 24),
//           SizedBox(height: 8),
//           Text(
//             value,
//             style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//               color: Colors.grey[800],
//             ),
//           ),
//           Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
//         ],
//       ),
//     );
//   }

//   Widget _buildRecentActivity() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Aktivitas Terbaru',
//           style: TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//             color: Colors.grey[800],
//           ),
//         ),
//         SizedBox(height: 15),
//         _isLoadingNotifications
//             ? Center(child: CircularProgressIndicator())
//             : _errorMessage != null
//             ? Text(_errorMessage!, style: TextStyle(color: Colors.red))
//             : Container(
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(15),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.grey.withOpacity(0.1),
//                       blurRadius: 10,
//                       offset: Offset(0, 2),
//                     ),
//                   ],
//                 ),
//                 child: _notifications.isEmpty
//                     ? ListTile(
//                         title: Text('Belum ada aktivitas'),
//                         subtitle: Text('Aktivitas akan muncul di sini'),
//                       )
//                     : Column(
//                         children: _notifications.asMap().entries.map((entry) {
//                           final notification = entry.value;
//                           return Column(
//                             children: [
//                               _buildActivityItem(notification),
//                               if (entry.key < _notifications.length - 1)
//                                 Divider(height: 1),
//                             ],
//                           );
//                         }).toList(),
//                       ),
//               ),
//       ],
//     );
//   }

//   Widget _buildActivityItem(NotificationModel notification) {
//     String title = '';
//     String subtitle = '';
//     IconData icon = Icons.notifications;
//     Color color = Colors.grey;

//     switch (notification.type) {
//       case 'registrasi':
//         title = 'Nasabah baru terdaftar';
//         subtitle = notification.user?.name ?? 'Unknown';
//         icon = Icons.person_add;
//         color = Colors.purple;
//         break;
//       case 'setoran':
//         title =
//             'Setoran ${notification.setoranSampah?.jenisSampah?.namaSampah ?? 'Sampah'}';
//         subtitle =
//             '${notification.setoranSampah?.beratKg ?? 0} kg • Rp ${notification.setoranSampah?.totalHarga ?? 0}';
//         icon = Icons.recycling;
//         color = Colors.green;
//         break;
//       case 'penarikan':
//         title = 'Penarikan saldo';
//         subtitle = 'Rp ${notification.penarikanSaldo?.jumlah ?? 0}';
//         icon = Icons.money_off;
//         color = Colors.orange;
//         break;
//       default:
//         title = 'Aktivitas tidak dikenal';
//         subtitle = notification.message;
//     }

//     // Menghitung waktu relatif
//     final createdAt =
//         notification.createdAt ?? DateTime.now(); // Fallback jika null
//     final now = DateTime.now();
//     final difference = now.difference(createdAt);
//     String time = difference.inMinutes < 60
//         ? '${difference.inMinutes} menit lalu'
//         : difference.inHours < 24
//         ? '${difference.inHours} jam lalu'
//         : '${difference.inDays} hari lalu';

//     return ListTile(
//       leading: Container(
//         padding: EdgeInsets.all(8),
//         decoration: BoxDecoration(
//           color: color.withOpacity(0.1),
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: Icon(icon, color: color, size: 20),
//       ),
//       title: Text(
//         title,
//         style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
//       ),
//       subtitle: Text(subtitle),
//       trailing: Text(
//         time,
//         style: TextStyle(color: Colors.grey[500], fontSize: 12),
//       ),
//     );
//   }
// }
