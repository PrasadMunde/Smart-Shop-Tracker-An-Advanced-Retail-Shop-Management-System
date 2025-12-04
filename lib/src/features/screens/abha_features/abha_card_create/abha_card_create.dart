import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shopcare/src/constants/text_strings.dart';

import '../../../../common_widgets/appbar/appbar.dart';
import '../../../../constants/image_strjngs.dart';
import '../../../../constants/sizes.dart';
import 'aadhar_card_otp.dart';

class AbhaCardCreate extends StatefulWidget {
  const AbhaCardCreate({super.key});

  @override
  State<AbhaCardCreate> createState() => _AbhaCardCreateState();
}

class _AbhaCardCreateState extends State<AbhaCardCreate> {
  TextEditingController _textController = TextEditingController();
  String _encryptedText = "";
  String _errorMessage = "";

  void _encryptText() async {
    final String url = 'https://www.devglan.com/online-tools/rsa-encrypt';
    final String publicKey = "MIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAstWB95C5pHLXiYW59qyO4Xb+59KYVm9Hywbo77qETZVAyc6VIsxU+UWhd/k/YtjZibCznB+HaXWX9TVTFs9Nwgv7LRGq5uLczpZQDrU7dnGkl/urRA8p0Jv/f8T0MZdFWQgks91uFffeBmJOb58u68ZRxSYGMPe4hb9XXKDVsgoSJaRNYviH7RgAI2QhTCwLEiMqIaUX3p1SAc178ZlN8qHXSSGXvhDR1GKM+y2DIyJqlzfik7lD14mDY/I4lcbftib8cv7llkybtjX1AayfZp4XpmIXKWv8nRM488/jOAF81Bi13paKgpjQUUuwq9tb5Qd/DChytYgBTBTJFe7irDFCmTIcqPr8+IMB7tXA3YXPp3z605Z6cGoYxezUm2Nz2o6oUmarDUntDhq/PnkNergmSeSvS8gD9DHBuJkJWZweG3xOPXiKQAUBr92mdFhJGm6fitO5jsBxgpmulxpG0oKDy9lAOLWSqK92JMcbMNHn4wRikdI9HSiXrrI7fLhJYTbyU3I4v5ESdEsayHXuiwO/1C8y56egzKSw44GAtEpbAkTNEEfK5H5R0QnVBIXOvfeF4tzGvmkfOO6nNXU3o/WAdOyV3xSQ9dqLY5MEL4sJCGY1iJBIAQ452s8v0ynJG5Yq+8hNhsCVnklCzAlsIzQpnSVDUVEzv17grVAw078CAwEAAQ==";

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'textToEncrypt': _textController.text,
          'keyType': 'publicKeyForEncryption',
          'cipherType': 'RSA/ECB/OAEPWithSHA-1AndMGF1Padding',
          'publicKey': publicKey,
        }),
      );
      final Map<String, dynamic> responseData = json.decode(response.body);
      setState(() {
        _encryptedText = responseData['encryptedOutput'] ?? 'No encrypted text';
        _errorMessage = "";
        log(_encryptedText);
         Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AadharCardOtp()) );
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String? _aadharnumber;
    var mediaQuery = MediaQuery.of(context);
    var height = mediaQuery.size.height;
    return Scaffold(
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        child: Container(
          child: Padding(
          padding: const EdgeInsets.all(tDefaultSize),
        child:Column( children: [
          SizedBox(height: 55,),
          Column(
            children: [
              Text(
                "Create ABHA Card",
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Enter Your Aadhar Number then we will make it Abha card',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
            ],
          ),
          SizedBox(height: 30,),
          Form(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: tFormHeight - 10),
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _textController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          label: Text('Aadhar Number'),
                          prefixIcon: Icon(Icons.numbers)),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your Aadhar number';
                        }
                        if (value.length < 12 || value.length > 12) {
                          return "Please enter valid Aadhar number";
                        }
                        // Additional phone number validation can be added here
                        return null;
                      },
                      onSaved: (value) {
                        _aadharnumber= value;
                      },
                    ),
                    const SizedBox(
                      height: tFormHeight - 10,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          _encryptText();
                        },
                        child: Text(tNext.toUpperCase()),
                      ),
                    ),
                    Image(
                      image: AssetImage(tCreateAbhaScreenImage1),
                      height: height * 0.4,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ]),
            )),
      )
    );
  }
}
