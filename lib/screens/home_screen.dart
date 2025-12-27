import 'dart:async';
import 'dart:io';
import 'dart:ui'; // مهم لتأثير الزجاج (Blur)
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../controllers/product_controller.dart';
import '../controllers/theme_controller.dart';
import '../controllers/language_controller.dart';
import '../models/category_model.dart';
import '../utils/app_colors.dart';
import '../utils/localization.dart';
import '../utils/icon_helper.dart';

import 'login_screen.dart';
import 'product_detail_screen.dart';
import 'admin_panel_screen.dart';
import 'about_screen.dart';
import 'orders_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthController authController = Get.put(AuthController());
  final ProductController productController = Get.put(ProductController());
  final ThemeController themeController = Get.put(ThemeController());
  final LanguageController languageController = Get.put(LanguageController());

  final PageController _pageController = PageController(viewportFraction: 0.9);
  Timer? _timer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    // تشغيل المؤقت للصور المتحركة
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!_pageController.hasClients) return;
      // نفترض وجود 3 عناصر في الكاروسيل
      if (_currentPage < 2) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 600),
        curve: Curves.fastOutSlowIn,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ✅ التحقق من الثيم بدون Obx لتقليل إعادة البناء
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final List<Color> bgGradient = isDark
        ? [const Color(0xFF1A1A2E), const Color(0xFF16213E)]
        : [const Color(0xFFFDFBF7), const Color(0xFFEDF1F4)];

    final Color textColor = isDark ? Colors.white : Colors.black87;
    final Color cardColor = isDark ? const Color(0xFF252A40) : Colors.white;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          AppStrings.appName,
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 24,
            color: textColor,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: textColor),
        actions: [
          _buildAppBarAction(
            Icons.brightness_4_outlined,
                () {
              // ✅ تبديل الثيم
              themeController.toggleTheme();
            },
            isDark,
          ),
          _buildAppBarAction(Icons.language,
                  () => languageController.toggleLanguage(), isDark),
          const SizedBox(width: 8),
        ],
      ),
      drawer: _buildDrawer(isDark), // ✅ تم استرجاع القائمة الجانبية
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: bgGradient,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),

                // ✅ الكاروسيل مع التفاصيل
                _buildCarousel(isDark),
                const SizedBox(height: 30),

                // قسم الفئات
                _buildSectionHeader(
                    AppStrings.categories, textColor, AppColors.primary),
                const SizedBox(height: 16),

                // 👇👇 التعديل هنا: أضفنا Obx لمراقبة البيانات 👇👇
                Obx(() => SizedBox(
                  height: 125,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    // الآن عندما تتغير البيانات في الكنترولر، سيتم تحديث هذا الرقم تلقائياً
                    itemCount: productController.categories.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 16),
                    itemBuilder: (context, index) {
                      var category = productController.categories[index];
                      return _buildCategoryCard(
                          category, isDark, cardColor, textColor);
                    },
                  ),
                )), // 👈 لا تنس إغلاق قوس Obx هنا

                const SizedBox(height: 24),
                // قسم المنتجات
                _buildSectionHeader(
                    AppStrings.products, textColor, AppColors.secondary),
                const SizedBox(height: 16),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Obx(() => GridView.builder(
                    key: const PageStorageKey('products_grid'),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.58, // ✅ نسبة الطول المناسبة
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: productController.filteredProducts.length,
                    itemBuilder: (context, index) {
                      var product = productController.filteredProducts[index];
                      return GestureDetector(
                        onTap: () => Get.to(
                                () => ProductDetailScreen(product: product)),
                        child: _buildProductCardContainer(
                            product, isDark, cardColor),
                      );
                    },
                  )),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ================= HELPERS & WIDGETS =================

  // ✅ 1. استرجاع بطاقة الفئات الملونة
  Widget _buildCategoryCard(
      Category category, bool isDark, Color cardColor, Color textColor) {
    return GestureDetector(
      onTap: () => productController.filterByCategory(category),
      child: Container(
        width: 90,
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
              color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey.withOpacity(0.1),
              width: 1),
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black.withOpacity(0.3) : const Color(0xFF4C5876).withOpacity(0.08),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 55,
              width: 55,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(isDark ? 0.1 : 0.05),
                shape: BoxShape.circle,
              ),
              child: ShaderMask(
                shaderCallback: (Rect bounds) {
                  return const LinearGradient(
                    colors: [AppColors.primary, AppColors.secondary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ).createShader(bounds);
                },
                child: Icon(
                  IconHelper.getIcon(category.icon),
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              category.name,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: textColor,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ 2. استرجاع بطاقة المنتج الكاملة (مع حذف القلب والتقييم)
  Widget _buildProductCardContainer(var product, bool isDark, Color cardColor) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withOpacity(0.3) : Colors.grey.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 5),
            spreadRadius: 1,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // قسم الصورة
            Expanded(
              flex: 5,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: 'product_${product.name}',
                    child: product.image.isNotEmpty
                        ? Image.file(
                      File(product.image),
                      fit: BoxFit.cover,
                      cacheWidth: 350, // ✅ تحسين الأداء
                      gaplessPlayback: true,
                      errorBuilder: (_, __, ___) => Container(
                        color: Colors.grey[300],
                        child: const Icon(Icons.image, size: 50, color: Colors.grey),
                      ),
                    )
                        : Container(color: AppColors.primary.withOpacity(0.2)),
                  ),

                  // ❌ تم حذف أيقونة القلب من هنا

                  // علامة جديد
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.secondary,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        "جديد",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // قسم التفاصيل (تم استرجاعه)
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "أثاث فاخر", // نص ثابت
                          style: TextStyle(
                            fontSize: 10,
                            color: isDark ? Colors.grey[400] : Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          product.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),

                        // ❌ تم حذف قسم التقييم (النجوم) من هنا

                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible( // ✅ لمنع الخطأ عند كبر الرقم
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: '${product.price} ',
                                    style: const TextStyle(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 16,
                                    ),
                                  ),
                                  TextSpan(
                                    text: AppStrings.rial,
                                    style: TextStyle(
                                      color: isDark ? Colors.white70 : Colors.grey[700],
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.add, color: Colors.white, size: 20),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ 3. استرجاع الكاروسيل مع النصوص والتدرج
  Widget _buildCarousel(bool isDark) {
    return Obx(() {
      if (productController.products.isEmpty) return const SizedBox.shrink();

      final lastProducts = productController.products.reversed.take(3).toList();

      return SizedBox(
        height: 240,
        child: PageView.builder(
          controller: _pageController,
          itemCount: lastProducts.length,
          itemBuilder: (context, index) {
            final product = lastProducts[index];
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.file(
                      File(product.image),
                      fit: BoxFit.cover,
                      cacheWidth: 600, // ✅ تحسين الأداء
                      gaplessPlayback: true,
                    ),
                    // التدرج الأسود للنصوص
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: const [0.3, 1.0],
                          colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
                        ),
                      ),
                    ),
                    // النصوص العائمة
                    Positioned(
                      bottom: 20,
                      left: 20,
                      right: 20,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3), // ✅ تخفيف الضباب لعدم التعليق
                          child: Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              border: Border.all(color: Colors.white.withOpacity(0.15)),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.name,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: AppColors.secondary,
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          AppStrings.isNew,
                                          style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  '${product.price} ${AppStrings.rial}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    });
  }

  // ✅ 4. استرجاع القائمة الجانبية (Drawer)
  Widget _buildDrawer(bool isDark) {
    return Drawer(
      backgroundColor: isDark ? const Color(0xFF1E1E2C) : Colors.white,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 60, bottom: 30, left: 20, right: 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primary,
                  isDark ? Colors.black87 : AppColors.primary.withOpacity(0.7),
                ],
              ),
              borderRadius: const BorderRadius.only(bottomRight: Radius.circular(40)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundColor: isDark ? Colors.grey[900] : Colors.white,
                  child: Icon(Icons.person, size: 40, color: AppColors.primary),
                ),
                const SizedBox(height: 15),
                Text(
                  AppStrings.appName,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                Obx(() => Text(
                  authController.isLoggedIn.value ? '${authController.currentUser.value?.name}' : 'زائر',
                  style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14),
                )),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(top: 20),
              children: [
                _buildDrawerTile(Icons.home_rounded, AppStrings.home, () => Get.back(), isDark),
                _buildDrawerTile(Icons.grid_view_rounded, AppStrings.categories, () {
                  Get.back();
                  Get.offAll(() => const HomeScreen());
                }, isDark),
                _buildDrawerTile(Icons.info_outline_rounded, AppStrings.about, () {
                  Get.back();
                  Get.to(() => const AboutScreen());
                }, isDark),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Divider(color: isDark ? Colors.white24 : Colors.grey[300])),
                Obx(() => authController.isLoggedIn.value
                    ? Column(
                  children: [
                    if (authController.isAdmin.value)
                      _buildDrawerTile(Icons.dashboard_rounded, AppStrings.adminPanel, () {
                        Get.back();
                        Get.to(() => const AdminPanelScreen());
                      }, isDark),
                    _buildDrawerTile(Icons.shopping_bag_outlined, AppStrings.orders, () {
                      Get.back();
                      Get.to(() => const OrdersScreen());
                    }, isDark),
                    _buildDrawerTile(Icons.logout, AppStrings.logout, () {
                      authController.logout();
                      Get.back();
                    }, isDark, color: Colors.redAccent),
                  ],
                )
                    : _buildDrawerTile(Icons.login_rounded, AppStrings.login, () {
                  Get.back();
                  Get.to(() => const LoginScreen());
                }, isDark)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerTile(IconData icon, String title, VoidCallback onTap, bool isDark, {Color? color}) {
    Color itemColor = color ?? (isDark ? Colors.white70 : Colors.black87);
    return ListTile(
      leading: Icon(icon, color: itemColor),
      title: Text(title, style: TextStyle(color: itemColor, fontWeight: FontWeight.w500)),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24),
    );
  }

  Widget _buildSectionHeader(String title, Color textColor, Color indicatorColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Container(
            height: 25,
            width: 5,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [indicatorColor, indicatorColor.withOpacity(0.5)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBarAction(IconData icon, VoidCallback onTap, bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, size: 20),
        onPressed: onTap,
        splashRadius: 22,
      ),
    );
  }
}