import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
// تأكد من أن مسارات الاستيراد هذه صحيحة في مشروعك
import '../utils/app_colors.dart';
import '../utils/localization.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  // البيانات الثابتة للصفحة
  final String phoneNumber = '+967770939800';
  final String shopNameAr = 'أبو زياد لتفصيل الدواليب';
  final String ownerNameAr = 'طلال غانم';
  final String addressAr = 'إب - جبلة - الشارع العام - أمام عالم الجوال';

  @override
  Widget build(BuildContext context) {
    // استخدام لون أساسي في حال لم يكن AppColors معرفاً تماماً
    final Color primaryColor = AppColors.primary;
    final Color secondaryColor = AppColors.secondary;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.about), // أو استبدلها بـ Text("من نحن") مباشرة
        centerTitle: true,
        backgroundColor: primaryColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section - رأس الصفحة
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [primaryColor, secondaryColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.storefront_rounded,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    shopNameAr,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "دقة في التصميم.. جودة في التنفيذ",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Info Section - قسم المعلومات
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  // كارت معلومات المالك
                  _buildInfoTile(
                    icon: Icons.person,
                    title: "مالك المحل",
                    subtitle: ownerNameAr,
                    color: primaryColor,
                  ),
                  const SizedBox(height: 15),
                  // كارت العنوان
                  _buildInfoTile(
                    icon: Icons.location_on,
                    title: "العنوان",
                    subtitle: addressAr,
                    color: primaryColor,
                  ),

                  const SizedBox(height: 30),
                  const Divider(),
                  const SizedBox(height: 20),

                  // Contact Buttons Section - قسم أزرار التواصل
                  const Text(
                    "تواصل معنا مباشرة",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      // زر الاتصال
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _launchCall(phoneNumber),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[700],
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: const Icon(Icons.call, color: Colors.white),
                          label: const Text(
                            "اتصال",
                            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      // زر الواتساب
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _launchWhatsApp(phoneNumber),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF25D366), // لون واتساب الرسمي
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: const Icon(Icons.message_rounded, color: Colors.white),
                          label: const Text(
                            "واتساب",
                            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // دالة مساعدة لبناء كروت المعلومات
  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color,
            fontSize: 14,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black87,
            height: 1.3,
          ),
        ),
      ),
    );
  }

  // دوال الاتصال والمراسلة (خارج الـ build)
  void _launchWhatsApp(String phone) async {
    final String message = 'مرحباً، أود الاستفسار عن تفصيل الدواليب لديكم.';
    // تنظيف الرقم وإعداده للرابط
    final cleanPhone = phone.replaceAll('+', '').replaceAll('-', '').replaceAll(' ', '');

    // استخدام رابط عالمي يعمل على أندرويد و iOS
    final Uri whatsappUrl = Uri.parse("https://wa.me/$cleanPhone?text=${Uri.encodeComponent(message)}");

    try {
      if (await canLaunchUrl(whatsappUrl)) {
        await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
      } else {
        debugPrint("Could not launch WhatsApp: $whatsappUrl");
        // يمكنك هنا إظهار رسالة خطأ للمستخدم (SnackBar)
      }
    } catch (e) {
      debugPrint("Error launching WhatsApp: $e");
    }
  }

  void _launchCall(String phone) async {
    final Uri callUrl = Uri.parse('tel:$phone');
    try {
      if (await canLaunchUrl(callUrl)) {
        await launchUrl(callUrl);
      } else {
        debugPrint("Could not launch call: $callUrl");
      }
    } catch (e) {
      debugPrint("Error launching call: $e");
    }
  }
}