import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insight_hub/constant/routes.dart';
import 'package:insight_hub/cuibt/cubit/register_cubit.dart';
import 'package:insight_hub/widget/back_button.dart';
import 'package:insight_hub/widget/card_container.dart';
import 'package:insight_hub/widget/next_button.dart';
import 'package:insight_hub/widget/validatores.dart';

class RegisterEmailScreen extends StatefulWidget {
  const RegisterEmailScreen({super.key});
 //make routname

 @override
 State<RegisterEmailScreen> createState() => _RegisterEmailScreenState();
}

class _RegisterEmailScreenState extends State<RegisterEmailScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }
 
@override


  void handleNext() {
    if (_formKey.currentState!.validate()) {
     final email = emailController.text;
      
      // هنا يمكن حفظ الإيميل
        context.read<RegisterCubit>().saveEmail(email);

      Navigator.pushNamed(context, Routes.registerPasswordScreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,

        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),

            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Back Button
                  BackButtonWidget(),
                  const SizedBox(height: 20),
                  const Text(
                    "Create Account",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Enter your email to get started",
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                  const SizedBox(height: 40),

                  CardContainer(
                    children: [
                      /// Label
                      const Text(
                        "Email address",
                        style: TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 8),

                      /// Email Field
                      TextFormField(
                        autofillHints: const [AutofillHints.email],
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(RegExp(r"\s")),
                        ],
                        decoration: InputDecoration(
                          hintText: "you@example.com",
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                              color: Colors.blue,
                              width: 2,
                            ),
                          ),
                        ),
                        validator:Validators.email,
                      ),
                    ],
                  ),

                  const Spacer(),
                  /// Next Button
                  SizedBox(
                    width: double
                        .infinity, //this make make problem when make phone horizontal

                    child: NextButton(
                      onPressed: handleNext,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


