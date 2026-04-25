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

  bool loading = false;

  void createCampaign() async {
    if (!_formKey.currentState!.validate()) return;

    final campaign = CampaignModel(
      title: titleController.text,
      description: descController.text,
      donationType: "MONEY",
      goalAmount: 10000,
    );

    setState(() => loading = true);

    await ref
        .read(campaignProvider.notifier)
        .createCampaign(campaign);

    final state = ref.read(campaignProvider);

    state.whenOrNull(
      data: (_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Campaign Created Successfully")),
        );
        Navigator.pop(context);
      },
      error: (e, _) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      },
    );

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Campaign"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [

                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: "Title",
                  ),
                  validator: (v) =>
                      v == null || v.isEmpty ? "Required" : null,
                ),

                const SizedBox(height: 12),

                TextFormField(
                  controller: descController,
                  decoration: const InputDecoration(
                    labelText: "Description",
                  ),
                  maxLines: 4,
                  validator: (v) =>
                      v == null || v.isEmpty ? "Required" : null,
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: loading ? null : createCampaign,
                    child: loading
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