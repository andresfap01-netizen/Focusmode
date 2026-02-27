import 'package:flutter/material.dart';
import 'Modelo_App.dart';


class AddApp extends StatefulWidget {

  final List<Modelo_App> appsSeleccionadas;

  const AddApp({
    super.key,
    required this.appsSeleccionadas,
  });

  @override
  State<AddApp> createState() => _AddAppState();
}

class _AddAppState extends State<AddApp>{

  List<Modelo_App> todasLasApps = [

    Modelo_App(
      nombre: "TikTok",
      icono: "assets/imagenes/Tiktok.png",
    ),

    Modelo_App(
      nombre: "Instagram",
      icono: "assets/imagenes/Instagram.png",
    ),

    Modelo_App(
      nombre: "WhatsApp",
      icono: "assets/imagenes/Whatsapp.png",
    ),

    Modelo_App(
      nombre: "Facebook",
      icono: "assets/imagenes/Facebook.png",
    ),

  ];

  @override
  void initState(){

    super.initState();

    for(var app in todasLasApps){

      for(var seleccionada in widget.appsSeleccionadas){

        if(app.nombre == seleccionada.nombre){

          app.seleccionada= true;

        }

      }

    }

  }

  void guardar(){

    final seleccionadas =
        todasLasApps.where((app) => app.seleccionada).toList();

    Navigator.pop(context, seleccionadas);

  }

  @override
  Widget build(BuildContext context){

    return Scaffold(

      backgroundColor: const Color(0xFFF5EDFF),

      appBar: AppBar(

        backgroundColor: const Color(0xFFF5EDFF),

        elevation: 0,

        title: const Text(
          "Añadir Apps",
          style: TextStyle(color: Colors.black),
        ),

        iconTheme: const IconThemeData(color: Colors.black),

      ),

      body: Padding(

        padding: const EdgeInsets.all(20),

        child: Column(

          children: [

            Expanded(

              child: ListView.builder(

                itemCount: todasLasApps.length,

                itemBuilder: (_, index){

                  final app = todasLasApps[index];

                  return Container(

                    margin: const EdgeInsets.only(bottom: 10),

                    decoration: BoxDecoration(

                      color: Colors.white,

                      borderRadius: BorderRadius.circular(15),

                    ),

                    child: CheckboxListTile(

                      value: app.seleccionada,

                      onChanged: (value){

                        setState(() {

                          app.seleccionada = value!;

                        });

                      },

                      title: Text(app.nombre),

                      secondary: Image.asset(app.icono, width: 40),

                    ),

                  );

                },

              ),

            ),

            SizedBox(

              width: double.infinity,

              height: 50,

              child: ElevatedButton(

                style: ElevatedButton.styleFrom(

                  backgroundColor: const Color(0xFF6C63FF),

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),

                ),

                onPressed: guardar,

                child: const Text(
                  "Guardar cambios",
                  style: TextStyle(fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
                ),

              ),

            ),

          ],

        ),

      ),

    );

  }

}