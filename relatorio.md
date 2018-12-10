# Relatório

**Alunos:** João Robson Santos Martins - 15/0154003 /  Arthur Temporim - 

## Desenvolvimento técnico

### Mecanismo de persistência
Foi utilizado escrita em arquivo, mas isso apenas para o objeto já instanciado no código do backend, ou seja, não conseguimos ler do arquivo para apresentar no frontend a partir da requisição GET nem escrever novos objetos a partir do POST.

### Recursos avançados das linguagens
Foram utilizadas mônadas no trecho do código que utilizado "do-notation" para lidar com o IO.

### Rotas, tasks e subscribers
Não foram utilizados rotas, tasks e subscribers no projeto final. Anteriormente, foi utilizado um listener para eventos do teclado a fim de registrar quando o usuário pressionava "Enter", ou seja, inseria uma quebra de linha, no código do campo de texto. Porém esse problema foi resolvido posteriormente com a property "white-space" do CSS.

### Union Types
Foram utilizados Union Types para gerenciar as mensagens do Update e também para realizar as validações dos campos dos formulário utilizado para cadastrar um código, onde cada Union Type representava os possíveis valores para cada campo.

### Instanciação de classe em Haskell
Foi definido o tipo CCode, que sofre herança de Show e Generic. CCode também é utilizado na instância das classes ToJSON e FromJSON.

## Qualidade do Produto

## Implementa recursos básicos esperados além da aparência?
Sim. No front-end o usuário consegue visualizar a lista de imagens, visualizar a imagem em tela cheia, zoom in, zoom out, arrastar, visualizar em tamanho real ou ajustada e navegar entre as imagens em tela cheia. No back-end a API funciona da forma esperada para as ações básicas (listar, criar, atualizar, obter e apagar imagens).

## Interações de forma eficiente
O usuário pode navegar na aplicação através ícones específicos de fácil visualização e também através de vários atalhos de teclado. Na verdade, o usuário consegue realizar todas as ações da aplicação que conseguiri com o mouse através do teclado (menos arrastar a imagem).

## Conseguiu polir a aplicação?
Sim, foi tomado o cuidado de adicionar transições on hover, evitar cores que se misturassem com a imagem muito frequentemente, adicionar divs com cores diferentes atrás dos ícones, não permitir arrastar a imagem quando ela estiver em tamanho real ou menor, o zoom in e out possuem limites, não permitir troca de imagem quando não em tela cheia, dentre outros detalhes.

## Pronto para produção?
Quase. O back-end está integrado com o docker mas eu não o colocaria em produção sem autenticação nas rotas e sem definir melhor algumas questões de timeout em requisições e outros mecanismos de proteção. Já o front-end não está integrado com nenhum servidor, mas com relação ao código fonte, ele já poderia ser utilizado normalmente, alterando apenas a rota da qual ela obteria as imagens.

## Integração front + back 
### Front usa backend como mecanismo de persistência?
Não. 

### Conseguiu conectar os dois sistemas adequadamente?
Sim, as rotas são gerencias pelo backend. Assim, o frontend o acessa por meio de requisições HTTP. Para contornar o problema do CORS, utilizamos o devd, um "servidor local para desenvolvedores", juntamente com o simpleCors

### Consegue rodar mais de uma instâcia (discriminada por URL, por exemplo)
Sim, uma vez que o backend está dockerizado, para adicionar instâncias, necessário apenas subir outra instância com host ou porta diferente. Já o front-end não está integrado a um servidor, mas no código fonte também não há nenhum impedimento nesse sentido.

## Método
### Possui sistema de build?
Sim, foi utilizado o comando elm make, que compila o código elm para Javascript para ser importado no arquivo index.html juntamente com o arquivo CSS. Tentamos utilizar o docker, mas por problemas com a versão dos nossos sistemas operacionais, não obtivemos êxito.

### Testes unitários e boas práticas?
Não foram implementados testes. Já as boas práticas foram adotadas, como a separação do código elm em módulos separados para a View, Model e Msg, a adoção de nomes explicativos e atomicidade para funções.

### Implantou em algum lugar?
Não.

