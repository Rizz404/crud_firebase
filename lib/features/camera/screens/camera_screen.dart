import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:saturday_firebase_project/features/camera/screens/camera_result_screen.dart';
import 'package:saturday_firebase_project/features/camera/widgets/filter_selector.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen>
    with WidgetsBindingObserver {
  List<CameraDescription> _cameras = [];
  CameraController? _cameraController;
  String? _errorMessage;
  Color _currentFilter = Colors.white;
  bool _isCapturing = false;

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();

      if (_cameras.isEmpty) {
        setState(() {
          _errorMessage = "No camera available";
        });
        return;
      }

      _cameraController = CameraController(
        _cameras.first,
        ResolutionPreset.max,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

      await _cameraController!.initialize();

      if (mounted) {
        setState(() {});
      }
    } on CameraException catch (e) {
      _handleCameraError(e);
    } catch (e) {
      _handleGenericError(e);
    }
  }

  void _handleCameraError(CameraException e) {
    setState(() {
      _errorMessage = 'Error kamera: ${e.description}';
    });
    debugPrint(_errorMessage);
  }

  void _handleGenericError(dynamic e) {
    setState(() {
      _errorMessage = 'Error: ${e.toString()}';
    });
    debugPrint(_errorMessage);
  }

  Future<void> _takePicture() async {
    if (!_cameraController!.value.isInitialized || _isCapturing) return;

    setState(() {
      _isCapturing = true;
    });

    try {
      final XFile picture = await _cameraController!.takePicture();
      _navigateToImageResultScreen(picture);
    } catch (e) {
      _handleGenericError(e);
    } finally {
      if (mounted) {
        setState(() {
          _isCapturing = false;
        });
      }
    }
  }

  void _navigateToImageResultScreen(XFile image) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CameraResultScreen(
          imagePath: image.path,
          initialFilter: _currentFilter,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.paused) {
      _cameraController?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    }

    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Camera'),
        backgroundColor: Colors.black.withOpacity(0.3),
        elevation: 0,
      ),
      body: _buildCameraContent(),
    );
  }

  Widget _buildCameraContent() {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return Stack(
      children: [
        _buildCameraPreviewWithFilter(),
        _buildFilterSelectorWithCapture(),
        if (_isCapturing)
          Container(
            color: Colors.black.withOpacity(0.3),
            child: const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          ),
      ],
    );
  }

  Widget _buildCameraPreviewWithFilter() {
    return ColorFiltered(
      colorFilter: ColorFilter.mode(
        _currentFilter.withOpacity(0.5),
        BlendMode.hardLight,
      ),
      child: CameraPreview(_cameraController!),
    );
  }

  Widget _buildFilterSelectorWithCapture() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: const EdgeInsets.only(bottom: 40),
        child: FilterSelector(
          filters: _getAvailableFilters(),
          onFilterChanged: (color) => setState(() => _currentFilter = color),
          onFilterTap: _takePicture,
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }

  List<Color> _getAvailableFilters() => [
        Colors.white,
        ...Colors.primaries.map((color) => color.withOpacity(0.7)),
      ];
}
