import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class ImageCubit extends Cubit<ImageState> {
  ImageCubit() : super(ImageInitial());

  final ImagePicker picker = ImagePicker();

  // اختيار صورة من المعرض
  Future<void> pickImageFromGallery() async {
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      emit(ImagePicked(File(pickedFile.path)));
    }
  }

  // إعادة تعيين الصورة
  void resetImage() {
    emit(ImageInitial());
  }
}

abstract class ImageState {}

class ImageInitial extends ImageState {}

class ImagePicked extends ImageState {
  final File image;
  ImagePicked(this.image);
}
