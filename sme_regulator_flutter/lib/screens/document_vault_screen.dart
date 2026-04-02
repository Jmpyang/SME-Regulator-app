import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import '../providers/document_provider.dart';

class DocumentVaultScreen extends StatefulWidget {
  const DocumentVaultScreen({super.key});

  @override
  State<DocumentVaultScreen> createState() => _DocumentVaultScreenState();
}

class _DocumentVaultScreenState extends State<DocumentVaultScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DocumentProvider>().loadDocuments();
    });
  }

  void _uploadDocument() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      if (mounted) {
        // Simplified upload logic
        PlatformFile file = result.files.first;
        final success = await context.read<DocumentProvider>().uploadDocument(file, file.name);
        if (success && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Upload successful')));
        } else if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Upload failed')));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DocumentProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Document Vault')),
      body: provider.isLoading && provider.documents.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: provider.loadDocuments,
              child: ListView.builder(
                itemCount: provider.documents.length,
                itemBuilder: (context, index) {
                  final doc = provider.documents[index];
                  return ListTile(
                    leading: const Icon(Icons.description),
                    title: Text(doc.title),
                    subtitle: Text(doc.uploadedAt.toLocal().toString().split(' ')[0]),
                    trailing: IconButton(
                      icon: const Icon(Icons.download),
                      onPressed: () {
                        // Implement document download logic
                      },
                    ),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _uploadDocument,
        child: const Icon(Icons.add),
      ),
    );
  }
}
