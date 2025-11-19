import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('pt'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'MediExpress'**
  String get appTitle;

  /// No description provided for @hello.
  ///
  /// In en, this message translates to:
  /// **'Hello'**
  String get hello;

  /// No description provided for @homeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your pharmacy in minutes'**
  String get homeSubtitle;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'My profile'**
  String get profileTitle;

  /// No description provided for @adminPanelTitle.
  ///
  /// In en, this message translates to:
  /// **'Admin Panel'**
  String get adminPanelTitle;

  /// No description provided for @logoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logoutTitle;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get loginTitle;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @commonOk.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get commonOk;

  /// No description provided for @commonApply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get commonApply;

  /// No description provided for @commonClearFilter.
  ///
  /// In en, this message translates to:
  /// **'Clear filter'**
  String get commonClearFilter;

  /// No description provided for @languageSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageSectionTitle;

  /// No description provided for @useSystemLanguage.
  ///
  /// In en, this message translates to:
  /// **'Use system language'**
  String get useSystemLanguage;

  /// No description provided for @spanishLabel.
  ///
  /// In en, this message translates to:
  /// **'Spanish'**
  String get spanishLabel;

  /// No description provided for @englishLabel.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get englishLabel;

  /// No description provided for @portugueseLabel.
  ///
  /// In en, this message translates to:
  /// **'Portuguese'**
  String get portugueseLabel;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search medicine, dosage or brand'**
  String get searchHint;

  /// No description provided for @filterByPrice.
  ///
  /// In en, this message translates to:
  /// **'Filter by price'**
  String get filterByPrice;

  /// No description provided for @minPriceHint.
  ///
  /// In en, this message translates to:
  /// **'Minimum price (e.g. 15000)'**
  String get minPriceHint;

  /// No description provided for @maxPriceHint.
  ///
  /// In en, this message translates to:
  /// **'Maximum price (e.g. 25000)'**
  String get maxPriceHint;

  /// No description provided for @productUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Product not available'**
  String get productUnavailable;

  /// No description provided for @productOutOfStock.
  ///
  /// In en, this message translates to:
  /// **'Out of stock'**
  String get productOutOfStock;

  /// No description provided for @addedToCart.
  ///
  /// In en, this message translates to:
  /// **'Added to cart'**
  String get addedToCart;

  /// No description provided for @catalogTitle.
  ///
  /// In en, this message translates to:
  /// **'Medicines catalog'**
  String get catalogTitle;

  /// No description provided for @localesTitle.
  ///
  /// In en, this message translates to:
  /// **'Stores'**
  String get localesTitle;

  /// No description provided for @noStoreInfo.
  ///
  /// In en, this message translates to:
  /// **'No store information'**
  String get noStoreInfo;

  /// No description provided for @addressLabel.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get addressLabel;

  /// No description provided for @scheduleLabel.
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get scheduleLabel;

  /// No description provided for @availabilityLabel.
  ///
  /// In en, this message translates to:
  /// **'Availability'**
  String get availabilityLabel;

  /// No description provided for @available.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get available;

  /// No description provided for @notAvailable.
  ///
  /// In en, this message translates to:
  /// **'Not available'**
  String get notAvailable;

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// No description provided for @filterInStock.
  ///
  /// In en, this message translates to:
  /// **'In stock'**
  String get filterInStock;

  /// No description provided for @filterOutOfStock.
  ///
  /// In en, this message translates to:
  /// **'Out of stock'**
  String get filterOutOfStock;

  /// No description provided for @quantityTag.
  ///
  /// In en, this message translates to:
  /// **'Qty: {count}'**
  String quantityTag(Object count);

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to see your orders and discounts'**
  String get loginSubtitle;

  /// No description provided for @usernameOrPhone.
  ///
  /// In en, this message translates to:
  /// **'Email or phone'**
  String get usernameOrPhone;

  /// No description provided for @enterUsernameOrPhone.
  ///
  /// In en, this message translates to:
  /// **'Enter email or phone'**
  String get enterUsernameOrPhone;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @enterPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get enterPassword;

  /// No description provided for @noAccountRegister.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? Sign up'**
  String get noAccountRegister;

  /// No description provided for @demoCredentials.
  ///
  /// In en, this message translates to:
  /// **'Demo credentials'**
  String get demoCredentials;

  /// No description provided for @use.
  ///
  /// In en, this message translates to:
  /// **'Use'**
  String get use;

  /// No description provided for @enter.
  ///
  /// In en, this message translates to:
  /// **'Enter'**
  String get enter;

  /// No description provided for @invalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Invalid credentials or user not registered'**
  String get invalidCredentials;

  /// No description provided for @loginSuccess.
  ///
  /// In en, this message translates to:
  /// **'Login successful'**
  String get loginSuccess;

  /// No description provided for @userProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'User Profile'**
  String get userProfileTitle;

  /// No description provided for @nationalIdLabel.
  ///
  /// In en, this message translates to:
  /// **'ID'**
  String get nationalIdLabel;

  /// No description provided for @phoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phoneLabel;

  /// No description provided for @notLoggedIn.
  ///
  /// In en, this message translates to:
  /// **'You\'re not logged in'**
  String get notLoggedIn;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @tabHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get tabHome;

  /// No description provided for @tabStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get tabStatus;

  /// No description provided for @tabStores.
  ///
  /// In en, this message translates to:
  /// **'Stores'**
  String get tabStores;

  /// No description provided for @tabProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get tabProfile;

  /// No description provided for @orderStatusTitle.
  ///
  /// In en, this message translates to:
  /// **'Order Status'**
  String get orderStatusTitle;

  /// No description provided for @orderLabel.
  ///
  /// In en, this message translates to:
  /// **'Order #{orderId}'**
  String orderLabel(Object orderId);

  /// No description provided for @summaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Summary'**
  String get summaryTitle;

  /// No description provided for @paymentProcessed.
  ///
  /// In en, this message translates to:
  /// **'Your payment has been processed and your order is being prepared.'**
  String get paymentProcessed;

  /// No description provided for @willNotify.
  ///
  /// In en, this message translates to:
  /// **'We\'ll notify you when it\'s dispatched.'**
  String get willNotify;

  /// No description provided for @backToHome.
  ///
  /// In en, this message translates to:
  /// **'Back to Home'**
  String get backToHome;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @adminAccessDeniedTitle.
  ///
  /// In en, this message translates to:
  /// **'Access denied'**
  String get adminAccessDeniedTitle;

  /// No description provided for @adminAccessDeniedMessage.
  ///
  /// In en, this message translates to:
  /// **'Only users with administrator role can access this screen.'**
  String get adminAccessDeniedMessage;

  /// No description provided for @adminAddProduct.
  ///
  /// In en, this message translates to:
  /// **'Add product'**
  String get adminAddProduct;

  /// No description provided for @adminProductName.
  ///
  /// In en, this message translates to:
  /// **'Product name'**
  String get adminProductName;

  /// No description provided for @adminEnterProductName.
  ///
  /// In en, this message translates to:
  /// **'Enter the name'**
  String get adminEnterProductName;

  /// No description provided for @adminProductDosage.
  ///
  /// In en, this message translates to:
  /// **'Dosage'**
  String get adminProductDosage;

  /// No description provided for @adminProductPriceHint.
  ///
  /// In en, this message translates to:
  /// **'Price (e.g. 15000)'**
  String get adminProductPriceHint;

  /// No description provided for @adminProductQuantityHint.
  ///
  /// In en, this message translates to:
  /// **'Quantity (e.g. 10)'**
  String get adminProductQuantityHint;

  /// No description provided for @adminEnterQuantity.
  ///
  /// In en, this message translates to:
  /// **'Enter the quantity'**
  String get adminEnterQuantity;

  /// No description provided for @adminInvalidQuantity.
  ///
  /// In en, this message translates to:
  /// **'Invalid quantity'**
  String get adminInvalidQuantity;

  /// No description provided for @adminDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get adminDescription;

  /// No description provided for @adminClearProducts.
  ///
  /// In en, this message translates to:
  /// **'Clear products'**
  String get adminClearProducts;

  /// No description provided for @adminProductAdded.
  ///
  /// In en, this message translates to:
  /// **'Product added'**
  String get adminProductAdded;

  /// No description provided for @adminDistributionSection.
  ///
  /// In en, this message translates to:
  /// **'Distribution point management'**
  String get adminDistributionSection;

  /// No description provided for @adminDistributionPointName.
  ///
  /// In en, this message translates to:
  /// **'Distribution point name'**
  String get adminDistributionPointName;

  /// No description provided for @adminMedicinesAvailability.
  ///
  /// In en, this message translates to:
  /// **'Medicines availability'**
  String get adminMedicinesAvailability;

  /// No description provided for @adminSaveDistributionPoint.
  ///
  /// In en, this message translates to:
  /// **'Save distribution point'**
  String get adminSaveDistributionPoint;

  /// No description provided for @adminDistributionSaved.
  ///
  /// In en, this message translates to:
  /// **'Distribution point data saved'**
  String get adminDistributionSaved;

  /// No description provided for @adminAddStore.
  ///
  /// In en, this message translates to:
  /// **'Add store'**
  String get adminAddStore;

  /// No description provided for @adminStoreName.
  ///
  /// In en, this message translates to:
  /// **'Store name'**
  String get adminStoreName;

  /// No description provided for @adminEnterStoreName.
  ///
  /// In en, this message translates to:
  /// **'Enter the store name'**
  String get adminEnterStoreName;

  /// No description provided for @adminEnterAddress.
  ///
  /// In en, this message translates to:
  /// **'Enter an address'**
  String get adminEnterAddress;

  /// No description provided for @adminStoreAdded.
  ///
  /// In en, this message translates to:
  /// **'Store added'**
  String get adminStoreAdded;

  /// No description provided for @adminAddedProducts.
  ///
  /// In en, this message translates to:
  /// **'Added products'**
  String get adminAddedProducts;

  /// No description provided for @adminNoProducts.
  ///
  /// In en, this message translates to:
  /// **'No products added'**
  String get adminNoProducts;

  /// No description provided for @adminAddedStores.
  ///
  /// In en, this message translates to:
  /// **'Added stores'**
  String get adminAddedStores;

  /// No description provided for @adminNoStores.
  ///
  /// In en, this message translates to:
  /// **'No stores added'**
  String get adminNoStores;

  /// No description provided for @adminSelectAsActive.
  ///
  /// In en, this message translates to:
  /// **'Set as active'**
  String get adminSelectAsActive;

  /// No description provided for @cartTitle.
  ///
  /// In en, this message translates to:
  /// **'Cart'**
  String get cartTitle;

  /// No description provided for @cartEmpty.
  ///
  /// In en, this message translates to:
  /// **'Your cart is empty'**
  String get cartEmpty;

  /// No description provided for @cartTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get cartTotal;

  /// No description provided for @cartCheckout.
  ///
  /// In en, this message translates to:
  /// **'Go to pay'**
  String get cartCheckout;

  /// No description provided for @cartClear.
  ///
  /// In en, this message translates to:
  /// **'Clear cart'**
  String get cartClear;

  /// No description provided for @changePasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get changePasswordTitle;

  /// No description provided for @currentPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Current password'**
  String get currentPasswordLabel;

  /// No description provided for @newPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get newPasswordLabel;

  /// No description provided for @confirmNewPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm new password'**
  String get confirmNewPasswordLabel;

  /// No description provided for @enterCurrentPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your current password'**
  String get enterCurrentPassword;

  /// No description provided for @enterNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter a new password'**
  String get enterNewPassword;

  /// No description provided for @passwordMinLength.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordMinLength;

  /// No description provided for @confirmNewPasswordPrompt.
  ///
  /// In en, this message translates to:
  /// **'Confirm the new password'**
  String get confirmNewPasswordPrompt;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @noAuthenticatedUser.
  ///
  /// In en, this message translates to:
  /// **'No authenticated user'**
  String get noAuthenticatedUser;

  /// No description provided for @currentPasswordIncorrect.
  ///
  /// In en, this message translates to:
  /// **'Current password is incorrect'**
  String get currentPasswordIncorrect;

  /// No description provided for @passwordUpdated.
  ///
  /// In en, this message translates to:
  /// **'Password updated'**
  String get passwordUpdated;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @editProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get editProfileTitle;

  /// No description provided for @fullNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get fullNameLabel;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// No description provided for @avatarUrlOptionalLabel.
  ///
  /// In en, this message translates to:
  /// **'Avatar URL (optional)'**
  String get avatarUrlOptionalLabel;

  /// No description provided for @enterNamePrompt.
  ///
  /// In en, this message translates to:
  /// **'Enter the name'**
  String get enterNamePrompt;

  /// No description provided for @enterEmailPrompt.
  ///
  /// In en, this message translates to:
  /// **'Enter the email'**
  String get enterEmailPrompt;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email'**
  String get invalidEmail;

  /// No description provided for @profileUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile updated'**
  String get profileUpdated;

  /// No description provided for @cashTitle.
  ///
  /// In en, this message translates to:
  /// **'Cash payment'**
  String get cashTitle;

  /// No description provided for @cashTotalToPay.
  ///
  /// In en, this message translates to:
  /// **'Total to pay'**
  String get cashTotalToPay;

  /// No description provided for @cashAmountReceived.
  ///
  /// In en, this message translates to:
  /// **'Amount received'**
  String get cashAmountReceived;

  /// No description provided for @cashEnterAmountHint.
  ///
  /// In en, this message translates to:
  /// **'Enter the amount in pesos'**
  String get cashEnterAmountHint;

  /// No description provided for @cashEnterValidAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid amount'**
  String get cashEnterValidAmount;

  /// No description provided for @cashAmountLessThanTotal.
  ///
  /// In en, this message translates to:
  /// **'The amount is less than the total to pay'**
  String get cashAmountLessThanTotal;

  /// No description provided for @cashNeedChange.
  ///
  /// In en, this message translates to:
  /// **'You will need change: {amount}'**
  String cashNeedChange(Object amount);

  /// No description provided for @cashFixEnteredAmount.
  ///
  /// In en, this message translates to:
  /// **'Fix the entered amount'**
  String get cashFixEnteredAmount;

  /// No description provided for @cashNeedChangeButton.
  ///
  /// In en, this message translates to:
  /// **'I will need change'**
  String get cashNeedChangeButton;

  /// No description provided for @cashAcceptPayment.
  ///
  /// In en, this message translates to:
  /// **'Accept payment'**
  String get cashAcceptPayment;

  /// No description provided for @cashSummaryWithCount.
  ///
  /// In en, this message translates to:
  /// **'Summary ({count} items)'**
  String cashSummaryWithCount(Object count);

  /// No description provided for @cashNoItems.
  ///
  /// In en, this message translates to:
  /// **'No items'**
  String get cashNoItems;

  /// No description provided for @cashUnnamedItem.
  ///
  /// In en, this message translates to:
  /// **'No name'**
  String get cashUnnamedItem;

  /// No description provided for @cashPaymentApproved.
  ///
  /// In en, this message translates to:
  /// **'Payment approved. Change: {change}'**
  String cashPaymentApproved(Object change);

  /// No description provided for @cashPaymentApprovedStatus.
  ///
  /// In en, this message translates to:
  /// **'Payment approved'**
  String get cashPaymentApprovedStatus;

  /// No description provided for @cashErrorProcessing.
  ///
  /// In en, this message translates to:
  /// **'Error processing payment: {error}'**
  String cashErrorProcessing(Object error);

  /// No description provided for @free.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get free;

  /// No description provided for @continueLabel.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueLabel;

  /// No description provided for @paymentMethodTitle.
  ///
  /// In en, this message translates to:
  /// **'Payment method'**
  String get paymentMethodTitle;

  /// No description provided for @selectPaymentMethodPrompt.
  ///
  /// In en, this message translates to:
  /// **'Select a payment method:'**
  String get selectPaymentMethodPrompt;

  /// No description provided for @paymentCashTitle.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get paymentCashTitle;

  /// No description provided for @paymentCashSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Pay cash on delivery'**
  String get paymentCashSubtitle;

  /// No description provided for @paymentDebitTitle.
  ///
  /// In en, this message translates to:
  /// **'Debit card'**
  String get paymentDebitTitle;

  /// No description provided for @paymentDebitSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Pay with bank debit'**
  String get paymentDebitSubtitle;

  /// No description provided for @paymentCreditTitle.
  ///
  /// In en, this message translates to:
  /// **'Credit card'**
  String get paymentCreditTitle;

  /// No description provided for @paymentCreditSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Pay with Visa, MasterCard, Amex'**
  String get paymentCreditSubtitle;

  /// No description provided for @deliveryMethodTitle.
  ///
  /// In en, this message translates to:
  /// **'Delivery method'**
  String get deliveryMethodTitle;

  /// No description provided for @deliveryHome.
  ///
  /// In en, this message translates to:
  /// **'Home delivery'**
  String get deliveryHome;

  /// No description provided for @deliveryHomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Flat fee of {fee} per order'**
  String deliveryHomeSubtitle(Object fee);

  /// No description provided for @pickupInStore.
  ///
  /// In en, this message translates to:
  /// **'Pick up in store'**
  String get pickupInStore;

  /// No description provided for @pickupNoCharge.
  ///
  /// In en, this message translates to:
  /// **'No extra charge'**
  String get pickupNoCharge;

  /// No description provided for @selectPickupStore.
  ///
  /// In en, this message translates to:
  /// **'Select a store to pick up'**
  String get selectPickupStore;

  /// No description provided for @noStoresAvailableNow.
  ///
  /// In en, this message translates to:
  /// **'No stores available at the moment'**
  String get noStoresAvailableNow;

  /// No description provided for @noStoresWithAvailability.
  ///
  /// In en, this message translates to:
  /// **'No stores currently available'**
  String get noStoresWithAvailability;

  /// No description provided for @summaryWithCount.
  ///
  /// In en, this message translates to:
  /// **'Summary ({count} items)'**
  String summaryWithCount(Object count);

  /// No description provided for @noItemsToPay.
  ///
  /// In en, this message translates to:
  /// **'No items to pay.'**
  String get noItemsToPay;

  /// No description provided for @subtotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get subtotal;

  /// No description provided for @viewDetails.
  ///
  /// In en, this message translates to:
  /// **'View details'**
  String get viewDetails;

  /// No description provided for @imageUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Image not available'**
  String get imageUnavailable;

  /// No description provided for @insufficientStock.
  ///
  /// In en, this message translates to:
  /// **'Insufficient stock'**
  String get insufficientStock;

  /// No description provided for @descriptionUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Description not available for this product.'**
  String get descriptionUnavailable;

  /// No description provided for @usageInstructionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Usage instructions'**
  String get usageInstructionsTitle;

  /// No description provided for @detailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get detailsTitle;

  /// No description provided for @quantityLabel.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantityLabel;

  /// No description provided for @availableStock.
  ///
  /// In en, this message translates to:
  /// **'Available stock: {count}'**
  String availableStock(Object count);

  /// No description provided for @alsoBuyTitle.
  ///
  /// In en, this message translates to:
  /// **'You may also buy'**
  String get alsoBuyTitle;

  /// No description provided for @noSuggestions.
  ///
  /// In en, this message translates to:
  /// **'No suggestions available at the moment.'**
  String get noSuggestions;

  /// No description provided for @addToCart.
  ///
  /// In en, this message translates to:
  /// **'Add to cart'**
  String get addToCart;

  /// No description provided for @addedToCartItems.
  ///
  /// In en, this message translates to:
  /// **'Added {count} x {name} to cart'**
  String addedToCartItems(Object count, Object name);

  /// No description provided for @productUsageTitle.
  ///
  /// In en, this message translates to:
  /// **'Description and use'**
  String get productUsageTitle;

  /// No description provided for @productDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Product details'**
  String get productDetailsTitle;

  /// No description provided for @defaultProductName.
  ///
  /// In en, this message translates to:
  /// **'Product'**
  String get defaultProductName;

  /// No description provided for @registeredAddressFallback.
  ///
  /// In en, this message translates to:
  /// **'Registered address'**
  String get registeredAddressFallback;

  /// No description provided for @registerTitle.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get registerTitle;

  /// No description provided for @registerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign up to checkout faster and save your details'**
  String get registerSubtitle;

  /// No description provided for @userTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'User type'**
  String get userTypeLabel;

  /// No description provided for @userTypeClient.
  ///
  /// In en, this message translates to:
  /// **'Client'**
  String get userTypeClient;

  /// No description provided for @userTypeAdmin.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get userTypeAdmin;

  /// No description provided for @nameRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get nameRequired;

  /// No description provided for @idRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter the ID'**
  String get idRequired;

  /// No description provided for @phoneRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter the phone'**
  String get phoneRequired;

  /// No description provided for @emailRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter the email'**
  String get emailRequired;

  /// No description provided for @addressRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter the address'**
  String get addressRequired;

  /// No description provided for @userTypeRequired.
  ///
  /// In en, this message translates to:
  /// **'Select the user type'**
  String get userTypeRequired;

  /// No description provided for @passwordRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter the password'**
  String get passwordRequired;

  /// No description provided for @registerButton.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get registerButton;

  /// No description provided for @userAlreadyExists.
  ///
  /// In en, this message translates to:
  /// **'A user with that email already exists'**
  String get userAlreadyExists;

  /// No description provided for @registrationAndLoginSuccess.
  ///
  /// In en, this message translates to:
  /// **'Registration and login completed successfully'**
  String get registrationAndLoginSuccess;

  /// No description provided for @creditCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Credit card'**
  String get creditCardTitle;

  /// No description provided for @creditCardImageFallback.
  ///
  /// In en, this message translates to:
  /// **'Card'**
  String get creditCardImageFallback;

  /// No description provided for @cardNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Card number'**
  String get cardNumberLabel;

  /// No description provided for @cardNumberHint.
  ///
  /// In en, this message translates to:
  /// **'1234123412341234'**
  String get cardNumberHint;

  /// No description provided for @cardNumberInvalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid number'**
  String get cardNumberInvalid;

  /// No description provided for @cardNumberExact16.
  ///
  /// In en, this message translates to:
  /// **'The number must be exactly 16 digits'**
  String get cardNumberExact16;

  /// No description provided for @expiryLabel.
  ///
  /// In en, this message translates to:
  /// **'Expiration date (MM/YY)'**
  String get expiryLabel;

  /// No description provided for @expiryHint.
  ///
  /// In en, this message translates to:
  /// **'MM/YY'**
  String get expiryHint;

  /// No description provided for @expiryRequired.
  ///
  /// In en, this message translates to:
  /// **'Date required'**
  String get expiryRequired;

  /// No description provided for @expiryInvalidFormat.
  ///
  /// In en, this message translates to:
  /// **'Invalid format (MM/YY)'**
  String get expiryInvalidFormat;

  /// No description provided for @expirySameAsCurrent.
  ///
  /// In en, this message translates to:
  /// **'The date cannot be the same as the current month/year'**
  String get expirySameAsCurrent;

  /// No description provided for @cvcLabel.
  ///
  /// In en, this message translates to:
  /// **'CVC code'**
  String get cvcLabel;

  /// No description provided for @cvcHint.
  ///
  /// In en, this message translates to:
  /// **'123'**
  String get cvcHint;

  /// No description provided for @cvcInvalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid code'**
  String get cvcInvalid;

  /// No description provided for @cvcExact3.
  ///
  /// In en, this message translates to:
  /// **'The CVC must be exactly 3 digits'**
  String get cvcExact3;

  /// No description provided for @nameOnCardLabel.
  ///
  /// In en, this message translates to:
  /// **'Name on card'**
  String get nameOnCardLabel;

  /// No description provided for @nameOnCardHint.
  ///
  /// In en, this message translates to:
  /// **'As it appears on the card'**
  String get nameOnCardHint;

  /// No description provided for @nameOnCardRequired.
  ///
  /// In en, this message translates to:
  /// **'Name required'**
  String get nameOnCardRequired;

  /// No description provided for @payButton.
  ///
  /// In en, this message translates to:
  /// **'Pay'**
  String get payButton;

  /// No description provided for @fixErrorsBeforeContinue.
  ///
  /// In en, this message translates to:
  /// **'Fix the errors before continuing'**
  String get fixErrorsBeforeContinue;

  /// No description provided for @paymentSimulatedApproved.
  ///
  /// In en, this message translates to:
  /// **'Simulated payment approved'**
  String get paymentSimulatedApproved;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
