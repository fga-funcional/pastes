# Relatório

**Alunos:** João Robson Santos Martins - 15/0154003 /  Arthur Temporim - 14/0016759 

## Desenvolvimento técnico

### Mecanismo de persistência
Foi utilizado escrita em arquivo, mas isso apenas para o objeto já instanciado no código do backend, ou seja, não conseguimos ler do arquivo para apresentar no frontend a partir da requisição GET nem escrever novos objetos a partir do POST.

## Recursos avançados das linguagens
Foram utilizadas mônadas no trecho do código que utiliza "do-notation" para lidar com o IO.

### Rotas, tasks e subscribers
Não foram utilizados rotas, tasks e subscribers no projeto final. Anteriormente, foi utilizado um listener para eventos do teclado a fim de registrar quando o usuário pressionava "Enter", ou seja, inseria uma quebra de linha, no código inserido no campo de texto. Porém, esse problema foi resolvido posteriormente com a property "white-space" do CSS.

### Union Types
Foram utilizados Union Types para gerenciar as mensagens do Update e também para realizar as validações dos campos dos formulário utilizado para cadastrar um código, onde cada Union Type representava os possíveis valores para cada campo.

### Instanciação de classe em Haskell
Foi definido o tipo CCode, que sofre herança de Show e Generic. CCode também é utilizado na instância das classes ToJSON e FromJSON.

## Qualidade do Produto

## Implementa recursos básicos esperados além da aparência?
Sim. No frontend, o usuário consegue cadastrar um código novo, um nome para esse código e selecionar a linguagem desse código, permitindo o *syntax highlight* adequado. Após o cadastro, ele consegue visualizar a lista de códigos cadastrados.

## Interações de forma eficiente
Além de poder realizar a navegação pelo teclado, o usuário consegue cadastrar um código com apenas três passos.


## Conseguiu polir a aplicação?
Sim, foi utilizado a biblioteca Bulma do elm, que permite adicionar componentes de UI já integrados com CSS no projeto. Além disso, validadores para não permitir os campos de texto do código e do seu nome vazios disparam mensagens de aviso com cores fortes, para facilitar o entendimento do usuário.

## Pronto para produção?
A integração com o docker ficou quase pronta. Por problemas de compatibilidade de versão entre a imagem disponível e os SO que utilizamos, não conseguimos completar a integração, mas caso conseguíssemos, poderíamos utilizar persistência no banco. O que faltaria seria apenas utilizar autenticação nas rotas e a criação de rotas individuais e níveis de permissão para cada código adicionado.

## Integração front + back 
### Front usa backend como mecanismo de persistência?
Não. 

### Conseguiu conectar os dois sistemas adequadamente?
Sim, as rotas são gerencias pelo backend. Assim, o frontend o acessa por meio de requisições HTTP. Para contornar o problema do CORS, utilizamos o devd, um "servidor local para desenvolvedores", juntamente com o middleware simpleCors do Haskell.

### Consegue rodar mais de uma instâcia (discriminada por URL, por exemplo)
Não, pois não conseguimos dockerizar a aplicação.

## Método
### Possui sistema de build?
Sim, foi utilizado o comando elm make, que compila o código elm para Javascript para ser importado no arquivo index.html juntamente com o arquivo CSS. Tentamos utilizar o docker, mas por problemas com a versão dos nossos sistemas operacionais, não obtivemos êxito.

### Testes unitários e boas práticas?
Não foram implementados testes. Já as boas práticas foram adotadas, como a separação do código elm em módulos separados para a View, Model e Msg, a adoção de nomes explicativos e atomicidade para funções.

### Implantou em algum lugar?
Não.

