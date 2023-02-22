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




