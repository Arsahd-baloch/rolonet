import 'package:flutter/material.dart';

// ─── Mock Data Models ────────────────────────
enum RequestStatus { pending, approved, rejected, completed }

class _HelpRequest {
  final String type;
  final RequestStatus status;
  final String date;

  const _HelpRequest({
    required this.type,
    required this.status,
    required this.date,
  });
}

class _Category {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  const _Category({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}

// ─────────────────────────────────────────────
// BENEFICIARY SCREEN
// ─────────────────────────────────────────────
class BeneficiaryScreen extends StatefulWidget {
  const BeneficiaryScreen({super.key});

  @override
  State<BeneficiaryScreen> createState() => _BeneficiaryScreenState();
}

class _BeneficiaryScreenState extends State<BeneficiaryScreen> {
  static const List<_Category> _categories = [
    _Category(title: 'Food Assistance', description: 'Packaged food, dry rations & meal kits', icon: Icons.fastfood_rounded, color: Color(0xFF10B981)),
    _Category(title: 'Medical Help', description: 'First aid, medicines & health support', icon: Icons.medical_services_rounded, color: Color(0xFFEF4444)),
    _Category(title: 'Shelter Support', description: 'Temporary housing & emergency shelter', icon: Icons.home_rounded, color: Color(0xFF3B82F6)),
    _Category(title: 'Clothing Aid', description: 'Clothes, blankets & warm wear', icon: Icons.checkroom_rounded, color: Color(0xFF8B5CF6)),
    _Category(title: 'Financial Support', description: 'Emergency funds & financial relief', icon: Icons.attach_money_rounded, color: Color(0xFFF59E0B)),
    _Category(title: 'Emergency Relief', description: 'Urgent multi-category disaster aid', icon: Icons.emergency_rounded, color: Color(0xFFDC2626)),
  ];

  static const List<_HelpRequest> _myRequests = [
    _HelpRequest(type: 'Food Assistance', status: RequestStatus.approved, date: '18 Apr 2025'),
    _HelpRequest(type: 'Clothing Aid', status: RequestStatus.pending, date: '19 Apr 2025'),
    _HelpRequest(type: 'Medical Help', status: RequestStatus.completed, date: '10 Apr 2025'),
    _HelpRequest(type: 'Shelter Support', status: RequestStatus.rejected, date: '5 Apr 2025'),
  ];

  void _openRequestForm(BuildContext context, String categoryTitle) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _RequestFormModal(categoryTitle: categoryTitle),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            const _Header(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Categories grid
                    const _SectionHeader(
                      title: 'Support Categories',
                      subtitle: 'Select what kind of help you need',
                    ),
                    const SizedBox(height: 12),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _categories.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.85,
                      ),
                      itemBuilder: (context, i) {
                        return _CategoryCard(
                          category: _categories[i],
                          onRequestTap: () => _openRequestForm(context, _categories[i].title),
                        );
                      },
                    ),
                    const SizedBox(height: 28),
                    // My requests
                    const _SectionHeader(
                      title: 'My Requests',
                      subtitle: 'Track your submitted requests',
                    ),
                    const SizedBox(height: 12),
                    ..._myRequests.map((r) => _RequestItem(request: r)),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// HEADER
// ─────────────────────────────────────────────
class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      color: Colors.white,
      child: Row(
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Beneficiary Support',
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800, color: Color(0xFF1E293B)),
              ),
              Text(
                'Request and track assistance',
                style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
              ),
            ],
          ),
          const Spacer(),
          // Profile placeholder
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFEF4444).withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFEF4444).withOpacity(0.2)),
            ),
            child: const Icon(Icons.person_outline_rounded, color: Color(0xFFEF4444), size: 22),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// CATEGORY CARD
// ─────────────────────────────────────────────
class _CategoryCard extends StatelessWidget {
  final _Category category;
  final VoidCallback onRequestTap;

  const _CategoryCard({required this.category, required this.onRequestTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [BoxShadow(color: Color(0x08000000), blurRadius: 6, offset: Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Colored top section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: category.color.withOpacity(0.08),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: category.color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(category.icon, color: category.color, size: 22),
                ),
                const SizedBox(height: 10),
                Text(
                  category.title,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF1E293B)),
                ),
                const SizedBox(height: 3),
                Text(
                  category.description,
                  style: const TextStyle(fontSize: 10, color: Color(0xFF94A3B8), height: 1.4),
                  maxLines: 2,
                ),
              ],
            ),
          ),
          // Button
          Padding(
            padding: const EdgeInsets.all(10),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onRequestTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: category.color,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 9),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
                ),
                child: const Text('Request Help'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// REQUEST FORM MODAL
// ─────────────────────────────────────────────
class _RequestFormModal extends StatefulWidget {
  final String categoryTitle;
  const _RequestFormModal({required this.categoryTitle});

  @override
  State<_RequestFormModal> createState() => _RequestFormModalState();
}

class _RequestFormModalState extends State<_RequestFormModal> {
  final _formKey = GlobalKey<FormState>();
  String _selectedPriority = 'Medium';

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2E8F0),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              // Title
              Row(
                children: [
                  const Icon(Icons.help_outline_rounded, color: Color(0xFF1E40AF), size: 22),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Request: ${widget.categoryTitle}',
                      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: Color(0xFF1E293B)),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded, color: Color(0xFF94A3B8)),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Full Name
              _FieldLabel(text: 'Full Name'),
              const SizedBox(height: 8),
              TextFormField(
                decoration: _inputDeco('Enter your full name', Icons.person_outline),
                validator: (v) => (v == null || v.isEmpty) ? 'Full name is required' : null,
              ),
              const SizedBox(height: 14),

              // Phone
              _FieldLabel(text: 'Phone Number'),
              const SizedBox(height: 8),
              TextFormField(
                keyboardType: TextInputType.phone,
                decoration: _inputDeco('Enter your phone number', Icons.phone_outlined),
                validator: (v) => (v == null || v.isEmpty) ? 'Phone number is required' : null,
              ),
              const SizedBox(height: 14),

              // Address
              _FieldLabel(text: 'Address'),
              const SizedBox(height: 8),
              TextFormField(
                maxLines: 2,
                decoration: _inputDeco('Enter your address', Icons.location_on_outlined),
                validator: (v) => (v == null || v.isEmpty) ? 'Address is required' : null,
              ),
              const SizedBox(height: 14),

              // Description
              _FieldLabel(text: 'Description of Need'),
              const SizedBox(height: 8),
              TextFormField(
                maxLines: 3,
                decoration: _inputDeco('Describe what you need...', Icons.description_outlined),
                validator: (v) => (v == null || v.isEmpty) ? 'Please describe your need' : null,
              ),
              const SizedBox(height: 14),

              // Priority selector
              _FieldLabel(text: 'Priority Level'),
              const SizedBox(height: 10),
              Row(
                children: ['Low', 'Medium', 'High'].map((p) {
                  final bool selected = _selectedPriority == p;
                  final Color pColor = p == 'High'
                      ? const Color(0xFFEF4444)
                      : p == 'Medium'
                          ? const Color(0xFFF59E0B)
                          : const Color(0xFF10B981);
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedPriority = p),
                      child: Container(
                        margin: EdgeInsets.only(right: p != 'High' ? 8 : 0),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: selected ? pColor.withOpacity(0.12) : const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: selected ? pColor : const Color(0xFFE2E8F0),
                            width: selected ? 1.5 : 1,
                          ),
                        ),
                        child: Text(
                          p,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: selected ? pColor : const Color(0xFF94A3B8),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              // Submit button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Navigator.of(context).pop();
                      // TODO: Submit help request (UI only)
                    }
                  },
                  icon: const Icon(Icons.send_rounded, size: 18),
                  label: const Text('Submit Request'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E40AF),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDeco(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFFCBD5E1), fontSize: 14),
      prefixIcon: Icon(icon, color: const Color(0xFF94A3B8), size: 20),
      filled: true,
      fillColor: const Color(0xFFF8FAFC),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF1E40AF), width: 1.5)),
      errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFEF4444))),
      focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1.5)),
    );
  }
}

// ─────────────────────────────────────────────
// MY REQUESTS LIST ITEM
// ─────────────────────────────────────────────
class _RequestItem extends StatelessWidget {
  final _HelpRequest request;
  const _RequestItem({required this.request});

  Color get _statusColor {
    switch (request.status) {
      case RequestStatus.pending:   return const Color(0xFFF59E0B);
      case RequestStatus.approved:  return const Color(0xFF3B82F6);
      case RequestStatus.rejected:  return const Color(0xFFEF4444);
      case RequestStatus.completed: return const Color(0xFF10B981);
    }
  }

  String get _statusLabel {
    switch (request.status) {
      case RequestStatus.pending:   return 'PENDING';
      case RequestStatus.approved:  return 'APPROVED';
      case RequestStatus.rejected:  return 'REJECTED';
      case RequestStatus.completed: return 'COMPLETED';
    }
  }

  IconData get _statusIcon {
    switch (request.status) {
      case RequestStatus.pending:   return Icons.hourglass_empty_rounded;
      case RequestStatus.approved:  return Icons.thumb_up_rounded;
      case RequestStatus.rejected:  return Icons.cancel_rounded;
      case RequestStatus.completed: return Icons.check_circle_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [BoxShadow(color: Color(0x06000000), blurRadius: 4, offset: Offset(0, 1))],
      ),
      child: Row(
        children: [
          // Status icon
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: _statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(_statusIcon, color: _statusColor, size: 20),
          ),
          const SizedBox(width: 14),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  request.type,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF1E293B)),
                ),
                const SizedBox(height: 3),
                Text(
                  request.date,
                  style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                ),
              ],
            ),
          ),
          // Status badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: _statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _statusColor.withOpacity(0.3)),
            ),
            child: Text(
              _statusLabel,
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: _statusColor, letterSpacing: 0.3),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// SHARED
// ─────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  const _SectionHeader({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: Color(0xFF1E293B))),
        const SizedBox(height: 3),
        Text(subtitle, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
      ],
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF374151)),
    );
  }
}
