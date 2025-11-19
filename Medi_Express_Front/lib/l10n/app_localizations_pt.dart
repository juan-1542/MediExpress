// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'MediExpress';

  @override
  String get hello => 'Olá';

  @override
  String get homeSubtitle => 'Sua farmácia em minutos';

  @override
  String get profileTitle => 'Meu perfil';

  @override
  String get adminPanelTitle => 'Painel Admin';

  @override
  String get logoutTitle => 'Sair';

  @override
  String get loginTitle => 'Entrar';

  @override
  String get settingsTitle => 'Configurações';

  @override
  String get commonOk => 'OK';

  @override
  String get commonApply => 'Aplicar';

  @override
  String get commonClearFilter => 'Limpar filtro';

  @override
  String get languageSectionTitle => 'Idioma / Língua';

  @override
  String get useSystemLanguage => 'Usar idioma do sistema';

  @override
  String get spanishLabel => 'Español';

  @override
  String get englishLabel => 'English';

  @override
  String get portugueseLabel => 'Português';

  @override
  String get searchHint => 'Buscar medicamento, dosagem ou marca';

  @override
  String get filterByPrice => 'Filtrar por preço';

  @override
  String get minPriceHint => 'Preço mínimo (ex. 15000)';

  @override
  String get maxPriceHint => 'Preço máximo (ex. 25000)';

  @override
  String get productUnavailable => 'Produto não disponível';

  @override
  String get productOutOfStock => 'Produto sem estoque';

  @override
  String get addedToCart => 'Adicionado ao carrinho';

  @override
  String get catalogTitle => 'Catálogo de medicamentos';

  @override
  String get localesTitle => 'Lojas';

  @override
  String get noStoreInfo => 'Não há informações de lojas';

  @override
  String get addressLabel => 'Endereço';

  @override
  String get scheduleLabel => 'Horário';

  @override
  String get availabilityLabel => 'Disponibilidade';

  @override
  String get available => 'Disponível';

  @override
  String get notAvailable => 'Não disponível';

  @override
  String get filterAll => 'Todos';

  @override
  String get filterInStock => 'Com estoque';

  @override
  String get filterOutOfStock => 'Sem estoque';

  @override
  String quantityTag(Object count) {
    return 'Qtd: $count';
  }

  @override
  String get loginSubtitle => 'Entre para ver seus pedidos e descontos';

  @override
  String get usernameOrPhone => 'E-mail ou telefone';

  @override
  String get enterUsernameOrPhone => 'Digite e-mail ou telefone';

  @override
  String get password => 'Senha';

  @override
  String get enterPassword => 'Digite sua senha';

  @override
  String get noAccountRegister => 'Não tem conta? Cadastre-se';

  @override
  String get demoCredentials => 'Credenciais de demonstração';

  @override
  String get use => 'Usar';

  @override
  String get enter => 'Entrar';

  @override
  String get invalidCredentials =>
      'Credenciais inválidas ou usuário não registrado';

  @override
  String get loginSuccess => 'Login bem-sucedido';

  @override
  String get userProfileTitle => 'Perfil do Usuário';

  @override
  String get nationalIdLabel => 'CPF';

  @override
  String get phoneLabel => 'Telefone';

  @override
  String get notLoggedIn => 'Você não está conectado';

  @override
  String get edit => 'Editar';

  @override
  String get tabHome => 'Início';

  @override
  String get tabStatus => 'Status';

  @override
  String get tabStores => 'Lojas';

  @override
  String get tabProfile => 'Perfil';

  @override
  String get orderStatusTitle => 'Status do Pedido';

  @override
  String orderLabel(Object orderId) {
    return 'Pedido #$orderId';
  }

  @override
  String get summaryTitle => 'Resumo';

  @override
  String get paymentProcessed =>
      'Seu pagamento foi processado e seu pedido está sendo preparado.';

  @override
  String get willNotify => 'Enviaremos uma notificação quando for despachado.';

  @override
  String get backToHome => 'Voltar ao início';

  @override
  String get back => 'Voltar';

  @override
  String get adminAccessDeniedTitle => 'Acesso negado';

  @override
  String get adminAccessDeniedMessage =>
      'Apenas usuários com função de administrador podem acessar esta tela.';

  @override
  String get adminAddProduct => 'Adicionar produto';

  @override
  String get adminProductName => 'Nome do produto';

  @override
  String get adminEnterProductName => 'Digite o nome';

  @override
  String get adminProductDosage => 'Dosagem';

  @override
  String get adminProductPriceHint => 'Preço (ex. 15000)';

  @override
  String get adminProductQuantityHint => 'Quantidade (ex. 10)';

  @override
  String get adminEnterQuantity => 'Digite a quantidade';

  @override
  String get adminInvalidQuantity => 'Quantidade inválida';

  @override
  String get adminDescription => 'Descrição';

  @override
  String get adminClearProducts => 'Limpar produtos';

  @override
  String get adminProductAdded => 'Produto adicionado';

  @override
  String get adminDistributionSection => 'Gestão do ponto de distribuição';

  @override
  String get adminDistributionPointName => 'Nome do ponto de distribuição';

  @override
  String get adminMedicinesAvailability => 'Disponibilidade de medicamentos';

  @override
  String get adminSaveDistributionPoint => 'Salvar ponto de distribuição';

  @override
  String get adminDistributionSaved => 'Dados do ponto de distribuição salvos';

  @override
  String get adminAddStore => 'Adicionar loja';

  @override
  String get adminStoreName => 'Nome da loja';

  @override
  String get adminEnterStoreName => 'Digite o nome da loja';

  @override
  String get adminEnterAddress => 'Digite um endereço';

  @override
  String get adminStoreAdded => 'Loja adicionada';

  @override
  String get adminAddedProducts => 'Produtos adicionados';

  @override
  String get adminNoProducts => 'Nenhum produto adicionado';

  @override
  String get adminAddedStores => 'Lojas adicionadas';

  @override
  String get adminNoStores => 'Nenhuma loja adicionada';

  @override
  String get adminSelectAsActive => 'Selecionar como ativo';

  @override
  String get cartTitle => 'Carrinho';

  @override
  String get cartEmpty => 'O carrinho está vazio';

  @override
  String get cartTotal => 'Total';

  @override
  String get cartCheckout => 'Ir para pagamento';

  @override
  String get cartClear => 'Esvaziar carrinho';

  @override
  String get changePasswordTitle => 'Alterar senha';

  @override
  String get currentPasswordLabel => 'Senha atual';

  @override
  String get newPasswordLabel => 'Nova senha';

  @override
  String get confirmNewPasswordLabel => 'Confirmar nova senha';

  @override
  String get enterCurrentPassword => 'Digite sua senha atual';

  @override
  String get enterNewPassword => 'Digite uma nova senha';

  @override
  String get passwordMinLength => 'A senha deve ter pelo menos 6 caracteres';

  @override
  String get confirmNewPasswordPrompt => 'Confirme a nova senha';

  @override
  String get passwordsDoNotMatch => 'As senhas não coincidem';

  @override
  String get noAuthenticatedUser => 'Nenhum usuário autenticado';

  @override
  String get currentPasswordIncorrect => 'Senha atual incorreta';

  @override
  String get passwordUpdated => 'Senha atualizada';

  @override
  String get cancel => 'Cancelar';

  @override
  String get save => 'Salvar';

  @override
  String get editProfileTitle => 'Editar perfil';

  @override
  String get fullNameLabel => 'Nome completo';

  @override
  String get emailLabel => 'E-mail';

  @override
  String get avatarUrlOptionalLabel => 'URL do avatar (opcional)';

  @override
  String get enterNamePrompt => 'Digite o nome';

  @override
  String get enterEmailPrompt => 'Digite o e-mail';

  @override
  String get invalidEmail => 'Digite um e-mail válido';

  @override
  String get profileUpdated => 'Perfil atualizado';

  @override
  String get cashTitle => 'Pagamento em dinheiro';

  @override
  String get cashTotalToPay => 'Total a pagar';

  @override
  String get cashAmountReceived => 'Valor recebido';

  @override
  String get cashEnterAmountHint => 'Digite o valor em reais';

  @override
  String get cashEnterValidAmount => 'Digite um valor válido';

  @override
  String get cashAmountLessThanTotal => 'O valor é menor que o total a pagar';

  @override
  String cashNeedChange(Object amount) {
    return 'Você precisará de troco: $amount';
  }

  @override
  String get cashFixEnteredAmount => 'Corrija o valor digitado';

  @override
  String get cashNeedChangeButton => 'Precisarei de troco';

  @override
  String get cashAcceptPayment => 'Aceitar pagamento';

  @override
  String cashSummaryWithCount(Object count) {
    return 'Resumo ($count itens)';
  }

  @override
  String get cashNoItems => 'Nenhum item';

  @override
  String get cashUnnamedItem => 'Sem nome';

  @override
  String cashPaymentApproved(Object change) {
    return 'Pagamento aprovado. Troco: $change';
  }

  @override
  String get cashPaymentApprovedStatus => 'Pagamento aprovado';

  @override
  String cashErrorProcessing(Object error) {
    return 'Erro ao processar pagamento: $error';
  }

  @override
  String get free => 'Grátis';

  @override
  String get continueLabel => 'Continuar';

  @override
  String get paymentMethodTitle => 'Método de pagamento';

  @override
  String get selectPaymentMethodPrompt => 'Selecione um método de pagamento:';

  @override
  String get paymentCashTitle => 'Dinheiro';

  @override
  String get paymentCashSubtitle => 'Pague em dinheiro na entrega';

  @override
  String get paymentDebitTitle => 'Cartão de Débito';

  @override
  String get paymentDebitSubtitle => 'Pagamento com débito bancário';

  @override
  String get paymentCreditTitle => 'Cartão de Crédito';

  @override
  String get paymentCreditSubtitle => 'Pague com Visa, MasterCard, Amex';

  @override
  String get deliveryMethodTitle => 'Método de entrega';

  @override
  String get deliveryHome => 'Entrega em domicílio';

  @override
  String deliveryHomeSubtitle(Object fee) {
    return 'Taxa fixa de $fee por pedido';
  }

  @override
  String get pickupInStore => 'Retirar na loja';

  @override
  String get pickupNoCharge => 'Sem custo adicional';

  @override
  String get selectPickupStore => 'Selecione uma loja para retirar';

  @override
  String get noStoresAvailableNow => 'Não há lojas disponíveis no momento';

  @override
  String get noStoresWithAvailability =>
      'Não há lojas com disponibilidade no momento';

  @override
  String summaryWithCount(Object count) {
    return 'Resumo ($count itens)';
  }

  @override
  String get noItemsToPay => 'Nenhum item para pagar.';

  @override
  String get subtotal => 'Subtotal';

  @override
  String get viewDetails => 'Ver detalhes';

  @override
  String get imageUnavailable => 'Imagem não disponível';

  @override
  String get insufficientStock => 'Estoque insuficiente';

  @override
  String get descriptionUnavailable =>
      'Descrição não disponível para este produto.';

  @override
  String get usageInstructionsTitle => 'Instruções de uso';

  @override
  String get detailsTitle => 'Detalhes';

  @override
  String get quantityLabel => 'Quantidade';

  @override
  String availableStock(Object count) {
    return 'Estoque disponível: $count';
  }

  @override
  String get alsoBuyTitle => 'Você também pode comprar';

  @override
  String get noSuggestions => 'Nenhuma sugestão disponível no momento.';

  @override
  String get addToCart => 'Adicionar ao carrinho';

  @override
  String addedToCartItems(Object count, Object name) {
    return 'Adicionado $count x $name ao carrinho';
  }

  @override
  String get productUsageTitle => 'Descrição e uso';

  @override
  String get productDetailsTitle => 'Detalhes do produto';

  @override
  String get defaultProductName => 'Produto';

  @override
  String get registeredAddressFallback => 'Endereço registrado';

  @override
  String get registerTitle => 'Criar conta';

  @override
  String get registerSubtitle =>
      'Cadastre-se para comprar mais rápido e salvar seus dados';

  @override
  String get userTypeLabel => 'Tipo de usuário';

  @override
  String get userTypeClient => 'Cliente';

  @override
  String get userTypeAdmin => 'Admin';

  @override
  String get nameRequired => 'Digite seu nome';

  @override
  String get idRequired => 'Digite o CPF';

  @override
  String get phoneRequired => 'Digite o telefone';

  @override
  String get emailRequired => 'Digite o e-mail';

  @override
  String get addressRequired => 'Digite o endereço';

  @override
  String get userTypeRequired => 'Selecione o tipo de usuário';

  @override
  String get passwordRequired => 'Digite a senha';

  @override
  String get registerButton => 'Cadastrar';

  @override
  String get userAlreadyExists => 'Já existe um usuário com esse e-mail';

  @override
  String get registrationAndLoginSuccess =>
      'Cadastro e login realizados com sucesso';

  @override
  String get creditCardTitle => 'Cartão de crédito';

  @override
  String get creditCardImageFallback => 'Cartão';

  @override
  String get cardNumberLabel => 'Número do cartão';

  @override
  String get cardNumberHint => '1234123412341234';

  @override
  String get cardNumberInvalid => 'Número inválido';

  @override
  String get cardNumberExact16 => 'O número deve ter exatamente 16 dígitos';

  @override
  String get expiryLabel => 'Data de validade (MM/AA)';

  @override
  String get expiryHint => 'MM/AA';

  @override
  String get expiryRequired => 'Data obrigatória';

  @override
  String get expiryInvalidFormat => 'Formato inválido (MM/AA)';

  @override
  String get expirySameAsCurrent =>
      'A data não pode ser igual ao mês/ano atual';

  @override
  String get cvcLabel => 'Código CVC';

  @override
  String get cvcHint => '123';

  @override
  String get cvcInvalid => 'Código inválido';

  @override
  String get cvcExact3 => 'O CVC deve ter exatamente 3 dígitos';

  @override
  String get nameOnCardLabel => 'Nome no cartão';

  @override
  String get nameOnCardHint => 'Como aparece no cartão';

  @override
  String get nameOnCardRequired => 'Nome obrigatório';

  @override
  String get payButton => 'Pagar';

  @override
  String get fixErrorsBeforeContinue => 'Corrija os erros antes de continuar';

  @override
  String get paymentSimulatedApproved => 'Pagamento simulado aprovado';
}
