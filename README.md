# ATIVIDADE-AWS-DOCKER

## REQUISITOS

1. instalação e configuração do
DOCKER ou CONTAINERD no host
EC2;
Ponto adicional para o trabalho utilizar
a instalação via script de Start
Instance (user_data.sh);
2. Efetuar Deploy de uma
aplicação Wordpress com:
container de aplicação
RDS database Mysql;
3. Configuração da utilização do serviço
EFS AWS para estáticos do container
de aplicação Wordpress;
4. configuração do serviço de
Load Balancer AWS para a
aplicação Wordpress.

## PONTOS DE ANTEÇÃO

* Não utilizar ip público para saída
do serviços WP (Evitem publicar o
serviço WP via IP Público);
* Sugestão para o tráfego de internet
sair pelo LB (Load Balancer Classic);
* Pastas públicas e estáticos do
wordpress sugestão de utilizar
o EFS (Elastic File Sistem);
* Fica a critério de cada
integrante (ou dupla) usar
Dockerfile ou Dockercompose;
* Necessário demonstrar a
aplicação wordpress funcionando
(tela de login);
* Aplicação Wordpress precisa
estar rodando na porta 80 ou
8080;
* Utilizar repositório git para
versionamento;
* Criar documentação.

## Criação da VPC

* No console da AWS, em Painel de VPC iremos criar uma nova VPC.
* Com o painel aberto, realizaremos a seguinte configuração:
* VPC e mais
* Recursos a serem criados: VPC e mais
* Nome: docker_project
* Bloco CIDR IPv4: 10.0.0/16
* Número de zonas de disponibilidade (AZs): 2 (us-east-1a / us-east-1b)
* Gateways NAT (USD): em 1 AZ
* Endpoints da VPC: nenhum
* Criar vpc.

## Security Groups

* No painel EC2, faremos a criação dos grupos de segurança;
* No menu lateral esquerdo iremos até a opção “Secutity groups”, em seguida “Criar grupo de segurança”;
* Criaremos os seguintes grupos:

### SG_EC2

| TIPO      | PROTOCOLO  |  PORTAS  |
| :-------: | :--------: | :------: |
| SSH       | TCP        | 22       |
| HTTP      | TCP        | 80       |

### SG_LOAD_BALANCER

| TIPO      | PROTOCOLO  |  PORTAS  |
| :-------: | :--------: | :------: |
| HTTP      | TCP        | 80       |

### SG_ENDPOINT

| TIPO      | PROTOCOLO  |  PORTAS  |
| :-------: | :--------: | :------: |
| SSH       | TCP        | 22       |

### SG_RDS

| TIPO      | PROTOCOLO  |  PORTAS  |
| :-------: | :--------: | :------: |
| MySql     | TCP        | 3306     |

### SG_EFS

| TIPO      | PROTOCOLO  |  PORTAS  |
| :-------: | :--------: | :------: |
| NFS       | TCP        | 2049     |

## Endpoints

* No console da AWS, em Painel de VPC iremos criar um Endpoints;
* Defina um nome para o endpoints;
* Em “Categoria de serviço”, selecione “Endponts do EC2 Instance Connect”;
* Em seguida seleciona a VPC criada anteriormente e logo abaixo o security group criado para o endpoint;
* Por fim, selecione uma sub-rede privada pertencente a VPC criada anteriormente;
* Clique em “criar endpoint”.

## EFS – Elasctic File System

* No painel EFS, faremos a criação criaremos um sistema de arquivos;
* Defina um nome;
* Em VPC selecionaremos a VPC criada anteriormente;
* Em seguida, personalizar;
* Tipo do sistema de arquivos: regional
* Mantenha as demais configurações por padrão e clique em próximo;
* Em seguida clique em próximo novamente;
* Novamente clique em próximo;
* Revise todas as informações e clique em “criar”.

## RDS – MySQL

* No painel Amazon RDS, criaremos um banco de dados relacional;
* Em “Opções de mecanismos” escolheremos a opção “MySQL”;
* Em “Modelos”, utilizaremos o nível gratuito;
* Defina um nome de usuário e uma senha;
* Em “Conectividade”, selecione a VPC criada anteriormente;
* Em seguida selecione o grupo de segurança RDS também criado anteriormente;
* Em “Configurações adicionais”, dê um nome ao bando de dados;
* Mantenha os restantes das configurações por padrão, e clique em “Criar banco de dados”.

## Load Balancer

* No painel EC2, criaremos um Load Balancers;
* Vá até a opção “Load Balancers”, no painel lateral esquerdo;
* Em seguida clique em “Criar load balancer”;
* Usaremos o “Classic Load Balancer”;
* Defina um nome para o load balancer;
* Mantenha-o voltado para a internet;
* Em “Mapeamento de rede”, selecione a VPC criada anteriormente e em seguida selecione as duas sub-redes públicas da VPC;
* Em “Grupo de segurança”, escolha o grupo de segurança criado para o load balancer anteriormente;
* Verifique todas as informações e clique em “Criar load balancer”.

## Chave Pública

* Acesse os serviços de EC2 da AWS;
* No painel lateral esquerdo selecione a opção “Pares de Chaves”;
* Vá até a opção “Criar par de chaves” no canto superior direito;
* Com o painel aberto escolha um nome para o par de chaves;
* Em seguida escolha o tipo de par de chaves e o formato que desejar;
* Ao final, clique em “Criar par de chaves”;
* Salve o arquivo que será gerado em um local seguro;
* Pronto, o par de chaves está criado e será listada em “Pares de Chaves”.

## Modelo de Execução Instância EC2 

* No painel EC2, criaremos um modelo de execução de instância; 
* Defina um nome ao modelo e uma descrição;
* A AMI usada será “Amazon Linux AMI 2023”;
* Tipo de instância: t3.small
* Em seguida selecione a key par criada anteriormente;
* Selecione o grupo de segurança criando anteriormente para a instância EC2;
* Insira as tags necessárias; 
* Em “detalhes avançados”, no campo “user data” faremos a inserção do shell script abaixo;
* Verifique todas as informações e em seguida cliquem em “criar modelo de execução”

## Auto Scaling Groups

* No painel EC2, clique na opção “Grupos de Auto Scaling”;
* Em seguida em “Criar grupo do Auto Scaling”;
* Daremos o nome de “asg_project”
* Em seguida selecionaremos o modelo de execução criado anteriormente;
* Selecionaremos a VPC criada para o projeto e as duas sub-redes privadas;
* Em “balanceador de carga” iremos escolher a opção “Anexar a um balanceador de carga existente”;
* Logo em seguida “Escolher entre Classic Load Balancers” e selecionaremos o load balancer criando anteriormente;
* Habilitaremos também a opção “verificações de integridade do Elastic Load Balancing”;
* Em “tamanho do grupo” e em “escalabilidade”, colocaremos 2;
* Em “Política de manutenção de instâncias”, selecionaremos a opção “priorizar disponibilidade”;
* Revise todas as informações e clique em “criar grupo de auto scaling”
