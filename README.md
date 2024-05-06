# ATIVIDADE-AWS-DOCKER

## Requisitos

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

## Pontos de Atenção

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
