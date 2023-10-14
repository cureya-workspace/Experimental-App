import 'package:cureya_exp_mobile_app/components/appbar.dart';
import 'package:cureya_exp_mobile_app/components/or_divider.dart';
import 'package:cureya_exp_mobile_app/helpers/auth_helper.dart';
import 'package:cureya_exp_mobile_app/screens/create_user_screen.dart';
import 'package:cureya_exp_mobile_app/screens/search_screen.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    CustomAppBar(
                        title: "Log In",
                        description:
                            "To find best and affordable healthcare service"),
                    const SizedBox(height: 14),
                    const LoginForm(),
                  ],
                ),
                const Expanded(child: SizedBox()),
                Column(
                  children: [
                    const OrDivider(),
                    SizedBox(
                      width: double.maxFinite,
                      child: MaterialButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateUserScreen()));
                          },
                          elevation: 0,
                          color: const Color.fromRGBO(72, 187, 120, 1),
                          textColor: Colors.black,
                          child: const Text(
                            'Create an account',
                            style: TextStyle(color: Colors.white),
                          )),
                    ),
                  ],
                ),
              ]),
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  Map<String, String> credentials = {
    'email': '',
    'password': '',
  };

  final globalFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
        key: globalFormKey,
        child: Column(
          children: [
            Container(
              height: 42,
              decoration: BoxDecoration(
                  color: const Color.fromRGBO(243, 243, 243, 1),
                  borderRadius: BorderRadius.circular(10)),
              child: Center(
                child: TextFormField(
                  validator: (String? val) {
                    if (val!.isEmpty) {
                      return "Cannot be empty";
                    }
                    if (!RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(val)) {
                      return "Please provide valid email";
                    }
                    return null;
                  },
                  onSaved: (newValue) {
                    credentials['email'] = newValue!;
                  },
                  style: const TextStyle(fontSize: 14),
                  decoration: const InputDecoration(
                      counterText: "",
                      hintText: 'Email',
                      hintStyle: TextStyle(color: Colors.black, fontSize: 14),
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 14.3)),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 8),
              height: 42,
              decoration: BoxDecoration(
                  color: const Color.fromRGBO(243, 243, 243, 1),
                  borderRadius: BorderRadius.circular(10)),
              child: Center(
                child: TextFormField(
                  validator: (String? val) {
                    if (val!.length < 6) {
                      return "Cannot be smaller than 6 characters";
                    }
                    return null;
                  },
                  onSaved: (newValue) {
                    credentials['password'] = newValue!;
                  },
                  obscureText: true,
                  style: const TextStyle(fontSize: 14),
                  decoration: const InputDecoration(
                      counterText: "",
                      hintText: 'Password',
                      hintStyle: TextStyle(color: Colors.black, fontSize: 14),
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 14.3)),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.maxFinite,
              child: MaterialButton(
                  onPressed: () async {
                    if (globalFormKey.currentState!.validate()) {
                      globalFormKey.currentState!.save();

                      try {
                        await AuthHelper.login(
                            credentials['email'], credentials['password']);
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Logged Successfully")));
                        // ignore: use_build_context_synchronously
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (_) => SearchScreen()));
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(e.toString())));
                      }
                    }
                  },
                  elevation: 0,
                  color: const Color.fromRGBO(72, 187, 120, 1),
                  textColor: Colors.black,
                  child: const Text(
                    'Log In',
                    style: TextStyle(color: Colors.white),
                  )),
            ),
          ],
        ));
  }
}
