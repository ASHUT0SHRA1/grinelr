import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grinler/features/auth/view/login_view.dart';
import 'package:grinler/features/auth/view/signup_view.dart';

class LandingPage extends StatelessWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const LandingPage(),
      );

  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Container(
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/img_1.png'), fit: BoxFit.cover)),
          child: Column(children: [
            SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: 80,
                width: 80,
                child: Image.asset('assets/images/img.png'),
              ),
              ),
            SizedBox(
              height: 350,
            ),

            Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Show your\n Funny Side",
                      style: GoogleFonts.pacifico(
                          color: Colors.white,
                          fontSize: 35,
                          fontWeight: FontWeight.bold)),
                  // Text("Funny Side",
                  //     style: GoogleFonts.pacifico(
                  //         color: Colors.white,
                  //         fontSize: 35,
                  //         fontWeight: FontWeight.bold)),
                ]),
            Container(
              margin:
                  const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              child: Text(
                "Powering humor and creativity through meme collaboration. Laugh, create, connect.",
                style: GoogleFonts.kalam(
                    fontSize: 20, color: Colors.white.withOpacity(0.8)),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                const MaterialStatePropertyAll(Colors.white),
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ))),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignUpView()));
                        },
                        child: const SizedBox(
                            height: 60,
                            width: 110,
                            child: Center(
                              child: Text(
                                "Register",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 20),
                              ),
                            ))),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: const MaterialStatePropertyAll(
                              Color.fromRGBO(240, 46, 101, 1)),
                          shape: MaterialStateProperty.all<
                              RoundedRectangleBorder>(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ))),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginView()));
                      },
                      child: const SizedBox(
                        height: 60,
                        width: 110,
                        child: Center(
                          child: Text(
                            "Sign In",
                            style:
                                TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }
}
