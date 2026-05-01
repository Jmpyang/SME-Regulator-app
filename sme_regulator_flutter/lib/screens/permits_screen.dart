import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import '../models/document_model.dart';
import '../providers/document_provider.dart';
import '../widgets/custom_app_bar.dart';

/// Filters documents to show only those relevant to permits and licenses
List<DocumentModel> documentsForPermitsView(List<DocumentModel> all) {
  final keywords = ['permit', 'license', 'cert', 'regulatory', 'tax', 'business'];
  final matched = all.where((d) {
    final t = d.type.toLowerCase();
    final title = d.title.toLowerCase();
    return keywords.any((k) => t.contains(k) || title.contains(k));
  }).toList();
  return matched;
}

class PermitsScreen extends StatefulWidget {
  const PermitsScreen({super.key});

  @override
  State<PermitsScreen> createState() => _PermitsScreenState();
}

class _PermitsScreenState extends State<PermitsScreen> {
  bool _hasLoaded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DocumentProvider>().loadDocuments().then((_) {
        if (mounted) setState(() => _hasLoaded = true);
      }).catchError((_) {
        if (mounted) setState(() => _hasLoaded = true);
      });
    });
  }

  Future<void> _uploadPermit() async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => const _UploadDialog(),
    );
    
    if (result == null || !mounted) return;
    
    final title = result['title'] as String?;
    final documentType = result['documentType'] as String?;
    final pickedFile = result['pickedFile'] as PlatformFile?;
    
    if (title == null || title.isEmpty || documentType == null || pickedFile == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill all fields and select a file')),
        );
      }
      return;
    }
    
    try {
      await context.read<DocumentProvider>().uploadDocument(
        title: title,
        documentType: documentType,
        pickedFile: pickedFile,
      );
      if (!mounted) return;
      
      // Show email notification feedback
      final emailStatus = context.read<DocumentProvider>().emailNotificationStatus;
      if (emailStatus == 'failed') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Document uploaded successfully, but email notification failed'),
            backgroundColor: Colors.orange,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Permit uploaded successfully')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Upload failed: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DocumentProvider>();
    final documents = documentsForPermitsView(provider.documents);
    final bool useTableLayout = MediaQuery.sizeOf(context).width >= 600;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      appBar: const CustomAppBar(title: 'Permits'),
      body: RefreshIndicator(
              onRefresh: () async {
                setState(() => _hasLoaded = false);
                await provider.loadDocuments();
                if (mounted) setState(() => _hasLoaded = true);
              },
              child: !_hasLoaded
                  ? const Center(child: CircularProgressIndicator())
                  : provider.error != null && documents.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.error_outline,
                                size: 64,
                                color: Theme.of(context).colorScheme.error,
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () => provider.loadDocuments(),
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        )
          : SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(),
                      const SizedBox(height: 32),
                      if (provider.error != null) _buildErrorBanner(provider.error!),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            )
                          ],
                        ),
                        child: _buildDocumentList(documents, useTableLayout),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Regulatory Permits',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
              ),
              Text(
                'Live tracking of your compliance status.',
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
            ],
          ),
        ),
        ElevatedButton.icon(
          onPressed: _uploadPermit,
          icon: const Icon(Icons.add),
          label: const Text('New Upload'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildDocumentList(List<DocumentModel> documents, bool useTable) {
    if (documents.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 60),
        child: Center(child: Text('No permits found. Upload one to begin.')),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: documents.length,
      separatorBuilder: (_, __) => Divider(height: 1, color: Colors.grey.shade100),
      itemBuilder: (context, index) {
        final doc = documents[index];
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          title: Text(doc.title, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text('${doc.type} • ${doc.uploadedAt.toString().split(' ')[0]}'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildStatusBadge(doc.status),
              const SizedBox(width: 8),
              const Icon(Icons.chevron_right),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    switch (status.toLowerCase()) {
      case 'verified': color = Colors.green; break;
      case 'pending': color = Colors.orange; break;
      case 'expired': color = Colors.red; break;
      default: color = Colors.blueGrey;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildErrorBanner(String message) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(8)),
      child: Text(message, style: TextStyle(color: Colors.red.shade900)),
    );
  }
}

class _UploadDialog extends StatefulWidget {
  const _UploadDialog();
  @override
  State<_UploadDialog> createState() => _UploadDialogState();
}

class _UploadDialogState extends State<_UploadDialog> {
  final _titleController = TextEditingController();
  String _selectedType = 'Permit';
  PlatformFile? _pickedFile;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Upload Permit'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: 'Document Title'),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            initialValue: _selectedType,
            items: ['Permit', 'License', 'Certificate', 'Tax Compliance']
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (v) => setState(() => _selectedType = v!),
            decoration: const InputDecoration(labelText: 'Category'),
          ),
          const SizedBox(height: 16),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.attach_file),
            title: Text(_pickedFile == null ? 'No file selected' : _pickedFile!.name),
            trailing: TextButton(
              onPressed: () async {
                final result = await FilePicker.pickFiles(
                  type: FileType.custom,
                  allowedExtensions: ['pdf', 'png', 'jpg', 'jpeg'],
                );
                if (result != null) {
                  setState(() => _pickedFile = result.files.single);
                }
              },
              child: const Text('Browse'),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () {
            if (_titleController.text.isNotEmpty && _pickedFile != null) {
              Navigator.pop(context, {
                'title': _titleController.text,
                'documentType': _selectedType,
                'pickedFile': _pickedFile,
              });
            }
          },
          child: const Text('Confirm'),
        ),
      ],
    );
  }
}