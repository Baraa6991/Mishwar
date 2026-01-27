import 'package:bloc/bloc.dart';
import 'package:mishwar/data/repositories/auth_repository.dart';
import 'package:mishwar/Helper/cach_helper.dart';
import 'package:mishwar/generated/l10n.dart';

part 'delete_account_state.dart';

class DeleteAccountCubit extends Cubit<DeleteAccountState> {
  final ApiRepository repository;

  DeleteAccountCubit({required this.repository}) : super(DeleteAccountInitial());

  Future<void> deleteAccount() async {
    emit(DeleteAccountLoading());
    print("🟡 [DeleteAccountCubit] بدأ تنفيذ deleteAccount()");

    try {
      // --- 1️⃣ الحصول على معرف المستخدم من الكاش ---
      final id = CacheHelper.getUserId();
      print("🔹 [DeleteAccountCubit] تم استرجاع userId من الكاش: $id");

      if (id == null) {
        print("❌ [DeleteAccountCubit] فشل: userId غير موجود في الكاش!");
        emit(DeleteAccountError(message: "User ID not found in cache"));
        return;
      }

      // --- 2️⃣ إرسال الطلب إلى الـ Repository ---
      print("🔹 [DeleteAccountCubit] إرسال طلب حذف الحساب إلى الـ Repository...");
      final data = await repository.deleteAccount(userId: id);

      print("🟢 [DeleteAccountCubit] استجابة الـ Repository: $data");

      // --- 3️⃣ التحقق من الاستجابة ---
      if (data['successful'] == true) {
        print("✅ [DeleteAccountCubit] تم حذف الحساب بنجاح من السيرفر.");
        await CacheHelper.removeAllData();
        print("🧹 [DeleteAccountCubit] تم مسح جميع بيانات الكاش.");
        emit(DeleteAccountSuccess(message: S.current.DeleteSuccess));
      } else {
        print("⚠️ [DeleteAccountCubit] فشل حذف الحساب - القيمة successful ليست true.");
        emit(DeleteAccountError(message: S.current.DeleteFailed));
      }

    } catch (e, stack) {
      // --- 4️⃣ التقاط أي خطأ غير متوقع ---
      print("🔥 [DeleteAccountCubit] حدث خطأ أثناء حذف الحساب: $e");
      print("📜 StackTrace: $stack");
      emit(DeleteAccountError(message: S.current.DeleteFailed));
    }
  }
}
