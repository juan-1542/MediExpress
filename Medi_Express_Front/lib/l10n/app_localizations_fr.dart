// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get currency => 'EUR';

  @override
  String get currencySymbol => '€';

  @override
  String get appTitle => 'MediExpress';

  @override
  String get hello => 'Bonjour';

  @override
  String get homeSubtitle => 'Votre pharmacie en quelques minutes';

  @override
  String get profileTitle => 'Mon profil';

  @override
  String get adminPanelTitle => 'Panneau Admin';

  @override
  String get logoutTitle => 'Se déconnecter';

  @override
  String get loginTitle => 'Se connecter';

  @override
  String get settingsTitle => 'Paramètres';

  @override
  String get commonOk => 'OK';

  @override
  String get commonApply => 'Appliquer';

  @override
  String get commonClearFilter => 'Effacer le filtre';

  @override
  String get languageSectionTitle => 'Langue';

  @override
  String get useSystemLanguage => 'Utiliser la langue du système';

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
  String get searchHint => 'Rechercher médicament, dosage ou marque';

  @override
  String get filterByPrice => 'Filtrer par prix';

  @override
  String get minPriceHint => 'Prix minimum (ex. 15000)';

  @override
  String get maxPriceHint => 'Prix maximum (ex. 25000)';

  @override
  String get productUnavailable => 'Produit non disponible';

  @override
  String get productOutOfStock => 'Produit en rupture de stock';

  @override
  String get addedToCart => 'Ajouté au panier';

  @override
  String get catalogTitle => 'Catalogue de médicaments';

  @override
  String get localesTitle => 'Magasins';

  @override
  String get noStoreInfo => 'Aucune information de magasin';

  @override
  String get addressLabel => 'Adresse';

  @override
  String get scheduleLabel => 'Horaires';

  @override
  String get availabilityLabel => 'Disponibilité';

  @override
  String get available => 'Disponible';

  @override
  String get notAvailable => 'Non disponible';

  @override
  String get filterAll => 'Tous';

  @override
  String get filterInStock => 'En stock';

  @override
  String get filterOutOfStock => 'Rupture de stock';

  @override
  String quantityTag(Object count) {
    return 'Qté: $count';
  }

  @override
  String get loginSubtitle =>
      'Connectez-vous pour voir vos commandes et réductions';

  @override
  String get usernameOrPhone => 'Email ou téléphone';

  @override
  String get enterUsernameOrPhone => 'Entrez email ou téléphone';

  @override
  String get password => 'Mot de passe';

  @override
  String get enterPassword => 'Entrez votre mot de passe';

  @override
  String get noAccountRegister => 'Pas de compte? Inscrivez-vous';

  @override
  String get demoCredentials => 'Identifiants de démonstration';

  @override
  String get use => 'Utiliser';

  @override
  String get enter => 'Entrer';

  @override
  String get invalidCredentials =>
      'Identifiants invalides ou utilisateur non enregistré';

  @override
  String get loginSuccess => 'Connexion réussie';

  @override
  String get userProfileTitle => 'Profil utilisateur';

  @override
  String get nationalIdLabel => 'Pièce d\'identité';

  @override
  String get phoneLabel => 'Téléphone';

  @override
  String get notLoggedIn => 'Vous n\'êtes pas connecté';

  @override
  String get edit => 'Modifier';

  @override
  String get tabHome => 'Accueil';

  @override
  String get tabStatus => 'État';

  @override
  String get tabStores => 'Magasins';

  @override
  String get tabProfile => 'Profil';

  @override
  String get orderStatusTitle => 'État de la commande';

  @override
  String orderLabel(Object orderId) {
    return 'Commande #$orderId';
  }

  @override
  String get summaryTitle => 'Résumé';

  @override
  String get paymentProcessed =>
      'Votre paiement a été traité et votre commande est en préparation.';

  @override
  String get willNotify => 'Nous vous avertirons lorsqu\'elle sera expédiée.';

  @override
  String get backToHome => 'Retour à l\'accueil';

  @override
  String get back => 'Retour';

  @override
  String get adminAccessDeniedTitle => 'Accès refusé';

  @override
  String get adminAccessDeniedMessage =>
      'Seuls les utilisateurs avec le rôle d\'administrateur peuvent accéder à cet écran.';

  @override
  String get adminAddProduct => 'Ajouter un produit';

  @override
  String get adminProductName => 'Nom du produit';

  @override
  String get adminEnterProductName => 'Entrez le nom';

  @override
  String get adminProductDosage => 'Dosage';

  @override
  String get adminProductPriceHint => 'Prix (ex. 15000)';

  @override
  String get adminProductQuantityHint => 'Quantité (ex. 10)';

  @override
  String get adminEnterQuantity => 'Entrez la quantité';

  @override
  String get adminInvalidQuantity => 'Quantité invalide';

  @override
  String get adminDescription => 'Description';

  @override
  String get adminClearProducts => 'Effacer les produits';

  @override
  String get adminProductAdded => 'Produit ajouté';

  @override
  String get adminDistributionSection => 'Gestion du point de distribution';

  @override
  String get adminDistributionPointName => 'Nom du point de distribution';

  @override
  String get adminMedicinesAvailability => 'Disponibilité des médicaments';

  @override
  String get adminSaveDistributionPoint =>
      'Enregistrer le point de distribution';

  @override
  String get adminDistributionSaved =>
      'Données du point de distribution enregistrées';

  @override
  String get adminAddStore => 'Ajouter un magasin';

  @override
  String get adminStoreName => 'Nom du magasin';

  @override
  String get adminEnterStoreName => 'Entrez le nom du magasin';

  @override
  String get adminEnterAddress => 'Entrez une adresse';

  @override
  String get adminStoreAdded => 'Magasin ajouté';

  @override
  String get adminAddedProducts => 'Produits ajoutés';

  @override
  String get adminNoProducts => 'Aucun produit ajouté';

  @override
  String get adminAddedStores => 'Magasins ajoutés';

  @override
  String get adminNoStores => 'Aucun magasin ajouté';

  @override
  String get adminSelectAsActive => 'Définir comme actif';

  @override
  String get cartTitle => 'Panier';

  @override
  String get cartEmpty => 'Votre panier est vide';

  @override
  String get cartTotal => 'Total';

  @override
  String get cartCheckout => 'Passer au paiement';

  @override
  String get cartClear => 'Vider le panier';

  @override
  String get changePasswordTitle => 'Changer le mot de passe';

  @override
  String get currentPasswordLabel => 'Mot de passe actuel';

  @override
  String get newPasswordLabel => 'Nouveau mot de passe';

  @override
  String get confirmNewPasswordLabel => 'Confirmer le nouveau mot de passe';

  @override
  String get enterCurrentPassword => 'Entrez votre mot de passe actuel';

  @override
  String get enterNewPassword => 'Entrez un nouveau mot de passe';

  @override
  String get passwordMinLength =>
      'Le mot de passe doit contenir au moins 6 caractères';

  @override
  String get confirmNewPasswordPrompt => 'Confirmez le nouveau mot de passe';

  @override
  String get passwordsDoNotMatch => 'Les mots de passe ne correspondent pas';

  @override
  String get noAuthenticatedUser => 'Aucun utilisateur authentifié';

  @override
  String get currentPasswordIncorrect => 'Mot de passe actuel incorrect';

  @override
  String get passwordUpdated => 'Mot de passe mis à jour';

  @override
  String get cancel => 'Annuler';

  @override
  String get save => 'Enregistrer';

  @override
  String get editProfileTitle => 'Modifier le profil';

  @override
  String get fullNameLabel => 'Nom complet';

  @override
  String get emailLabel => 'Email';

  @override
  String get avatarUrlOptionalLabel => 'URL de l\'avatar (facultatif)';

  @override
  String get enterNamePrompt => 'Entrez le nom';

  @override
  String get enterEmailPrompt => 'Entrez l\'email';

  @override
  String get invalidEmail => 'Entrez un email valide';

  @override
  String get profileUpdated => 'Profil mis à jour';

  @override
  String get cashTitle => 'Paiement en espèces';

  @override
  String get cashTotalToPay => 'Total à payer';

  @override
  String get cashAmountReceived => 'Montant reçu';

  @override
  String get cashEnterAmountHint => 'Entrez le montant en pesos';

  @override
  String get cashEnterValidAmount => 'Entrez un montant valide';

  @override
  String get cashAmountLessThanTotal =>
      'Le montant est inférieur au total à payer';

  @override
  String cashNeedChange(Object amount) {
    return 'Vous aurez besoin de monnaie: $amount';
  }

  @override
  String get cashFixEnteredAmount => 'Corrigez le montant saisi';

  @override
  String get cashNeedChangeButton => 'J\'aurai besoin de monnaie';

  @override
  String get cashAcceptPayment => 'Accepter le paiement';

  @override
  String cashSummaryWithCount(Object count) {
    return 'Résumé ($count articles)';
  }

  @override
  String get cashNoItems => 'Aucun article';

  @override
  String get cashUnnamedItem => 'Sans nom';

  @override
  String cashPaymentApproved(Object change) {
    return 'Paiement approuvé. Monnaie: $change';
  }

  @override
  String get cashPaymentApprovedStatus => 'Paiement approuvé';

  @override
  String cashErrorProcessing(Object error) {
    return 'Erreur lors du traitement du paiement: $error';
  }

  @override
  String get free => 'Gratuit';

  @override
  String get continueLabel => 'Continuer';

  @override
  String get paymentMethodTitle => 'Méthode de paiement';

  @override
  String get selectPaymentMethodPrompt =>
      'Sélectionnez une méthode de paiement:';

  @override
  String get paymentCashTitle => 'Espèces';

  @override
  String get paymentCashSubtitle => 'Payer en espèces à la livraison';

  @override
  String get paymentDebitTitle => 'Carte de débit';

  @override
  String get paymentDebitSubtitle => 'Payer par débit bancaire';

  @override
  String get paymentCreditTitle => 'Carte de crédit';

  @override
  String get paymentCreditSubtitle => 'Payer avec Visa, MasterCard, Amex';

  @override
  String get deliveryMethodTitle => 'Méthode de livraison';

  @override
  String get deliveryHome => 'Livraison à domicile';

  @override
  String deliveryHomeSubtitle(Object fee) {
    return 'Frais fixes de $fee par commande';
  }

  @override
  String get pickupInStore => 'Retrait en magasin';

  @override
  String get pickupNoCharge => 'Sans frais supplémentaires';

  @override
  String get selectPickupStore => 'Sélectionnez un magasin pour le retrait';

  @override
  String get noStoresAvailableNow => 'Aucun magasin disponible pour le moment';

  @override
  String get noStoresWithAvailability =>
      'Aucun magasin actuellement disponible';

  @override
  String summaryWithCount(Object count) {
    return 'Résumé ($count articles)';
  }

  @override
  String get noItemsToPay => 'Aucun article à payer.';

  @override
  String get subtotal => 'Sous-total';

  @override
  String get viewDetails => 'Voir les détails';

  @override
  String get imageUnavailable => 'Image non disponible';

  @override
  String get insufficientStock => 'Stock insuffisant';

  @override
  String get descriptionUnavailable =>
      'Description non disponible pour ce produit.';

  @override
  String get usageInstructionsTitle => 'Instructions d\'utilisation';

  @override
  String get detailsTitle => 'Détails';

  @override
  String get quantityLabel => 'Quantité';

  @override
  String availableStock(Object count) {
    return 'Stock disponible: $count';
  }

  @override
  String get alsoBuyTitle => 'Vous pourriez aussi acheter';

  @override
  String get noSuggestions => 'Aucune suggestion disponible pour le moment.';

  @override
  String get addToCart => 'Ajouter au panier';

  @override
  String addedToCartItems(Object count, Object name) {
    return 'Ajouté $count x $name au panier';
  }

  @override
  String get productUsageTitle => 'Description et utilisation';

  @override
  String get productDetailsTitle => 'Détails du produit';

  @override
  String get defaultProductName => 'Produit';

  @override
  String get registeredAddressFallback => 'Adresse enregistrée';

  @override
  String get registerTitle => 'Créer un compte';

  @override
  String get registerSubtitle =>
      'Inscrivez-vous pour commander plus rapidement et enregistrer vos informations';

  @override
  String get userTypeLabel => 'Type d\'utilisateur';

  @override
  String get userTypeClient => 'Client';

  @override
  String get userTypeAdmin => 'Admin';

  @override
  String get nameRequired => 'Entrez votre nom';

  @override
  String get idRequired => 'Entrez la pièce d\'identité';

  @override
  String get phoneRequired => 'Entrez le téléphone';

  @override
  String get emailRequired => 'Entrez l\'email';

  @override
  String get addressRequired => 'Entrez l\'adresse';

  @override
  String get userTypeRequired => 'Sélectionnez le type d\'utilisateur';

  @override
  String get passwordRequired => 'Entrez le mot de passe';

  @override
  String get registerButton => 'S\'inscrire';

  @override
  String get userAlreadyExists => 'Un utilisateur avec cet email existe déjà';

  @override
  String get registrationAndLoginSuccess => 'Inscription et connexion réussies';

  @override
  String get creditCardTitle => 'Carte de crédit';

  @override
  String get creditCardImageFallback => 'Carte';

  @override
  String get cardNumberLabel => 'Numéro de carte';

  @override
  String get cardNumberHint => '1234123412341234';

  @override
  String get cardNumberInvalid => 'Numéro invalide';

  @override
  String get cardNumberExact16 =>
      'Le numéro doit contenir exactement 16 chiffres';

  @override
  String get expiryLabel => 'Date d\'expiration (MM/AA)';

  @override
  String get expiryHint => 'MM/AA';

  @override
  String get expiryRequired => 'Date requise';

  @override
  String get expiryInvalidFormat => 'Format invalide (MM/AA)';

  @override
  String get expirySameAsCurrent =>
      'La date ne peut pas être identique au mois/année actuel';

  @override
  String get cvcLabel => 'Code CVC';

  @override
  String get cvcHint => '123';

  @override
  String get cvcInvalid => 'Code invalide';

  @override
  String get cvcExact3 => 'Le CVC doit contenir exactement 3 chiffres';

  @override
  String get nameOnCardLabel => 'Nom sur la carte';

  @override
  String get nameOnCardHint => 'Tel qu\'il apparaît sur la carte';

  @override
  String get nameOnCardRequired => 'Nom requis';

  @override
  String get payButton => 'Payer';

  @override
  String get fixErrorsBeforeContinue =>
      'Corrigez les erreurs avant de continuer';

  @override
  String get paymentSimulatedApproved => 'Paiement simulé approuvé';
}
