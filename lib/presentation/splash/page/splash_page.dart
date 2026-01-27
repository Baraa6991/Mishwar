import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishwar/Helper/cach_helper.dart';
import 'package:mishwar/Theme/colors_cubit/app_color_cubit.dart';
import 'package:mishwar/Theme/colors_cubit/app_color_state.dart';
import 'package:mishwar/data/repositories/trip_repository.dart';
import 'package:mishwar/presentation/home/cubit/check_end_cubit.dart';
import 'package:mishwar/presentation/home/cubit/exchange_cubit.dart';
import 'package:mishwar/presentation/home/cubit/trip_cubit.dart';
import 'package:mishwar/presentation/home/cubit/vehicle_classifications_cubit.dart';
import 'package:mishwar/presentation/home/page/trip_page.dart';
import 'package:mishwar/presentation/login/page/login_page.dart';
import 'package:mishwar/services/map_service.dart';
import 'dart:io';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});
  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  void _navigate() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    // فحص إذا كان المستخدم قد وافق على الشروط من قبل
    final hasAcceptedTerms =
        CacheHelper.getData(key: "accepted_terms") ?? false;

    if (!hasAcceptedTerms) {
      // إظهار dialog الشروط أولاً
      _showTermsDialog();
    } else {
      // المتابعة للتحقق من التوكن
      _checkTokenAndNavigate();
    }
  }

  void _showTermsDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const TermsDialog();
      },
    ).then((accepted) {
      if (accepted == true) {
        // إظهار dialog الخصوصية
        _showPrivacyDialog();
      } else {
        // الخروج من التطبيق
        exit(0);
      }
    });
  }

  void _showPrivacyDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const PrivacyDialog();
      },
    ).then((accepted) {
      if (accepted == true) {
        // حفظ الموافقة
        CacheHelper.saveData(key: "accepted_terms", value: true);
        _checkTokenAndNavigate();
      } else {
        // الخروج من التطبيق
        exit(0);
      }
    });
  }

  void _checkTokenAndNavigate() {
    final token = CacheHelper.getData(key: "token");
    if (token != null && token.toString().isNotEmpty) {
      // يوجد توكن → الانتقال للصفحة الرئيسية
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) =>
                    ExchangeCubit(repository: ApiTripRepository())
                      ..fetchExchange(),
              ),
              BlocProvider(create: (_) => CheckEndCubit(ApiTripRepository())),
              BlocProvider(
                create: (context) => TripCubit(
                  mapService: MapService(),
                  exchangeCubit: context.read<ExchangeCubit>(),
                ),
              ),
              BlocProvider(
                create: (_) =>
                    VehicleClassificationsCubit(repository: ApiTripRepository())
                      ..fetchVehicleClassifications(context),
              ),
            ],
            child: const HomeMapPage(),
          ),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeState appColors = context.watch<ThemeCubit>().state;
    return Scaffold(
      backgroundColor: appColors.primary,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/مشوار.png',
              width: 300.w,
              height: 300.h,
              fit: BoxFit.cover,
              color: appColors.secondary,
            ),
          ],
        ),
      ),
    );
  }
}

// Dialog شروط الاستخدام
class TermsDialog extends StatelessWidget {
  const TermsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeState appColors = context.watch<ThemeCubit>().state;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Container(
        padding: EdgeInsets.all(20.w),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
          maxWidth: MediaQuery.of(context).size.width * 0.9,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // العنوان
            Text(
              'شروط الاستخدام',
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
                color: appColors.primary,
              ),
            ),
            SizedBox(height: 16.h),

            // النص
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  _getTermsOfServiceText(),
                  style: TextStyle(
                    fontSize: 14.sp,
                    height: 1.5,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),

            SizedBox(height: 16.h),

            // أزرار القبول والرفض
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[300],
                      foregroundColor: Colors.black87,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: Text(
                      'رفض',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: appColors.primary,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: Text(
                      'قبول',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getTermsOfServiceText() {
    return '''شروط الخدمة

سياسة الدفع والاسترداد

لا تُصدر أي مبالغ مستردة أو استرداد نقدي. بمجرد إيداع المبلغ، يصبح غير قابل للاسترداد. يجب عليك استخدام رصيدك لشراء خدماتنا، مثل الاستضافة أو حملات تحسين محركات البحث. بإيداعك المبلغ، فإنك توافق على عدم تقديم أي نزاع أو طلب استرداد ضدنا.

في حال تقديم نزاع أو طلب استرداد بعد الإيداع، نحتفظ بحقنا في إلغاء جميع الطلبات المستقبلية وحظرك من موقعنا. الأنشطة الاحتيالية، مثل استخدام بطاقات ائتمان غير مصرح بها أو مسروقة، ستؤدي إلى إغلاق الحساب نهائيًا.

سياسة الرصيد المجاني والقسائم

نقدم طرقًا متعددة لكسب رصيد مجاني وقسائم وعروض إيداع، ولكننا نحتفظ بحقنا في مراجعة هذه الأرصدة وخصمها إذا اشتبهنا في أي شكل من أشكال إساءة الاستخدام. إذا خصمنا رصيدك المجاني وأصبح رصيد حسابك سالبًا، فسيتم تعليق حسابك. لإعادة تفعيل حساب معلق، يجب عليك سداد دفعة مخصصة لتسوية رصيدك.

معلومات الاتصال

إذا كانت لديكم أي استفسارات حول شروط الخدمة، يُرجى التواصل معنا. فريقنا مُتاح لمساعدتكم في أي استفسارات أو مخاوف تتعلق بشروط الخدمة. نحن ملتزمون بضمان تجربة آمنة ومُرضية لكم على منصتنا.''';
  }
}

// Dialog سياسة الخصوصية
class PrivacyDialog extends StatelessWidget {
  const PrivacyDialog({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeState appColors = context.watch<ThemeCubit>().state;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Container(
        padding: EdgeInsets.all(20.w),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
          maxWidth: MediaQuery.of(context).size.width * 0.9,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // العنوان
            Text(
              'سياسة الخصوصية',
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
                color: appColors.primary,
              ),
            ),
            SizedBox(height: 16.h),

            // النص
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  _getPrivacyPolicyText(),
                  style: TextStyle(
                    fontSize: 14.sp,
                    height: 1.5,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),

            SizedBox(height: 16.h),

            // أزرار القبول والرفض
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[300],
                      foregroundColor: Colors.black87,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: Text(
                      'رفض',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: appColors.primary,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: Text(
                      'قبول',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getPrivacyPolicyText() {
    return '''توضح سياسة الخصوصية هذه كيفية جمع معلوماتك الشخصية واستخدامها والإفصاح عنها وحمايتها عند زيارتك لموقعنا الإلكتروني. من خلال الوصول إلى موقعنا الإلكتروني أو استخدامه، فإنك توافق على شروط سياسة الخصوصية هذه وتوافق على جمع معلوماتك واستخدامها كما هو موضح هنا. نحن ملتزمون بضمان حماية خصوصيتك. إذا طلبنا منك تقديم معلومات معينة يمكن من خلالها تحديد هويتك عند استخدام هذا الموقع الإلكتروني، فيمكنك التأكد من أنها لن تُستخدم إلا وفقًا لسياسة الخصوصية هذه. نراجع بانتظام امتثالنا لهذه السياسة ونضمن أن جميع ممارسات التعامل مع البيانات شفافة وآمنة.

المعلومات التي نجمعها

نجمع معلومات شخصية مثل الأسماء وعناوين البريد الإلكتروني وبيانات التصفح لتحسين تجربة المستخدم وتقديم خدمات مخصصة. تساعدنا هذه البيانات على فهم تفضيلات المستخدم وتحسين عروضنا. خصوصيتك مهمة بالنسبة لنا، ونضمن التعامل مع جميع المعلومات بسرية تامة.

المعلومات الشخصية: الاسم وعنوان البريد الإلكتروني ورقم الهاتف وتفاصيل الاتصال الأخرى

بيانات الاستخدام: معلومات حول كيفية استخدامك لموقعنا الإلكتروني، بما في ذلك عنوان IP الخاص بك، ونوع المتصفح، والصفحات التي قمت بزيارتها

ملفات تعريف الارتباط وتقنية التتبع: نستخدم ملفات تعريف الارتباط لتحسين تجربتك على موقعنا الإلكتروني. يمكنك إدارة تفضيلات ملفات تعريف الارتباط من خلال إعدادات المتصفح

كيف نستخدم معلوماتك

نستخدم معلوماتك لتقديم خدماتنا وتحسينها، مما يضمن تجربة شخصية مصممة خصيصًا لتلبية احتياجاتك. يشمل ذلك معالجة المعاملات، وإرسال التحديثات، والرد على الاستفسارات. بالإضافة إلى ذلك، نستخدم بياناتك لأغراض تحليلية لتحسين عروضنا ولإجراءات أمنية للحماية من الاحتيال

لتقديم خدماتنا وصيانتها

لتحسين وتخصيص تجربتك على موقعنا الإلكتروني

للتواصل معك، بما في ذلك إرسال التحديثات والمواد الترويجية

لتحليل استخدام الموقع الإلكتروني وتحسين خدماتنا

مشاركة معلوماتك

لا نبيع أو نتاجر أو ننقل معلوماتك الشخصية إلى أطراف خارجية إلا كما هو موضح في سياسة الخصوصية هذه. نتخذ خطوات معقولة لضمان التزام أي أطراف ثالثة نشاركها معلوماتك الشخصية بالتزامات السرية والأمن المناسبة فيما يتعلق بمعلوماتك الشخصية. نحن نتفهم أهمية الحفاظ على خصوصية وأمان معلوماتك الشخصية. لذلك، ننفذ تدابير صارمة لحماية بياناتك من الوصول أو الاستخدام أو الكشف غير المصرح به. يشمل التزامنا بحماية خصوصيتك

تشفير البيانات: نستخدم تقنيات تشفير متقدمة لحماية معلوماتك الشخصية أثناء النقل والتخزين. وهذا يضمن أن تكون بياناتك آمنة وغير قابلة للوصول من قبل أطراف غير مصرح لها.

ضوابط الوصول: نقيد الوصول إلى معلوماتك الشخصية على الموظفين والمقاولين والوكلاء الذين يحتاجون إلى معرفة تلك المعلومات لمعالجتها نيابةً عنا فقط. يخضع هؤلاء الأفراد لالتزامات سرية صارمة، وقد يتم تأديبهم أو فصلهم إذا فشلوا في الوفاء بهذه الالتزامات

عمليات تدقيق منتظمة: نجري عمليات تدقيق منتظمة لممارسات التعامل مع البيانات وتدابير الأمان لدينا لضمان الامتثال لسياسة الخصوصية هذه والقوانين المعمول بها. يساعدنا ذلك في تحديد ومعالجة أي ثغرات محتملة في أنظمتنا.

الاستجابة للحوادث: في حالة حدوث خرق غير محتمل للبيانات، وضعنا إجراءات للاستجابة السريعة والفعالة. سنخطرك ونخطر أي سلطات ذات صلة وفقًا لما يقتضيه القانون، وسنتخذ جميع الخطوات اللازمة للتخفيف من تأثير الخرق.

تواصل معنا

إذا كانت لديك أي أسئلة حول خصوصيتنا وسياستنا، فيُرجى الاتصال بنا. فريقنا متاح لمساعدتك في أي استفسارات أو مخاوف قد تكون لديك بشأن خصوصيتنا وسياستنا. نحن نقدر خصوصيتك ونلتزم بضمان أن تكون تجربتك على موقعنا الإلكتروني شفافة ومرضية.''';
  }
}