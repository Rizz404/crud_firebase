import 'package:flutter/material.dart';
import 'package:saturday_firebase_project/features/mahasiswa/model/mahasiswa_model.dart';
import 'package:saturday_firebase_project/features/mahasiswa/repositories/mahasiswa_repository.dart';
import 'package:saturday_firebase_project/features/mahasiswa/screens/mahasiswa_screen.dart';
import 'package:uuid/uuid.dart';

class MahasiswaUpsertScreen extends StatefulWidget {
  final MahasiswaModel? selectedMahasiswa;

  const MahasiswaUpsertScreen({super.key, this.selectedMahasiswa});

  @override
  State<MahasiswaUpsertScreen> createState() => _MahasiswaUpsertScreenState();
}

class _MahasiswaUpsertScreenState extends State<MahasiswaUpsertScreen> {
  final MahasiswaRepository _repository = MahasiswaRepository();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _nimController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;

  @override
  void initState() {
    if (widget.selectedMahasiswa != null) {
      _nameController.text = widget.selectedMahasiswa!.name;
      _nimController.text = widget.selectedMahasiswa!.nim;
    }
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nimController.dispose();
    super.dispose();
  }

  void _clearForm() {
    _nameController.clear();
    _nimController.clear();
  }

  Future<void> _saveMahasiswa() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });
    try {
      final mahasiswa = MahasiswaModel(
        id: widget.selectedMahasiswa?.id ?? const Uuid().v4(),
        name: _nameController.text.trim(),
        nim: _nimController.text.trim(),
      );

      if (widget.selectedMahasiswa != null) {
        await _repository.updateMahasiswa(
            widget.selectedMahasiswa!.id, mahasiswa);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Mahasiswa berhasil diperbarui')),
          );
        }
      } else {
        await _repository.createMahasiswa(mahasiswa);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Mahasiswa berhasil diperbarui')),
          );
        }
      }

      if (mounted) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => MahasiswaScreen()));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.selectedMahasiswa != null
            ? 'Update mahasiswa'
            : 'Create mahasiswa'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nama',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Nama tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nimController,
                  decoration: const InputDecoration(
                    labelText: 'NIM',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'NIM tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (!_isLoading) {
                          _saveMahasiswa();
                        }
                      },
                      child: Text(widget.selectedMahasiswa == null
                          ? 'Create Mahasiswa'
                          : 'Update Mahasiswa'),
                    ),
                    if (widget.selectedMahasiswa != null)
                      TextButton(
                        onPressed: _clearForm,
                        child: const Text('Batal'),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
