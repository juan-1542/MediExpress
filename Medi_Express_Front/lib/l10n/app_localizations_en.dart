// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get currency => 'USD';

  @override
  String get currencySymbol => '\$';

  @override
  String get appTitle => 'MediExpress';

  @override
  String get hello => 'Hello';

  @override
  String get homeSubtitle => 'Your pharmacy in minutes';

  @override
  String get profileTitle => 'My profile';

  @override
  String get adminPanelTitle => 'Admin Panel';

  @override
  String get logoutTitle => 'Log out';

  @override
  String get loginTitle => 'Log in';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get commonOk => 'OK';

  @override
  String get commonApply => 'Apply';

  @override
  String get commonClearFilter => 'Clear filter';

  @override
  String get languageSectionTitle => 'Language';

  @override
  String get useSystemLanguage => 'Use system language';

  @override
  String get spanishLabel => 'Spanish';

  @override
  String get englishLabel => 'English';

  @override
  String get portugueseLabel => 'Portuguese';

  @override
  String get frenchLabel => 'French';

  @override
  String get japaneseLabel => 'Japanese';

  @override
  String get searchHint => 'Search medicine, dosage or brand';

  @override
  String get filterByPrice => 'Filter by price';

  @override
  String get minPriceHint => 'Minimum price (e.g. 15000)';

  @override
  String get maxPriceHint => 'Maximum price (e.g. 25000)';

  @override
  String get productUnavailable => 'Product not available';

  @override
  String get productOutOfStock => 'Out of stock';

  @override
  String get addedToCart => 'Added to cart';

  @override
  String get catalogTitle => 'Medicines catalog';

  @override
  String get localesTitle => 'Stores';

  @override
  String get noStoreInfo => 'No store information';

  @override
  String get addressLabel => 'Address';

  @override
  String get scheduleLabel => 'Schedule';

  @override
  String get availabilityLabel => 'Availability';

  @override
  String get available => 'Available';

  @override
  String get notAvailable => 'Not available';

  @override
  String get filterAll => 'All';

  @override
  String get filterInStock => 'In stock';

  @override
  String get filterOutOfStock => 'Out of stock';

  @override
  String quantityTag(Object count) {
    return 'Qty: $count';
  }

  @override
  String get loginSubtitle => 'Sign in to see your orders and discounts';

  @override
  String get usernameOrPhone => 'Email or phone';

  @override
  String get enterUsernameOrPhone => 'Enter email or phone';

  @override
  String get password => 'Password';

  @override
  String get enterPassword => 'Enter your password';

  @override
  String get noAccountRegister => 'Don\'t have an account? Sign up';

  @override
  String get demoCredentials => 'Demo credentials';

  @override
  String get use => 'Use';

  @override
  String get enter => 'Enter';

  @override
  String get invalidCredentials => 'Invalid credentials or user not registered';

  @override
  String get loginSuccess => 'Login successful';

  @override
  String get userProfileTitle => 'User Profile';

  @override
  String get nationalIdLabel => 'ID';

  @override
  String get phoneLabel => 'Phone';

  @override
  String get notLoggedIn => 'You\'re not logged in';

  @override
  String get edit => 'Edit';

  @override
  String get tabHome => 'Home';

  @override
  String get tabStatus => 'Status';

  @override
  String get tabStores => 'Stores';

  @override
  String get tabProfile => 'Profile';

  @override
  String get orderStatusTitle => 'Order Status';

  @override
  String orderLabel(Object orderId) {
    return 'Order #$orderId';
  }

  @override
  String get summaryTitle => 'Summary';

  @override
  String get paymentProcessed =>
      'Your payment has been processed and your order is being prepared.';

  @override
  String get willNotify => 'We\'ll notify you when it\'s dispatched.';

  @override
  String get backToHome => 'Back to Home';

  @override
  String get back => 'Back';

  @override
  String get adminAccessDeniedTitle => 'Access denied';

  @override
  String get adminAccessDeniedMessage =>
      'Only users with administrator role can access this screen.';

  @override
  String get adminAddProduct => 'Add product';

  @override
  String get adminProductName => 'Product name';

  @override
  String get adminEnterProductName => 'Enter the name';

  @override
  String get adminProductDosage => 'Dosage';

  @override
  String get adminProductPriceHint => 'Price (e.g. 15000)';

  @override
  String get adminProductQuantityHint => 'Quantity (e.g. 10)';

  @override
  String get adminEnterQuantity => 'Enter the quantity';

  @override
  String get adminInvalidQuantity => 'Invalid quantity';

  @override
  String get adminDescription => 'Description';

  @override
  String get adminClearProducts => 'Clear products';

  @override
  String get adminProductAdded => 'Product added';

  @override
  String get adminDistributionSection => 'Distribution point management';

  @override
  String get adminDistributionPointName => 'Distribution point name';

  @override
  String get adminMedicinesAvailability => 'Medicines availability';

  @override
  String get adminSaveDistributionPoint => 'Save distribution point';

  @override
  String get adminDistributionSaved => 'Distribution point data saved';

  @override
  String get adminAddStore => 'Add store';

  @override
  String get adminStoreName => 'Store name';

  @override
  String get adminEnterStoreName => 'Enter the store name';

  @override
  String get adminEnterAddress => 'Enter an address';

  @override
  String get adminStoreAdded => 'Store added';

  @override
  String get adminAddedProducts => 'Added products';

  @override
  String get adminNoProducts => 'No products added';

  @override
  String get adminAddedStores => 'Added stores';

  @override
  String get adminNoStores => 'No stores added';

  @override
  String get adminSelectAsActive => 'Set as active';

  @override
  String get cartTitle => 'Cart';

  @override
  String get cartEmpty => 'Your cart is empty';

  @override
  String get cartTotal => 'Total';

  @override
  String get cartCheckout => 'Go to pay';

  @override
  String get cartClear => 'Clear cart';

  @override
  String get changePasswordTitle => 'Change password';

  @override
  String get currentPasswordLabel => 'Current password';

  @override
  String get newPasswordLabel => 'New password';

  @override
  String get confirmNewPasswordLabel => 'Confirm new password';

  @override
  String get enterCurrentPassword => 'Enter your current password';

  @override
  String get enterNewPassword => 'Enter a new password';

  @override
  String get passwordMinLength => 'Password must be at least 6 characters';

  @override
  String get confirmNewPasswordPrompt => 'Confirm the new password';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get noAuthenticatedUser => 'No authenticated user';

  @override
  String get currentPasswordIncorrect => 'Current password is incorrect';

  @override
  String get passwordUpdated => 'Password updated';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get editProfileTitle => 'Edit profile';

  @override
  String get fullNameLabel => 'Full name';

  @override
  String get emailLabel => 'Email';

  @override
  String get avatarUrlOptionalLabel => 'Avatar URL (optional)';

  @override
  String get enterNamePrompt => 'Enter the name';

  @override
  String get enterEmailPrompt => 'Enter the email';

  @override
  String get invalidEmail => 'Enter a valid email';

  @override
  String get profileUpdated => 'Profile updated';

  @override
  String get cashTitle => 'Cash payment';

  @override
  String get cashTotalToPay => 'Total to pay';

  @override
  String get cashAmountReceived => 'Amount received';

  @override
  String get cashEnterAmountHint => 'Enter the amount in pesos';

  @override
  String get cashEnterValidAmount => 'Enter a valid amount';

  @override
  String get cashAmountLessThanTotal =>
      'The amount is less than the total to pay';

  @override
  String cashNeedChange(Object amount) {
    return 'You will need change: $amount';
  }

  @override
  String get cashFixEnteredAmount => 'Fix the entered amount';

  @override
  String get cashNeedChangeButton => 'I will need change';

  @override
  String get cashAcceptPayment => 'Accept payment';

  @override
  String cashSummaryWithCount(Object count) {
    return 'Summary ($count items)';
  }

  @override
  String get cashNoItems => 'No items';

  @override
  String get cashUnnamedItem => 'No name';

  @override
  String cashPaymentApproved(Object change) {
    return 'Payment approved. Change: $change';
  }

  @override
  String get cashPaymentApprovedStatus => 'Payment approved';

  @override
  String cashErrorProcessing(Object error) {
    return 'Error processing payment: $error';
  }

  @override
  String get free => 'Free';

  @override
  String get continueLabel => 'Continue';

  @override
  String get paymentMethodTitle => 'Payment method';

  @override
  String get selectPaymentMethodPrompt => 'Select a payment method:';

  @override
  String get paymentCashTitle => 'Cash';

  @override
  String get paymentCashSubtitle => 'Pay cash on delivery';

  @override
  String get paymentDebitTitle => 'Debit card';

  @override
  String get paymentDebitSubtitle => 'Pay with bank debit';

  @override
  String get paymentCreditTitle => 'Credit card';

  @override
  String get paymentCreditSubtitle => 'Pay with Visa, MasterCard, Amex';

  @override
  String get deliveryMethodTitle => 'Delivery method';

  @override
  String get deliveryHome => 'Home delivery';

  @override
  String deliveryHomeSubtitle(Object fee) {
    return 'Flat fee of $fee per order';
  }

  @override
  String get pickupInStore => 'Pick up in store';

  @override
  String get pickupNoCharge => 'No extra charge';

  @override
  String get selectPickupStore => 'Select a store to pick up';

  @override
  String get noStoresAvailableNow => 'No stores available at the moment';

  @override
  String get noStoresWithAvailability => 'No stores currently available';

  @override
  String summaryWithCount(Object count) {
    return 'Summary ($count items)';
  }

  @override
  String get noItemsToPay => 'No items to pay.';

  @override
  String get subtotal => 'Subtotal';

  @override
  String get viewDetails => 'View details';

  @override
  String get imageUnavailable => 'Image not available';

  @override
  String get insufficientStock => 'Insufficient stock';

  @override
  String get descriptionUnavailable =>
      'Description not available for this product.';

  @override
  String get usageInstructionsTitle => 'Usage instructions';

  @override
  String get detailsTitle => 'Details';

  @override
  String get quantityLabel => 'Quantity';

  @override
  String availableStock(Object count) {
    return 'Available stock: $count';
  }

  @override
  String get alsoBuyTitle => 'You may also buy';

  @override
  String get noSuggestions => 'No suggestions available at the moment.';

  @override
  String get addToCart => 'Add to cart';

  @override
  String addedToCartItems(Object count, Object name) {
    return 'Added $count x $name to cart';
  }

  @override
  String get productUsageTitle => 'Description and use';

  @override
  String get productDetailsTitle => 'Product details';

  @override
  String get defaultProductName => 'Product';

  @override
  String get registeredAddressFallback => 'Registered address';

  @override
  String get registerTitle => 'Create account';

  @override
  String get registerSubtitle =>
      'Sign up to checkout faster and save your details';

  @override
  String get userTypeLabel => 'User type';

  @override
  String get userTypeClient => 'Client';

  @override
  String get userTypeAdmin => 'Admin';

  @override
  String get nameRequired => 'Enter your name';

  @override
  String get idRequired => 'Enter the ID';

  @override
  String get phoneRequired => 'Enter the phone';

  @override
  String get emailRequired => 'Enter the email';

  @override
  String get addressRequired => 'Enter the address';

  @override
  String get userTypeRequired => 'Select the user type';

  @override
  String get passwordRequired => 'Enter the password';

  @override
  String get registerButton => 'Sign up';

  @override
  String get userAlreadyExists => 'A user with that email already exists';

  @override
  String get registrationAndLoginSuccess =>
      'Registration and login completed successfully';

  @override
  String get creditCardTitle => 'Credit card';

  @override
  String get creditCardImageFallback => 'Card';

  @override
  String get cardNumberLabel => 'Card number';

  @override
  String get cardNumberHint => '1234123412341234';

  @override
  String get cardNumberInvalid => 'Invalid number';

  @override
  String get cardNumberExact16 => 'The number must be exactly 16 digits';

  @override
  String get expiryLabel => 'Expiration date (MM/YY)';

  @override
  String get expiryHint => 'MM/YY';

  @override
  String get expiryRequired => 'Date required';

  @override
  String get expiryInvalidFormat => 'Invalid format (MM/YY)';

  @override
  String get expirySameAsCurrent =>
      'The date cannot be the same as the current month/year';

  @override
  String get cvcLabel => 'CVC code';

  @override
  String get cvcHint => '123';

  @override
  String get cvcInvalid => 'Invalid code';

  @override
  String get cvcExact3 => 'The CVC must be exactly 3 digits';

  @override
  String get nameOnCardLabel => 'Name on card';

  @override
  String get nameOnCardHint => 'As it appears on the card';

  @override
  String get nameOnCardRequired => 'Name required';

  @override
  String get payButton => 'Pay';

  @override
  String get fixErrorsBeforeContinue => 'Fix the errors before continuing';

  @override
  String get paymentSimulatedApproved => 'Simulated payment approved';
}
