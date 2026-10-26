import 'package:flutter/material.dart';

enum ReportUiState { idle, loading, success, empty, error }

class ReportFormScreen extends StatefulWidget {
  const ReportFormScreen({super.key});

  @override
  State<ReportFormScreen> createState() => _ReportFormScreenState();
}

class _ReportFormScreenState extends State<ReportFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();

  ReportUiState _uiState = ReportUiState.idle;
  bool _simulateFailure = false;

  Future<void> submitReport() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _uiState = ReportUiState.loading);

    try {
      await Future<void>.delayed(const Duration(seconds: 3));
      if (_simulateFailure) throw Exception('Simulated failure');
      if (!mounted) return;
      setState(() => _uiState = ReportUiState.success);
    } catch (_) {
      if (!mounted) return;
      setState(() => _uiState = ReportUiState.error);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Submit Report Form')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: _buildBodyBasedOnState(),
          ),
        ),
      ),
    );
  }

  Widget _buildBodyBasedOnState() {
    switch (_uiState) {
      case ReportUiState.loading:
        return const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Submitting your report, please wait...'),
          ],
        );

      case ReportUiState.success:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 64),
            const SizedBox(height: 16),
            const Text(
              'Success! Report submitted successfully.',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => setState(() => _uiState = ReportUiState.idle),
              child: const Text('Submit Another Report'),
            ),
          ],
        );

      case ReportUiState.empty:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.inbox, color: Colors.grey, size: 64),
            const SizedBox(height: 16),
            const Text(
              'No report records found.',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => setState(() => _uiState = ReportUiState.idle),
              child: const Text('Create a Report'),
            ),
          ],
        );

      case ReportUiState.error:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, color: Colors.red, size: 64),
            const SizedBox(height: 16),
            const Text(
              'Failed to submit report. Please try again.',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 24),
            ElevatedButton(onPressed: submitReport, child: const Text('Retry')),
          ],
        );

      case ReportUiState.idle:
      default:
        return Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Report Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter a title'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter a description'
                    : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Checkbox(
                    value: _simulateFailure,
                    onChanged: (val) =>
                        setState(() => _simulateFailure = val ?? false),
                  ),
                  const Text('Simulate Error on Submit'),
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: submitReport,
                child: const Text('Submit Report'),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => setState(() => _uiState = ReportUiState.empty),
                child: const Text('Preview Empty State'),
              ),
            ],
          ),
        );
    }
  }
}
