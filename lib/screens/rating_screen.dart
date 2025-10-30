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

  SMITrigger? trigSuccess; //Animación de éxito
  SMITrigger? trigFail; //Animación de fallo
  Artboard? mainArtboard; //Tablero principal de Rive
  double _ratingValue = 0; //Valor de la calificación

  //Función para reiniciar el controlador y disparar la animación correspondiente
  Future<void> _restartControllerAndTrigger(bool? isSuccess) async {
    //Verifica que el controlador esté bien inicializado
    if (mainArtboard == null) return;

    //Reinicia el controlador del State Machine
    mainArtboard!.removeController(controller!);
    controller = StateMachineController.fromArtboard(
      mainArtboard!,
      'Login Machine',
    );

    //Si el controlador se reinició bien, se reasiganna las variables
    if (controller != null) {
      mainArtboard!.addController(controller!);
      trigSuccess = controller!.findSMI('trigSuccess');
      trigFail = controller!.findSMI('trigFail');
    }

    //Delay que asegura que el contolador se haya reiniciado
    await Future.delayed(const Duration(milliseconds: 50));

    //Disparar la animación correspondiente
    if (isSuccess == null) return;
    if (isSuccess) {
      //Dispara la animación de éxito
      trigSuccess?.fire();
    } else {
      //Dispara la animación de fallo
      trigFail?.fire();
    }
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
                    //Asignar el artboard principal
                    mainArtboard = artboard;

                    //Crear el controlador del State Machine
                    controller = StateMachineController.fromArtboard(
                      artboard,
                      "Login Machine",
                    );

                    //Verificar si es conrtolador inció bien
                    if (controller == null) return;
                    artboard.addController(controller!);

                    //Asignar las variables
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
                initialRating: 0,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) =>
                    const Icon(Icons.star, color: Colors.amber),
                onRatingUpdate: (value) {
                  setState(() {
                    //Actualiza el valor de la calificación
                    _ratingValue = value;
                  });
                  //Dispara la animación conrrespondiente, según la calificación
                  if (value >= 4) {
                    //Dispara la animación de éxito
                    _restartControllerAndTrigger(true);
                  } else if (value <= 2) {
                    //Dispara la animación de fallo
                    _restartControllerAndTrigger(false);
                  } else {
                    //No hace nada
                    _restartControllerAndTrigger(null);
                  }
                },
              ),

              //Botón de calificar
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
