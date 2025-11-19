// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get currency => 'JPY';

  @override
  String get currencySymbol => '¥';

  @override
  String get appTitle => 'MediExpress';

  @override
  String get hello => 'こんにちは';

  @override
  String get homeSubtitle => '数分であなたの薬局';

  @override
  String get profileTitle => 'マイプロフィール';

  @override
  String get adminPanelTitle => '管理パネル';

  @override
  String get adminSubtitle => '製品と店舗の管理';

  @override
  String get logoutTitle => 'ログアウト';

  @override
  String get loginTitle => 'ログイン';

  @override
  String get settingsTitle => '設定';

  @override
  String get commonOk => 'OK';

  @override
  String get commonApply => '適用';

  @override
  String get commonClearFilter => 'フィルタをクリア';

  @override
  String get languageSectionTitle => '言語';

  @override
  String get languageSubtitle => '優先言語を選択してください';

  @override
  String get systemLanguageSubtitle => '自動検出';

  @override
  String get useSystemLanguage => 'システム言語を使用';

  @override
  String get spanishLabel => 'Español';

  @override
  String get englishLabel => 'English';

  @override
  String get portugueseLabel => 'Português';

  @override
  String get frenchLabel => 'Français';

  @override
  String get japaneseLabel => '日本語';

  @override
  String get searchHint => '薬、用量、またはブランドを検索';

  @override
  String get filterByPrice => '価格でフィルタ';

  @override
  String get minPriceHint => '最低価格（例：15000）';

  @override
  String get maxPriceHint => '最高価格（例：25000）';

  @override
  String get productUnavailable => '商品が利用できません';

  @override
  String get productOutOfStock => '在庫切れ';

  @override
  String get addedToCart => 'カートに追加されました';

  @override
  String get catalogTitle => '医薬品カタログ';

  @override
  String get localesTitle => '店舗';

  @override
  String get localesSubtitle => '利用可能な店舗';

  @override
  String get storeSelected => '店舗が選択されました';

  @override
  String get active => 'アクティブ';

  @override
  String get noStoreInfo => '店舗情報がありません';

  @override
  String get addressLabel => '住所';

  @override
  String get scheduleLabel => '営業時間';

  @override
  String get availabilityLabel => '在庫状況';

  @override
  String get available => '在庫あり';

  @override
  String get notAvailable => '在庫なし';

  @override
  String get filterAll => 'すべて';

  @override
  String get filterInStock => '在庫あり';

  @override
  String get filterOutOfStock => '在庫切れ';

  @override
  String quantityTag(Object count) {
    return '数量：$count';
  }

  @override
  String get loginSubtitle => 'ログインして注文と割引を確認';

  @override
  String get usernameOrPhone => 'メールまたは電話番号';

  @override
  String get enterUsernameOrPhone => 'メールまたは電話番号を入力';

  @override
  String get password => 'パスワード';

  @override
  String get enterPassword => 'パスワードを入力';

  @override
  String get noAccountRegister => 'アカウントをお持ちでない場合は登録';

  @override
  String get demoCredentials => 'デモ認証情報';

  @override
  String get use => '使用';

  @override
  String get enter => '入力';

  @override
  String get invalidCredentials => '無効な認証情報またはユーザーが登録されていません';

  @override
  String get loginSuccess => 'ログイン成功';

  @override
  String get userProfileTitle => 'ユーザープロフィール';

  @override
  String get nationalIdLabel => '身分証明書';

  @override
  String get phoneLabel => '電話番号';

  @override
  String get notLoggedIn => 'ログインしていません';

  @override
  String get edit => '編集';

  @override
  String get tabHome => 'ホーム';

  @override
  String get tabStatus => 'ステータス';

  @override
  String get tabStores => '店舗';

  @override
  String get tabProfile => 'プロフィール';

  @override
  String get orderStatusTitle => '注文ステータス';

  @override
  String get orderStatusSubtitle => '注文の追跡';

  @override
  String get noOrders => '注文なし';

  @override
  String orderLabel(Object orderId) {
    return '注文 #$orderId';
  }

  @override
  String get summaryTitle => '概要';

  @override
  String get paymentProcessed => 'お支払いが処理され、ご注文は準備中です。';

  @override
  String get willNotify => '発送時にお知らせします。';

  @override
  String get backToHome => 'ホームに戻る';

  @override
  String get back => '戻る';

  @override
  String get adminAccessDeniedTitle => 'アクセス拒否';

  @override
  String get adminAccessDeniedMessage => '管理者権限を持つユーザーのみがこの画面にアクセスできます。';

  @override
  String get adminAddProduct => '商品を追加';

  @override
  String get adminProductName => '商品名';

  @override
  String get adminEnterProductName => '名前を入力';

  @override
  String get adminProductDosage => '用量';

  @override
  String get adminProductPriceHint => '価格（例：15000）';

  @override
  String get adminProductQuantityHint => '数量（例：10）';

  @override
  String get adminEnterQuantity => '数量を入力';

  @override
  String get adminInvalidQuantity => '無効な数量';

  @override
  String get adminDescription => '説明';

  @override
  String get adminClearProducts => '商品をクリア';

  @override
  String get adminProductAdded => '商品が追加されました';

  @override
  String get adminDistributionSection => '配送拠点管理';

  @override
  String get adminDistributionPointName => '配送拠点名';

  @override
  String get adminMedicinesAvailability => '医薬品の在庫状況';

  @override
  String get adminSaveDistributionPoint => '配送拠点を保存';

  @override
  String get adminDistributionSaved => '配送拠点データが保存されました';

  @override
  String get adminAddStore => '店舗を追加';

  @override
  String get adminStoreName => '店舗名';

  @override
  String get adminEnterStoreName => '店舗名を入力';

  @override
  String get adminEnterAddress => '住所を入力';

  @override
  String get adminStoreAdded => '店舗が追加されました';

  @override
  String get adminAddedProducts => '追加された商品';

  @override
  String get adminNoProducts => '追加された商品がありません';

  @override
  String get adminAddedStores => '追加された店舗';

  @override
  String get adminNoStores => '追加された店舗がありません';

  @override
  String get adminSelectAsActive => 'アクティブとして設定';

  @override
  String get cartTitle => 'カート';

  @override
  String get cartEmpty => 'カートは空です';

  @override
  String get cartTotal => '合計';

  @override
  String get cartCheckout => 'お支払いへ';

  @override
  String get cartClear => 'カートを空にする';

  @override
  String get changePasswordTitle => 'パスワードを変更';

  @override
  String get currentPasswordLabel => '現在のパスワード';

  @override
  String get newPasswordLabel => '新しいパスワード';

  @override
  String get confirmNewPasswordLabel => '新しいパスワードの確認';

  @override
  String get enterCurrentPassword => '現在のパスワードを入力';

  @override
  String get enterNewPassword => '新しいパスワードを入力';

  @override
  String get passwordMinLength => 'パスワードは6文字以上である必要があります';

  @override
  String get confirmNewPasswordPrompt => '新しいパスワードを確認';

  @override
  String get passwordsDoNotMatch => 'パスワードが一致しません';

  @override
  String get noAuthenticatedUser => '認証されたユーザーがいません';

  @override
  String get currentPasswordIncorrect => '現在のパスワードが正しくありません';

  @override
  String get passwordUpdated => 'パスワードが更新されました';

  @override
  String get cancel => 'キャンセル';

  @override
  String get save => '保存';

  @override
  String get editProfileTitle => 'プロフィール編集';

  @override
  String get profileSubtitle => '個人情報を更新';

  @override
  String get personalInfoSection => '個人情報';

  @override
  String get fullNameLabel => '氏名';

  @override
  String get emailLabel => 'メール';

  @override
  String get avatarUrlOptionalLabel => 'アバターURL（オプション）';

  @override
  String get enterNamePrompt => '名前を入力';

  @override
  String get enterEmailPrompt => 'メールを入力';

  @override
  String get invalidEmail => '有効なメールを入力';

  @override
  String get profileUpdated => 'プロフィールが更新されました';

  @override
  String get cashTitle => '現金払い';

  @override
  String get cashTotalToPay => 'お支払い総額';

  @override
  String get cashAmountReceived => '受取金額';

  @override
  String get cashEnterAmountHint => '金額をペソで入力';

  @override
  String get cashEnterValidAmount => '有効な金額を入力';

  @override
  String get cashAmountLessThanTotal => '金額が合計よりも少ないです';

  @override
  String cashNeedChange(Object amount) {
    return 'お釣りが必要です：$amount';
  }

  @override
  String get cashFixEnteredAmount => '入力した金額を修正';

  @override
  String get cashNeedChangeButton => 'お釣りが必要です';

  @override
  String get cashAcceptPayment => 'お支払いを承認';

  @override
  String cashSummaryWithCount(Object count) {
    return '概要（$countアイテム）';
  }

  @override
  String get cashNoItems => 'アイテムがありません';

  @override
  String get cashUnnamedItem => '名前なし';

  @override
  String cashPaymentApproved(Object change) {
    return 'お支払いが承認されました。お釣り：$change';
  }

  @override
  String get cashPaymentApprovedStatus => 'お支払いが承認されました';

  @override
  String cashErrorProcessing(Object error) {
    return 'お支払い処理エラー：$error';
  }

  @override
  String get free => '無料';

  @override
  String get continueLabel => '続ける';

  @override
  String get paymentMethodTitle => '支払い方法';

  @override
  String get selectPaymentMethodPrompt => '支払い方法を選択：';

  @override
  String get paymentCashTitle => '現金';

  @override
  String get paymentCashSubtitle => '配達時に現金で支払い';

  @override
  String get paymentDebitTitle => 'デビットカード';

  @override
  String get paymentDebitSubtitle => '銀行デビットで支払い';

  @override
  String get paymentCreditTitle => 'クレジットカード';

  @override
  String get paymentCreditSubtitle => 'Visa、MasterCard、Amexで支払い';

  @override
  String get deliveryMethodTitle => '配送方法';

  @override
  String get deliveryHome => '自宅配送';

  @override
  String deliveryHomeSubtitle(Object fee) {
    return '注文ごとに$feeの固定料金';
  }

  @override
  String get pickupInStore => '店舗で受け取り';

  @override
  String get pickupNoCharge => '追加料金なし';

  @override
  String get selectPickupStore => '受け取り店舗を選択';

  @override
  String get noStoresAvailableNow => '現在利用可能な店舗がありません';

  @override
  String get noStoresWithAvailability => '現在利用可能な店舗がありません';

  @override
  String summaryWithCount(Object count) {
    return '概要（$countアイテム）';
  }

  @override
  String get noItemsToPay => 'お支払いするアイテムがありません。';

  @override
  String get subtotal => '小計';

  @override
  String get viewDetails => '詳細を表示';

  @override
  String get imageUnavailable => '画像が利用できません';

  @override
  String get insufficientStock => '在庫不足';

  @override
  String get descriptionUnavailable => 'この商品の説明はありません。';

  @override
  String get usageInstructionsTitle => '使用方法';

  @override
  String get detailsTitle => '詳細';

  @override
  String get quantityLabel => '数量';

  @override
  String availableStock(Object count) {
    return '在庫数：$count';
  }

  @override
  String get alsoBuyTitle => 'こちらもお買い求めいただけます';

  @override
  String get noSuggestions => '現在おすすめはありません。';

  @override
  String get addToCart => 'カートに追加';

  @override
  String addedToCartItems(Object count, Object name) {
    return '$count x $nameをカートに追加しました';
  }

  @override
  String get productUsageTitle => '説明と使用方法';

  @override
  String get productDetailsTitle => '商品詳細';

  @override
  String get defaultProductName => '商品';

  @override
  String get registeredAddressFallback => '登録された住所';

  @override
  String get registerTitle => 'アカウント作成';

  @override
  String get registerSubtitle => '登録して素早くチェックアウトし、情報を保存';

  @override
  String get userTypeLabel => 'ユーザータイプ';

  @override
  String get userTypeClient => '顧客';

  @override
  String get userTypeAdmin => '管理者';

  @override
  String get nameRequired => '名前を入力';

  @override
  String get idRequired => '身分証明書を入力';

  @override
  String get phoneRequired => '電話番号を入力';

  @override
  String get emailRequired => 'メールを入力';

  @override
  String get addressRequired => '住所を入力';

  @override
  String get userTypeRequired => 'ユーザータイプを選択';

  @override
  String get passwordRequired => 'パスワードを入力';

  @override
  String get registerButton => '登録';

  @override
  String get userAlreadyExists => 'そのメールアドレスのユーザーは既に存在します';

  @override
  String get registrationAndLoginSuccess => '登録とログインが正常に完了しました';

  @override
  String get creditCardTitle => 'クレジットカード';

  @override
  String get creditCardImageFallback => 'カード';

  @override
  String get cardNumberLabel => 'カード番号';

  @override
  String get cardNumberHint => '1234123412341234';

  @override
  String get cardNumberInvalid => '無効な番号';

  @override
  String get cardNumberExact16 => '番号は16桁である必要があります';

  @override
  String get expiryLabel => '有効期限（MM/YY）';

  @override
  String get expiryHint => 'MM/YY';

  @override
  String get expiryRequired => '日付が必要です';

  @override
  String get expiryInvalidFormat => '無効な形式（MM/YY）';

  @override
  String get expirySameAsCurrent => '日付は現在の月/年と同じにできません';

  @override
  String get cvcLabel => 'CVCコード';

  @override
  String get cvcHint => '123';

  @override
  String get cvcInvalid => '無効なコード';

  @override
  String get cvcExact3 => 'CVCは3桁である必要があります';

  @override
  String get nameOnCardLabel => 'カード名義';

  @override
  String get nameOnCardHint => 'カードに記載されている通り';

  @override
  String get nameOnCardRequired => '名前が必要です';

  @override
  String get payButton => '支払い';

  @override
  String get fixErrorsBeforeContinue => '続行する前にエラーを修正';

  @override
  String get paymentSimulatedApproved => 'シミュレートされた支払いが承認されました';
}
