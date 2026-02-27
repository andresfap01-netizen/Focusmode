import 'package:flutter/material.dart';
import 'package:focusmode/view/PantallaPrincipal.dart';
import 'package:google_fonts/google_fonts.dart';

class Permiso extends StatelessWidget {
  const Permiso({super.key});

  void VentanaEmergente(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: Colors.purple, width: 2),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "FOCUS MODE QUIERE ACCEDER A TIEMPO EN PANTALLA",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 15),

                Text(
                  "Si permites que FOCUS MODE acceda a tiempo en pantalla, "
                  "también podrá consultar tus datos de actividad, así como "
                  "restringir contenido y limitar tu uso de apps y sitios web.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(fontSize: 13),
                ),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PantallaPrincipal(),
                          ),
                        );
                      },
                      child: Text(
                        "CONTINUAR",
                        style: GoogleFonts.poppins(color: Colors.white),
                      ),
                    ),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2E2E48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "NO PERMITIR",
                        style: GoogleFonts.poppins(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),

      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.purple,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),

                  const SizedBox(width: 10),

                  Text("Back", style: GoogleFonts.poppins(fontSize: 16)),
                ],
              ),
            ),
          ),

          Center(
            child: Padding(
              padding: const EdgeInsets.all(25),

              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "FOCUS MODE",
                    style: GoogleFonts.poppins(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 30),

                  Image.asset('assets/imagenes/icono2.png', width: 150),

                  const SizedBox(height: 30),

                  Text(
                    "PERMISO DE TIEMPO EN PANTALLA",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),

                  const SizedBox(height: 15),

                  Text(
                    "Para ayudarte a mantenerte enfocado, necesitamos permisos "
                    "de tiempo en pantalla. Esto nos permite limitar aplicaciones "
                    "distractoras y asegurarnos de que sigas cumpliendo tus objetivos.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(fontSize: 14),
                  ),

                  const SizedBox(height: 30),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2E2E48),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {
                      VentanaEmergente(context);
                    },
                    child: Text(
                      "CONCEDER PERMISOS",
                      style: GoogleFonts.poppins(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
