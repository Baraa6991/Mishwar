// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Login`
  String get LoginTitle {
    return Intl.message('Login', name: 'LoginTitle', desc: '', args: []);
  }

  /// `Phone number 09xxxxxxxx`
  String get LoginTextFieldPhone {
    return Intl.message(
      'Phone number 09xxxxxxxx',
      name: 'LoginTextFieldPhone',
      desc: '',
      args: [],
    );
  }

  /// `Don't have an account?`
  String get LoginRegister {
    return Intl.message(
      'Don\'t have an account?',
      name: 'LoginRegister',
      desc: '',
      args: [],
    );
  }

  /// `Create Account`
  String get LoginRegisterGo {
    return Intl.message(
      'Create Account',
      name: 'LoginRegisterGo',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get RegisterTextFieldName {
    return Intl.message(
      'Name',
      name: 'RegisterTextFieldName',
      desc: '',
      args: [],
    );
  }

  /// `Phone number 09xxxxxxxx`
  String get RegisterTextFieldPhone {
    return Intl.message(
      'Phone number 09xxxxxxxx',
      name: 'RegisterTextFieldPhone',
      desc: '',
      args: [],
    );
  }

  /// `Have an account?`
  String get RegisterLogin {
    return Intl.message(
      'Have an account?',
      name: 'RegisterLogin',
      desc: '',
      args: [],
    );
  }

  /// `Verification`
  String get Verification {
    return Intl.message(
      'Verification',
      name: 'Verification',
      desc: '',
      args: [],
    );
  }

  /// `Resend Code`
  String get ReSendCode {
    return Intl.message('Resend Code', name: 'ReSendCode', desc: '', args: []);
  }

  /// `Old Trips`
  String get OldTrips {
    return Intl.message('Old Trips', name: 'OldTrips', desc: '', args: []);
  }

  /// `Password`
  String get LoginPassword {
    return Intl.message('Password', name: 'LoginPassword', desc: '', args: []);
  }

  /// `Login successful`
  String get LoginSuccess {
    return Intl.message(
      'Login successful',
      name: 'LoginSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Login failed, please check your credentials`
  String get LoginFailed {
    return Intl.message(
      'Login failed, please check your credentials',
      name: 'LoginFailed',
      desc: '',
      args: [],
    );
  }

  /// `Registered successfully! Check your phone for verification code`
  String get RegisterSuccess {
    return Intl.message(
      'Registered successfully! Check your phone for verification code',
      name: 'RegisterSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Registration failed`
  String get RegisterFailed {
    return Intl.message(
      'Registration failed',
      name: 'RegisterFailed',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Password`
  String get RegisterConfirmPassword {
    return Intl.message(
      'Confirm Password',
      name: 'RegisterConfirmPassword',
      desc: '',
      args: [],
    );
  }

  /// `Phone verified successfully`
  String get VerificationSuccess {
    return Intl.message(
      'Phone verified successfully',
      name: 'VerificationSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Verification failed`
  String get VerificationFailed {
    return Intl.message(
      'Verification failed',
      name: 'VerificationFailed',
      desc: '',
      args: [],
    );
  }

  /// `Verification code sent successfully`
  String get ResendCodeSuccess {
    return Intl.message(
      'Verification code sent successfully',
      name: 'ResendCodeSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Failed to resend code`
  String get ResendCodeFailed {
    return Intl.message(
      'Failed to resend code',
      name: 'ResendCodeFailed',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the 6-digit code`
  String get VerificationCodeRequired {
    return Intl.message(
      'Please enter the 6-digit code',
      name: 'VerificationCodeRequired',
      desc: '',
      args: [],
    );
  }

  /// `Password reset code sent successfully`
  String get ForgetPasswordSuccess {
    return Intl.message(
      'Password reset code sent successfully',
      name: 'ForgetPasswordSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Failed to send password reset code`
  String get ForgetPasswordFailed {
    return Intl.message(
      'Failed to send password reset code',
      name: 'ForgetPasswordFailed',
      desc: '',
      args: [],
    );
  }

  /// `Connection error, please check your internet`
  String get ErrorConnection {
    return Intl.message(
      'Connection error, please check your internet',
      name: 'ErrorConnection',
      desc: '',
      args: [],
    );
  }

  /// `Server error, please try again later`
  String get ErrorServer {
    return Intl.message(
      'Server error, please try again later',
      name: 'ErrorServer',
      desc: '',
      args: [],
    );
  }

  /// `Unexpected error occurred`
  String get ErrorUnexpected {
    return Intl.message(
      'Unexpected error occurred',
      name: 'ErrorUnexpected',
      desc: '',
      args: [],
    );
  }

  /// `Invalid credentials, please try again`
  String get ErrorInvalidCredentials {
    return Intl.message(
      'Invalid credentials, please try again',
      name: 'ErrorInvalidCredentials',
      desc: '',
      args: [],
    );
  }

  /// `You are not authorized, please log in again`
  String get ErrorUnauthorized {
    return Intl.message(
      'You are not authorized, please log in again',
      name: 'ErrorUnauthorized',
      desc: '',
      args: [],
    );
  }

  /// `User not found`
  String get ErrorUserNotFound {
    return Intl.message(
      'User not found',
      name: 'ErrorUserNotFound',
      desc: '',
      args: [],
    );
  }

  /// `Connection timeout, please try again later`
  String get ErrorTimeout {
    return Intl.message(
      'Connection timeout, please try again later',
      name: 'ErrorTimeout',
      desc: '',
      args: [],
    );
  }

  /// `Network issue detected`
  String get ErrorNetwork {
    return Intl.message(
      'Network issue detected',
      name: 'ErrorNetwork',
      desc: '',
      args: [],
    );
  }

  /// `Invalid data entered, please verify your input`
  String get ErrorValidation {
    return Intl.message(
      'Invalid data entered, please verify your input',
      name: 'ErrorValidation',
      desc: '',
      args: [],
    );
  }

  /// `Forget Password??`
  String get ForgetPassword {
    return Intl.message(
      'Forget Password??',
      name: 'ForgetPassword',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get Save {
    return Intl.message('Save', name: 'Save', desc: '', args: []);
  }

  /// `Reset Password`
  String get ResetPassword {
    return Intl.message(
      'Reset Password',
      name: 'ResetPassword',
      desc: '',
      args: [],
    );
  }

  /// `New Password`
  String get NewPassword {
    return Intl.message(
      'New Password',
      name: 'NewPassword',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Password`
  String get ConfirmPassword {
    return Intl.message(
      'Confirm Password',
      name: 'ConfirmPassword',
      desc: '',
      args: [],
    );
  }

  /// `Password reset successfully!`
  String get PasswordResetSuccess {
    return Intl.message(
      'Password reset successfully!',
      name: 'PasswordResetSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Failed to reset password, please try again`
  String get PasswordResetFailed {
    return Intl.message(
      'Failed to reset password, please try again',
      name: 'PasswordResetFailed',
      desc: '',
      args: [],
    );
  }

  /// `Please fill all fields`
  String get PleaseFillAllFields {
    return Intl.message(
      'Please fill all fields',
      name: 'PleaseFillAllFields',
      desc: '',
      args: [],
    );
  }

  /// `Token refreshed successfully`
  String get TokenRefreshed {
    return Intl.message(
      'Token refreshed successfully',
      name: 'TokenRefreshed',
      desc: '',
      args: [],
    );
  }

  /// `stars`
  String get star {
    return Intl.message('stars', name: 'star', desc: '', args: []);
  }

  /// `Terms of Use`
  String get TermsOfUse {
    return Intl.message('Terms of Use', name: 'TermsOfUse', desc: '', args: []);
  }

  /// `Privacy Policy`
  String get PrivacyPolicy {
    return Intl.message(
      'Privacy Policy',
      name: 'PrivacyPolicy',
      desc: '',
      args: [],
    );
  }

  /// `Change Mode`
  String get ChangeMode {
    return Intl.message('Change Mode', name: 'ChangeMode', desc: '', args: []);
  }

  /// `Change Language`
  String get ChangeLanguage {
    return Intl.message(
      'Change Language',
      name: 'ChangeLanguage',
      desc: '',
      args: [],
    );
  }

  /// `Logout`
  String get Logout {
    return Intl.message('Logout', name: 'Logout', desc: '', args: []);
  }

  /// `Delete Account`
  String get DeleteAccount {
    return Intl.message(
      'Delete Account',
      name: 'DeleteAccount',
      desc: '',
      args: [],
    );
  }

  /// `Logged out successfully`
  String get LogoutSuccess {
    return Intl.message(
      'Logged out successfully',
      name: 'LogoutSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Failed to log out, please try again`
  String get LogoutFailed {
    return Intl.message(
      'Failed to log out, please try again',
      name: 'LogoutFailed',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to log out?`
  String get LogoutConfirm {
    return Intl.message(
      'Are you sure you want to log out?',
      name: 'LogoutConfirm',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get Cansel {
    return Intl.message('Cancel', name: 'Cansel', desc: '', args: []);
  }

  /// `Are you sure you want to delete the account?`
  String get DeleteConfirm {
    return Intl.message(
      'Are you sure you want to delete the account?',
      name: 'DeleteConfirm',
      desc: '',
      args: [],
    );
  }

  /// `Account deleted successfully`
  String get DeleteSuccess {
    return Intl.message(
      'Account deleted successfully',
      name: 'DeleteSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Account deletion failed`
  String get DeleteFailed {
    return Intl.message(
      'Account deletion failed',
      name: 'DeleteFailed',
      desc: '',
      args: [],
    );
  }

  /// `Order Now`
  String get OrderNow {
    return Intl.message('Order Now', name: 'OrderNow', desc: '', args: []);
  }

  /// `Find the destination...`
  String get search {
    return Intl.message(
      'Find the destination...',
      name: 'search',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get Profile {
    return Intl.message('Profile', name: 'Profile', desc: '', args: []);
  }

  /// `Settings`
  String get Settings {
    return Intl.message('Settings', name: 'Settings', desc: '', args: []);
  }

  /// `Car Without Ac`
  String get CarType1 {
    return Intl.message('Car Without Ac', name: 'CarType1', desc: '', args: []);
  }

  /// `Car With Ac`
  String get CarType2 {
    return Intl.message('Car With Ac', name: 'CarType2', desc: '', args: []);
  }

  /// `Luxury Car`
  String get CarType3 {
    return Intl.message('Luxury Car', name: 'CarType3', desc: '', args: []);
  }

  /// `Mini Truck`
  String get CarType4 {
    return Intl.message('Mini Truck', name: 'CarType4', desc: '', args: []);
  }

  /// `Van`
  String get CarType5 {
    return Intl.message('Van', name: 'CarType5', desc: '', args: []);
  }

  /// `An error occurred while fetching data`
  String get ErrorFetchData {
    return Intl.message(
      'An error occurred while fetching data',
      name: 'ErrorFetchData',
      desc: '',
      args: [],
    );
  }

  /// `Bike`
  String get CarType6 {
    return Intl.message('Bike', name: 'CarType6', desc: '', args: []);
  }

  /// `Drivers found successfully`
  String get findDriversSuccess {
    return Intl.message(
      'Drivers found successfully',
      name: 'findDriversSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Failed to find drivers. Please try again.`
  String get findDriversFailed {
    return Intl.message(
      'Failed to find drivers. Please try again.',
      name: 'findDriversFailed',
      desc: '',
      args: [],
    );
  }

  /// `Searching for driver…`
  String get SearchingForDriver {
    return Intl.message(
      'Searching for driver…',
      name: 'SearchingForDriver',
      desc: '',
      args: [],
    );
  }

  /// `Driver found`
  String get DriverFound {
    return Intl.message(
      'Driver found',
      name: 'DriverFound',
      desc: '',
      args: [],
    );
  }

  /// `Trip cancelled`
  String get TripCancelled {
    return Intl.message(
      'Trip cancelled',
      name: 'TripCancelled',
      desc: '',
      args: [],
    );
  }

  /// `Rate Trip`
  String get RateTrip {
    return Intl.message('Rate Trip', name: 'RateTrip', desc: '', args: []);
  }

  /// `How was your experience with the driver?`
  String get HowWasYourExperience {
    return Intl.message(
      'How was your experience with the driver?',
      name: 'HowWasYourExperience',
      desc: '',
      args: [],
    );
  }

  /// `Add comment (optional)`
  String get AddComment {
    return Intl.message(
      'Add comment (optional)',
      name: 'AddComment',
      desc: '',
      args: [],
    );
  }

  /// `Skip`
  String get Skip {
    return Intl.message('Skip', name: 'Skip', desc: '', args: []);
  }

  /// `Send`
  String get Send {
    return Intl.message('Send', name: 'Send', desc: '', args: []);
  }

  /// `Edit Phon`
  String get EditPhone {
    return Intl.message('Edit Phon', name: 'EditPhone', desc: '', args: []);
  }

  /// `Name`
  String get Name {
    return Intl.message('Name', name: 'Name', desc: '', args: []);
  }

  /// `Please select a rating`
  String get PleaseSelectRating {
    return Intl.message(
      'Please select a rating',
      name: 'PleaseSelectRating',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get Cancel {
    return Intl.message('Cancel', name: 'Cancel', desc: '', args: []);
  }

  /// `Current Location`
  String get CurrentLocation {
    return Intl.message(
      'Current Location',
      name: 'CurrentLocation',
      desc: '',
      args: [],
    );
  }

  /// `Profile updated successfully`
  String get ProfileUpdated {
    return Intl.message(
      'Profile updated successfully',
      name: 'ProfileUpdated',
      desc: '',
      args: [],
    );
  }

  /// `Destination`
  String get Destination {
    return Intl.message('Destination', name: 'Destination', desc: '', args: []);
  }

  /// `Please wait until data is loaded...`
  String get PleaseWaitForData {
    return Intl.message(
      'Please wait until data is loaded...',
      name: 'PleaseWaitForData',
      desc: '',
      args: [],
    );
  }

  /// `This Privacy Policy explains how we collect, use, disclose, and protect your personal information when you visit or use our website. By accessing or using our website, you agree to the terms of this Privacy Policy and consent to the collection and use of your information as described herein. We are committed to ensuring that your privacy is protected. Any personal information you provide will only be used in accordance with this Privacy Policy. We regularly review our compliance and ensure that all data handling practices are transparent and secure.\n\nInformation We Collect\n\nWe collect personal information such as names, email addresses, and browsing data to improve user experience and provide personalized services. This data helps us understand user preferences and improve our offerings. Your privacy is important to us, and we ensure that all information is handled with strict confidentiality.\n\nPersonal Information: Name, email address, phone number, and other contact details.\n\nUsage Data: Information about how you use our website, including your IP address, browser type, and pages visited.\n\nCookies and Tracking Technologies: We use cookies to enhance your experience on our website. You can manage cookie preferences through your browser settings.\n\nHow We Use Your Information\n\nWe use your information to provide and improve our services, including processing transactions, sending updates, and responding to inquiries. We also use data for analytical purposes and security measures to prevent fraud.\n\nSharing Your Information\n\nWe do not sell, trade, or transfer your personal information to external parties except as described in this Privacy Policy. We take reasonable steps to ensure that third parties comply with appropriate confidentiality and security obligations. These measures include data encryption, access controls, and regular security audits.\n\nContact Us\n\nIf you have any questions about this Privacy Policy, please contact us. We are committed to protecting your privacy and ensuring a transparent and secure experience.`
  String get PrivacyPolicyText {
    return Intl.message(
      'This Privacy Policy explains how we collect, use, disclose, and protect your personal information when you visit or use our website. By accessing or using our website, you agree to the terms of this Privacy Policy and consent to the collection and use of your information as described herein. We are committed to ensuring that your privacy is protected. Any personal information you provide will only be used in accordance with this Privacy Policy. We regularly review our compliance and ensure that all data handling practices are transparent and secure.\n\nInformation We Collect\n\nWe collect personal information such as names, email addresses, and browsing data to improve user experience and provide personalized services. This data helps us understand user preferences and improve our offerings. Your privacy is important to us, and we ensure that all information is handled with strict confidentiality.\n\nPersonal Information: Name, email address, phone number, and other contact details.\n\nUsage Data: Information about how you use our website, including your IP address, browser type, and pages visited.\n\nCookies and Tracking Technologies: We use cookies to enhance your experience on our website. You can manage cookie preferences through your browser settings.\n\nHow We Use Your Information\n\nWe use your information to provide and improve our services, including processing transactions, sending updates, and responding to inquiries. We also use data for analytical purposes and security measures to prevent fraud.\n\nSharing Your Information\n\nWe do not sell, trade, or transfer your personal information to external parties except as described in this Privacy Policy. We take reasonable steps to ensure that third parties comply with appropriate confidentiality and security obligations. These measures include data encryption, access controls, and regular security audits.\n\nContact Us\n\nIf you have any questions about this Privacy Policy, please contact us. We are committed to protecting your privacy and ensuring a transparent and secure experience.',
      name: 'PrivacyPolicyText',
      desc: '',
      args: [],
    );
  }

  /// `Payment and Refund Policy\n\nRefunds or cashback will not be issued. Once a deposit is made, it is non-reversible. You must use your balance to purchase our services, such as hosting or SEO campaigns. By making a deposit, you agree not to file a dispute or chargeback against us.\n\nIf a dispute or chargeback is filed after making a deposit, we reserve the right to terminate all future orders and ban you from our site. Fraudulent activities, such as using unauthorized or stolen credit cards, will result in account termination without exception.\n\nFree Balance and Coupon Policy\n\nWe offer multiple ways to earn free balance, coupons, and deposit offers, but we reserve the right to review and deduct these balances if we believe there is any form of misuse. If we deduct your free balance and your account balance becomes negative, your account will be suspended. To reactivate a suspended account, you must make a custom payment to settle your balance.\n\nContact Information\n\nIf you have any questions about our Terms of Service, please contact us through this link. Our team is available to assist you with any inquiries or concerns regarding our Terms of Service. We are committed to ensuring that your experience on our platform is secure and satisfactory.`
  String get TermsOfUseText {
    return Intl.message(
      'Payment and Refund Policy\n\nRefunds or cashback will not be issued. Once a deposit is made, it is non-reversible. You must use your balance to purchase our services, such as hosting or SEO campaigns. By making a deposit, you agree not to file a dispute or chargeback against us.\n\nIf a dispute or chargeback is filed after making a deposit, we reserve the right to terminate all future orders and ban you from our site. Fraudulent activities, such as using unauthorized or stolen credit cards, will result in account termination without exception.\n\nFree Balance and Coupon Policy\n\nWe offer multiple ways to earn free balance, coupons, and deposit offers, but we reserve the right to review and deduct these balances if we believe there is any form of misuse. If we deduct your free balance and your account balance becomes negative, your account will be suspended. To reactivate a suspended account, you must make a custom payment to settle your balance.\n\nContact Information\n\nIf you have any questions about our Terms of Service, please contact us through this link. Our team is available to assist you with any inquiries or concerns regarding our Terms of Service. We are committed to ensuring that your experience on our platform is secure and satisfactory.',
      name: 'TermsOfUseText',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
