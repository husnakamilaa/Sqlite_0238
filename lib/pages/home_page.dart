import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqlite/bloc/user_bloc.dart';
import 'package:sqlite/bloc/user_event.dart';
import 'package:sqlite/bloc/user_state.dart';
import 'package:sqlite/pages/user_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  final Color primaryGreen = const Color(0xFF4D694C);
  final Color darkGreen = const Color(0xFF1E291E);
  final Color softGreen = const Color(0xFFF0F4F0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: softGreen,
      appBar: AppBar(
        title: const Text(
          "Daftar User",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: darkGreen,
        elevation: 0,
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserLoading)
            return const Center(child: CircularProgressIndicator());
          if (state is UserLoaded && state.users.isNotEmpty) {
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.users.length,
              itemBuilder: (context, index) {
                final user = state.users[index];
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    title: Text(user.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user.email),
                        Text(user.notelp),
                        Text(user.alamat),
                      ],
                    ),
                    isThreeLine: true,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => UserFormPage(user: user),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => context.read<UserBloc>().add(
                            DeleteUserEvent(user.id),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
          return const Center(
            child: Text("Belum ada user. Klik + untuk menambah."),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: darkGreen,
        foregroundColor: Colors.white,
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const UserFormPage()),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
