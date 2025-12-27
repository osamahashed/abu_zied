import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const _databaseName = "AbuZiyad.db";
  static const _databaseVersion = 1;

  // Table names
  static const tableUsers = 'users';
  static const tableCategories = 'categories';
  static const tableProducts = 'products';
  static const tableOrders = 'orders';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    // Users table
    await db.execute('''
      CREATE TABLE $tableUsers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        phone TEXT,
        password TEXT NOT NULL,
        role TEXT NOT NULL DEFAULT 'client'
      )
    ''');

    // Categories table
    await db.execute('''
      CREATE TABLE $tableCategories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name_ar TEXT NOT NULL,
        name_en TEXT NOT NULL,
        icon TEXT
      )
    ''');

    // Products table
    await db.execute('''
      CREATE TABLE $tableProducts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name_ar TEXT NOT NULL,
        name_en TEXT NOT NULL,
        description_ar TEXT,
        description_en TEXT,
        price REAL NOT NULL,
        image TEXT NOT NULL,
        category_id INTEGER NOT NULL,
        FOREIGN KEY (category_id) REFERENCES $tableCategories (id) ON DELETE CASCADE
      )
    ''');

    // Orders table
    await db.execute('''
      CREATE TABLE $tableOrders (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        product_id INTEGER NOT NULL,
        notes TEXT,
        order_date TEXT NOT NULL,
        status TEXT NOT NULL DEFAULT 'pending',
        FOREIGN KEY (user_id) REFERENCES $tableUsers (id),
        FOREIGN KEY (product_id) REFERENCES $tableProducts (id)
      )
    ''');

    await _createInitialData(db);
  }

  Future<void> _createInitialData(Database db) async {
    // Add default admin user
    await db.rawInsert('''
      INSERT INTO $tableUsers(name, password, role) VALUES('admin', 'admin123', 'admin')
    ''');

    // Add initial categories
    await db.rawInsert('''
      INSERT INTO $tableCategories(name_ar, name_en, icon) VALUES('دواليب ملابس', 'Wardrobes', 'wardrobe')
    ''');
    await db.rawInsert('''
      INSERT INTO $tableCategories(name_ar, name_en, icon) VALUES('مطابخ', 'Kitchens', 'kitchen')
    ''');
    await db.rawInsert('''
      INSERT INTO $tableCategories(name_ar, name_en, icon) VALUES('خزائن', 'Cabinets', 'cabinet')
    ''');


  }

  // CRUD Operations for Users
  Future<int> insertUser(Map<String, dynamic> row) async {
    Database db = await database;
    return await db.insert(tableUsers, row);
  }

  Future<List<Map<String, dynamic>>> getAllUsers() async {
    Database db = await database;
    return await db.query(tableUsers);
  }

  Future<Map<String, dynamic>?> getUserById(int id) async {
    Database db = await database;
    List<Map<String, dynamic>> result =
        await db.query(tableUsers, where: 'id = ?', whereArgs: [id]);
    return result.isNotEmpty ? result.first : null;
  }

  Future<int> updateUser(Map<String, dynamic> row) async {
    Database db = await database;
    int id = row['id'];
    return await db.update(tableUsers, row, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteUser(int id) async {
    Database db = await database;
    return await db.delete(tableUsers, where: 'id = ?', whereArgs: [id]);
  }

  // CRUD Operations for Categories
  Future<int> insertCategory(Map<String, dynamic> row) async {
    Database db = await database;
    return await db.insert(tableCategories, row);
  }

  Future<List<Map<String, dynamic>>> getAllCategories() async {
    Database db = await database;
    return await db.query(tableCategories);
  }

  Future<int> updateCategory(Map<String, dynamic> row) async {
    Database db = await database;
    int id = row['id'];
    return await db.update(tableCategories, row,
        where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteCategory(int id) async {
    Database db = await database;
    return await db.delete(tableCategories, where: 'id = ?', whereArgs: [id]);
  }

  // CRUD Operations for Products
  Future<int> insertProduct(Map<String, dynamic> row) async {
    Database db = await database;
    return await db.insert(tableProducts, row);
  }

  Future<List<Map<String, dynamic>>> getAllProducts() async {
    Database db = await database;
    return await db.query(tableProducts);
  }

  Future<List<Map<String, dynamic>>> getProductsByCategory(
      int categoryId) async {
    Database db = await database;
    return await db.query(tableProducts,
        where: 'category_id = ?', whereArgs: [categoryId]);
  }

  Future<Map<String, dynamic>?> getProductById(int id) async {
    Database db = await database;
    List<Map<String, dynamic>> result =
        await db.query(tableProducts, where: 'id = ?', whereArgs: [id]);
    return result.isNotEmpty ? result.first : null;
  }

  Future<int> updateProduct(Map<String, dynamic> row) async {
    Database db = await database;
    int id = row['id'];
    return await db.update(tableProducts, row,
        where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteProduct(int id) async {
    Database db = await database;
    return await db.delete(tableProducts, where: 'id = ?', whereArgs: [id]);
  }

  // CRUD Operations for Orders
  Future<int> insertOrder(Map<String, dynamic> row) async {
    Database db = await database;
    return await db.insert(tableOrders, row);
  }

  Future<List<Map<String, dynamic>>> getAllOrders() async {
    Database db = await database;
    return await db.query(tableOrders);
  }

  Future<List<Map<String, dynamic>>> getOrdersByUser(int userId) async {
    Database db = await database;
    return await db.query(tableOrders,
        where: 'user_id = ?', whereArgs: [userId]);
  }

  Future<Map<String, dynamic>?> getOrderById(int id) async {
    Database db = await database;
    List<Map<String, dynamic>> result =
        await db.query(tableOrders, where: 'id = ?', whereArgs: [id]);
    return result.isNotEmpty ? result.first : null;
  }

  Future<int> updateOrder(Map<String, dynamic> row) async {
    Database db = await database;
    int id = row['id'];
    return await db.update(tableOrders, row, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteOrder(int id) async {
    Database db = await database;
    return await db.delete(tableOrders, where: 'id = ?', whereArgs: [id]);
  }
}
