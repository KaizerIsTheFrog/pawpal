import 'package:flutter/material.dart';
import 'package:pawpal/models/user.dart';
import 'package:pawpal/widgets/DrawerAnimation.dart';
import 'package:pawpal/screens/LoginScreen.dart';
import 'package:pawpal/screens/MainScreen.dart';
// import 'package:pawpal/screens/MyPetsScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:pawpal/screens/profilepage.dart';

class MyDrawer extends StatefulWidget {
  final User? user;
  const MyDrawer({super.key, this.user});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  late double screenHeight;
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            currentAccountPicture: CircleAvatar(radius: 15, child: Text('A')),
            accountName: Text(widget.user?.name ?? 'Guest'),
            accountEmail: Text(widget.user?.email ?? 'Guest'),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                AnimatedRoute.slideFromRight(MainScreen(user: widget.user)),
              );
            },
          ),
          // ListTile(
          //   leading: Icon(Icons.pets),
          //   title: Text('My Pets'),
          //   onTap: () {
          //     Navigator.pop(context);
          //     Navigator.pushReplacement(
          //       context,
          //       AnimatedRoute.slideFromRight(MyPetsScreen(user: widget.user)),
          //     );
          //   },
          // ),
          // ListTile(
          //   leading: Icon(Icons.logout),
          //   title: Text('Logout'),
          //   onTap: () {
          //     logout();
          //   },
          // ),
          // ListTile(
          //   leading: Icon(Icons.person),
          //   title: Text('Profile'),
          //   onTap: () {
          //     if (widget.user?.userId == '0') {
          //       //showdialog
          //       showDialog(
          //         context: context,
          //         builder: (_) => AlertDialog(
          //           shape: RoundedRectangleBorder(
          //             borderRadius: BorderRadius.circular(16),
          //           ),
          //           title: Row(
          //             children: const [
          //               Icon(Icons.lock_outline, color: Color(0xFF1F3C88)),
          //               SizedBox(width: 8),
          //               Text("Login Required"),
          //             ],
          //           ),
          //           content: const Text(
          //             "Please login to continue and access this feature.",
          //           ),
          //           actions: [
          //             TextButton(
          //               onPressed: () => Navigator.pop(context),
          //               child: const Text("Cancel"),
          //             ),
          //             ElevatedButton(
          //               style: ElevatedButton.styleFrom(
          //                 backgroundColor: const Color(0xFF1F3C88),
          //                 shape: RoundedRectangleBorder(
          //                   borderRadius: BorderRadius.circular(10),
          //                 ),
          //               ),
          //               onPressed: () {
          //                 Navigator.pushReplacement(
          //                   context,
          //                   AnimatedRoute.slideFromRight(const LoginPage()),
          //                 );
          //               },
          //               child: const Text(
          //                 "Login",
          //                 style: TextStyle(color: Colors.white),
          //               ),
          //             ),
          //           ],
          //         ),
          //       );

          //       return;
          //     }
          //     Navigator.pop(context);
          //     if (widget.user != null) {
          //       Navigator.pushReplacement(
          //         context,
          //         AnimatedRoute.slideFromRight(ProfilePage(user: widget.user!)),
          //       );
          //     }
          //   },
          // ),

          // ListTile(
          //   leading: Icon(Icons.login),
          //   title: Text('Login'),
          //   onTap: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (context) => LoginPage()),
          //     );
          //   },
          // ),
          const Divider(color: Colors.grey),
          SizedBox(
            height: screenHeight / 3.5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: const [
                Text("STTGK3013", style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('email');
    prefs.remove('password');
    prefs.remove('rememberMe');

    if (!mounted) return;
    await Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }
}
