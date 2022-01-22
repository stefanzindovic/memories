import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:memories/theme/colors.dart';

enum RefreshUserAuthenticationStatus {
  initial,
  loading,
  success,
  error,
}

enum DeleteUserAccountStatus {
  initial,
  loading,
  success,
  error,
}

class ConfirmIdentityPage extends StatefulWidget {
  const ConfirmIdentityPage({Key? key}) : super(key: key);

  @override
  _ConfirmIdentityPageState createState() => _ConfirmIdentityPageState();
}

class _ConfirmIdentityPageState extends State<ConfirmIdentityPage> {
  String _password = '';
  String? errorMessage;
  RefreshUserAuthenticationStatus _refreshUserAuthenticationStatus =
      RefreshUserAuthenticationStatus.initial;
  DeleteUserAccountStatus _deleteUserAccountStatus =
      DeleteUserAccountStatus.initial;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Deaktoivacija naloga'),
      ),
      body: SafeArea(
        minimum: EdgeInsets.symmetric(horizontal: 20.w),
        child: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (overscroll) {
            overscroll.disallowIndicator();
            return true;
          },
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              children: [
                SizedBox(height: 30.h),
                Text(
                  'Unesite vašu lozinku kako bi potvrdili vaš identitet i nastavili proces deaktivacije vašeg korisničkog računa.',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                SizedBox(height: 20.h),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const Align(
                        child: const Text('Lozinka'),
                        alignment: Alignment.topLeft,
                      ),
                      SizedBox(height: 10.h),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        style: const TextStyle(color: lightColor),
                        obscureText: true,
                        decoration: const InputDecoration(
                          hintText: 'koristite najmanje 8 karaktera...',
                        ),
                        validator: (value) {
                          if (value!.length < 8 || value.length > 24) {
                            return 'Unešena lozinka nije validna. Molimo vas da unesete lozinku koja je duža od 8 i krća od 24 karaktera.';
                          } else {
                            setState(() => _password = value);
                          }
                        },
                      ),
                      SizedBox(height: 20.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(
                            width: 10.h,
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(110.w, 65.h),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {}
                            },
                            child: Row(
                              children: [
                                const Text('Dalje'),
                                SizedBox(
                                  width: 5.w,
                                ),
                                const Icon(
                                  FeatherIcons.arrowRight,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
