// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get currency => 'COP';

  @override
  String get currencySymbol => '\$';

  @override
  String get appTitle => 'MediExpress';

  @override
  String get hello => 'Hola';

  @override
  String get homeSubtitle => 'Tu farmacia en minutos';

  @override
  String get profileTitle => 'Mi perfil';

  @override
  String get adminPanelTitle => 'Panel Admin';

  @override
  String get logoutTitle => 'Cerrar sesión';

  @override
  String get loginTitle => 'Iniciar sesión';

  @override
  String get settingsTitle => 'Configuraciones';

  @override
  String get commonOk => 'OK';

  @override
  String get commonApply => 'Aplicar';

  @override
  String get commonClearFilter => 'Limpiar filtro';

  @override
  String get languageSectionTitle => 'Idioma / Language';

  @override
  String get useSystemLanguage => 'Usar idioma del sistema';

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
  String get searchHint => 'Buscar medicamento, dosis o marca';

  @override
  String get filterByPrice => 'Filtrar por precio';

  @override
  String get minPriceHint => 'Precio mínimo (ej. 15000)';

  @override
  String get maxPriceHint => 'Precio máximo (ej. 25000)';

  @override
  String get productUnavailable => 'Producto no disponible';

  @override
  String get productOutOfStock => 'Producto sin stock';

  @override
  String get addedToCart => 'Agregado al carrito';

  @override
  String get catalogTitle => 'Catálogo de medicamentos';

  @override
  String get localesTitle => 'Locales';

  @override
  String get noStoreInfo => 'No hay información de locales';

  @override
  String get addressLabel => 'Dirección';

  @override
  String get scheduleLabel => 'Horario';

  @override
  String get availabilityLabel => 'Disponibilidad';

  @override
  String get available => 'Disponible';

  @override
  String get notAvailable => 'No disponible';

  @override
  String get filterAll => 'Todos';

  @override
  String get filterInStock => 'Con stock';

  @override
  String get filterOutOfStock => 'Sin stock';

  @override
  String quantityTag(Object count) {
    return 'Cantidad: $count';
  }

  @override
  String get loginSubtitle => 'Accede para ver tus pedidos y descuentos';

  @override
  String get usernameOrPhone => 'Correo o teléfono';

  @override
  String get enterUsernameOrPhone => 'Ingresa correo o teléfono';

  @override
  String get password => 'Contraseña';

  @override
  String get enterPassword => 'Ingresa la contraseña';

  @override
  String get noAccountRegister => '¿No tienes cuenta? Regístrate';

  @override
  String get demoCredentials => 'Credenciales de demo';

  @override
  String get use => 'Usar';

  @override
  String get enter => 'Entrar';

  @override
  String get invalidCredentials =>
      'Credenciales inválidas o usuario no registrado';

  @override
  String get loginSuccess => 'Inicio de sesión correcto';

  @override
  String get userProfileTitle => 'Perfil del Usuario';

  @override
  String get nationalIdLabel => 'Cédula';

  @override
  String get phoneLabel => 'Teléfono';

  @override
  String get notLoggedIn => 'No has iniciado sesión';

  @override
  String get edit => 'Editar';

  @override
  String get tabHome => 'Inicio';

  @override
  String get tabStatus => 'Estado';

  @override
  String get tabStores => 'Locales';

  @override
  String get tabProfile => 'Perfil';

  @override
  String get orderStatusTitle => 'Estado del pedido';

  @override
  String orderLabel(Object orderId) {
    return 'Pedido #$orderId';
  }

  @override
  String get summaryTitle => 'Resumen';

  @override
  String get paymentProcessed =>
      'Tu pago se ha procesado correctamente y tu pedido está en preparación.';

  @override
  String get willNotify =>
      'Te enviaremos una notificación cuando sea despachado.';

  @override
  String get backToHome => 'Volver al inicio';

  @override
  String get back => 'Volver';

  @override
  String get adminAccessDeniedTitle => 'Acceso denegado';

  @override
  String get adminAccessDeniedMessage =>
      'Solo los usuarios con rol de administrador pueden acceder a esta pantalla.';

  @override
  String get adminAddProduct => 'Añadir producto';

  @override
  String get adminProductName => 'Nombre del producto';

  @override
  String get adminEnterProductName => 'Ingresa el nombre';

  @override
  String get adminProductDosage => 'Dosis';

  @override
  String get adminProductPriceHint => 'Precio (ej. 15000)';

  @override
  String get adminProductQuantityHint => 'Cantidad (ej. 10)';

  @override
  String get adminEnterQuantity => 'Ingresa la cantidad';

  @override
  String get adminInvalidQuantity => 'Cantidad inválida';

  @override
  String get adminDescription => 'Descripción';

  @override
  String get adminClearProducts => 'Limpiar productos';

  @override
  String get adminProductAdded => 'Producto añadido';

  @override
  String get adminDistributionSection => 'Gestión del punto de distribución';

  @override
  String get adminDistributionPointName => 'Nombre del punto de distribución';

  @override
  String get adminMedicinesAvailability => 'Disponibilidad de medicamentos';

  @override
  String get adminSaveDistributionPoint => 'Guardar punto de distribución';

  @override
  String get adminDistributionSaved =>
      'Datos de punto de distribución guardados';

  @override
  String get adminAddStore => 'Añadir local';

  @override
  String get adminStoreName => 'Nombre del local';

  @override
  String get adminEnterStoreName => 'Ingresa el nombre del local';

  @override
  String get adminEnterAddress => 'Ingresa una dirección';

  @override
  String get adminStoreAdded => 'Local añadido';

  @override
  String get adminAddedProducts => 'Productos añadidos';

  @override
  String get adminNoProducts => 'No hay productos añadidos';

  @override
  String get adminAddedStores => 'Locales añadidos';

  @override
  String get adminNoStores => 'No hay locales añadidos';

  @override
  String get adminSelectAsActive => 'Seleccionar como activo';

  @override
  String get cartTitle => 'Carrito';

  @override
  String get cartEmpty => 'El carrito está vacío';

  @override
  String get cartTotal => 'Total';

  @override
  String get cartCheckout => 'Ir a pagar';

  @override
  String get cartClear => 'Vaciar carrito';

  @override
  String get changePasswordTitle => 'Cambiar contraseña';

  @override
  String get currentPasswordLabel => 'Contraseña actual';

  @override
  String get newPasswordLabel => 'Nueva contraseña';

  @override
  String get confirmNewPasswordLabel => 'Confirmar nueva contraseña';

  @override
  String get enterCurrentPassword => 'Ingresa la contraseña actual';

  @override
  String get enterNewPassword => 'Ingresa la nueva contraseña';

  @override
  String get passwordMinLength =>
      'La contraseña debe tener al menos 6 caracteres';

  @override
  String get confirmNewPasswordPrompt => 'Confirma la nueva contraseña';

  @override
  String get passwordsDoNotMatch => 'Las contraseñas no coinciden';

  @override
  String get noAuthenticatedUser => 'No hay usuario autenticado';

  @override
  String get currentPasswordIncorrect => 'Contraseña actual incorrecta';

  @override
  String get passwordUpdated => 'Contraseña actualizada';

  @override
  String get cancel => 'Cancelar';

  @override
  String get save => 'Guardar';

  @override
  String get editProfileTitle => 'Editar perfil';

  @override
  String get fullNameLabel => 'Nombre completo';

  @override
  String get emailLabel => 'Correo';

  @override
  String get avatarUrlOptionalLabel => 'URL avatar (opcional)';

  @override
  String get enterNamePrompt => 'Ingresa el nombre';

  @override
  String get enterEmailPrompt => 'Ingresa el correo';

  @override
  String get invalidEmail => 'Ingresa un correo válido';

  @override
  String get profileUpdated => 'Perfil actualizado';

  @override
  String get cashTitle => 'Pago en efectivo';

  @override
  String get cashTotalToPay => 'Total a pagar';

  @override
  String get cashAmountReceived => 'Cantidad recibida';

  @override
  String get cashEnterAmountHint => 'Ingresa la cantidad en pesos';

  @override
  String get cashEnterValidAmount => 'Ingresa una cantidad válida';

  @override
  String get cashAmountLessThanTotal => 'La cantidad es menor al total a pagar';

  @override
  String cashNeedChange(Object amount) {
    return 'Necesitarás cambio: $amount';
  }

  @override
  String get cashFixEnteredAmount => 'Corrige la cantidad ingresada';

  @override
  String get cashNeedChangeButton => 'Necesitaré cambio';

  @override
  String get cashAcceptPayment => 'Aceptar pago';

  @override
  String cashSummaryWithCount(Object count) {
    return 'Resumen ($count artículos)';
  }

  @override
  String get cashNoItems => 'No hay artículos';

  @override
  String get cashUnnamedItem => 'Sin nombre';

  @override
  String cashPaymentApproved(Object change) {
    return 'Pago aprobado. Cambio: $change';
  }

  @override
  String get cashPaymentApprovedStatus => 'Pago aprobado';

  @override
  String cashErrorProcessing(Object error) {
    return 'Error procesando pago: $error';
  }

  @override
  String get free => 'Gratis';

  @override
  String get continueLabel => 'Continuar';

  @override
  String get paymentMethodTitle => 'Método de pago';

  @override
  String get selectPaymentMethodPrompt => 'Selecciona un método de pago:';

  @override
  String get paymentCashTitle => 'Efectivo';

  @override
  String get paymentCashSubtitle => 'Paga en efectivo al recibir';

  @override
  String get paymentDebitTitle => 'Tarjeta Débito';

  @override
  String get paymentDebitSubtitle => 'Pago con débito bancario';

  @override
  String get paymentCreditTitle => 'Tarjeta Crédito';

  @override
  String get paymentCreditSubtitle => 'Paga con Visa, MasterCard, Amex';

  @override
  String get deliveryMethodTitle => 'Método de entrega';

  @override
  String get deliveryHome => 'Domicilio';

  @override
  String deliveryHomeSubtitle(Object fee) {
    return 'Cargo fijo de $fee por pedido';
  }

  @override
  String get pickupInStore => 'Reclamar presencialmente';

  @override
  String get pickupNoCharge => 'Sin cargo adicional';

  @override
  String get selectPickupStore => 'Selecciona un local para retirar';

  @override
  String get noStoresAvailableNow =>
      'No hay locales disponibles en este momento';

  @override
  String get noStoresWithAvailability =>
      'No hay locales con disponibilidad actualmente';

  @override
  String summaryWithCount(Object count) {
    return 'Resumen ($count artículos)';
  }

  @override
  String get noItemsToPay => 'No hay artículos para pagar.';

  @override
  String get subtotal => 'Subtotal';

  @override
  String get viewDetails => 'Ver detalles';

  @override
  String get imageUnavailable => 'Imagen no disponible';

  @override
  String get insufficientStock => 'No hay suficiente stock';

  @override
  String get descriptionUnavailable =>
      'Descripción no disponible para este producto.';

  @override
  String get usageInstructionsTitle => 'Indicaciones de uso';

  @override
  String get detailsTitle => 'Detalles';

  @override
  String get quantityLabel => 'Cantidad';

  @override
  String availableStock(Object count) {
    return 'Stock disponible: $count';
  }

  @override
  String get alsoBuyTitle => 'También puedes comprar';

  @override
  String get noSuggestions => 'No hay sugerencias disponibles en este momento.';

  @override
  String get addToCart => 'Añadir al carrito';

  @override
  String addedToCartItems(Object count, Object name) {
    return 'Añadido $count x $name al carrito';
  }

  @override
  String get productUsageTitle => 'Descripción y uso';

  @override
  String get productDetailsTitle => 'Detalles del producto';

  @override
  String get defaultProductName => 'Producto';

  @override
  String get registeredAddressFallback => 'Dirección registrada';

  @override
  String get registerTitle => 'Crear cuenta';

  @override
  String get registerSubtitle =>
      'Regístrate para comprar más rápido y guardar tus datos';

  @override
  String get userTypeLabel => 'Tipo de usuario';

  @override
  String get userTypeClient => 'Cliente';

  @override
  String get userTypeAdmin => 'Admin';

  @override
  String get nameRequired => 'Ingresa tu nombre';

  @override
  String get idRequired => 'Ingresa la cédula';

  @override
  String get phoneRequired => 'Ingresa el teléfono';

  @override
  String get emailRequired => 'Ingresa el correo';

  @override
  String get addressRequired => 'Ingresa la dirección';

  @override
  String get userTypeRequired => 'Selecciona el tipo de usuario';

  @override
  String get passwordRequired => 'Ingresa la clave';

  @override
  String get registerButton => 'Registrarse';

  @override
  String get userAlreadyExists => 'Ya existe un usuario con ese correo';

  @override
  String get registrationAndLoginSuccess =>
      'Registro y login realizados con éxito';

  @override
  String get creditCardTitle => 'Tarjeta de crédito';

  @override
  String get creditCardImageFallback => 'Tarjeta';

  @override
  String get cardNumberLabel => 'Número de tarjeta';

  @override
  String get cardNumberHint => '1234123412341234';

  @override
  String get cardNumberInvalid => 'Número inválido';

  @override
  String get cardNumberExact16 => 'El número debe tener exactamente 16 dígitos';

  @override
  String get expiryLabel => 'Fecha de expiración (MM/AA)';

  @override
  String get expiryHint => 'MM/AA';

  @override
  String get expiryRequired => 'Fecha requerida';

  @override
  String get expiryInvalidFormat => 'Formato inválido (MM/AA)';

  @override
  String get expirySameAsCurrent =>
      'La fecha no puede ser igual al mes/año actual';

  @override
  String get cvcLabel => 'Código CVC';

  @override
  String get cvcHint => '123';

  @override
  String get cvcInvalid => 'Código inválido';

  @override
  String get cvcExact3 => 'El CVC debe tener exactamente 3 dígitos';

  @override
  String get nameOnCardLabel => 'Nombre en la tarjeta';

  @override
  String get nameOnCardHint => 'Como aparece en la tarjeta';

  @override
  String get nameOnCardRequired => 'Nombre requerido';

  @override
  String get payButton => 'Pagar';

  @override
  String get fixErrorsBeforeContinue =>
      'Corrige los errores antes de continuar';

  @override
  String get paymentSimulatedApproved => 'Pago simulado aprobado';
}
