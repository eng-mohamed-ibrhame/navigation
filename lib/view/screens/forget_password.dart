import 'package:flutter/material.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:navigation/view/components/customized_edit_form_text.dart';

import '../../model/utility/utility_methods.dart';

class ForgetPassword extends HookConsumerWidget {
  ForgetPassword({super.key});

  CountryCode? _displayCode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextEditingController phController = useTextEditingController();
    final GlobalKey<FormState> globalKey =
        useMemoized(() => GlobalKey<FormState>());

    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back_outlined),
        ),
      ),
      body: Form(
        key: globalKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * .1,
            ),
            Image.asset(
              'assets/images/flutter_image.jpg',
              // height: 150,
            ),
            const SizedBox(
              height: 30,
            ),
            const Center(child: Text('Please Enter your number to send code')),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: CountryCodePicker(
                    onInit: (value) {
                      _displayCode = value;
                    },
                    showDropDownButton: true,
                    favorite: const ['EG', 'US'],
                    initialSelection: 'EG',
                    onChanged: (value) {
                      _displayCode = value;
                    },
                  ),
                ),
                Flexible(
                  flex: 2,
                  fit: FlexFit.tight,
                  child: CustomizedTextFormField(
                    autofocus: true,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: phController,
                    validator: phoneValidated,
                    labelText: 'Phone',
                    maxLength: 11,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    prefixIcon: const Icon(Icons.call),
                    keyboardType: TextInputType.phone,
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 50,
            ),
            ElevatedButton(
              onPressed: () {
                if (globalKey.currentState!.validate()) {
                  // send otp authentication
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      padding: const EdgeInsets.all(10),
                      content: Text(
                          'sent code to ${_displayCode!.dialCode} - ${phController.text}'),
                      dismissDirection: DismissDirection.down,
                    ),
                  );
                }
              },
              child: const Text('Send'),
            ),
          ],
        ),
      ),
    );
  }
}
