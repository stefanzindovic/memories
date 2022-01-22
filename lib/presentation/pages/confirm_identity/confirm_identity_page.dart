import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:memories/models/collection.dart';
import 'package:memories/models/memory.dart';
import 'package:memories/models/user.dart';
import 'package:memories/providers/collection_data_proivder.dart';
import 'package:memories/providers/current_user_provider.dart';
import 'package:memories/providers/memory_data_provider.dart';
import 'package:memories/providers/user_data_provider.dart';
import 'package:memories/repository/collections_informations.dart';
import 'package:memories/repository/memory_informations.dart';
import 'package:memories/repository/secure_storage.dart';
import 'package:memories/repository/user_authentication.dart';
import 'package:memories/repository/user_informations.dart';
import 'package:memories/theme/colors.dart';
import 'package:provider/provider.dart';

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
  String? _email;
  String? errorMessage;
  RefreshUserAuthenticationStatus _refreshUserAuthenticationStatus =
      RefreshUserAuthenticationStatus.initial;
  DeleteUserAccountStatus _deleteUserAccountStatus =
      DeleteUserAccountStatus.initial;
  final _formKey = GlobalKey<FormState>();
  List<CollectionModel?> _collections = [];
  List<MemoryModel?> _memories = [];
  UserModel? _user;

  Future<RefreshUserAuthenticationStatus> refreshUserAuthentication() async {
    RefreshUserAuthenticationStatus status =
        RefreshUserAuthenticationStatus.initial;
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: _email!, password: _password);
      status = RefreshUserAuthenticationStatus.success;
      print('Sve je u redu!');
    } on FirebaseAuthException catch (e) {
      print(e);
      if (e.code == 'user-not-found') {
        errorMessage =
            'Korisnik sa tom e-mail adresom ne postoji. Molimo vas da pokušate sa drugom e-mail adresom ili da kreirate novi korisniški račun.';
      } else if (e.code == 'wrong-password') {
        errorMessage =
            'Navedeni podaci za prijavljivanje se ne poklapaju. Molimo vas da pokušate ponovo.';
      } else if (e.code == 'network-request-failed') {
        errorMessage =
            'Internet konekcija nije ostvarena. Molimo vas da provjerite vašu internet vezu i pokušajte ponovo.';
      }
      status = RefreshUserAuthenticationStatus.error;
    } catch (e) {
      print(e);
      status = RefreshUserAuthenticationStatus.error;
      errorMessage =
          'Trenutno nismo u mogućnosti da deaktiviramo vaš korisnički nalog. Molimo vas da pokušate ponovo malo kasnije.';
    }
    return status;
  }

  Future<DeleteUserAccountStatus> deleteUserAccount() async {
    DeleteUserAccountStatus status = DeleteUserAccountStatus.initial;
    try {
      for (var memory in _memories) {
        if (memory != null) {
          await MemoryInformations.deleteMemory(memory.id);
        }
      }
      for (var collection in _collections) {
        if (collection != null) {
          await CollectionsInformations.deleteCollection(collection.id);
        }
      }
      if (_user?.profilePhotoUrl != null) {
        await UserInformations.deleteProfilePhoto();
      }
      await UserInformations.deleteUserInfo();
      await UserInformations.deleteUserAccount();

      print('Sve je u redu!');
      status = DeleteUserAccountStatus.success;
    } catch (e) {
      print(e);
      status = DeleteUserAccountStatus.error;
      errorMessage =
          'Trenutno nismo u mogućnosti da deaktiviramo vaš korisnički nalog. Molimo vas da pokušate ponovo malo kasnije.';
    }
    return status;
  }

  @override
  Widget build(BuildContext context) {
    setState(
        () => _email = Provider.of<CurrentUserProvider>(context).credentials);
    print(_email);
    setState(() => _collections =
        Provider.of<CollectionDataProvoder>(context).collections);
    setState(
        () => _memories = Provider.of<MemoryDataProvider>(context).memories);
    setState(() => _user = Provider.of<UserDataProvider>(context).userData);
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
                              if (_formKey.currentState!.validate()) {
                                setState(() =>
                                    _refreshUserAuthenticationStatus =
                                        RefreshUserAuthenticationStatus
                                            .loading);
                                final RefreshUserAuthenticationStatus result =
                                    await refreshUserAuthentication();
                                if (result ==
                                    RefreshUserAuthenticationStatus.error) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: backgroundColor,
                                      content: Text(
                                        errorMessage.toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2,
                                      ),
                                    ),
                                  );
                                } else if (result ==
                                    RefreshUserAuthenticationStatus.success) {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        backgroundColor: backgroundColor,
                                        title: Text(
                                          'Da li želite da deaktivirate vaš korisnički račun?',
                                          style: GoogleFonts.encodeSans(
                                            color: lightColor,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        content: Text(
                                          'U slučaju brisanja ove uspomene, sve informacije koje su vezane za nju će biti trajno obrisani. Ako ste sigurni da želite da obrišete ovu uspomenu koristite dugme "Nastavite"',
                                          style: GoogleFonts.encodeSans(
                                            color: textColor,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text('Odustanite'),
                                            style: TextButton.styleFrom(
                                              primary: lightColor,
                                              textStyle: GoogleFonts.encodeSans(
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          ElevatedButton(
                                            onPressed: () async {
                                              setState(() =>
                                                  _deleteUserAccountStatus =
                                                      DeleteUserAccountStatus
                                                          .loading);
                                              final DeleteUserAccountStatus
                                                  status =
                                                  await deleteUserAccount();
                                              if (status ==
                                                  DeleteUserAccountStatus
                                                      .error) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    backgroundColor:
                                                        backgroundColor,
                                                    content: Text(
                                                      errorMessage.toString(),
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyText2,
                                                    ),
                                                  ),
                                                );
                                              } else if (status ==
                                                  DeleteUserAccountStatus
                                                      .success) {
                                                await UserAuthentication
                                                    .signoutUser();
                                                Navigator
                                                    .pushNamedAndRemoveUntil(
                                                        context,
                                                        '/sign-in',
                                                        (route) => false);
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    backgroundColor:
                                                        backgroundColor,
                                                    content: Text(
                                                      'Vaš korisnički račun je uspješno deaktiviran.',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyText2,
                                                    ),
                                                  ),
                                                );
                                              }
                                              setState(() =>
                                                  _deleteUserAccountStatus =
                                                      DeleteUserAccountStatus
                                                          .initial);
                                            },
                                            child: Text('Nastavite'),
                                            style: ElevatedButton.styleFrom(
                                                primary: errorColor),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                                setState(() =>
                                    _refreshUserAuthenticationStatus =
                                        RefreshUserAuthenticationStatus
                                            .initial);
                              }
                            },
                            child: (_refreshUserAuthenticationStatus ==
                                    RefreshUserAuthenticationStatus.loading)
                                ? SizedBox(
                                    width: 24.w,
                                    height: 24.h,
                                    child: const CircularProgressIndicator(
                                        color: lightColor),
                                  )
                                : Row(
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
