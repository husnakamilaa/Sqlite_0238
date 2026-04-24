import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_intl_phone_field/flutter_intl_phone_field.dart';
import 'package:sqlite/bloc/user_bloc.dart';
import 'package:sqlite/bloc/user_event.dart';
import 'package:sqlite/domain/entities/user_entity.dart';

class UserFormPage extends StatefulWidget {
  final UserEntity? user;
  const UserFormPage({super.key, this.user});

  @override
  State<UserFormPage> createState() => _UserFormPageState();
}

class _UserFormPageState extends State<UserFormPage> {
  final _formKey = GlobalKey<FormState>();

  final Color primaryGreen = const Color(0xFF4D694C); 
  final Color darkGreen = const Color(0xFF1E291E);    
  final Color softGreen = const Color(0xFFF0F4F0);

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _alamatController = TextEditingController();

  String notelp = "";

  @override
  void initState() {
    super.initState();
    if (widget.user != null) {
      _nameController.text = widget.user!.name;
      _emailController.text = widget.user!.email;
      _alamatController.text = widget.user!.alamat;
      notelp = widget.user!.notelp;
    }
  }

  InputDecoration _InputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: darkGreen), 
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: darkGreen.withOpacity(0.5)), 
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: darkGreen, width: 2), 
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.user != null;

    return Scaffold(
      backgroundColor: softGreen,
      appBar: AppBar(
        title: 
        Text(
          isEdit ? "Edit User" : "Tambah User",
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: darkGreen,
        elevation: 0,
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: _InputDecoration("Nama Lengkap"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Nama gk boleh kosong";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 15),

                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: _InputDecoration("Email"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Email tidak boleh kosong";
                    }
                    final regex = RegExp(r'^[a-zA-Z0-9._]+@gmail\.com$');
                    if (!regex.hasMatch(value)) {
                      return "Email harus valid dan menggunakan @gmail.com";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 15),

                IntlPhoneField(
                  decoration: _InputDecoration("No Telpon"),
                  initialCountryCode: 'ID',
                  initialValue: notelp,
                  onChanged: (phone) {
                    notelp = phone.completeNumber;
                  },
                  validator: (phone) {
                    if (phone == null || phone.number.isEmpty) {
                      return "No telpon tidak boleh kosong";
                    }
                    if (!phone.completeNumber.startsWith("+62")) {
                      return "No telpon harus diawali +62";
                    }
                    if (phone.completeNumber.length > 15) {
                      return "No telpon maksimal 15 karakter";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 15),

                TextFormField(
                  controller: _alamatController,
                  decoration: _InputDecoration("Alamat"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Alamat tidak boleh kosong";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryGreen, 
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 5,
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final newUser = UserEntity(
                          id: isEdit
                              ? widget.user!.id
                              : DateTime.now().microsecondsSinceEpoch
                                    .toString(),
                          name: _nameController.text,
                          email: _emailController.text,
                          notelp: notelp,
                          alamat: _alamatController.text,
                        );
                        if (isEdit) {
                          context.read<UserBloc>().add(
                            UpdateUserEvent(newUser),
                          );
                        } else {
                          context.read<UserBloc>().add(AddUserEvent(newUser));
                        }
                        Navigator.pop(context);
                      }
                    },
                    child: Text(
                      isEdit ? "Simpan Perubahan" : "Simpan User Baru",
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
