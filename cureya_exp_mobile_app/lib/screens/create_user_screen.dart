// ignore_for_file: prefer_final_fields, body_might_complete_normally_nullable, use_build_context_synchronously

import 'package:cureya_exp_mobile_app/components/appbar.dart';
import 'package:cureya_exp_mobile_app/components/or_divider.dart';
import 'package:cureya_exp_mobile_app/helpers/auth_helper.dart';
import 'package:cureya_exp_mobile_app/screens/login_screen.dart';
import 'package:cureya_exp_mobile_app/screens/search_screen.dart';
import 'package:flutter/material.dart';

class CreateUserScreen extends StatelessWidget {
  const CreateUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    CustomAppBar(
                        title: 'Create an Account',
                        description:
                            'To find best and affordable healthcare service.'),
                    const CreateUserForm(),
                  ],
                ),
                Column(
                  children: [
                    OrDivider(),
                    SizedBox(
                      width: double.maxFinite,
                      child: MaterialButton(
                        elevation: 0,
                        color: const Color.fromRGBO(72, 187, 120, 1),
                        textColor: Colors.white,
                        onPressed: () {
                         Navigator.of(context).pop();
                        },
                        child: const Text('Already have an account'),
                      ),
                    )
                  ],
                )
              ],
            )),
      ),
    );
  }
}

class CreateUserForm extends StatefulWidget {
  const CreateUserForm({super.key});

  @override
  State<CreateUserForm> createState() => _CreateUserFormState();
}

class _CreateUserFormState extends State<CreateUserForm> {
  final GlobalKey<FormState> _globalKeyFormState = GlobalKey<FormState>();
  String verifyPassword = '';
  Map<String, dynamic> userDetails = {
    'first_name': '',
    'last_name': '',
    'email': '',
    'password': '',
    'phone': ''
  };

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _globalKeyFormState,
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 8),
              height: 42,
              decoration: BoxDecoration(
                  color: const Color.fromRGBO(243, 243, 243, 1),
                  borderRadius: BorderRadius.circular(10)),
              child: Center(
                child: TextFormField(
                  validator: (String? val) {
                    if (val!.length < 3) {
                      return "Cannot be smaller than 3 characters";
                    }
                  },
                  onSaved: (newValue) {
                    setState(() {
                      userDetails['first_name'] = newValue!;
                    });
                  },
                  style: const TextStyle(fontSize: 14),
                  decoration: const InputDecoration(
                      counterText: "",
                      hintText: 'First Name',
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
                    if (val!.length < 3) {
                      return "Cannot be smaller than 3 characters";
                    }
                  },
                  onSaved: (newValue) {
                    setState(() {
                      userDetails['last_name'] = newValue!;
                    });
                  },
                  style: const TextStyle(fontSize: 14),
                  decoration: const InputDecoration(
                      counterText: "",
                      hintText: 'Last Name',
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
                    if (val!.isEmpty) {
                      return "Cannot be empty";
                    }
                    if (!RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(val)) {
                      return "Please provide valid email";
                    }
                  },
                  onSaved: (newValue) {
                    userDetails['email'] = newValue!;
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
                    if (val!.length != 10) {
                      return "Enter valid phone number";
                    }
                  },
                  keyboardType: TextInputType.phone,
                  onSaved: (newValue) {
                    userDetails['phone'] = newValue!;
                  },
                  maxLength: 10,
                  style: const TextStyle(fontSize: 14),
                  decoration: const InputDecoration(
                      counterText: "",
                      hintText: 'Phone',
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
                  },
                  onChanged: (val) {
                    setState(() {
                      verifyPassword = val;
                    });
                  },
                  onSaved: (newValue) {
                    userDetails['password'] = newValue!;
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
            Container(
              margin: const EdgeInsets.only(top: 8),
              height: 42,
              decoration: BoxDecoration(
                  color: const Color.fromRGBO(243, 243, 243, 1),
                  borderRadius: BorderRadius.circular(10)),
              child: Center(
                child: TextFormField(
                  validator: (String? val) {
                    if (val! != verifyPassword) {
                      return "Not matched!";
                    }
                  },
                  obscureText: true,
                  style: const TextStyle(fontSize: 14),
                  decoration: const InputDecoration(
                      counterText: "",
                      hintText: 'Confirm Password',
                      hintStyle: TextStyle(color: Colors.black, fontSize: 14),
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 14.3)),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.maxFinite,
              child: MaterialButton(
                elevation: 0,
                color: const Color.fromRGBO(72, 187, 120, 1),
                textColor: Colors.white,
                onPressed: () async {
                  if (_globalKeyFormState.currentState!.validate()) {
                    _globalKeyFormState.currentState!.save();

                    try {
                      await AuthHelper.createAnAccount(userDetails);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Created account Successfully')));
                      await AuthHelper.login(
                          userDetails['email'], userDetails['password']);
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (_) => SearchScreen()));
                    } catch (e) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(e.toString())));
                    }
                  }
                },
                child: const Text('Create an account'),
              ),
            ),
          ],
        ));
  }
}
