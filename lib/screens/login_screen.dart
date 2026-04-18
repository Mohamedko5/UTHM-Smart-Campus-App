import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  // ── Controllers ──────────────────────────────────────────────
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // ── State ─────────────────────────────────────────────────────
  bool _obscurePassword = true;
  bool _isLoading = false;
  bool _rememberMe = false;

  // ── Animation ─────────────────────────────────────────────────
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  // ── Colors ────────────────────────────────────────────────────
  static const Color kBlue700 = Color(0xFF113A6E);
  static const Color kBlue600 = Color(0xFF1A52A0);
  static const Color kBlue500 = Color(0xFF2563EB);
  static const Color kTeal = Color(0xFF0891B2);
  static const Color kGray50 = Color(0xFFF8FAFC);
  static const Color kGray200 = Color(0xFFE2E8F0);
  static const Color kGray400 = Color(0xFF94A3B8);
  static const Color kGray500 = Color(0xFF64748B);

  @override
  void initState() {
    super.initState();

    // Fade + slide animation on screen entry
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    );

    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    ));

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ── Validators ────────────────────────────────────────────────
  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your student email';
    }
    // Accept @uthm.edu.my or @student.uthm.edu.my
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@(student\.)?uthm\.edu\.my$',
    );
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Use your UTHM email (e.g. aa220001@uthm.edu.my)';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  // ── Login Logic ───────────────────────────────────────────────
  Future<void> _handleLogin() async {
    // Hide keyboard
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // Simulate network request — replace with real auth later
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;
    setState(() => _isLoading = false);

    // Navigate to Dashboard
    Navigator.pushReplacementNamed(context, '/dashboard');
  }

  // ── SSO Login ─────────────────────────────────────────────────
  void _handleSSOLogin() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Redirecting to UTHM SSO...'),
        backgroundColor: kBlue500,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  // ── Forgot Password ───────────────────────────────────────────
  void _handleForgotPassword() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ForgotPasswordSheet(),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // BUILD
  // ─────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kGray50,
      // Makes content resize when keyboard appears
      resizeToAvoidBottomInset: true,
      body: FadeTransition(
        opacity: _fadeAnim,
        child: SlideTransition(
          position: _slideAnim,
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  // ── TOP HERO ──────────────────────────────────
                  _buildHeroSection(context),

                  // ── FORM AREA ─────────────────────────────────
                  Expanded(
                    child: _buildFormSection(context),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // HERO SECTION (blue top area with logo)
  // ─────────────────────────────────────────────────────────────
  Widget _buildHeroSection(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [kBlue700, kBlue600],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const SizedBox(height: 36),

            // Logo container
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.35),
                  width: 2,
                ),
              ),
              child: const Center(
                child: Text('🎓', style: TextStyle(fontSize: 44)),
              ),
            ),

            const SizedBox(height: 16),

            // App name
            const Text(
              'UTHM Smart Campus',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: -0.3,
              ),
            ),

            const SizedBox(height: 4),

            // Subtitle
            Text(
              'Universiti Tun Hussein Onn Malaysia',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withValues(alpha: 0.7),
                fontWeight: FontWeight.w400,
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // FORM SECTION (white area with inputs)
  // ─────────────────────────────────────────────────────────────
  Widget _buildFormSection(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: kGray50,
        // Clip-path wave effect using top border radius
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),
      // Pull the form UP to overlap the blue header
      transform: Matrix4.translationValues(0, -24, 0),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome text
              const Text(
                'Welcome back 👋',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1E293B),
                  letterSpacing: -0.5,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                'Login with your UTHM student account',
                style: TextStyle(
                  fontSize: 13,
                  color: kGray500,
                  fontWeight: FontWeight.w400,
                ),
              ),

              const SizedBox(height: 28),

              // ── EMAIL FIELD ──────────────────────────────────
              _buildFieldLabel('STUDENT EMAIL'),
              const SizedBox(height: 6),
              _buildEmailField(),

              const SizedBox(height: 16),

              // ── PASSWORD FIELD ───────────────────────────────
              _buildFieldLabel('PASSWORD'),
              const SizedBox(height: 6),
              _buildPasswordField(),

              const SizedBox(height: 10),

              // ── REMEMBER ME + FORGOT PASSWORD ────────────────
              Row(
                children: [
                  // Remember me checkbox
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: Checkbox(
                      value: _rememberMe,
                      onChanged: (v) =>
                          setState(() => _rememberMe = v ?? false),
                      activeColor: kBlue500,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Remember me',
                    style: TextStyle(fontSize: 12, color: kGray500),
                  ),
                  const Spacer(),
                  // Forgot password
                  GestureDetector(
                    onTap: _handleForgotPassword,
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(
                        fontSize: 12,
                        color: kBlue500,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // ── LOGIN BUTTON ─────────────────────────────────
              _buildLoginButton(),

              const SizedBox(height: 20),

              // ── OR DIVIDER ───────────────────────────────────
              _buildOrDivider(),

              const SizedBox(height: 16),

              // ── SSO BUTTON ───────────────────────────────────
              _buildSSOButton(),

              const Spacer(),

              // ── REGISTER LINK ────────────────────────────────
              _buildRegisterLink(),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // REUSABLE WIDGETS
  // ─────────────────────────────────────────────────────────────

  Widget _buildFieldLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: kGray500,
        letterSpacing: 0.8,
      ),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      autocorrect: false,
      validator: _validateEmail,
      style: const TextStyle(fontSize: 14, color: Color(0xFF1E293B)),
      decoration: InputDecoration(
        hintText: 'aa220001@uthm.edu.my',
        hintStyle: TextStyle(color: kGray400, fontSize: 13),
        prefixIcon: const Icon(Icons.email_outlined, color: kGray400, size: 20),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: kGray200, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: kGray200, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: kBlue500, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFEF4444), width: 2),
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (_) => _handleLogin(),
      validator: _validatePassword,
      style: const TextStyle(fontSize: 14, color: Color(0xFF1E293B)),
      decoration: InputDecoration(
        hintText: '••••••••',
        hintStyle: TextStyle(color: kGray400, fontSize: 13),
        prefixIcon: const Icon(Icons.lock_outline, color: kGray400, size: 20),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: kGray400,
            size: 20,
          ),
          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: kGray200, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: kGray200, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: kBlue500, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFEF4444), width: 2),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [kBlue500, kTeal],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: kBlue500.withValues(alpha: 0.4),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: _isLoading ? null : _handleLogin,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: _isLoading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.5,
                  ),
                )
              : const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.lock_open_rounded,
                        color: Colors.white, size: 18),
                    SizedBox(width: 8),
                    Text(
                      'LOGIN TO CAMPUS',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildOrDivider() {
    return Row(
      children: [
        Expanded(child: Divider(color: kGray200, thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            'or continue with',
            style: TextStyle(fontSize: 12, color: kGray400),
          ),
        ),
        Expanded(child: Divider(color: kGray200, thickness: 1)),
      ],
    );
  }

  Widget _buildSSOButton() {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton.icon(
        onPressed: _handleSSOLogin,
        icon: const Text('🏛️', style: TextStyle(fontSize: 18)),
        label: const Text(
          'SSO University Login',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1E293B),
          ),
        ),
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          side: const BorderSide(color: kGray200, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildRegisterLink() {
    return Center(
      child: RichText(
        text: TextSpan(
          text: "New student?  ",
          style: TextStyle(fontSize: 13, color: kGray500),
          children: [
            WidgetSpan(
              child: GestureDetector(
                onTap: () {
                  // TODO: Navigate to Register screen
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Register screen coming soon!'),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      margin: const EdgeInsets.all(16),
                    ),
                  );
                },
                child: const Text(
                  'Register here',
                  style: TextStyle(
                    fontSize: 13,
                    color: kBlue500,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// FORGOT PASSWORD BOTTOM SHEET
// ─────────────────────────────────────────────────────────────────────────────
class _ForgotPasswordSheet extends StatefulWidget {
  @override
  State<_ForgotPasswordSheet> createState() => __ForgotPasswordSheetState();
}

class __ForgotPasswordSheetState extends State<_ForgotPasswordSheet> {
  final _emailCtrl = TextEditingController();
  bool _sent = false;
  bool _loading = false;

  static const Color kBlue500 = Color(0xFF2563EB);
  static const Color kGray200 = Color(0xFFE2E8F0);
  static const Color kGray400 = Color(0xFF94A3B8);
  static const Color kGray500 = Color(0xFF64748B);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: kGray200,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),

          if (!_sent) ...[
            const Text(
              '🔑 Reset Password',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Enter your UTHM email and we\'ll send a reset link.',
              style: TextStyle(fontSize: 13, color: kGray500),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _emailCtrl,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: 'aa220001@uthm.edu.my',
                hintStyle: TextStyle(color: kGray400),
                prefixIcon: const Icon(Icons.email_outlined, color: kGray400),
                filled: true,
                fillColor: const Color(0xFFF8FAFC),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: kGray200),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: kGray200),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: kBlue500, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _loading
                    ? null
                    : () async {
                        setState(() => _loading = true);
                        await Future.delayed(const Duration(seconds: 1));
                        setState(() {
                          _loading = false;
                          _sent = true;
                        });
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: kBlue500,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Send Reset Link',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ] else ...[
            // Success state
            const Center(child: Text('✉️', style: TextStyle(fontSize: 48))),
            const SizedBox(height: 12),
            const Center(
              child: Text(
                'Check your email!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1E293B),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Center(
              child: Text(
                'A password reset link has been sent to your UTHM email.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: kGray500),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: kBlue500,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Back to Login',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
