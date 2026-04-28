import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/document_model.dart';
import '../providers/document_provider.dart';
import '../widgets/custom_app_bar.dart';
import '../core/constants.dart';

/// Prefer permit-like [DocumentModel.type] values; if none match, show full vault list.
List<DocumentModel> documentsForPermitsView(List<DocumentModel> all) {
  final keywords = ['permit', 'license', 'cert', 'regulatory'];
  final matched = all.where((d) {
    final t = d.type.toLowerCase();
    return keywords.any((k) => t.contains(k));
  }).toList();
  return matched.isNotEmpty ? matched : all;
}

class PermitsScreen extends StatefulWidget {
  const PermitsScreen({super.key});

  @override
  State<PermitsScreen> createState() => _PermitsScreenState();
}

class _PermitsScreenState extends State<PermitsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DocumentProvider>().loadDocuments();
    });
  }

  Future<void> _uploadPermit() async {
    // Show dialog for title and document type input
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) => _UploadDialog(),
    );
    
    if (result == null || !mounted) return;
    
    try {
      await context.read<DocumentProvider>().uploadDocument(
        title: result['title']!,
        documentType: result['documentType']!,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permit uploaded successfully')),
      );
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
    final bool useTableLayout = MediaQuery.sizeOf(context).width >= 560;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      appBar: const CustomAppBar(title: 'Permits'),
      body: provider.isLoading && documents.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Page Title Area
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Regulatory Permits',
                                    style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.w900,
                                      color: Color(0xFF111827),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Live tracking of your compliance status.',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade600,
                                    ),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.white,
                              ),
                              child: IconButton(
                                icon: Icon(Icons.refresh, color: Colors.grey.shade600),
                                onPressed: () {
                                  context.read<DocumentProvider>().loadDocuments();
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton.icon(
                            style: TextButton.styleFrom(
                              backgroundColor: const Color(0xFF4F46E5),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: _uploadPermit,
                            icon: const Icon(Icons.add, size: 20),
                            label: const Text(
                              'New Upload',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Error Banner
                    if (provider.error != null)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.only(bottom: 24),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF2F2),
                          border: Border.all(color: const Color(0xFFFCA5A5)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.warning_amber_rounded, color: Color(0xFFDC2626), size: 20),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                provider.error!,
                                style: const TextStyle(
                                  color: Color(0xFFDC2626),
                                  fontWeight: FontWeight.w900,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                    // Permits Table Card
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Table Header (wide layout only)
                          if (useTableLayout) ...[
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: _buildColumnHeader('DOCUMENT TITLE'),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: _buildColumnHeader('TYPE'),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: _buildColumnHeader('UPLOADED DATE'),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: _buildColumnHeader('STATUS'),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: _buildColumnHeader('ACTIONS'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Divider(height: 1, color: Colors.grey.shade200),
                          ],
                          
                          // States
                          if (documents.isEmpty)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 80.0),
                              child: Center(
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.find_in_page_outlined,
                                      color: Colors.grey.shade300,
                                      size: 48,
                                    ),
                                    const SizedBox(height: 24),
                                    const Text(
                                      'No active permits',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w900,
                                        fontSize: 16,
                                        color: Color(0xFF111827),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Upload your compliance documents to start tracking.',
                                      style: TextStyle(
                                        color: Colors.grey.shade500,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          else
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: documents.length,
                              separatorBuilder: (context, index) => Divider(height: 1, color: Colors.grey.shade200),
                              itemBuilder: (context, index) {
                                final doc = documents[index];
                                if (!useTableLayout) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          doc.title,
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          doc.type.isNotEmpty ? doc.type : 'General',
                                          style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          doc.uploadedAt.toLocal().toString().split(' ')[0],
                                          style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                                        ),
                                        const SizedBox(height: 8),
                                        Wrap(
                                          spacing: 8,
                                          runSpacing: 8,
                                          crossAxisAlignment: WrapCrossAlignment.center,
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFD1FAE5),
                                                borderRadius: BorderRadius.circular(16),
                                              ),
                                              child: const Text(
                                                'ACTIVE',
                                                style: TextStyle(
                                                  color: Color(0xFF059669),
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w900,
                                                ),
                                              ),
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.download_rounded, color: Colors.blueGrey),
                                              onPressed: () {},
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                }
                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          doc.title,
                                          style: const TextStyle(fontWeight: FontWeight.bold),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          doc.type.isNotEmpty ? doc.type : 'General',
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          doc.uploadedAt.toLocal().toString().split(' ')[0],
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFD1FAE5),
                                              borderRadius: BorderRadius.circular(16),
                                            ),
                                            child: const Text(
                                              'ACTIVE',
                                              style: TextStyle(
                                                color: Color(0xFF059669),
                                                fontSize: 10,
                                                fontWeight: FontWeight.w900,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: IconButton(
                                            icon: const Icon(Icons.download_rounded, color: Colors.blueGrey),
                                            onPressed: () {},
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildColumnHeader(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w900,
        color: Colors.blueGrey.shade400,
        letterSpacing: 1.0,
      ),
    );
  }
}

class _UploadDialog extends StatefulWidget {
  @override
  __UploadDialogState createState() => __UploadDialogState();
}

class __UploadDialogState extends State<_UploadDialog> {
  final _titleController = TextEditingController();
  String _selectedDocumentType = 'Permit';
  
  final List<String> _documentTypes = [
    'Permit',
    'License',
    'Certificate',
    'Registration',
    ...kBusinessTypes,
  ];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Upload Document'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Document Title',
              hintText: 'Enter document title',
            ),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _selectedDocumentType,
            decoration: const InputDecoration(
              labelText: 'Document Type',
            ),
            items: _documentTypes
                .map((type) => DropdownMenuItem(
                      value: type,
                      child: Text(type),
                    ))
                .toList(),
            onChanged: (value) {
              setState(() {
                _selectedDocumentType = value!;
              });
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_titleController.text.isNotEmpty) {
              Navigator.of(context).pop({
                'title': _titleController.text,
                'documentType': _selectedDocumentType,
              });
            }
          },
          child: const Text('Upload'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }
}
