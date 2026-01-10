import 'package:flutter/material.dart';
import 'package:pawpal/models/user.dart';
import 'package:pawpal/my_config.dart';
import 'package:pawpal/screens/MyDonationsScreen.dart';
import 'package:pawpal/screens/MyPetsScreen.dart';
import 'package:pawpal/screens/ProfileScreen.dart';
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
            currentAccountPicture: CircleAvatar(
              foregroundImage: NetworkImage(
                '${MyConfig.baseUrl}/pawpal/assets/${widget.user!.profileImagePath}',
              ),
            ),
            accountName: Text(widget.user?.name ?? 'Guest'),
            accountEmail: Text(widget.user?.email ?? 'Guest'),
          ),

          ListTile(
            // Profile button
            leading: Icon(Icons.person),
            title: Text('Profile'),
            onTap: () {
              if (widget.user?.userId == '0') {
                //showdialog
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    title: Row(
                      children: const [
                        Icon(Icons.lock_outline),
                        SizedBox(width: 8),
                        Text("Login Required"),
                      ],
                    ),
                    content: const Text(
                      "Please login to continue and access this feature.",
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Cancel"),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orangeAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            AnimatedRoute.slideFromLeftDrawer(
                              const LoginPage(),
                            ),
                          );
                        },
                        child: const Text(
                          "Login",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                );

                return;
              }

              if (widget.user != null) {
                Navigator.pushReplacement(
                  context,
                  AnimatedRoute.slideFromLeftDrawer(
                    ProfileScreen(user: widget.user!),
                  ),
                );
              }
            },
          ),

          const Divider(color: Colors.orangeAccent),

          ListTile(
            // Home button
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              Navigator.push(
                context,
                AnimatedRoute.slideFromLeftDrawer(
                  MainScreen(user: widget.user),
                ),
                // MaterialPageRoute(
                //   builder: (context) => MainScreen(user: widget.user),
                // ),
              );
            },
          ),

          ListTile(
            // My Pets button
            leading: Icon(Icons.pets),
            title: Text('My Pets'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                AnimatedRoute.slideFromLeftDrawer(
                  MyPetsScreen(user: widget.user),
                ),
              );
            },
          ),

          ListTile(
            // My Donations button
            leading: Icon(Icons.volunteer_activism),
            title: Text('My Donations'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                AnimatedRoute.slideFromLeftDrawer(
                  MyDonationsScreen(user: widget.user),
                ),
              );
            },
          ),

          const Divider(color: Colors.orangeAccent),

          ListTile(
            // Logout button
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () {
              logout();
            },
          ),

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
