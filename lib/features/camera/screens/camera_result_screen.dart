import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:saturday_firebase_project/features/camera/widgets/filter_selector.dart';

class CameraResultScreen extends StatefulWidget {
  final String imagePath;
  final Color initialFilter;

  const CameraResultScreen({
    super.key,
    required this.imagePath,
    this.initialFilter = Colors.white,
  });

  @override
  State<CameraResultScreen> createState() => _CameraResultScreenState();
}

class _CameraResultScreenState extends State<CameraResultScreen> {
  late Color _selectedFilter;
  late img.Image _originalImage;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _selectedFilter = widget.initialFilter;
    _loadOriginalImage();
  }

  Future<void> _loadOriginalImage() async {
    final bytes = await File(widget.imagePath).readAsBytes();
    _originalImage = img.decodeImage(bytes)!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hasil Foto')),
      body: Stack(
        children: [
          _buildFilteredPreview(),
          _buildFilterSelector(),
        ],
      ),
      floatingActionButton: _buildSaveButton(),
    );
  }

  Widget _buildFilteredPreview() {
    return ColorFiltered(
      colorFilter: ColorFilter.mode(
        _selectedFilter.withOpacity(0.5),
        BlendMode.hardLight,
      ),
      child: Image.file(File(widget.imagePath), fit: BoxFit.cover),
    );
  }

  Widget _buildFilterSelector() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: FilterSelector(
        filters: _getAvailableFilters(),
        onFilterChanged: (color) => setState(() => _selectedFilter = color),
      ),
    );
  }

  Widget _buildSaveButton() {
    return FloatingActionButton.extended(
      onPressed: _isProcessing ? null : _saveFilteredImage,
      icon: _isProcessing
          ? const CircularProgressIndicator(color: Colors.white)
          : const Icon(Icons.save_alt),
      label: Text(_isProcessing ? 'Menyimpan...' : 'Simpan ke Galeri'),
    );
  }

  Future<void> _saveFilteredImage() async {
    setState(() => _isProcessing = true);

    try {
      final filteredImage = _applyFilter(_selectedFilter);
      final appDir = await getExternalStorageDirectory();
      final fileName = 'FILTERED_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final path = '${appDir!.path}/$fileName';

      await File(path).writeAsBytes(img.encodeJpg(filteredImage));

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Foto tersimpan di: $path')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  img.Image _applyFilter(Color filterColor) {
    final overlay = img.Image.from(_originalImage);
    img.fillRect(overlay,
        x1: 0,
        y1: 0,
        x2: overlay.width,
        y2: overlay.height,
        color: img.ColorRgba8(
          filterColor.red,
          filterColor.green,
          filterColor.blue,
          (filterColor.alpha * 255)
              .toInt(), // Correct alpha calculation for fillRect
        ));

    return img.compositeImage(
      _originalImage,
      overlay,
      blend: img.BlendMode.hardLight,
    );
  }

  List<Color> _getAvailableFilters() => [
        Colors.white,
        ...Colors.primaries.map((color) => color.withOpacity(0.7)),
      ];
}
