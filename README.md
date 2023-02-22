# Linguagem
O projeto foi desenvolvido na liguagem dart utilizando o framework Flutter para gerar IOS e android. Porém esse projeto está apenas configurado para uso nos disposítivos android.

# Estrutura do framework
- lib
    - Arquivos padrão do flutter
- android
    - Arquivos de configuração nativa do android
- ios
    - Arquivos de configuração nativa do IOS
- web
    - Arquivos de configuração para utilizar aplicação na WEB
- linux
    - Arquivos de configuração nativa do Linux
- windows
    - Arquivos de configuração nativa do Windows
- test
    - Arquivos de configurações e utilização de testes unitários, testes de widgets ou testes de integração.
        - Widget: Classe visual padrão do Flutter, todo visual do Flutter é um Widget.

# Estrutura do projeto
Toda a estrutura do projeto se encontra na pasta lib, a arquitetura do projeto escolhida foi a MVC (Model, View and Controller). Pois isso as pastas seguem a seguinte logíca.

- views
    - Páginas da aplicação e widgets como cartões e campos de entrada.
- utils
    - Constante da aplicação para consumo de APIs para e-mail e SMS, funções de validação, formação de campos de entrada e as rotas da aplicação.
- controllers
    - Regras de negócio da aplicação e consumo direto com o Firestore (que séria a API em um projeto com RestAPI).
- models
    - Estrutura dos dados para facilitar comunicação entre todas as partes da aplicação.

# Rodando o projeto

Siga o link para instalar o flutter https://docs.flutter.dev/get-started/install

Depois faça o clone do projeto:
`git clone https://git.vibbra.com.br/matheus-1667867709/vibbra_mobile_nf`

Instale os pacotes do projeto: `flutter pub get`

Configure a API da clickSend no arquivo utils/constants.dart
- clickSendUrl = "https://rest.clicksend.com";
- clickSendKey = ""; // API_KEY da clickSend
- clickSendUsername = ""; //USERNAME da conta na clickSend
- clickSendEmailId = 0; // ID do e-mail para enviar como remetente 

Por último rode a aplicação com: `flutter run`

Para disposítivos específicicos roda com: `flutter run -d DISPOTIVO_IDENTIFICADOR`

Para listar disposítivos disponíveis: `flutter devices`



# Detalhamento do código
Autenticação usa o Firebase Authentication, e como banco de dados o Firebase Firestore.
Para envio de SMS e e-mail utiliza a API da ClickSend

TERMOS: CRUD (CREATE, READ, UPDATE, DELETE) - Todo o fluxo de criação, listagem, atualização e exclusão dos dados.

## Pacotes principais
- provider - Gerenciamento de estado global, funciona como um controller.
- google_sign_in - Para utilizar o login com g-mail
- flutter_facebook_auth - Para utilizar o login com facebook
- speed_dial_fab - Menu de rápido acesso da home
- syncfusion_flutter_charts - Gráficos da aplicação
- http - Conexão HTTPs com API da clickSend
- intl - Para formatação de datas
- cloud_firestore - Para conexão com o Firebase Firestore
- ionicons - Alguns icones extras
- firebase_auth - Para Autenticação com o firebase
- firebase_core - Configuração principal do firebase
## main.dart
Configuração inicial da aplicação, instancia os providers (controllers), o tema padrão, firebase e rotas.
## firebase_options.dart
Arquivo gerado pelo firebase para facilitar a integração das aplicações em Flutter com o Firebase

## auth
- View (signin_page.dart, signup_page.dart)
    - Realiza o login ou cadastro de um usuário. Pode utilizar e-mail e senha, gmail ou facebook.
- Controller (auth_controller.dart)
    - Validação das regras para o LOGIN, comunicação com o Firebase Authentication.
- Models
    - Error: Modelo de erro padrão para os campos de entrada.

## home
- View (home_page.dart)
    - Notificação: Faz a validação para saber se envia ou não o SMS ou E-MAIL
    - FAB de ação: para listar os lançamentos e realizar novos lançamentos.
        - Lançamento pode ser despesa ou nota fiscal
    - Gráficos:
        - Listagem dos gráficos de notas fiscais, limite faturamento, despesas e balanço geral
    - AppBar actions 
        - Refresh (Atualizar): Atualiza os dados dos gráficos
        - Restore (Histórico): Histórico de lançamentos
        - Settings (Configurações): Configurações da aplicação, cadastro de empresa parceiras e categorias de despesa
        - Logout (Sair da aplicação): Faz o logout do firebase
    - Stream:
        - Fica ouvindo se o usuário ativo muda para redirecionar o mesmo pro login caso não seja ativo.
- Controller (home_controller.dart, notification_controller.dart)
    - home_controller.dart: Busca no firebase as configurações(SETTINGS), Notas fiscais (INVOICES) e despesas (EXPENSES). Todas essas informações são utilizadas nos gráficos da home.
    - notification_controller.dart: Faz a verifcação de deve ou não enviar os alertas, e a comunicação com API da ClickSend
- Models
    - _BalenceGeneral: Criado especificamente para listar o gráfico de balanço geral.
    - Invoice: Modelo da nota fiscal
    - Expense: Modelo da despesa 
    - SettingsVibbra: Modelo das configurações da aplicação
    - Error

## Configurações
- View (settings_page.dart, preferences_page.dart, expenses_categories, partners)
    - Permite a configuração da aplicação
    - Preferências (Preferences):
        - Permite cadastrar o limite de faturamento do MEI
        - Permite configurar alerta para SMS e E-mail
        - Permite víncular um número para o alerta de SMS
    - Empresas parceiras (Partners)
        - CRUD das empresas parceiras
    - Categorias de despesas (Expenses Categories)
        - CRUD das despesas da categoria
- Controller (settings_controller.dart, partner_controller.dart, expense_category_controller.dart)
    - Faz toda validação de regras de negócio e comunicação com o Firestore
- Models
    - Partner: Modelo da empresa parceira
    - ExpenseCategory: Modelo da categoria de despesa 
    - SettingsVibbra: Modelo das configurações da aplicação
    - Error


## Histórico
- View (histories)
    - Faz a listagem do histórico de despesas e notas fiscais emitidas
- Controller (histories_controller.dart)
    - Faz a formatação das informações para virar um HistoryModel para ser possível listar na mesma lista tanto despesas como notas fiscais. E se comunicar com o Firestore para buscar as notas fiscais e despesas
- Models
    - History: Modelo de dado do registro do lançamento, contém o tipo de lançamento e o valor dele.
    - Invoice
    - Expense
    - Error

## Despesas
- View (expenses)
    - CRUD das despesas, precisa escolher uma categoria de despesa para cadastrar (que não esteja arquivada) e pode ou não víncular com uma empresa parceira.
- Controller (expense_controller.dart)
    - Validação das regras do CRUD, e comunicação com Firestore.
- Models
    - Expense: Contém os valores para a despesa, o valor da categoria de despesa, a referência da categoria de despesa no Firestore, pode ter ou não o valor de uma empresa parceira e a referência da mesma no Firestore.
    - Error
## Notas fiscais
- View (invoices)
    - CRUD das notas fiscais, precisa escolher uma empresa parceira.
- Controller (invoice_controller.dart)
    - Validação das regras do CRUD, e comunicação com Firestore.
- Models
    - Invoice: Contém todas informações para nota fiscal, contém o valor de uma empresa parceira e a referência da mesma no Firestore.
    - Error



