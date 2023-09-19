import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ms_undraw/ms_undraw.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  final Widget destination;
  const LoginPage({super.key, required this.destination});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final firstController = TextEditingController();
  final firstFocus = FocusNode();
  final lastController = TextEditingController();
  final lastFocus = FocusNode();

  setFirstName() async {
    final prefs = await SharedPreferences.getInstance();

    prefs.setString("FirstName", firstController.text);
  }

  setLastName() async {
    final prefs = await SharedPreferences.getInstance();

    prefs.setString("LastName", lastController.text);
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Welcome",
                style: Theme.of(context).textTheme.displayMedium,
                textAlign: TextAlign.center,
              ),
              Text(
                "Please sign in to start using the app.",
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              Flexible(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  // child:
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxHeight < 200) {
                        return const SizedBox(height: 25);
                      }

                      return UnDraw(
                        color: Theme.of(context).colorScheme.secondary,
                        illustration: UnDrawIllustration.login,
                      );
                    },
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(15),
                child: TextFormField(
                  controller: firstController,
                  focusNode: firstFocus,
                  onTapOutside: (_) => firstFocus.unfocus(),
                  inputFormatters: [
                    FilteringTextInputFormatter.singleLineFormatter,
                    FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your first name.";
                    }

                    return null;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    labelText: "First Name:",
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(15),
                child: TextFormField(
                  controller: lastController,
                  focusNode: lastFocus,
                  onTapOutside: (_) => lastFocus.unfocus(),
                  inputFormatters: [
                    FilteringTextInputFormatter.singleLineFormatter,
                    FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
                  ],
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    labelText: "Last Name (optional):",
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                margin: const EdgeInsets.all(15),
                child: FilledButton(
                  onPressed: () async {
                    final nav = Navigator.of(context);

                    if (_formKey.currentState!.validate()) {
                      await setFirstName();
                      if (lastController.text.isNotEmpty) {
                        await setLastName();
                      }

                      nav.pushReplacement(
                        MaterialPageRoute(
                          builder: (_) {
                            return widget.destination;
                          },
                        ),
                      );
                    }
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(15),
                    child: Text("Sign In"),
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
