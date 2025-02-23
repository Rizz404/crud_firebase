import 'package:flutter/material.dart';
import 'package:saturday_firebase_project/features/biodata/model/biodata_model.dart';
import 'package:saturday_firebase_project/features/biodata/repositories/biodata_repository.dart';
import 'package:saturday_firebase_project/features/biodata/screens/biodata_screen.dart';
import 'package:uuid/uuid.dart';

class BiodataUpsertScreen extends StatefulWidget {
  final BiodataModel? selectedBiodata;

  const BiodataUpsertScreen({super.key, this.selectedBiodata});

  @override
  State<BiodataUpsertScreen> createState() => _BiodataUpsertScreenState();
}

class _BiodataUpsertScreenState extends State<BiodataUpsertScreen> {
  final BiodataRepository _repository = BiodataRepository();
  final TextEditingController _nameController = TextEditingController();
  int? _selectedAge;
  final TextEditingController _addressController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;

  @override
  void initState() {
    if (widget.selectedBiodata != null) {
      _nameController.text = widget.selectedBiodata!.name;
      _selectedAge = widget.selectedBiodata!.age;
      _addressController.text = widget.selectedBiodata!.address;
    }
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _clearForm() {
    _nameController.clear();
    _addressController.clear();
    _selectedAge = null;
  }

  Future<void> _saveBiodata() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });
    try {
      final biodata = BiodataModel(
        id: widget.selectedBiodata?.id ?? const Uuid().v4(),
        name: _nameController.text.trim(),
        age: _selectedAge!,
        address: _addressController.text.trim(),
      );

      if (widget.selectedBiodata != null) {
        await _repository.updateBiodata(widget.selectedBiodata!.id, biodata);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Biodata berhasil diperbarui')),
          );
        }
      } else {
        await _repository.createBiodata(biodata);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Biodata berhasil diperbarui')),
          );
        }
      }

      if (mounted) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => BiodataScreen()));
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
        title: Text(widget.selectedBiodata != null
            ? 'Update biodata'
            : 'Create biodata'),
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
                DropdownButtonFormField<int>(
                  value: _selectedAge,
                  decoration: const InputDecoration(
                    labelText: 'Usia',
                    border: OutlineInputBorder(),
                  ),
                  items: List.generate(43, (index) {
                    int age = index + 18;
                    return DropdownMenuItem(
                      value: age,
                      child: Text(age.toString()),
                    );
                  }),
                  onChanged: (value) {
                    setState(() {
                      _selectedAge = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Usia tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _addressController,
                  decoration: const InputDecoration(
                    labelText: 'Alamat',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Alamat tidak boleh kosong';
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
                          _saveBiodata();
                        }
                      },
                      child: Text(widget.selectedBiodata == null
                          ? 'Create Biodata'
                          : 'Update Biodata'),
                    ),
                    if (widget.selectedBiodata != null)
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
