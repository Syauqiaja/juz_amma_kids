import 'package:flutter/material.dart';
import 'package:juz_amma_kids/locator/assets.dart';
import 'package:juz_amma_kids/presentations/modals/button_scalable.dart';
import 'package:juz_amma_kids/presentations/modals/normal_button.dart';
import 'package:juz_amma_kids/theme/quranic_theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class InfoScreen extends StatefulWidget {
  const InfoScreen({super.key});

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  bool isLargeScreen = false;

  @override
  Widget build(BuildContext context) {
    isLargeScreen = MediaQuery.of(context).size.height > 650;
    return Padding(
      padding: const EdgeInsets.only(left: 24.0, right: 24, top: 16),
      child: Center(
        child: AspectRatio(
          aspectRatio: 1.5,
          child: Center(
            child: Stack(
              children: [
                Positioned.fill(
                  bottom: 24,
                  child: Image.asset(
                    Assets.frame2, // File gambar frame
                    fit: BoxFit
                        .fill, // Memastikan frame menyesuaikan seluruh area
                  ),
                ),
                Positioned(
                    left: 24,
                    right: 24,
                    top: 24,
                    bottom: 48,
                    child: Scrollbar(
                      trackVisibility: true,
                      thumbVisibility: true,
                      interactive: true,
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: Column(
                            children: [
                              Center(
                                  child: Text(
                                "Juz Amma Untuk Anak",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    decoration: TextDecoration.combine([]),
                                    fontFamily: 'titleFont',
                                    fontWeight: FontWeight.bold,
                                    shadows: [],
                                    height: 1.4),
                              )),
                              const SizedBox(height: 16),
                              Text(
                                '''
Juz Amma Untuk Anak adalah aplikasi edukatif untuk membantu anak-anak belajar membaca dan menghafal Juz Amma dari Al-Qur'an. Dirancang dengan teknologi AI canggih, aplikasi ini mampu menganalisis bacaan Al-Qur'an pengguna dan memberikan umpan balik instan tentang kesalahan dalam pelafalan.

Fitur-fitur utama:

🧠 Analisis Bacaan Otomatis dengan AI
Pengguna dapat membaca ayat Al-Qur'an dan aplikasi akan mendeteksi bacaan yang salah secara otomatis, menandai kata yang keliru dengan warna merah. Cocok untuk latihan mandiri atau bersama guru.

🎧 Audio Bacaan Terpadu
Dengarkan bacaan ayat-ayat pilihan, yang membantu anak-anak mengikuti dan meniru bacaan yang benar.

🔁 Pengulangan Ayat untuk Hafalan
Atur jumlah pengulangan tiap ayat sesuai kebutuhan agar proses hafalan lebih mudah dan menyenangkan.

🕌 Antarmuka Anak Ramah dan Islami
Desain visual yang menarik dan mudah digunakan oleh anak-anak, dengan semangat Islami yang kuat.

Aplikasi ini ideal untuk orang tua, guru, dan anak-anak yang ingin meningkatkan kemampuan membaca dan menghafal Al-Qur’an dengan cara modern dan interaktif.

Privacy Policy

This privacy policy applies to the mobile application Juz Amma Untuk Anak, provided as a free app and intended for use as is.

This page informs visitors about our policies regarding the collection, use, and disclosure of Personal Information for those who choose to use the Service.

By using the Service, you agree to the collection and use of information in accordance with this policy. The Personal Information collected is used to provide and improve the Service. We will not use or share your information except as described in this Privacy Policy.

The terms used in this Privacy Policy have the same meanings as in our Terms and Conditions unless otherwise defined here.

Information Collection and Use

For a better experience, we may require you to provide personally identifiable information. This data will be retained and used as described in this privacy policy.

The app uses third-party services that may collect information used to identify you.

Third-party service providers include:
- Google Play Services
- Google AdMob

Microphone Access and Audio Processing

This app may request access to your device's microphone to enable voice recording and related features. When using these features, your audio input may be transmitted to our servers for processing in real time (e.g. for voice recognition or recitation analysis). 

We do not store audio recordings or retain any voice data after processing. The transmission is secure and solely for the purpose of providing the app's voice-related functionalities. No audio is used for analytics, training, or advertising.

Advertising

This app uses Google AdMob to serve advertisements. AdMob may collect and use certain data (such as device identifiers, IP address, app usage data, and ad interaction data) to display personalized ads based on your interests.

If you prefer not to receive personalized ads, you can disable ad personalization in your device settings.

Learn more about how Google uses data from AdMob here:
https://policies.google.com/technologies/partner-sites

We do not control the data collection and usage practices of AdMob and recommend reviewing their privacy policy for more information.

Log Data

In case of an error in the app, we collect data on your device (via third-party products) called Log Data. This may include your IP address, device name, operating system version, app configuration, time and date of use, and other statistics.

Cookies

Cookies are files with small data used as anonymous unique identifiers. These are sent to your browser and stored on your device.

This Service does not use cookies explicitly, but third-party libraries may use them. You can accept or refuse cookies and be notified when one is sent. Refusing cookies may limit your use of some features.

Service Providers

We may employ third-party companies to:
- Facilitate our Service
- Provide the Service on our behalf
- Perform Service-related tasks
- Help analyze usage of our Service

These third parties may access your Personal Information only to perform tasks on our behalf and are obligated not to disclose or use it for any other purpose.

Security

We value your trust and use commercially acceptable means to protect your Personal Information. However, no method of transmission over the Internet or electronic storage is 100% secure, and we cannot guarantee absolute security.

Links to Other Sites

This Service may contain links to other sites. If you click a third-party link, you'll be directed to that site. These external sites are not operated by us, so we strongly advise reviewing their privacy policies. We do not control and are not responsible for any third-party content or privacy practices.

Children's Privacy

This Service does not address children under the age of 13. We do not knowingly collect personally identifiable information from children. If we discover that a child under 13 has provided us with personal information, we will delete it immediately. If you're a parent or guardian and believe your child has provided personal information, please contact us.

Changes to This Privacy Policy

We may update our Privacy Policy periodically. Please review this page for any changes. Updates will be posted on this page.

Effective Date: 2022-04-25

Contact Us

If you have any questions or suggestions about our Privacy Policy, contact us at:
appsstudiofactory@gmail.com
''',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    decoration: TextDecoration.combine([]),
                                    fontFamily: 'titleFont',
                                    shadows: [],
                                    height: 1.4),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: ButtonScalable(
                        child: Text("Tutup"),
                        onTap: () {
                          Navigator.of(context).pop();
                        })),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
