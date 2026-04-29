import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import '../providers/profile_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/custom_app_bar.dart';
import '../core/constants.dart';
import '../core/theme.dart';
import '../utils/error_handler.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _businessNameController = TextEditingController();
  final _kraPinController = TextEditingController();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String? _selectedJobTitle;
  String? _selectedIndustry;
  String? _selectedCounty;



  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    final provider = context.read<ProfileProvider>();
    await provider.loadProfile();
    final profile = provider.profile;

    if (profile != null) {
      _firstNameController.text = profile.firstName;
      _lastNameController.text = profile.lastName;
      _phoneController.text = profile.phone;
      _businessNameController.text = profile.businessName;
      _kraPinController.text = profile.kraPin;
      
      setState(() {
        _selectedJobTitle = profile.jobTitle.isNotEmpty ? profile.jobTitle : null;
        _selectedIndustry = profile.businessType.isNotEmpty ? profile.businessType : null;
        _selectedCounty = profile.county.isNotEmpty ? profile.county : null;
      });
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _businessNameController.dispose();
    _kraPinController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  bool _isPasswordFormValid() {
    return _currentPasswordController.text.isNotEmpty &&
           _newPasswordController.text.isNotEmpty &&
           _confirmPasswordController.text.isNotEmpty &&
           _newPasswordController.text != _currentPasswordController.text &&
           _newPasswordController.text == _confirmPasswordController.text;
  }

  Widget _buildPasswordValidationHelper() {
    final current = _currentPasswordController.text;
    final newPass = _newPasswordController.text;
    final confirm = _confirmPasswordController.text;
    
    if (current.isEmpty || newPass.isEmpty || confirm.isEmpty) {
      return const SizedBox.shrink();
    }
    
    if (newPass == current) {
      return Text(
        'Must differ from current password',
        style: TextStyle(color: Colors.red.shade600, fontSize: 12),
      );
    }
    
    if (newPass != confirm) {
      return Text(
        'Passwords do not match',
        style: TextStyle(color: Colors.red.shade600, fontSize: 12),
      );
    }
    
    return Text(
      'Ready to update ✓',
      style: TextStyle(color: Colors.green.shade600, fontSize: 12),
    );
  }

  Future<void> _updatePassword() async {
    try {
      final success = await context.read<AuthProvider>().changePassword(
        _currentPasswordController.text,
        _newPasswordController.text,
      );
      
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password updated'),
            backgroundColor: Colors.green,
          ),
        );
        // Clear password fields
        _currentPasswordController.clear();
        _newPasswordController.clear();
        _confirmPasswordController.clear();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(friendlyError(e as DioException)),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final provider = context.read<ProfileProvider>();
      
      final Map<String, dynamic> data = {
        'first_name': _firstNameController.text,
        'last_name': _lastNameController.text,
        'phone': _phoneController.text,
        'job_title': _selectedJobTitle ?? '',
        'business_name': _businessNameController.text,
        'kra_pin': _kraPinController.text,
        'business_type': _selectedIndustry ?? '',
        'county': _selectedCounty ?? '',
      };

      final success = await provider.updateProfile(data);
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProfileProvider>();
    final profile = provider.profile;
    final bool stackFormFields = MediaQuery.sizeOf(context).width < 560;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      appBar: const CustomAppBar(title: 'Account Settings'),
      body: provider.isLoading && profile == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          ListTile(
                            leading: const Icon(Icons.dark_mode_outlined),
                            title: const Text(
                              'Dark mode',
                              style: TextStyle(fontWeight: FontWeight.w900),
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Text(
                              'Switch between light and dark theme',
                              style: TextStyle(color: Colors.grey.shade600),
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: Switch(
                              value: context.watch<ThemeProvider>().isDark,
                              onChanged: (v) => context.read<ThemeProvider>().toggleTheme(),
                            ),
                          ),
                                                  ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Page Title Area
                    const Text(
                      'Account Settings',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Manage your professional and business identity.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 32),

                    if (provider.error != null)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.only(bottom: 24),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          border: Border.all(color: Theme.of(context).colorScheme.error),
                          borderRadius: AppTheme.kCardRadius,
                        ),
                        child: Text(
                          provider.error!,
                          style: TextStyle(color: Theme.of(context).colorScheme.onError),
                        ),
                      ),

                    // Main Form Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: AppTheme.kCardRadius,
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // PERSONAL DETAILS Section
                            _buildSectionHeader('PERSONAL DETAILS'),
                            const SizedBox(height: 24),
                            
                            _buildInputLabel('REGISTERED EMAIL (NOT EDITABLE)'),
                            const SizedBox(height: 8),
                            TextFormField(
                              initialValue: profile?.email ??
                                  context.read<AuthProvider>().user?.email ??
                                  '',
                              readOnly: true,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: const Color(0xFFF3F4F6),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(color: Colors.grey.shade300),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(color: Colors.grey.shade300),
                                ),
                              ),
                              style: const TextStyle(color: Color(0xFF6B7280)),
                            ),
                            const SizedBox(height: 24),

                            stackFormFields
                                ? Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      _buildInputLabel('FIRST NAME'),
                                      const SizedBox(height: 8),
                                      _buildTextField(controller: _firstNameController, hint: 'e.g. John'),
                                      const SizedBox(height: 24),
                                      _buildInputLabel('LAST NAME'),
                                      const SizedBox(height: 8),
                                      _buildTextField(controller: _lastNameController, hint: 'e.g. Doe'),
                                    ],
                                  )
                                : Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            _buildInputLabel('FIRST NAME'),
                                            const SizedBox(height: 8),
                                            _buildTextField(controller: _firstNameController, hint: 'e.g. John'),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 24),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            _buildInputLabel('LAST NAME'),
                                            const SizedBox(height: 8),
                                            _buildTextField(controller: _lastNameController, hint: 'e.g. Doe'),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                            const SizedBox(height: 24),

                            stackFormFields
                                ? Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Transform.translate(
                                        offset: const Offset(0, 0),
                                        child: Text.rich(
                                          TextSpan(
                                            text: 'PHONE NUMBER ',
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w900,
                                              color: Colors.blueGrey.shade700,
                                              letterSpacing: 1.0,
                                            ),
                                            children: const [
                                              TextSpan(
                                                text: '(+254 format)',
                                                style: TextStyle(
                                                  color: Color(0xFF4F46E5),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      TextFormField(
                                        controller: _phoneController,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w900,
                                          color: Color(0xFF111827),
                                          letterSpacing: 1.0,
                                        ),
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(8),
                                            borderSide: BorderSide(color: Colors.grey.shade300),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(8),
                                            borderSide: BorderSide(color: Colors.grey.shade300),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(8),
                                            borderSide: const BorderSide(color: Color(0xFF4F46E5)),
                                          ),
                                          suffixIcon: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFD1FAE5),
                                                borderRadius: BorderRadius.circular(16),
                                              ),
                                              child: const Text(
                                                'VERIFIED',
                                                style: TextStyle(
                                                  color: Color(0xFF059669),
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w900,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 24),
                                      _buildInputLabel('JOB TITLE'),
                                      const SizedBox(height: 8),
                                      _buildDropdown(
                                        hint: 'Select Job Title...',
                                        value: _selectedJobTitle,
                                        items: kJobTitles,
                                        onChanged: (val) => setState(() => _selectedJobTitle = val),
                                      ),
                                    ],
                                  )
                                : Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Transform.translate(
                                              offset: const Offset(0, 0),
                                              child: Text.rich(
                                                TextSpan(
                                                  text: 'PHONE NUMBER ',
                                                  style: TextStyle(
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w900,
                                                    color: Colors.blueGrey.shade700,
                                                    letterSpacing: 1.0,
                                                  ),
                                                  children: const [
                                                    TextSpan(
                                                      text: '(+254 format)',
                                                      style: TextStyle(
                                                        color: Color(0xFF4F46E5),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            TextFormField(
                                              controller: _phoneController,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w900,
                                                color: Color(0xFF111827),
                                                letterSpacing: 1.0,
                                              ),
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(8),
                                                  borderSide: BorderSide(color: Colors.grey.shade300),
                                                ),
                                                enabledBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(8),
                                                  borderSide: BorderSide(color: Colors.grey.shade300),
                                                ),
                                                focusedBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(8),
                                                  borderSide: const BorderSide(color: Color(0xFF4F46E5)),
                                                ),
                                                suffixIcon: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Container(
                                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                                    decoration: BoxDecoration(
                                                      color: const Color(0xFFD1FAE5),
                                                      borderRadius: BorderRadius.circular(16),
                                                    ),
                                                    child: const Text(
                                                      'VERIFIED',
                                                      style: TextStyle(
                                                        color: Color(0xFF059669),
                                                        fontSize: 10,
                                                        fontWeight: FontWeight.w900,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 24),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            _buildInputLabel('JOB TITLE'),
                                            const SizedBox(height: 8),
                                            _buildDropdown(
                                              hint: 'Select Job Title...',
                                              value: _selectedJobTitle,
                                              items: kJobTitles,
                                              onChanged: (val) => setState(() => _selectedJobTitle = val),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                            const SizedBox(height: 48),

                            // BUSINESS INFORMATION Section
                            _buildSectionHeader('BUSINESS INFORMATION'),
                            const SizedBox(height: 24),
                            
                            stackFormFields
                                ? Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      _buildInputLabel('BUSINESS NAME'),
                                      const SizedBox(height: 8),
                                      _buildTextField(controller: _businessNameController, hint: 'e.g. Acme Corp'),
                                      const SizedBox(height: 24),
                                      _buildInputLabel('KRA PIN / REG NO.'),
                                      const SizedBox(height: 8),
                                      _buildTextField(controller: _kraPinController, hint: 'e.g. A123456789Z'),
                                    ],
                                  )
                                : Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            _buildInputLabel('BUSINESS NAME'),
                                            const SizedBox(height: 8),
                                            _buildTextField(controller: _businessNameController, hint: 'e.g. Acme Corp'),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 24),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            _buildInputLabel('KRA PIN / REG NO.'),
                                            const SizedBox(height: 8),
                                            _buildTextField(controller: _kraPinController, hint: 'e.g. A123456789Z'),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                            const SizedBox(height: 24),

                            stackFormFields
                                ? Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      _buildInputLabel('TYPE OF BUSINESS (INDUSTRY)'),
                                      const SizedBox(height: 8),
                                      _buildDropdown(
                                        hint: 'Select Category...',
                                        value: _selectedIndustry,
                                        items: kBusinessTypes,
                                        onChanged: (val) => setState(() => _selectedIndustry = val),
                                      ),
                                      const SizedBox(height: 24),
                                      _buildInputLabel('COUNTY OF OPERATION'),
                                      const SizedBox(height: 8),
                                      _buildDropdown(
                                        hint: 'Select County...',
                                        value: _selectedCounty,
                                        items: kKenyanCounties,
                                        onChanged: (val) => setState(() => _selectedCounty = val),
                                      ),
                                    ],
                                  )
                                : Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            _buildInputLabel('TYPE OF BUSINESS (INDUSTRY)'),
                                            const SizedBox(height: 8),
                                            _buildDropdown(
                                              hint: 'Select Category...',
                                              value: _selectedIndustry,
                                              items: kBusinessTypes,
                                              onChanged: (val) => setState(() => _selectedIndustry = val),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 24),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            _buildInputLabel('COUNTY OF OPERATION'),
                                            const SizedBox(height: 8),
                                            _buildDropdown(
                                              hint: 'Select County...',
                                              value: _selectedCounty,
                                              items: kKenyanCounties,
                                              onChanged: (val) => setState(() => _selectedCounty = val),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                            const SizedBox(height: 48),

                            // Submit Button
                            Align(
                              alignment: stackFormFields ? Alignment.center : Alignment.centerRight,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF4F46E5),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: provider.isLoading ? null : _submitForm,
                                child: provider.isLoading
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                      )
                                    : const Text(
                                        'UPDATE PROFILE',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w900,
                                          letterSpacing: 1.0,
                                          fontSize: 12,
                                        ),
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    // Security Section
                    Text('Security', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 16),
                    // Current Password field
                    _buildPasswordTextField(_currentPasswordController, hint: 'Current Password'),
                    const SizedBox(height: 16),
                    // New Password field
                    _buildPasswordTextField(_newPasswordController, hint: 'New Password'),
                    const SizedBox(height: 16),
                    // Confirm New Password field
                    _buildPasswordTextField(_confirmPasswordController, hint: 'Confirm New Password'),
                    const SizedBox(height: 8),
                    // Password validation helper text
                    _buildPasswordValidationHelper(),
                    const SizedBox(height: 24),
                    // Update Password button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isPasswordFormValid() ? _updatePassword : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isPasswordFormValid() ? Colors.green : Colors.grey,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'UPDATE PASSWORD',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.0,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 16,
          decoration: BoxDecoration(
            color: const Color(0xFF4F46E5),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: Color(0xFF4F46E5),
              fontWeight: FontWeight.w900,
              fontSize: 12,
              letterSpacing: 1.0,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildInputLabel(String label) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w900,
        color: Colors.blueGrey.shade700,
        letterSpacing: 1.0,
      ),
    );
  }

  
  Widget _buildTextField({required TextEditingController controller, String hint = ''}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        filled: true,
        fillColor: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        border: const OutlineInputBorder(
          borderRadius: AppTheme.kInputRadius,
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppTheme.kInputRadius,
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: AppTheme.kInputRadius,
          borderSide: BorderSide(color: AppTheme.kPrimaryColor, width: 1.5),
        ),
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade400),
      ),
      style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
    );
  }

  Widget _buildPasswordTextField(TextEditingController controller, {String hint = ''}) {
    return TextFormField(
      controller: controller,
      obscureText: true,
      decoration: InputDecoration(
        filled: true,
        fillColor: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        border: const OutlineInputBorder(
          borderRadius: AppTheme.kInputRadius,
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppTheme.kInputRadius,
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: AppTheme.kInputRadius,
          borderSide: BorderSide(color: AppTheme.kPrimaryColor, width: 1.5),
        ),
        prefixIcon: Icon(Icons.lock_outlined, color: Colors.grey.shade400),
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade400),
      ),
      style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
    );
  }

  Widget _buildDropdown({
    required String hint,
    required List<String> items,
    String? value,
    void Function(String?)? onChanged,
  }) {
    return DropdownButtonFormField<String>(
      initialValue: value != null && items.contains(value) ? value : null,
      isExpanded: true,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF4F46E5)),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      icon: const Icon(Icons.keyboard_arrow_down),
      hint: Text(hint, style: TextStyle(color: Colors.grey.shade600)),
      items: items.map((e) => DropdownMenuItem(
        value: e, 
        child: Text(
          e, 
          overflow: TextOverflow.ellipsis,
        )
      )).toList(),
      onChanged: onChanged,
    );
  }
}
