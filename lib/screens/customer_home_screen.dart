import 'package:flutter/material.dart';
import 'package:trasav/screens/notification_nasabah_page.dart';
import '../models/user.dart';
import 'home_page.dart';
import 'setor_sampah_page.dart';
import 'riwayat_page.dart';
import 'saldo_page.dart';

class CustomerHomeScreen extends StatefulWidget {
  final User user;

  CustomerHomeScreen({required this.user});

  @override
  _CustomerHomeScreenState createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  int _selectedIndex = 0;

  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();

    // Initialize pages
    _pages = [
      HomePage(user: widget.user),
      SetorSampahPage(user: widget.user),
      RiwayatPage(user: widget.user),
      SaldoPage(user: widget.user),
    ];
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Fungsi logout
  void _logout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi Logout'),
          content: Text('Apakah Anda yakin ingin keluar?'),
          actions: [
            TextButton(
              child: Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Keluar'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(
                  context,
                ).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(),
      drawer: _buildSidebar(),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: _pages[_selectedIndex],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
      floatingActionButton: _selectedIndex == 0
          ? _buildFloatingActionButton()
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  AppBar _buildAppBar() {
    List<String> titles = ['Bank Sampah', 'Setor Sampah', 'Riwayat', 'Saldo'];

    return AppBar(
      elevation: 0,
      backgroundColor: Colors.green[600],
      title: Row(
        children: [
          Icon(Icons.eco, color: Colors.white),
          SizedBox(width: 8),
          Text(
            titles[_selectedIndex],
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.notifications_none, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    NotificationNasabahPage(user: widget.user),
              ),
            );
          },
        ),
        CircleAvatar(
          radius: 18,
          backgroundColor: Colors.white,
          child: Text(
            widget.user.name.isNotEmpty
                ? widget.user.name[0].toUpperCase()
                : 'U',
            style: TextStyle(
              color: Colors.green[600],
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(width: 16),
      ],
      leading: IconButton(
        icon: Icon(Icons.menu, color: Colors.white),
        onPressed: () => _scaffoldKey.currentState?.openDrawer(),
      ),
    );
  }

  Widget _buildSidebar() {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.green[600]!, Colors.green[400]!],
          ),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.transparent),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Text(
                      widget.user.name.isNotEmpty
                          ? widget.user.name[0].toUpperCase()
                          : 'U',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[600],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Halo, ${widget.user.name}!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Selamat datang kembali',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
            _buildDrawerItem(Icons.dashboard, 'Home', 0),
            _buildDrawerItem(Icons.recycling, 'Setor Sampah', 1),
            _buildDrawerItem(Icons.history, 'Riwayat Setoran', 2),
            _buildDrawerItem(Icons.account_balance_wallet, 'Saldo', 3),
            Divider(color: Colors.white30),
            _buildDrawerItem(Icons.logout, 'Keluar', 8, isLogout: true),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
    IconData icon,
    String title,
    int index, {
    bool isLogout = false,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: TextStyle(color: Colors.white, fontSize: 16)),
      onTap: () {
        Navigator.pop(context);
        if (isLogout) {
          _logout();
        } else {
          setState(() {
            _selectedIndex = index;
          });
        }
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.green[600],
        unselectedItemColor: Colors.grey[500],
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.recycling), label: 'Setor'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Riwayat'),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Saldo',
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        setState(() {
          _selectedIndex = 1; // Navigate to Setor Sampah page
        });
      },
      backgroundColor: Colors.green[600],
      child: Icon(Icons.add, color: Colors.white, size: 28),
      elevation: 8,
    );
  }
}
