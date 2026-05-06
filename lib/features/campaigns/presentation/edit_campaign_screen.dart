import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/campaign_model.dart';
import '../state/campaign_provider.dart';

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
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // ✅ Prefill form with existing campaign data
    titleController = TextEditingController(text: widget.campaign.title);
    descController  = TextEditingController(text: widget.campaign.description);
    goalController  = TextEditingController(text: widget.campaign.goalAmount.toString());
    donationType    = widget.campaign.donationType ?? 'MONEY';
  }

  @override
  void dispose() {
    titleController.dispose();
    descController.dispose();
    goalController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // ✅ Use copyWith to update only changed fields
      final updated = widget.campaign.copyWith(
        title:        titleController.text.trim(),
        description:  descController.text.trim(),
        goalAmount:   double.tryParse(goalController.text.trim()) ?? 0,
        donationType: donationType,
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
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
                // TITLE
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: "Campaign Title"),
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
                  decoration: const InputDecoration(labelText: "Goal Amount (PKR)"),
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
                    DropdownMenuItem(value: "BOTH",  child: Text("Both")),
                  ],
                  onChanged: (val) => setState(() => donationType = val!),
                ),

                const SizedBox(height: 24),

                // SUBMIT BUTTON
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submit,
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