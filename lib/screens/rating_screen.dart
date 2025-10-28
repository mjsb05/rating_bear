import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:rive/rive.dart';

class RatingScreen extends StatefulWidget {
  const RatingScreen({super.key});

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  //Cerebro de la lógica de las animaciones
  StateMachineController? controller;

  // SMI: State Machine Input
  SMIBool? isChecking; //Activa el modo "chismoso"
  SMIBool? isHandsUp; //Baja las manos
  SMITrigger? trigSuccess; //Animación de éxito
  SMITrigger? trigFail; //Animación de fallo

  //Foco pendiente de la barra:
  final ratingBarFocus = FocusNode();

  //listeners para los cambios en las variables
  @override
  void initState() {
    super.initState();

    ratingBarFocus.addListener(() {
      if (!ratingBarFocus.hasFocus) {
        //Si pierde el foco, bajar las manos
        isHandsUp?.change(false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    //para obtener el tamaño de la pantallla del disp
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            children: [
              SizedBox(
                width: size.width,
                height: 200,
                child: RiveAnimation.asset(
                  'assets/animated_login_character.riv',
                  stateMachines: ["Login Machine"],
                  //Al iniciarse
                  onInit: (artboard) {
                    controller = StateMachineController.fromArtboard(
                      artboard,
                      "Login Machine",
                    );
                    //Verificar si es conrtolador inció bien
                    if (controller == null) return;
                    artboard.addController(controller!);
                    //Asignar las variables
                    isChecking = controller!.findSMI("isChecking");
                    isHandsUp = controller!.findSMI("isHandsUp");
                    trigSuccess = controller!.findSMI("trigSuccess");
                    trigFail = controller!.findSMI("trigFail");
                  },
                ),
              ),
              //Espacio entre el oso y el texto medio
              const SizedBox(height: 30),

              Text(
                "Enjoying Sounter?",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 30),

              Text(
                "Whit how many stars would you rate you experience?",
                style: TextStyle(fontSize: 24, color: Colors.grey[700]),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 20),

              RatingBar.builder(
                initialRating: 3,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) =>
                    const Icon(Icons.star, color: Colors.amber),
                onRatingUpdate: (rating) {
                  if (rating <= 3) {
                    trigFail?.fire();
                  } else {
                    trigSuccess?.fire();
                  }
                },
              ),

              //Botón de Loginfeat
              const SizedBox(height: 20),
              //Botón estilo Android
              MaterialButton(
                minWidth: size.width,
                height: 50,
                color: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                onPressed: () {},

                child: const Text(
                  'Rate Now',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              TextButton(
                onPressed: () {},
                child: const Text(
                  "NO THANKS",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
