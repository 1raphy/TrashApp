// import 'package:flutter/material.dart';
// import '../models/user.dart';

// class OperatorHomeScreen extends StatefulWidget {
//   final User user;

//   OperatorHomeScreen({required this.user});

//   @override
//   _OperatorHomeScreenState createState() => _OperatorHomeScreenState();
// }

// class _OperatorHomeScreenState extends State<OperatorHomeScreen>
//     with TickerProviderStateMixin {
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//   late AnimationController _animationController;
//   late Animation<double> _fadeAnimation;
//   int _selectedIndex = 0;

//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       duration: Duration(milliseconds: 1000),
//       vsync: this,
//     );
//     _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
//     );
//     _animationController.forward();
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }

//   // Fungsi logout
//   void _logout() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Konfirmasi Logout'),
//           content: Text('Apakah Anda yakin ingin keluar?'),
//           actions: [
//             TextButton(
//               child: Text('Batal'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//             TextButton(
//               child: Text('Keluar'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 // Kembali ke halaman login atau landing page
//                 Navigator.of(context).pushNamedAndRemoveUntil(
//                   '/', // atau route login Anda
//                   (Route<dynamic> route) => false,
//                 );
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: _scaffoldKey,
//       backgroundColor: Colors.grey[50],
//       appBar: _buildAppBar(),
//       drawer: _buildSidebar(),
//       body: FadeTransition(opacity: _fadeAnimation, child: _buildBody()),
//       bottomNavigationBar: _buildBottomNavigationBar(),
//       floatingActionButton: _buildFloatingActionButton(),
//     );
//   }

//   AppBar _buildAppBar() {
//     return AppBar(
//       elevation: 0,
//       backgroundColor: Colors.green[600],
//       title: Row(
//         children: [
//           Icon(Icons.eco, color: Colors.white),
//           SizedBox(width: 8),
//           Text(
//             'Bank Sampah',
//             style: TextStyle(
//               color: Colors.white,
//               fontWeight: FontWeight.bold,
//               fontSize: 20,
//             ),
//           ),
//         ],
//       ),
//       actions: [
//         IconButton(
//           icon: Icon(Icons.notifications_none, color: Colors.white),
//           onPressed: () {},
//         ),
//         CircleAvatar(
//           radius: 18,
//           backgroundColor: Colors.white,
//           child: Text(
//             widget.user.name.isNotEmpty
//                 ? widget.user.name[0].toUpperCase()
//                 : 'U',
//             style: TextStyle(
//               color: Colors.green[600],
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//         SizedBox(width: 16),
//       ],
//       leading: IconButton(
//         icon: Icon(Icons.menu, color: Colors.white),
//         onPressed: () => _scaffoldKey.currentState?.openDrawer(),
//       ),
//     );
//   }

//   Widget _buildSidebar() {
//     return Drawer(
//       child: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [Colors.green[600]!, Colors.green[400]!],
//           ),
//         ),
//         child: ListView(
//           padding: EdgeInsets.zero,
//           children: [
//             DrawerHeader(
//               decoration: BoxDecoration(color: Colors.transparent),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   CircleAvatar(
//                     radius: 30,
//                     backgroundColor: Colors.white,
//                     child: Text(
//                       widget.user.name.isNotEmpty
//                           ? widget.user.name[0].toUpperCase()
//                           : 'U',
//                       style: TextStyle(
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.green[600],
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 10),
//                   Text(
//                     'Halo, ${widget.user.name}!',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   Text(
//                     'Selamat datang kembali',
//                     style: TextStyle(color: Colors.white70, fontSize: 14),
//                   ),
//                 ],
//               ),
//             ),
//             _buildDrawerItem(Icons.dashboard, 'Dashboard', 0),
//             _buildDrawerItem(Icons.recycling, 'Setor Sampah', 1),
//             _buildDrawerItem(Icons.account_balance_wallet, 'Saldo', 2),
//             _buildDrawerItem(Icons.history, 'Riwayat', 3),
//             Divider(color: Colors.white30),
//             _buildDrawerItem(Icons.logout, 'Keluar', 8, isLogout: true),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildDrawerItem(
//     IconData icon,
//     String title,
//     int index, {
//     bool isLogout = false,
//   }) {
//     return ListTile(
//       leading: Icon(icon, color: Colors.white),
//       title: Text(title, style: TextStyle(color: Colors.white, fontSize: 16)),
//       onTap: () {
//         Navigator.pop(context);
//         if (isLogout) {
//           _logout();
//         } else {
//           // Handle navigation untuk item lainnya
//           setState(() {
//             _selectedIndex = index;
//           });
//         }
//       },
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//       contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
//     );
//   }

//   Widget _buildBody() {
//     return SingleChildScrollView(
//       padding: EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildWelcomeCard(),
//           SizedBox(height: 20),
//           _buildQuickActions(),
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
//                   'Selamat Datang, ${widget.user.name}!',
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
//             'Mari bersama menjaga lingkungan dengan mendaur ulang sampah',
//             style: TextStyle(color: Colors.white70, fontSize: 14),
//           ),
//           SizedBox(height: 10),
//           Text(
//             'Email: ${widget.user.email}',
//             style: TextStyle(color: Colors.white70, fontSize: 12),
//           ),
//           Text(
//             'Telepon: ${widget.user.phone}',
//             style: TextStyle(color: Colors.white70, fontSize: 12),
//           ),
//           SizedBox(height: 15),
//           Row(
//             children: [
//               Icon(Icons.account_balance_wallet, color: Colors.white, size: 20),
//               SizedBox(width: 8),
//               Text(
//                 'Saldo Anda: Rp 125.000',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 16,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildQuickActions() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Aksi Cepat',
//           style: TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//             color: Colors.grey[800],
//           ),
//         ),
//         SizedBox(height: 15),
//         Row(
//           children: [
//             Expanded(
//               child: _buildActionCard(
//                 'Setor Sampah',
//                 Icons.recycling,
//                 Colors.green[500]!,
//               ),
//             ),
//             SizedBox(width: 10),
//             Expanded(
//               child: _buildActionCard(
//                 'Tarik Saldo',
//                 Icons.money,
//                 Colors.blue[500]!,
//               ),
//             ),
//           ],
//         ),
//         SizedBox(height: 10),
//       ],
//     );
//   }

//   Widget _buildActionCard(String title, IconData icon, Color color) {
//     return GestureDetector(
//       onTap: () {
//         // Handle action card tap
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(SnackBar(content: Text('$title dipilih')));
//       },
//       child: Container(
//         padding: EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(15),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.1),
//               blurRadius: 10,
//               offset: Offset(0, 2),
//             ),
//           ],
//         ),
//         child: Column(
//           children: [
//             Container(
//               padding: EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: color.withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Icon(icon, color: color, size: 24),
//             ),
//             SizedBox(height: 8),
//             Text(
//               title,
//               style: TextStyle(
//                 fontSize: 12,
//                 fontWeight: FontWeight.w600,
//                 color: Colors.grey[700],
//               ),
//               textAlign: TextAlign.center,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildStatsCards() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Statistik Bulan Ini',
//           style: TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//             color: Colors.grey[800],
//           ),
//         ),
//         SizedBox(height: 15),
//         Row(
//           children: [
//             Expanded(
//               child: _buildStatCard(
//                 '15 kg',
//                 'Sampah Disetor',
//                 Icons.eco,
//                 Colors.green,
//               ),
//             ),
//             SizedBox(width: 10),
//             Expanded(
//               child: _buildStatCard(
//                 'Rp. 250.000',
//                 'Saldo Ditarik',
//                 Icons.money,
//                 Colors.amber,
//               ),
//             ),
//           ],
//         ),
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
//         Container(
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(15),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.grey.withOpacity(0.1),
//                 blurRadius: 10,
//                 offset: Offset(0, 2),
//               ),
//             ],
//           ),
//           child: Column(
//             children: [
//               _buildActivityItem(
//                 'Setor sampah plastik',
//                 '2 kg',
//                 '2 jam lalu',
//                 Icons.recycling,
//                 Colors.green,
//               ),
//               Divider(height: 1),
//               _buildActivityItem(
//                 'Saldo Ditarik',
//                 'Rp. 100.000',
//                 '1 hari lalu',
//                 Icons.money,
//                 Colors.orange,
//               ),
//               Divider(height: 1),
//               _buildActivityItem(
//                 'Setor sampah kertas',
//                 '3 kg',
//                 '3 hari lalu',
//                 Icons.description,
//                 Colors.blue,
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildActivityItem(
//     String title,
//     String subtitle,
//     String time,
//     IconData icon,
//     Color color,
//   ) {
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

//   Widget _buildBottomNavigationBar() {
//     return Container(
//       decoration: BoxDecoration(
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.2),
//             blurRadius: 10,
//             offset: Offset(0, -2),
//           ),
//         ],
//       ),
//       child: BottomNavigationBar(
//         currentIndex: _selectedIndex,
//         onTap: (index) {
//           setState(() {
//             _selectedIndex = index;
//           });
//         },
//         type: BottomNavigationBarType.fixed,
//         backgroundColor: Colors.white,
//         selectedItemColor: Colors.green[600],
//         unselectedItemColor: Colors.grey[500],
//         items: [
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
//           BottomNavigationBarItem(icon: Icon(Icons.recycling), label: 'Setor'),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.account_balance_wallet),
//             label: 'Saldo',
//           ),
//           BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Riwayat'),
//           BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
//         ],
//       ),
//     );
//   }

//   Widget _buildFloatingActionButton() {
//     return FloatingActionButton(
//       onPressed: () {
//         // Navigate to setor sampah
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(SnackBar(content: Text('Fitur Setor Sampah')));
//       },
//       backgroundColor: Colors.green[600],
//       child: Icon(Icons.add, color: Colors.white, size: 28),
//       elevation: 8,
//     );
//   }
// }
