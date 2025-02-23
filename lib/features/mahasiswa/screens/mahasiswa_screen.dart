import 'package:flutter/material.dart';
import 'package:saturday_firebase_project/features/mahasiswa/model/mahasiswa_model.dart';
import 'package:saturday_firebase_project/features/mahasiswa/repositories/mahasiswa_repository.dart';
import 'package:saturday_firebase_project/features/mahasiswa/screens/mahasiswa_upsert_screen.dart';

class MahasiswaScreen extends StatefulWidget {
  const MahasiswaScreen({super.key});

  @override
  State<MahasiswaScreen> createState() => _MahasiswaScreenState();
}

class _MahasiswaScreenState extends State<MahasiswaScreen> {
  final MahasiswaRepository _repository = MahasiswaRepository();
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _deleteMahasiswa(String id) async {
    try {
      await _repository.deleteMahasiswa(id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Mahasiswa berhasil dihapus')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: !_isSearching
            ? const Text('Daftar Mahasiswa')
            : TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Cari mahasiswa...',
                ),
                onChanged: (value) => setState(() {}),
              ),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                }
              });
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => MahasiswaUpsertScreen(),
          ));
        },
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<MahasiswaModel>>(
              stream: _isSearching && _searchController.text.isNotEmpty
                  ? _repository.searchMahasiswa(_searchController.text)
                  : _repository.getAllMahasiswa(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }

                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final mahasiswaList = snapshot.data!;
                if (mahasiswaList.isEmpty) {
                  return const Center(
                    child: Text('Tidak ada data mahasiswa'),
                  );
                }

                return ListView.builder(
                  itemCount: mahasiswaList.length,
                  itemBuilder: (context, index) {
                    final mahasiswa = mahasiswaList[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: ListTile(
                        title: Text(mahasiswa.name),
                        subtitle: Text(mahasiswa.nim),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => MahasiswaUpsertScreen(
                                    selectedMahasiswa: mahasiswa,
                                  ),
                                ));
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Konfirmasi'),
                                  content: const Text(
                                    'Apakah Anda yakin ingin menghapus data ini?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Batal'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        _deleteMahasiswa(mahasiswa.id);
                                      },
                                      child: const Text('Hapus'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
