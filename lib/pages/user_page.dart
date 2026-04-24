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

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.user != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? "Edit User" : "Tambah User")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: "Nama Lengkap",
                  border: OutlineInputBorder(),
                ),
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
                decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Email tidak boleh kosong";
                  }
                  final regex = RegExp(r'^[a-zA-Z0-9._]+@gmail\.com$');
                  if(!regex.hasMatch(value)){
                    return "Email harus valid dan menggunakan @gmail.com";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 15),

              IntlPhoneField(
                decoration: const InputDecoration(
                  labelText: 'No Telpon',
                  border: OutlineInputBorder(),
                ),
                initialCountryCode: 'ID',
                initialValue: notelp,
                onChanged: (phone) {
                  notelp = phone.completeNumber;
                },
                validator: (phone) {
                  if (phone == null || phone.number.isEmpty) {
                    return "No telpon tidak boleh kosong";
                  }
                  if (!phone.completeNumber.startsWith("+62")){
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
                decoration: const InputDecoration(
                  labelText: "Alamat",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty){
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
                  onPressed: () {
                    final newUser = UserEntity(
                      id: isEdit
                          ? widget.user!.id
                          : DateTime.now().microsecondsSinceEpoch.toString(),
                      name: _nameController.text,
                      email: _emailController.text,
                    );
                    if (isEdit) {
                      context.read<UserBloc>().add(UpdateUserEvent(newUser));
                    } else {
                      context.read<UserBloc>().add(AddUserEvent(newUser));
                    }
                    Navigator.pop(context);
                  },
                  child: Text(isEdit ? "Simpan Perubahan" : "Simpan User Baru"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
