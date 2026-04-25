import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reliefnet/features/campaigns/domain/campaign_model.dart';
import 'package:reliefnet/features/campaigns/state/campaign_provider.dart';

class CreateCampaignScreen extends ConsumerStatefulWidget {
  const CreateCampaignScreen({super.key});

  @override
  ConsumerState<CreateCampaignScreen> createState() =>
      _CreateCampaignScreenState();
}

class _CreateCampaignScreenState
    extends ConsumerState<CreateCampaignScreen> {
  final _formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final descController = TextEditingController();
  final amountController = TextEditingController();

  String donationType = "MONEY";

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(campaignProvider);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Create Campaign",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: "Title"),
                  validator: (v) =>
                      v!.isEmpty ? "Title required" : null,
                ),

                const SizedBox(height: 12),

                TextFormField(
                  controller: descController,
                  decoration: const InputDecoration(labelText: "Description"),
                  maxLines: 3,
                  validator: (v) =>
                      v!.isEmpty ? "Description required" : null,
                ),

                const SizedBox(height: 12),

                TextFormField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration:
                      const InputDecoration(labelText: "Goal Amount"),
                ),

                const SizedBox(height: 12),

                DropdownButtonFormField(
                  initialValue: donationType,
                  items: const [
                    DropdownMenuItem(
                        value: "MONEY", child: Text("Money")),
                    DropdownMenuItem(
                        value: "ITEMS", child: Text("Items")),
                    DropdownMenuItem(
                        value: "BOTH", child: Text("Both")),
                  ],
                  onChanged: (val) {
                    donationType = val!;
                  },
                  decoration:
                      const InputDecoration(labelText: "Donation Type"),
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: state.isLoading
                        ? null
                        : () async {
                            if (!_formKey.currentState!.validate()) return;

                            final success = await ref
                                .read(campaignProvider.notifier)
                                .createCampaign(CampaignModel(
                              title: titleController.text,
                              description: descController.text,
                              donationType: donationType,
                              goalAmount:
                                  double.tryParse(amountController.text) ?? 0,
                            ));

                            if (!context.mounted) return;

                            if (success) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Campaign Created"),
                                ),
                              );
                              Navigator.pop(context);
                            }
                          },
                    child: state.isLoading
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