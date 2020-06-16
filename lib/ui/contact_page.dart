import 'dart:io';

import 'package:agenda_contacto/helpers/contact_helper.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactPage extends StatefulWidget {
  final Contact contacto;

  ContactPage({this.contacto});

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {

  final _nomeController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _emailController = TextEditingController();

  final _nameFocus = FocusNode();
  bool _usuarioEditado = false;

  Contact _contactoEditado;

  @override
  void initState() {
    super.initState();

    if (widget.contacto == null) {
      _contactoEditado = Contact();
    } else {
      _contactoEditado = Contact.fromMap(widget.contacto.toMap());
      _nomeController.text = _contactoEditado.name;
      _telefoneController.text = _contactoEditado.phone;
      _emailController.text = _contactoEditado.email;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: Text(_contactoEditado.name ?? "Novo Contacto"),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if(_contactoEditado.name != null && _contactoEditado.name.isNotEmpty){
              Navigator.pop(context, _contactoEditado);
            } else{
              FocusScope.of(context).requestFocus(_nameFocus);
            }
          },
          child: Icon(Icons.save),
          backgroundColor: Colors.red,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              GestureDetector(
                child: Container(
                  width: 140.0,
                  height: 140.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: _contactoEditado.img != null
                            ? FileImage(File(_contactoEditado.img))
                            : AssetImage("images/pessoa.png")),

                  ),
                ),
                onTap: (){
                  ImagePicker.pickImage(source: ImageSource.camera).then((file){
                    if(file == null) return;
                    setState(() {
                      _contactoEditado.img = file.path;
                    });
                  });
                },
              ),
              TextField(
                controller: _nomeController,
                focusNode: _nameFocus,
                decoration: InputDecoration(labelText: "Nome"),
                onChanged: (text){
                  _usuarioEditado = true;
                  setState(() {
                    _contactoEditado.name = text;
                  });
                },
              ),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: "Email"),
                onChanged: (text){
                  _usuarioEditado = true;
                  _contactoEditado.email = text;
                },
                keyboardType: TextInputType.emailAddress,
              ),
              TextField(
                controller: _telefoneController,
                decoration: InputDecoration(labelText: "Telefone"),
                onChanged: (text){
                  _usuarioEditado = true;
                  _contactoEditado.phone = text;
                },
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _requestPop() {
    if(_usuarioEditado){
      showDialog(context: context,
      builder: (context){
        return AlertDialog(
          title: Text("Descartar alterações?"),
          content: Text("Se sair as alterações serão perdidas."),
          actions: <Widget>[
            FlatButton(
              child: Text("Cancelar"),
              onPressed: (){
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text("Sim"),
              onPressed: (){
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
          ],
        );
      }
      );
      return Future.value(false);
    }else{
      return Future.value(true);

    }
  }
}
