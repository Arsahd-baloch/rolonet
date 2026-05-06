// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../domain/campaign_model.dart';
// import '../state/campaign_provider.dart';

// class CreateCampaignScreen extends ConsumerStatefulWidget {
//   const CreateCampaignScreen({super.key});

//   @override
//   ConsumerState<CreateCampaignScreen> createState() =>
//       _CreateCampaignScreenState();
// }

// class _CreateCampaignScreenState extends ConsumerState<CreateCampaignScreen> {
//   final _formKey = GlobalKey<FormState>();

//   final titleController = TextEditingController();
//   final descController = TextEditingController();
//   final goalController = TextEditingController();

//   String donationType = "MONEY";
//   String priority = "MEDIUM";

//   DateTime? startDate; // ✅ new
//   DateTime? endDate; // ✅ new

//   bool _isLoading = false;

//   @override
//   void dispose() {
//     titleController.dispose();
//     descController.dispose();
//     goalController.dispose();
//     super.dispose();
//   }

//   // ✅ DATE PICKER HELPER
//   Future<void> _pickDate({required bool isStart}) async {
//     final now = DateTime.now();
//     final initial = isStart
//         ? (startDate ?? now)
//         : (endDate ?? startDate ?? now);

//     final first = isStart ? now : (startDate ?? now);

//     final picked = await showDatePicker(
//       context: context,
//       initialDate: initial,
//       firstDate: first,
//       lastDate: DateTime(2100),
//     );

//     if (picked != null) {
//       setState(() {
//         if (isStart) {
//           startDate = picked;
//           // ✅ reset end date if it's before new start date
//           if (endDate != null && endDate!.isBefore(picked)) {
//             endDate = null;
//           }
//         } else {
//           endDate = picked;
//         }
//       });
//     }
//   }

//   // ✅ FORMAT DATE FOR DISPLAY
//   String _formatDate(DateTime? date) {
//     if (date == null) return "Not set";
//     return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
//   }

//   Future<void> _submit() async {
//     if (!_formKey.currentState!.validate()) return;

//     setState(() => _isLoading = true);

//     try {
//       final campaign = CampaignModel(
//         id: 0,
//         title: titleController.text.trim(),
//         description: descController.text.trim(),
//         status: 'DRAFT',
//         goalAmount: double.tryParse(goalController.text.trim()) ?? 0,
//         totalAmount: 0,
//         donationType: donationType,
//         donorCount: 0,
//         goalQuantity: 0,
//         totalQuantity: 0,
//         startDate: startDate, // ✅ new
//         endDate: endDate, // ✅ new
//       );

//       final success = await ref
//           .read(campaignProvider.notifier)
//           .createCampaign(campaign);

//       if (!mounted) return;

//       if (success) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Campaign Created Successfully")),
//         );
//         titleController.clear();
//         descController.clear();
//         goalController.clear();
//         Navigator.pop(context);
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Failed to create campaign")),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text("Error: $e")));
//     } finally {
//       if (mounted) setState(() => _isLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Create Campaign")),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(16),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               children: [
//                 // TITLE
//                 TextFormField(
//                   controller: titleController,
//                   decoration: const InputDecoration(
//                     labelText: "Campaign Title",
//                   ),
//                   validator: (v) => v == null || v.isEmpty ? "Required" : null,
//                 ),

//                 const SizedBox(height: 12),

//                 // DESCRIPTION
//                 TextFormField(
//                   controller: descController,
//                   maxLines: 3,
//                   decoration: const InputDecoration(labelText: "Description"),
//                   validator: (v) => v == null || v.isEmpty ? "Required" : null,
//                 ),

//                 const SizedBox(height: 12),

//                 // GOAL AMOUNT
//                 TextFormField(
//                   controller: goalController,
//                   keyboardType: TextInputType.number,
//                   decoration: const InputDecoration(
//                     labelText: "Goal Amount (PKR)",
//                   ),
//                   validator: (v) {
//                     if (v == null || v.isEmpty) return "Goal required";
//                     if (double.tryParse(v) == null) return "Enter valid number";
//                     return null;
//                   },
//                 ),

//                 const SizedBox(height: 12),

//                 // DONATION TYPE
//                 DropdownButtonFormField<String>(
//                   value: donationType,
//                   decoration: const InputDecoration(labelText: "Donation Type"),
//                   items: const [
//                     DropdownMenuItem(value: "MONEY", child: Text("Money")),
//                     DropdownMenuItem(value: "ITEMS", child: Text("Items")),
//                     DropdownMenuItem(value: "BOTH", child: Text("Both")),
//                   ],
//                   onChanged: (val) => setState(() => donationType = val!),
//                 ),

//                 const SizedBox(height: 12),

//                 // PRIORITY
//                 DropdownButtonFormField<String>(
//                   value: priority,
//                   decoration: const InputDecoration(labelText: "Priority"),
//                   items: const [
//                     DropdownMenuItem(value: "LOW", child: Text("Low")),
//                     DropdownMenuItem(value: "MEDIUM", child: Text("Medium")),
//                     DropdownMenuItem(value: "HIGH", child: Text("High")),
//                   ],
//                   onChanged: (val) => setState(() => priority = val!),
//                 ),

//                 const SizedBox(height: 16),

//                 // ✅ START DATE PICKER
//                 ListTile(
//                   contentPadding: EdgeInsets.zero,
//                   leading: const Icon(Icons.calendar_today, color: Colors.blue),
//                   title: const Text("Start Date"),
//                   subtitle: Text(
//                     _formatDate(startDate),
//                     style: TextStyle(
//                       color: startDate == null ? Colors.grey : Colors.black,
//                     ),
//                   ),
//                   trailing: startDate != null
//                       ? IconButton(
//                           icon: const Icon(Icons.clear, color: Colors.red),
//                           onPressed: () => setState(() => startDate = null),
//                         )
//                       : null,
//                   onTap: () => _pickDate(isStart: true),
//                 ),

//                 const Divider(),

//                 // ✅ END DATE PICKER
//                 ListTile(
//                   contentPadding: EdgeInsets.zero,
//                   leading: const Icon(Icons.event, color: Colors.red),
//                   title: const Text("End Date"),
//                   subtitle: Text(
//                     _formatDate(endDate),
//                     style: TextStyle(
//                       color: endDate == null ? Colors.grey : Colors.black,
//                     ),
//                   ),
//                   trailing: endDate != null
//                       ? IconButton(
//                           icon: const Icon(Icons.clear, color: Colors.red),
//                           onPressed: () => setState(() => endDate = null),
//                         )
//                       : null,
//                   onTap: () => _pickDate(isStart: false),
//                 ),

//                 const SizedBox(height: 24),

//                 // SUBMIT BUTTON
//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     onPressed: _isLoading ? null : _submit,
//                     child: _isLoading
//                         ? const CircularProgressIndicator()
//                         : const Text("Create Campaign"),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../domain/campaign_model.dart';
import '../state/campaign_provider.dart';
import '../../../core/services/cloudinary_service.dart';

class CreateCampaignScreen extends ConsumerStatefulWidget {
  const CreateCampaignScreen({super.key});

  @override
  ConsumerState<CreateCampaignScreen> createState() =>
      _CreateCampaignScreenState();
}

class _CreateCampaignScreenState extends ConsumerState<CreateCampaignScreen> {
  final _formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final descController = TextEditingController();
  final goalController = TextEditingController();

  String donationType = "MONEY";
  String priority = "MEDIUM";

  DateTime? startDate;
  DateTime? endDate;

  // ✅ IMAGE STATE
  XFile? _pickedFile; // works for both web and mobile
  bool _isUploading = false;
  String? _uploadedUrl;

  bool _isLoading = false;

  @override
  void dispose() {
    titleController.dispose();
    descController.dispose();
    goalController.dispose();
    super.dispose();
  }

  // ================= IMAGE PICKER =================
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80, // ✅ compress to reduce upload size
      maxWidth: 1200,
    );

    if (picked != null) {
      setState(() {
        _pickedFile = picked;
        _uploadedUrl = null; // reset old url
      });
    }
  }

  // ================= UPLOAD TO CLOUDINARY =================
  Future<String?> _uploadImage() async {
    if (_pickedFile == null) return null;

    setState(() => _isUploading = true);

    try {
      String? url;

      if (kIsWeb) {
        // ✅ Web — use bytes
        final bytes = await _pickedFile!.readAsBytes();
        url = await CloudinaryService.uploadImageBytes(
          bytes,
          _pickedFile!.name,
        );
      } else {
        // ✅ Mobile — use file
        final file = File(_pickedFile!.path);
        url = await CloudinaryService.uploadImage(file);
      }

      setState(() => _uploadedUrl = url);
      return url;
    } catch (e) {
      print("Upload error: $e");
      return null;
    } finally {
      setState(() => _isUploading = false);
    }
  }

  // ================= DATE PICKER =================
  Future<void> _pickDate({required bool isStart}) async {
    final now = DateTime.now();
    final initial = isStart
        ? (startDate ?? now)
        : (endDate ?? startDate ?? now);
    final first = isStart ? now : (startDate ?? now);

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: first,
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          startDate = picked;
          if (endDate != null && endDate!.isBefore(picked)) endDate = null;
        } else {
          endDate = picked;
        }
      });
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return "Not set";
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  // ================= SUBMIT =================
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // ✅ Upload image first if picked
      String? imageUrl;
      if (_pickedFile != null) {
        imageUrl = await _uploadImage();
        if (imageUrl == null) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Image upload failed. Try again.")),
            );
          }
          setState(() => _isLoading = false);
          return;
        }
      }

      final campaign = CampaignModel(
        id: 0,
        title: titleController.text.trim(),
        description: descController.text.trim(),
        status: 'DRAFT',
        goalAmount: double.tryParse(goalController.text.trim()) ?? 0,
        totalAmount: 0,
        donationType: donationType,
        donorCount: 0,
        goalQuantity: 0,
        totalQuantity: 0,
        startDate: startDate,
        endDate: endDate,
        imageUrl: imageUrl, // ✅ new
      );

      final success = await ref
          .read(campaignProvider.notifier)
          .createCampaign(campaign);

      if (!mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Campaign Created Successfully")),
        );
        titleController.clear();
        descController.clear();
        goalController.clear();
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to create campaign")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // ================= IMAGE PREVIEW WIDGET =================
  Widget _buildImagePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Campaign Image (Optional)",
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),

        const SizedBox(height: 8),

        GestureDetector(
          onTap: _pickImage,
          child: Container(
            width: double.infinity,
            height: 180,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: _pickedFile != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: kIsWeb
                        ? Image.network(_pickedFile!.path, fit: BoxFit.cover)
                        : Image.file(
                            File(_pickedFile!.path),
                            fit: BoxFit.cover,
                          ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_photo_alternate_outlined,
                        size: 48,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Tap to select image",
                        style: TextStyle(color: Colors.grey[500]),
                      ),
                    ],
                  ),
          ),
        ),

        // ✅ REMOVE IMAGE BUTTON
        if (_pickedFile != null)
          TextButton.icon(
            onPressed: () => setState(() {
              _pickedFile = null;
              _uploadedUrl = null;
            }),
            icon: const Icon(Icons.clear, color: Colors.red, size: 16),
            label: const Text(
              "Remove image",
              style: TextStyle(color: Colors.red),
            ),
          ),

        // ✅ UPLOADING INDICATOR
        if (_isUploading)
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: Row(
              children: [
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                SizedBox(width: 8),
                Text("Uploading image..."),
              ],
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Campaign")),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // ✅ IMAGE PICKER
                _buildImagePicker(),

                const SizedBox(height: 16),

                // TITLE
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: "Campaign Title",
                  ),
                  validator: (v) => v == null || v.isEmpty ? "Required" : null,
                ),

                const SizedBox(height: 12),

                // DESCRIPTION
                TextFormField(
                  controller: descController,
                  maxLines: 3,
                  decoration: const InputDecoration(labelText: "Description"),
                  validator: (v) => v == null || v.isEmpty ? "Required" : null,
                ),

                const SizedBox(height: 12),

                // GOAL AMOUNT
                TextFormField(
                  controller: goalController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Goal Amount (PKR)",
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return "Goal required";
                    if (double.tryParse(v) == null) return "Enter valid number";
                    return null;
                  },
                ),

                const SizedBox(height: 12),

                // DONATION TYPE
                DropdownButtonFormField<String>(
                  value: donationType,
                  decoration: const InputDecoration(labelText: "Donation Type"),
                  items: const [
                    DropdownMenuItem(value: "MONEY", child: Text("Money")),
                    DropdownMenuItem(value: "ITEMS", child: Text("Items")),
                    DropdownMenuItem(value: "BOTH", child: Text("Both")),
                  ],
                  onChanged: (val) => setState(() => donationType = val!),
                ),

                const SizedBox(height: 12),

                // PRIORITY
                DropdownButtonFormField<String>(
                  value: priority,
                  decoration: const InputDecoration(labelText: "Priority"),
                  items: const [
                    DropdownMenuItem(value: "LOW", child: Text("Low")),
                    DropdownMenuItem(value: "MEDIUM", child: Text("Medium")),
                    DropdownMenuItem(value: "HIGH", child: Text("High")),
                  ],
                  onChanged: (val) => setState(() => priority = val!),
                ),

                const SizedBox(height: 16),

                // START DATE
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.calendar_today, color: Colors.blue),
                  title: const Text("Start Date"),
                  subtitle: Text(_formatDate(startDate)),
                  trailing: startDate != null
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: Colors.red),
                          onPressed: () => setState(() => startDate = null),
                        )
                      : null,
                  onTap: () => _pickDate(isStart: true),
                ),

                const Divider(),

                // END DATE
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.event, color: Colors.red),
                  title: const Text("End Date"),
                  subtitle: Text(_formatDate(endDate)),
                  trailing: endDate != null
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: Colors.red),
                          onPressed: () => setState(() => endDate = null),
                        )
                      : null,
                  onTap: () => _pickDate(isStart: false),
                ),

                const SizedBox(height: 24),

                // SUBMIT
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading || _isUploading ? null : _submit,
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : const Text("Create Campaign"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
