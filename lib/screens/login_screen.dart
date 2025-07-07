import 'package:flutter/material.dart';
import 'register_screen.dart';
import 'customer_home_screen.dart';
import 'operator_home_screen.dart';
import '../services/api_service.dart';
import 'package:trasav/models/user.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isPasswordVisible = false;
  String? _errorMessage;

  AnimationController? _animationController;
  AnimationController? _pulseController;
  Animation<double>? _fadeAnimation;
  Animation<double>? _slideAnimation;
  Animation<double>? _pulseAnimation;

  // Modern color palette
  final Color primaryGreen = Color(0xFF00C853);
  final Color secondaryGreen = Color(0xFF69F0AE);
  final Color accentGreen = Color(0xFF00E676);
  final Color darkGreen = Color(0xFF00A041);
  final Color backgroundGreen = Color(0xFFF3FFF3);
  final Color cardColor = Color(0xFFFFFFFF);
  final Color shadowColor = Color(0x1A000000);

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1200),
      vsync: this,
    );
    _pulseController = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController!, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(parent: _animationController!, curve: Curves.elasticOut),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController!, curve: Curves.easeInOut),
    );

    _animationController?.forward();
    _pulseController?.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController?.dispose();
    _pulseController?.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
      try {
        final user = await ApiService.login(
          _emailController.text,
          _passwordController.text,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Text('Login berhasil! Selamat datang ${user.name}'),
              ],
            ),
            backgroundColor: primaryGreen,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: EdgeInsets.all(16),
          ),
        );

        if (user.role == 'nasabah') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => CustomerHomeScreen(user: user),
            ),
          );
        } else if (user.role == 'operator') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => OperatorHomeScreen(user: user),
            ),
          );
        }
      } catch (e) {
        setState(() {
          _errorMessage = e.toString();
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;

    return Scaffold(
      backgroundColor: backgroundGreen,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      // Animated Header
                      AnimatedBuilder(
                        animation:
                            _fadeAnimation ?? AlwaysStoppedAnimation(1.0),
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(0, _slideAnimation?.value ?? 0.0),
                            child: Opacity(
                              opacity: _fadeAnimation?.value ?? 1.0,
                              child: _buildHeader(screenSize),
                            ),
                          );
                        },
                      ),

                      // Form Container
                      Expanded(
                        child: AnimatedBuilder(
                          animation:
                              _fadeAnimation ?? AlwaysStoppedAnimation(1.0),
                          builder: (context, child) {
                            return Transform.translate(
                              offset: Offset(
                                0,
                                (_slideAnimation?.value ?? 0.0) * 2,
                              ),
                              child: Opacity(
                                opacity: _fadeAnimation?.value ?? 1.0,
                                child: _buildFormContainer(
                                  screenSize,
                                  isSmallScreen,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(Size screenSize) {
    return Container(
      width: double.infinity,
      height: screenSize.height * 0.35,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryGreen, accentGreen, secondaryGreen],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0.0, 0.6, 1.0],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
        boxShadow: [
          BoxShadow(
            color: primaryGreen.withOpacity(0.3),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Animated Logo
          AnimatedBuilder(
            animation: _pulseAnimation ?? AlwaysStoppedAnimation(1.0),
            builder: (context, child) {
              return Transform.scale(
                scale: _pulseAnimation?.value ?? 1.0,
                child: Container(
                  padding: EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.2),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Icon(Icons.recycling, size: 70, color: Colors.white),
                ),
              );
            },
          ),
          SizedBox(height: 24),

          // App Title with Glow Effect
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: Colors.white.withOpacity(0.3)),
            ),
            child: Text(
              'TraSav',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 2,
                shadows: [
                  Shadow(blurRadius: 10, color: Colors.white.withOpacity(0.5)),
                ],
              ),
            ),
          ),
          SizedBox(height: 12),

          // Subtitle
          Text(
            'Bank Sampah Digital',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white.withOpacity(0.9),
              fontWeight: FontWeight.w500,
              letterSpacing: 1,
            ),
          ),
          SizedBox(height: 8),

          // Description
          Text(
            'Mengelola sampah dengan teknologi modern',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.7),
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormContainer(Size screenSize, bool isSmallScreen) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 16 : 32,
        vertical: 16,
      ),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: 20,
            offset: Offset(0, 10),
            spreadRadius: 5,
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(isSmallScreen ? 20 : 32),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Text
              Text(
                'Selamat Datang Kembali!',
                style: TextStyle(
                  fontSize: isSmallScreen ? 26 : 30,
                  fontWeight: FontWeight.bold,
                  color: darkGreen,
                  letterSpacing: 0.5,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Masuk ke akun Anda untuk melanjutkan journey ramah lingkungan',
                style: TextStyle(
                  fontSize: isSmallScreen ? 14 : 16,
                  color: Colors.grey[600],
                  height: 1.4,
                ),
              ),
              SizedBox(height: 32),

              // Email Field
              _buildModernTextField(
                controller: _emailController,
                labelText: 'Email Address',
                hintText: 'Masukkan email Anda',
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email tidak boleh kosong';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Masukkan email yang valid';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              // Password Field
              _buildModernPasswordField(),
              SizedBox(height: 16),

              // Forgot Password
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            Icon(Icons.info_outline, color: Colors.white),
                            SizedBox(width: 8),
                            Text('Fitur lupa password akan segera hadir'),
                          ],
                        ),
                        backgroundColor: primaryGreen,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        margin: EdgeInsets.all(16),
                      ),
                    );
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Lupa Password?',
                    style: TextStyle(
                      color: primaryGreen,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),

              // Error Message
              if (_errorMessage != null) ...[
                SizedBox(height: 16),
                _buildErrorContainer(),
              ],

              SizedBox(height: 24),

              // Login Button
              _buildLoginButton(isSmallScreen),
              SizedBox(height: 24),

              // Divider
              Row(
                children: [
                  Expanded(child: Divider(color: Colors.grey[300])),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'atau',
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                  ),
                  Expanded(child: Divider(color: Colors.grey[300])),
                ],
              ),
              SizedBox(height: 24),

              // Register Link
              Center(
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Belum punya akun? ',
                        style: TextStyle(color: Colors.grey[600], fontSize: 16),
                      ),
                      WidgetSpan(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RegisterScreen(),
                              ),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: primaryGreen.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Daftar Sekarang',
                              style: TextStyle(
                                color: primaryGreen,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModernTextField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    required IconData prefixIcon,
    TextInputType? keyboardType,
    required String? Function(String?) validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: darkGreen,
          ),
        ),
        SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          style: TextStyle(fontSize: 16),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey[400]),
            prefixIcon: Container(
              margin: EdgeInsets.all(8),
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: primaryGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(prefixIcon, color: primaryGreen, size: 20),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: primaryGreen, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.red, width: 2),
            ),
            filled: true,
            fillColor: Colors.grey[50],
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
          validator: validator,
        ),
      ],
    );
  }

  Widget _buildModernPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Password',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: darkGreen,
          ),
        ),
        SizedBox(height: 8),
        TextFormField(
          controller: _passwordController,
          obscureText: !_isPasswordVisible,
          style: TextStyle(fontSize: 16),
          decoration: InputDecoration(
            hintText: 'Masukkan password Anda',
            hintStyle: TextStyle(color: Colors.grey[400]),
            prefixIcon: Container(
              margin: EdgeInsets.all(8),
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: primaryGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.lock_outline, color: primaryGreen, size: 20),
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _isPasswordVisible
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: primaryGreen,
              ),
              onPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: primaryGreen, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.red, width: 2),
            ),
            filled: true,
            fillColor: Colors.grey[50],
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Password tidak boleh kosong';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildErrorContainer() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red[200]!),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red, size: 24),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              _errorMessage!,
              style: TextStyle(
                color: Colors.red[700],
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginButton(bool isSmallScreen) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: _isLoading
          ? Container(
              decoration: BoxDecoration(
                color: primaryGreen.withOpacity(0.7),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    strokeWidth: 2,
                  ),
                ),
              ),
            )
          : ElevatedButton(
              onPressed: _login,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryGreen,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.login, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Masuk',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
