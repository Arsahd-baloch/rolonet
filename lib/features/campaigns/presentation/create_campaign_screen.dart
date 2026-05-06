import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/campaign_model.dart';
import '../state/campaign_provider.dart';

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

  bool _isLoading = false;

Future<void> createCampaign() async {
  if (!_formKey.currentState!.validate()) return;

  setState(() => _isLoading = true);

  try {
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
    );

    final success = await ref
        .read(campaignProvider.notifier)
        .createCampaign(campaign);

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Campaign Created Successfully")),
      );

      // reset form (IMPORTANT UX)
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error: $e")),
    );
  } finally {
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }
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
                  onChanged: (val) {
                    donationType = val!;
                  },
                ),

                const SizedBox(height: 12),

                // PRIORITY
                DropdownButtonFormField<String>(
                  initialValue: priority,
                  decoration: const InputDecoration(labelText: "Priority"),
                  items: const [
                    DropdownMenuItem(value: "LOW", child: Text("Low")),
                    DropdownMenuItem(value: "MEDIUM", child: Text("Medium")),
                    DropdownMenuItem(value: "HIGH", child: Text("High")),
                  ],
                  onChanged: (val) {
                    priority = val!;
                  },
                ),

                const SizedBox(height: 20),

                // BUTTON
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : createCampaign,
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
