import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../services/database_helper.dart';

enum AuthStatus {
  success,
  error,
  userNotFound,
  wrongPassword,
  userExists
}

class AuthController extends GetxController {
  final dbHelper = DatabaseHelper.instance;
  late SharedPreferences _prefs;

  var isLoggedIn = false.obs;
  var currentUser = Rx<User?>(null);
  var isAdmin = false.obs;

  @override
  void onInit() async {
    super.onInit();
    _prefs = await SharedPreferences.getInstance();
    await checkLoginStatus();
  }

  // Check if user is already logged in
  Future<void> checkLoginStatus() async {
    int? userId = _prefs.getInt('user_id');
    if (userId != null) {
      if (userId == 0) {
        // Hardcoded Admin User
        currentUser.value = User(
          id: 0,
          name: 'talal',
          password: 'talal12345',
          role: 'admin',
        );
        isLoggedIn.value = true;
        isAdmin.value = true;
        return;
      }

      var user = await dbHelper.getUserById(userId);
      if (user != null) {
        currentUser.value = User.fromMap(user);
        isLoggedIn.value = true;
        isAdmin.value = currentUser.value?.role == 'admin';
      }
    }
  }

  // Login
  Future<AuthStatus> login(String name, String password) async {
    // Check for hardcoded admin credentials
    if (name == 'talal' && password == 'talal12345') {
      currentUser.value = User(
        id: 0,
        name: 'talal',
        password: 'talal12345',
        role: 'admin',
      );
      isLoggedIn.value = true;
      isAdmin.value = true;

      // Save user ID 0 for admin
      await _prefs.setInt('user_id', 0);
      return AuthStatus.success;
    }

    try {
      List<Map<String, dynamic>> users = await dbHelper.getAllUsers();
      
      // Check if user exists first
      var user = users.firstWhereOrNull((u) => u['name'] == name);
      
      if (user == null) {
        return AuthStatus.userNotFound;
      }
      
      if (user['password'] != password) {
        return AuthStatus.wrongPassword;
      }

      currentUser.value = User.fromMap(user);
      isLoggedIn.value = true;
      isAdmin.value = currentUser.value?.role == 'admin';

      // Save user ID to SharedPreferences
      await _prefs.setInt('user_id', user['id']);
      return AuthStatus.success;
    } catch (e) {
      print('Login error: $e');
      return AuthStatus.error;
    }
  }

  // Register
  Future<AuthStatus> register(String name, String phone, String password) async {
    try {
      // Check if user already exists
      List<Map<String, dynamic>> users = await dbHelper.getAllUsers();
      var existingUser = users.firstWhereOrNull((u) => u['name'] == name);
      
      if (existingUser != null) {
        return AuthStatus.userExists;
      }

      User newUser = User(
        name: name,
        phone: phone,
        password: password,
        role: 'client',
      );

      int id = await dbHelper.insertUser(newUser.toMap());
      newUser = User(
        id: id,
        name: name,
        phone: phone,
        password: password,
        role: 'client',
      );

      currentUser.value = newUser;
      isLoggedIn.value = true;
      isAdmin.value = false;

      // Save user ID to SharedPreferences
      await _prefs.setInt('user_id', id);
      return AuthStatus.success;
    } catch (e) {
      print('Register error: $e');
      return AuthStatus.error;
    }
  }

  // Logout
  Future<void> logout() async {
    currentUser.value = null;
    isLoggedIn.value = false;
    isAdmin.value = false;
    await _prefs.remove('user_id');
  }
}
