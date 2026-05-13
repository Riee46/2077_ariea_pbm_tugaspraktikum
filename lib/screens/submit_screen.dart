import 'package:flutter/material.dart';
import '../services/api_service.dart';

class SubmitScreen extends StatefulWidget {
  const SubmitScreen({super.key});

  @override
  State<SubmitScreen> createState() => _SubmitScreenState();
}

class _SubmitScreenState extends State<SubmitScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descController = TextEditingController();
  final _githubController = TextEditingController();
  final _apiService = ApiService();
  bool _isLoading = false;

  Future<void> _submitAssignment() async {
    // Validasi form
    if (!_formKey.currentState!.validate()) return;

    // Ambil dan validasi harga
    final name = _nameController.text.trim();
    final price = int.tryParse(_priceController.text.trim());
    if (price == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Harga harus angka'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    final description = _descController.text.trim();
    final githubUrl = _githubController.text.trim();

    setState(() => _isLoading = true);

    try {
      final success = await _apiService.submitAssignment(
        name: name,
        price: price,
        description: description,
        githubUrl: githubUrl,
      );

      setState(() => _isLoading = false);

      if (success) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Tugas berhasil disubmit!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('❌ Submit gagal. Cek kembali data.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Submit Tugas',
          style: TextStyle(fontWeight: FontWeight.w700, color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.amber[50],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.amber[800]),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Pastikan data benar. Data tidak dapat diubah setelah disubmit.',
                      style: TextStyle(
                        color: Colors.amber[900],
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Nama Produk (Final)',
                floatingLabelBehavior: FloatingLabelBehavior.never,
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
              validator: (value) =>
                  value == null || value.isEmpty ? 'Nama produk wajib' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _priceController,
              decoration: InputDecoration(
                labelText: 'Harga (Rupiah)',
                floatingLabelBehavior: FloatingLabelBehavior.never,
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) return 'Harga wajib';
                if (int.tryParse(value) == null) return 'Harus angka';
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descController,
              decoration: InputDecoration(
                labelText: 'Deskripsi',
                floatingLabelBehavior: FloatingLabelBehavior.never,
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
              maxLines: 3,
              validator: (value) =>
                  value == null || value.isEmpty ? 'Deskripsi wajib' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _githubController,
              decoration: InputDecoration(
                labelText: 'URL GitHub Repository',
                hintText: 'https://github.com/username/repo',
                hintStyle: TextStyle(color: Colors.grey[400]),
                floatingLabelBehavior: FloatingLabelBehavior.never,
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) return 'URL GitHub wajib';
                if (!value.startsWith('https://github.com/')) {
                  return 'Harus dimulai dengan https://github.com/';
                }
                return null;
              },
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _isLoading ? null : _submitAssignment,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent[700],
                foregroundColor: Colors.white,
                elevation: 0,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      'Submit Sekarang',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
