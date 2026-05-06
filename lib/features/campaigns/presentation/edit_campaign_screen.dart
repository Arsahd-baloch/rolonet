// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../domain/campaign_model.dart';
// import '../state/campaign_provider.dart';

// class EditCampaignScreen extends ConsumerStatefulWidget {
//   final CampaignModel campaign;

//   const EditCampaignScreen({super.key, required this.campaign});

//   @override
//   ConsumerState<EditCampaignScreen> createState() => _EditCampaignScreenState();
// }

// class _EditCampaignScreenState extends ConsumerState<EditCampaignScreen> {
//   final _formKey = GlobalKey<FormState>();

//   late TextEditingController titleController;
//   late TextEditingController descController;
//   late TextEditingController goalController;

//   late String donationType;
//   DateTime? startDate; // ✅ new
//   DateTime? endDate; // ✅ new

//   bool _isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     // ✅ Prefill all fields including dates
//     titleController = TextEditingController(text: widget.campaign.title);
//     descController = TextEditingController(text: widget.campaign.description);
//     goalController = TextEditingController(
//       text: widget.campaign.goalAmount.toString(),
//     );
//     donationType = widget.campaign.donationType ?? 'MONEY';
//     startDate = widget.campaign.startDate; // ✅ prefill
//     endDate = widget.campaign.endDate; // ✅ prefill
//   }

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
//           // ✅ reset end date if before new start date
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
//       // ✅ copyWith includes dates
//       final updated = widget.campaign.copyWith(
//         title: titleController.text.trim(),
//         description: descController.text.trim(),
//         goalAmount: double.tryParse(goalController.text.trim()) ?? 0,
//         donationType: donationType,
//         startDate: startDate, // ✅ new
//         endDate: endDate, // ✅ new
//       );

//       final success = await ref
//           .read(campaignProvider.notifier)
//           .updateCampaign(widget.campaign.id, updated);

//       if (!mounted) return;

//       if (success) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Campaign updated successfully")),
//         );
//         Navigator.pop(context);
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Failed to update campaign")),
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
//       appBar: AppBar(title: const Text("Edit Campaign")),
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
//                         : const Text("Update Campaign"),
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

class EditCampaignScreen extends ConsumerStatefulWidget {
  final CampaignModel campaign;

  const EditCampaignScreen({super.key, required this.campaign});

  @override
  ConsumerState<EditCampaignScreen> createState() => _EditCampaignScreenState();
}

class _EditCampaignScreenState extends ConsumerState<EditCampaignScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController titleController;
  late TextEditingController descController;
  late TextEditingController goalController;

  late String donationType;
  DateTime? startDate;
  DateTime? endDate;

  // ✅ IMAGE STATE
  XFile? _pickedFile;
  bool _isUploading = false;
  String? _existingUrl; // ✅ prefilled from campaign

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.campaign.title);
    descController = TextEditingController(text: widget.campaign.description);
    goalController = TextEditingController(
      text: widget.campaign.goalAmount.toString(),
    );
    donationType = widget.campaign.donationType ?? 'MONEY';
    startDate = widget.campaign.startDate;
    endDate = widget.campaign.endDate;
    _existingUrl = widget.campaign.imageUrl; // ✅ prefill existing image
  }

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
      imageQuality: 80,
      maxWidth: 1200,
    );

    if (picked != null) {
      setState(() {
        _pickedFile = picked;
        _existingUrl = null; // ✅ clear old image when new one picked
      });
    }
  }

  // ================= UPLOAD TO CLOUDINARY =================
  Future<String?> _uploadImage() async {
    if (_pickedFile == null) return _existingUrl; // ✅ keep existing if no new

    setState(() => _isUploading = true);

    try {
      String? url;

      if (kIsWeb) {
        final bytes = await _pickedFile!.readAsBytes();
        url = await CloudinaryService.uploadImageBytes(
          bytes,
          _pickedFile!.name,
        );
      } else {
        final file = File(_pickedFile!.path);
        url = await CloudinaryService.uploadImage(file);
      }

      setState(() => _existingUrl = url);
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
      // ✅ upload new image if picked, else keep existing
      String? imageUrl = await _uploadImage();

      if (_pickedFile != null && imageUrl == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Image upload failed. Try again.")),
          );
        }
        setState(() => _isLoading = false);
        return;
      }

      final updated = widget.campaign.copyWith(
        title: titleController.text.trim(),
        description: descController.text.trim(),
        goalAmount: double.tryParse(goalController.text.trim()) ?? 0,
        donationType: donationType,
        startDate: startDate,
        endDate: endDate,
        imageUrl: imageUrl, // ✅ new or existing
      );

      final success = await ref
          .read(campaignProvider.notifier)
          .updateCampaign(widget.campaign.id, updated);

      if (!mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Campaign updated successfully")),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to update campaign")),
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
    // ✅ determine what to show
    final hasNewImage = _pickedFile != null;
    final hasExistingImage = _existingUrl != null && _existingUrl!.isNotEmpty;

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
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: hasNewImage
                  // ✅ show newly picked image
                  ? kIsWeb
                        ? Image.network(_pickedFile!.path, fit: BoxFit.cover)
                        : Image.file(File(_pickedFile!.path), fit: BoxFit.cover)
                  : hasExistingImage
                  // ✅ show existing cloudinary image
                  ? Image.network(
                      _existingUrl!,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return const Center(child: CircularProgressIndicator());
                      },
                      errorBuilder: (context, error, _) =>
                          const Center(child: Icon(Icons.broken_image)),
                    )
                  // ✅ no image yet
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
        ),

        // ✅ REMOVE IMAGE BUTTON
        if (hasNewImage || hasExistingImage)
          TextButton.icon(
            onPressed: () => setState(() {
              _pickedFile = null;
              _existingUrl = null;
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
      appBar: AppBar(title: const Text("Edit Campaign")),
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
                        : const Text("Update Campaign"),
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
