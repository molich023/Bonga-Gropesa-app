// lib/screens/kyc_screen.dart
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:bonga_gropesa/services/supabase_service.dart';

class KYCScreen extends StatefulWidget {
  final String userId;
  const KYCScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _KYCScreenState createState() => _KYCScreenState();
}

class _KYCScreenState extends State<KYCScreen> {
  XFile? _imageFile;
  final _supabase = SupabaseService();
  bool _isLoading = false;

  Future<void> _takePhoto() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() => _imageFile = image);
    }
  }

  Future<void> _submitKYC() async {
    if (_imageFile == null) return;
    setState(() => _isLoading = true);

    try {
      final bytes = await _imageFile!.readAsBytes();
      final base64Image = base64Encode(bytes);

      final result = await _supabase.submitKYC(
        userId: widget.userId,
        imageBase64: base64Image,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('KYC submitted! Liveness: ${result['liveness_confidence']}')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('KYC Verification')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_imageFile != null)
              Image.memory(
                _imageFile!.readAsBytesSync(),
                height: 200,
              )
            else
              const Text('No image selected'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _takePhoto,
              child: const Text('Take Selfie'),
            ),
            const SizedBox(height: 20),
            if (_imageFile != null)
              ElevatedButton(
                onPressed: _isLoading ? null : _submitKYC,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Submit KYC'),
              ),
          ],
        ),
      ),
    );
  }
}
