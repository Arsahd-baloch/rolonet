// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:reliefnet/features/donor/domain/donation_model.dart';
// import 'package:reliefnet/features/donor/state/donation_provider.dart';
// import 'package:reliefnet/features/campaigns/domain/campaign_model.dart';

// class DonateScreen extends ConsumerStatefulWidget {
//   final CampaignModel campaign;

//   const DonateScreen({super.key, required this.campaign});

//   @override
//   ConsumerState<DonateScreen> createState() => _DonateScreenState();
// }

// class _DonateScreenState extends ConsumerState<DonateScreen> {
//   final _formKey = GlobalKey<FormState>();

//   // ── Controllers ──
//   final _nameController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _messageController = TextEditingController();
//   final _amountController = TextEditingController();
//   final _quantityController = TextEditingController();

//   String _selectedType = 'MONEY'; // default

//   @override
//   void initState() {
//     super.initState();
//     // set default type based on campaign
//     final type = widget.campaign.donationType?.toUpperCase() ?? 'MONEY';
//     if (type == 'MONEY' || type == 'ITEMS' || type == 'BOTH') {
//       _selectedType = type == 'BOTH' ? 'MONEY' : type;
//     }
//   }

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _emailController.dispose();
//     _messageController.dispose();
//     _amountController.dispose();
//     _quantityController.dispose();
//     super.dispose();
//   }

//   // ── Allowed types based on campaign ──
//   List<String> get _allowedTypes {
//     final type = widget.campaign.donationType?.toUpperCase() ?? 'MONEY';
//     if (type == 'BOTH') return ['MONEY', 'ITEMS'];
//     return [type];
//   }

//   Future<void> _submit() async {
//     if (!_formKey.currentState!.validate()) return;

//     final donation = DonationModel(
//       campaignId: widget.campaign.id,
//       donationType: _selectedType,
//       amount: _selectedType == 'MONEY' || _selectedType == 'BOTH'
//           ? double.tryParse(_amountController.text.trim())
//           : null,
//       quantity: _selectedType == 'ITEMS' || _selectedType == 'BOTH'
//           ? int.tryParse(_quantityController.text.trim())
//           : null,
//       donorName: _nameController.text.trim().isEmpty
//           ? null
//           : _nameController.text.trim(),
//       donorEmail: _emailController.text.trim().isEmpty
//           ? null
//           : _emailController.text.trim(),
//       message: _messageController.text.trim().isEmpty
//           ? null
//           : _messageController.text.trim(),
//     );

//     final success = await ref
//         .read(donationProvider.notifier)
//         .submitDonation(campaignId: widget.campaign.id, donation: donation);

//     if (!mounted) return;

//     if (success) {
//       _showSuccessDialog();
//     } else {
//       final error = ref.read(donationProvider).errorMessage;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(error ?? 'Failed to submit donation'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }

//   void _showSuccessDialog() {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (_) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Icon(Icons.check_circle, color: Colors.green, size: 64),
//             const SizedBox(height: 16),
//             const Text(
//               'Donation Submitted!',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),
//             const Text(
//               'Thank you for your generosity. Your donation is pending verification.',
//               textAlign: TextAlign.center,
//               style: TextStyle(color: Colors.grey),
//             ),
//           ],
//         ),
//         actions: [
//           SizedBox(
//             width: double.infinity,
//             child: ElevatedButton(
//               onPressed: () {
//                 Navigator.pop(context); // close dialog
//                 Navigator.pop(context); // go back to detail
//                 ref.read(donationProvider.notifier).reset();
//               },
//               child: const Text('Done'),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final donationState = ref.watch(donationProvider);
//     final campaignType = widget.campaign.donationType?.toUpperCase() ?? 'MONEY';

//     return Scaffold(
//       appBar: AppBar(title: const Text('Make a Donation'), centerTitle: true),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // ── CAMPAIGN BANNER ──
//               Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: Colors.blue.shade50,
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(color: Colors.blue.shade100),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       widget.campaign.title,
//                       style: const TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     LinearProgressIndicator(
//                       value: widget.campaign.progress.clamp(0.0, 1.0),
//                       backgroundColor: Colors.blue.shade100,
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       'PKR ${widget.campaign.totalAmount.toStringAsFixed(0)} '
//                       'of PKR ${widget.campaign.goalAmount.toStringAsFixed(0)} raised',
//                       style: TextStyle(
//                         fontSize: 12,
//                         color: Colors.blue.shade700,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               const SizedBox(height: 24),

//               // ── DONATION TYPE SELECTOR (only if BOTH) ──
//               if (campaignType == 'BOTH') ...[
//                 const Text(
//                   'Donation Type',
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 8),
//                 Row(
//                   children: ['MONEY', 'ITEMS'].map((type) {
//                     final isSelected = _selectedType == type;
//                     return Expanded(
//                       child: GestureDetector(
//                         onTap: () => setState(() => _selectedType = type),
//                         child: Container(
//                           margin: const EdgeInsets.symmetric(horizontal: 4),
//                           padding: const EdgeInsets.symmetric(vertical: 12),
//                           decoration: BoxDecoration(
//                             color: isSelected
//                                 ? Colors.blue
//                                 : Colors.grey.shade100,
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           child: Center(
//                             child: Text(
//                               type,
//                               style: TextStyle(
//                                 color: isSelected ? Colors.white : Colors.black,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     );
//                   }).toList(),
//                 ),
//                 const SizedBox(height: 24),
//               ],

//               // ── AMOUNT (MONEY) ──
//               if (_selectedType == 'MONEY') ...[
//                 const Text(
//                   'Amount (PKR)',
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 8),
//                 TextFormField(
//                   controller: _amountController,
//                   keyboardType: TextInputType.number,
//                   decoration: InputDecoration(
//                     hintText: 'Enter amount',
//                     prefixIcon: const Icon(Icons.attach_money),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                   validator: (v) {
//                     if (_selectedType != 'MONEY') return null;
//                     if (v == null || v.trim().isEmpty) {
//                       return 'Please enter an amount';
//                     }
//                     if (double.tryParse(v.trim()) == null) {
//                       return 'Enter a valid number';
//                     }
//                     if (double.parse(v.trim()) <= 0) {
//                       return 'Amount must be greater than 0';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 24),
//               ],

//               // ── QUANTITY (ITEMS) ──
//               if (_selectedType == 'ITEMS') ...[
//                 const Text(
//                   'Quantity',
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 8),
//                 TextFormField(
//                   controller: _quantityController,
//                   keyboardType: TextInputType.number,
//                   decoration: InputDecoration(
//                     hintText: 'How many items?',
//                     prefixIcon: const Icon(Icons.inventory_2),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                   validator: (v) {
//                     if (_selectedType != 'ITEMS') return null;
//                     if (v == null || v.trim().isEmpty) {
//                       return 'Please enter quantity';
//                     }
//                     if (int.tryParse(v.trim()) == null) {
//                       return 'Enter a valid number';
//                     }
//                     if (int.parse(v.trim()) <= 0) {
//                       return 'Quantity must be greater than 0';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 24),
//               ],

//               // ── DONOR NAME (optional) ──
//               const Text(
//                 'Your Name (optional)',
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 8),
//               TextFormField(
//                 controller: _nameController,
//                 decoration: InputDecoration(
//                   hintText: 'Anonymous',
//                   prefixIcon: const Icon(Icons.person_outline),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 16),

//               // ── DONOR EMAIL (optional) ──
//               const Text(
//                 'Email (optional)',
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 8),
//               TextFormField(
//                 controller: _emailController,
//                 keyboardType: TextInputType.emailAddress,
//                 decoration: InputDecoration(
//                   hintText: 'you@example.com',
//                   prefixIcon: const Icon(Icons.email_outlined),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//                 validator: (v) {
//                   if (v == null || v.trim().isEmpty) return null;
//                   if (!v.contains('@')) return 'Enter a valid email';
//                   return null;
//                 },
//               ),

//               const SizedBox(height: 16),

//               // ── MESSAGE (optional) ──
//               const Text(
//                 'Message (optional)',
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 8),
//               TextFormField(
//                 controller: _messageController,
//                 maxLines: 3,
//                 decoration: InputDecoration(
//                   hintText: 'Leave a message of support...',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 32),

//               // ── SUBMIT BUTTON ──
//               SizedBox(
//                 width: double.infinity,
//                 height: 50,
//                 child: ElevatedButton(
//                   onPressed: donationState.isLoading ? null : _submit,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.blue,
//                     foregroundColor: Colors.white,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                   child: donationState.isLoading
//                       ? const CircularProgressIndicator(color: Colors.white)
//                       : const Text(
//                           'Submit Donation',
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                 ),
//               ),

//               const SizedBox(height: 16),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reliefnet/core/services/cloudinary_service.dart';
import 'package:reliefnet/features/donor/domain/donation_model.dart';
import 'package:reliefnet/features/donor/state/donation_provider.dart';
import 'package:reliefnet/features/campaigns/domain/campaign_model.dart';

class DonateScreen extends ConsumerStatefulWidget {
  final CampaignModel campaign;
  const DonateScreen({super.key, required this.campaign});

  @override
  ConsumerState<DonateScreen> createState() => _DonateScreenState();
}

class _DonateScreenState extends ConsumerState<DonateScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();
  final _amountController = TextEditingController();
  final _quantityController = TextEditingController();
  final _pickupLocationController = TextEditingController();

  String _selectedType = 'MONEY';
  File? _pickedImage;
  String? _uploadedImageUrl;
  bool _isUploadingImage = false;
  DateTime? _availableDatetime;

  @override
  void initState() {
    super.initState();
    final type = widget.campaign.donationType?.toUpperCase() ?? 'MONEY';
    _selectedType = type == 'BOTH' ? 'MONEY' : type;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    _amountController.dispose();
    _quantityController.dispose();
    _pickupLocationController.dispose();
    super.dispose();
  }

  // ── Pick image from gallery ──
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (picked == null) return;

    setState(() {
      _pickedImage = File(picked.path);
      _uploadedImageUrl = null;
      _isUploadingImage = true;
    });

    final url = await CloudinaryService.uploadImage(_pickedImage!);

    setState(() {
      _isUploadingImage = false;
      _uploadedImageUrl = url;
    });

    if (url == null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Image upload failed. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // ── Pick datetime ──
  Future<void> _pickDatetime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 60)),
    );
    if (date == null || !mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time == null) return;

    setState(() {
      _availableDatetime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    // Block submit if image is still uploading
    if (_isUploadingImage) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please wait for image to finish uploading'),
        ),
      );
      return;
    }

    // For ITEMS, photo is required
    if (_selectedType == 'ITEMS' && _uploadedImageUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please upload a photo of the items'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final donation = DonationModel(
      campaignId: widget.campaign.id,
      donationType: _selectedType,
      amount: _selectedType == 'MONEY'
          ? double.tryParse(_amountController.text.trim())
          : null,
      quantity: _selectedType == 'ITEMS'
          ? int.tryParse(_quantityController.text.trim())
          : null,
      donorName: _nameController.text.trim().isEmpty
          ? null
          : _nameController.text.trim(),
      donorEmail: _emailController.text.trim().isEmpty
          ? null
          : _emailController.text.trim(),
      message: _messageController.text.trim().isEmpty
          ? null
          : _messageController.text.trim(),
      proofImage: _uploadedImageUrl,
      pickupLocation: _selectedType == 'ITEMS'
          ? (_pickupLocationController.text.trim().isEmpty
                ? null
                : _pickupLocationController.text.trim())
          : null,
      availableDatetime: _selectedType == 'ITEMS' ? _availableDatetime : null,
    );

    final success = await ref
        .read(donationProvider.notifier)
        .submitDonation(campaignId: widget.campaign.id, donation: donation);

    if (!mounted) return;

    if (success) {
      _showSuccessDialog();
    } else {
      final error = ref.read(donationProvider).errorMessage;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error ?? 'Failed to submit donation'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 64),
            const SizedBox(height: 16),
            const Text(
              'Donation Submitted!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Thank you for your generosity. Your donation is pending verification.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
                ref.read(donationProvider.notifier).reset();
              },
              child: const Text('Done'),
            ),
          ),
        ],
      ),
    );
  }

  // ── Image picker widget ──
  Widget _buildImagePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Item Photo *',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _isUploadingImage ? null : _pickImage,
          child: Container(
            width: double.infinity,
            height: 160,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: _isUploadingImage
                ? const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 8),
                        Text(
                          'Uploading...',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : _pickedImage != null
                ? Stack(
                    fit: StackFit.expand,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(_pickedImage!, fit: BoxFit.cover),
                      ),
                      // Upload success indicator
                      if (_uploadedImageUrl != null)
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      // Tap to change
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'Change',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                      ),
                    ],
                  )
                : const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_photo_alternate_outlined,
                        size: 40,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Tap to add photo',
                        style: TextStyle(color: Colors.grey),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Show us what you\'re donating',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  // ── Datetime picker widget ──
  Widget _buildDatetimePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Available For Pickup (optional)',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _pickDatetime,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.calendar_today_outlined,
                  color: Colors.grey,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  _availableDatetime == null
                      ? 'Select date & time'
                      : '${_availableDatetime!.day}/${_availableDatetime!.month}/${_availableDatetime!.year} '
                            '${_availableDatetime!.hour.toString().padLeft(2, '0')}:'
                            '${_availableDatetime!.minute.toString().padLeft(2, '0')}',
                  style: TextStyle(
                    color: _availableDatetime == null
                        ? Colors.grey
                        : Colors.black87,
                  ),
                ),
                const Spacer(),
                if (_availableDatetime != null)
                  GestureDetector(
                    onTap: () => setState(() => _availableDatetime = null),
                    child: const Icon(
                      Icons.close,
                      size: 18,
                      color: Colors.grey,
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final donationState = ref.watch(donationProvider);
    final campaignType = widget.campaign.donationType?.toUpperCase() ?? 'MONEY';

    return Scaffold(
      appBar: AppBar(title: const Text('Make a Donation'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── CAMPAIGN BANNER ──
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.shade100),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.campaign.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: widget.campaign.progress.clamp(0.0, 1.0),
                      backgroundColor: Colors.blue.shade100,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'PKR ${widget.campaign.totalAmount.toStringAsFixed(0)} '
                      'of PKR ${widget.campaign.goalAmount.toStringAsFixed(0)} raised',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue.shade700,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ── DONATION TYPE SELECTOR (only if BOTH) ──
              if (campaignType == 'BOTH') ...[
                const Text(
                  'Donation Type',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Row(
                  children: ['MONEY', 'ITEMS'].map((type) {
                    final isSelected = _selectedType == type;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() {
                          _selectedType = type;
                          // Reset item fields when switching
                          _pickedImage = null;
                          _uploadedImageUrl = null;
                          _availableDatetime = null;
                          _pickupLocationController.clear();
                        }),
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.blue
                                : Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              type,
                              style: TextStyle(
                                color: isSelected ? Colors.white : Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),
              ],

              // ── MONEY FIELDS ──
              if (_selectedType == 'MONEY') ...[
                const Text(
                  'Amount (PKR)',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Enter amount',
                    prefixIcon: const Icon(Icons.attach_money),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (v) {
                    if (_selectedType != 'MONEY') return null;
                    if (v == null || v.trim().isEmpty)
                      return 'Please enter an amount';
                    if (double.tryParse(v.trim()) == null)
                      return 'Enter a valid number';
                    if (double.parse(v.trim()) <= 0)
                      return 'Amount must be greater than 0';
                    return null;
                  },
                ),
                const SizedBox(height: 24),
              ],

              // ── ITEMS FIELDS ──
              if (_selectedType == 'ITEMS') ...[
                // Photo upload
                _buildImagePicker(),

                // Quantity
                const Text(
                  'Quantity *',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _quantityController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'How many items?',
                    prefixIcon: const Icon(Icons.inventory_2),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (v) {
                    if (_selectedType != 'ITEMS') return null;
                    if (v == null || v.trim().isEmpty)
                      return 'Please enter quantity';
                    if (int.tryParse(v.trim()) == null)
                      return 'Enter a valid number';
                    if (int.parse(v.trim()) <= 0)
                      return 'Quantity must be greater than 0';
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Pickup location
                const Text(
                  'Pickup Location (optional)',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _pickupLocationController,
                  decoration: InputDecoration(
                    hintText: 'e.g. House 12, Block B, Lahore',
                    prefixIcon: const Icon(Icons.location_on_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Available datetime
                _buildDatetimePicker(),
              ],

              // ── DONOR NAME ──
              const Text(
                'Your Name (optional)',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: 'Anonymous',
                  prefixIcon: const Icon(Icons.person_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // ── DONOR EMAIL ──
              const Text(
                'Email (optional)',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'you@example.com',
                  prefixIcon: const Icon(Icons.email_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return null;
                  if (!v.contains('@')) return 'Enter a valid email';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // ── MESSAGE ──
              Text(
                _selectedType == 'ITEMS'
                    ? 'Item Description (optional)'
                    : 'Message (optional)',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _messageController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: _selectedType == 'ITEMS'
                      ? 'Describe the items (condition, type, etc.)'
                      : 'Leave a message of support...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // ── SUBMIT ──
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: (donationState.isLoading || _isUploadingImage)
                      ? null
                      : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: donationState.isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Submit Donation',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
