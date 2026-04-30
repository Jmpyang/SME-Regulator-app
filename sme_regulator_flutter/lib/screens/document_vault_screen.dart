import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import '../providers/document_provider.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/dashed_border_painter.dart';
import '../widgets/app_drawer.dart';
import '../core/theme.dart';

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
      context.read<DocumentProvider>().startSync();
    });
  }

  @override
  void dispose() {
    context.read<DocumentProvider>().stopSync();
    super.dispose();
  }

  void _showUploadBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _UploadBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DocumentProvider>();
    final documents = provider.documents;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: const CustomAppBar(title: 'Document Vault'),
      drawer: const AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () async => await context.read<DocumentProvider>().loadDocuments(),
        child: provider.isLoading && documents.isEmpty
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
                          onPressed: () => context.read<DocumentProvider>().loadDocuments(),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  )
                : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Upload Card
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: InkWell(
                              onTap: _showUploadBottomSheet,
                              borderRadius: BorderRadius.circular(12),
                              child: CustomPaint(
                                painter: DashedBorderPainter(
                                  color: Colors.grey.shade300,
                                  strokeWidth: 1.5,
                                  dashWidth: 6,
                                  dashSpace: 4,
                                  borderRadius: 12,
                                ),
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(32),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.cloud_upload_outlined,
                                        size: 48,
                                        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        'Tap to upload documents',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Supported formats: PDF, PNG, JPG',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),

                          if (provider.error != null)
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              margin: const EdgeInsets.only(bottom: 24),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.errorContainer,
                                border: Border.all(color: Theme.of(context).colorScheme.error),
                                borderRadius: AppTheme.kCardRadius,
                              ),
                              child: Text(
                                provider.error!,
                                style: TextStyle(color: Theme.of(context).colorScheme.onError),
                              ),
                            ),

                          const SizedBox(height: 24),

                          // Records Card
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              borderRadius: AppTheme.kCardRadius,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Your Records',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w900,
                                          color: Color(0xFF111827),
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Colors.grey.shade300),
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                        child: Text(
                                          '${documents.length} FILES',
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey.shade500,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(height: 1, color: Colors.grey.shade200),

                                if (documents.isEmpty)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 80.0),
                                    child: Center(
                                      child: Column(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(16),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFF9FAFB),
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: Icon(
                                              Icons.insert_drive_file_outlined,
                                              color: Colors.grey.shade300,
                                              size: 40,
                                            ),
                                          ),
                                          const SizedBox(height: 24),
                                          const Text(
                                            'No documents found.',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w900,
                                              fontSize: 16,
                                              color: Color(0xFF111827),
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            'Your compliance files will appear here once uploaded.',
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
                                      return ListTile(
                                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                        leading: Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFEEF2FF),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: const Icon(Icons.description, color: Color(0xFF4F46E5)),
                                        ),
                                        title: Text(
                                          doc.title,
                                          style: const TextStyle(fontWeight: FontWeight.bold),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        subtitle: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              doc.uploadedAt.toLocal().toString().split(' ')[0],
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 4),
                                            _buildStatusChip(doc.status),
                                          ],
                                        ),
                                        trailing: IconButton(
                                          icon: const Icon(Icons.download_rounded, color: Colors.blueGrey),
                                          onPressed: () {
                                            // Call download method
                                          },
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
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color backgroundColor;
    Color textColor;
    String text;
    IconData? icon;

    switch (status.toUpperCase()) {
      case 'PROCESSING':
        backgroundColor = Colors.amber.shade100;
        textColor = Colors.amber.shade800;
        text = 'Scanning...';
        icon = Icons.hourglass_empty;
        break;
      case 'VERIFIED':
        backgroundColor = Colors.green.shade100;
        textColor = Colors.green.shade800;
        text = 'Verified ✓';
        icon = Icons.check_circle;
        break;
      case 'MANUAL_REVIEW':
        backgroundColor = Colors.red.shade100;
        textColor = Colors.red.shade800;
        text = 'Action Required';
        icon = Icons.warning;
        break;
      case 'FAILED':
        backgroundColor = Colors.red.shade100;
        textColor = Colors.red.shade800;
        text = 'Scan Failed';
        icon = Icons.error;
        break;
      default:
        backgroundColor = Colors.grey.shade100;
        textColor = Colors.grey.shade800;
        text = 'Processing';
        icon = Icons.hourglass_empty;
    }

    return GestureDetector(
      onTap: status.toUpperCase() == 'MANUAL_REVIEW' ? _showManualReviewBottomSheet : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 12, color: textColor),
            const SizedBox(width: 4),
            Text(
              text,
              style: TextStyle(
                color: textColor,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showManualReviewBottomSheet() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Manual review feature coming soon')),
    );
  }
}

class _UploadBottomSheet extends StatefulWidget {
  @override
  State<_UploadBottomSheet> createState() => _UploadBottomSheetState();
}

class _UploadBottomSheetState extends State<_UploadBottomSheet> {
  final _titleController = TextEditingController();
  String? _selectedType;
  PlatformFile? _pickedFile;
  bool _isUploading = false;

  final List<String> _documentTypes = [
    'Business License',
    'Tax Certificate',
    'Permit',
    'Certificate',
    'Other',
  ];

  bool _isFormValid() => 
      _titleController.text.trim().isNotEmpty && 
      _selectedType != null && 
      _pickedFile != null;

  Future<void> _pickFile() async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'png', 'jpg', 'jpeg'],
    );
    if (result != null) {
      setState(() => _pickedFile = result.files.single);
    }
  }

  Future<void> _handleUpload() async {
    if (!_isFormValid()) return;

    setState(() => _isUploading = true);
    
    try {
      // Use the provider instead of a local Dio instance
      final provider = context.read<DocumentProvider>();
      
      // Assuming your provider has an upload method that calls DocumentService
      await provider.uploadDocument(
        title: _titleController.text.trim(),
        documentType: _selectedType!,
        pickedFile: _pickedFile!,
      );

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Document uploaded successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Upload failed: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 20, right: 20, top: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Upload Document', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          TextField(
            controller: _titleController,
            onChanged: (_) => setState(() {}), // Refresh UI to validate button
            decoration: const InputDecoration(labelText: 'Document Title', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            initialValue: _selectedType,
            decoration: const InputDecoration(labelText: 'Document Type', border: OutlineInputBorder()),
            items: _documentTypes.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
            onChanged: (val) => setState(() => _selectedType = val),
          ),
          const SizedBox(height: 16),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.attach_file),
            title: Text(_pickedFile == null ? 'No file selected' : _pickedFile!.name),
            trailing: TextButton(onPressed: _pickFile, child: const Text('Browse')),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isFormValid() && !_isUploading ? _handleUpload : null,
              child: _isUploading 
                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2)) 
                : const Text('Upload to Vault'),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }
}