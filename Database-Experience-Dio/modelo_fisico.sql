-- criação do banco de dados para o cenario de e-commerce

create database ecommerce;
use ecommerce;

create table clients(
	idClient int auto_increment primary key,
    Fname varchar(10) not null,
    Minit char(3),
    Lname varchar(20),
    CPF_OU_CNPJ char(11) not null,
	address varchar(30),
    estado VARCHAR(15) NOT NULL,
    social ENUM('PJ','PF') default 'PF',
    constraint unique_cpf_client unique (CPF)
);



select * from clients;

alter table clients add column social ENUM('PJ','PF') default 'PF';
alter table clients add column estado VARCHAR(15) NOT NULL;

UPDATE clients set estado = 
case 
	when idClient = 1 then 'SP'
	when idClient = 2 then 'RJ'
    when idClient = 3 then 'SC'
    when idClient = 4 then 'SP'
    when idClient = 5 then 'SP'
    when idClient = 6 then 'MG'
end;

select * from clients;

INSERT INTO clients (estado) values
('SP'),('RJ'),('SC'),('SP'),('SP'),('MG');

create table product(
	idProduct int auto_increment primary key,
    Pname varchar(50) not null,
    classification_kids bool default false,
    category enum('Eletrônico','Vestimenta','Brinquedos','Alimentos','Móveis') not null,
	avaliation float default 0,
    size varchar(10)
);

create table track(
	codRastreio int auto_increment primary key,
    idProduct int,
    constraint fk_rastreio_client foreign key (codRastreio) references product(idProduct)
);

create table payments(
	idClient int,
    idPayment int,
    typepayment enum('Boleto','Cartão','Dois Cartões'),
    limitAvailable float,
    primary key (idClient, idPayment)
);

create table orders(
	idOrder int auto_increment primary key,
    idOrderClient int,
    orderStats ENUM('Cancelado', 'Confirmado','Em processamento') default 'Em processamento',
    orderDescription VARCHAR(255),
    sendValue float default 10,
    paymentCash boolean default false,
    constraint fk_orders_client foreign key (idOrderClient) references clients (idClient)
);

create table productStorage(
	idProductStorage int auto_increment primary key,
    storageLocation varchar(255),
    quantity int default 0
);

create table supplier(
	idSupplier int auto_increment primary key,
    socialName varchar(255) not null,
    cnpj char(15) not null,
    contact VARCHAR(11) not null,
    constraint unique_suplier unique (cnpj)
);

create table seller(
	idSeller int auto_increment primary key,
    socialName VARCHAR(255) not null,
    abstractName VARCHAR(255),
    location varchar(150),
    cnpj char(15),
    cpf char(9),
    contact char(11) not null,
    constraint unique_cpf_seller unique (cpf),
    constraint unique_cnpj_seller unique (cpf)
);

create table productSeller(
	idPseller int,
    idPproduct int,
    prodQuantity int default 1,
    primary key (idPseller, idPproduct),
    constraint fk_product_seller foreign key (idPseller) references seller(idSeller),
    constraint fk_product_product foreign key (idPproduct) references product(idProduct)
);

create table productOrder(
	idPOproduct int,
    idPOorder int,
    poQuality int default 1,
    poStatus enum('Disponível','Sem estoque') default 'Disponível',
    primary key(idPOproduct,idPOorder),
    constraint	fk_productorder_seller foreign key (idPOproduct) references product (idProduct),
    constraint	fk_productorder_product foreign key (idPOorder) references orders (idOrder)
);

create table storageLocation(
	idLproduct int,
    idLstorage int,
    location varchar(255) not null,
    primary key(idLproduct,idLstorage),
    constraint fk_storage_location_product foreign key (idLproduct) references product(idProduct),
    constraint fk_storage_location_storage foreign key (idLstorage) references productStorage(idProductStorage)
);

create table productSupplier(
	idPsSupplier int,
    idPsProduct int,
    quantity int not null,
    primary key (idPsSupplier,idPsProduct),
    constraint fk_product_suplier_suplier foreign key (idPsSupplier) references supplier (idSupplier),
	constraint fk_product_suplier_product foreign key (idPsProduct) references product (idProduct)
);

-- PERSISTINDO OS DADOS NAS ENTIDADES

insert into clients  (Fname,Minit,Lname,CPF,address) values
('Maria', 'M', 'Silva', 12346789, 'rua silva de prata 29 - Carangola,Cidade das flores'),
('Matheus', 'O','Pimentel', 987654321, 'rua alemeda 289 - Centro Cidade das flores'),
('Ricardo','F','Silva"', 45678913, 'avenida alemeda vinha 1009 - Centro Cidade das flores'),
('Julia', 'S','França', 789123456, 'rua 1areijras 861 - Centro Cidade das flores '),
('Roberta', 'G', 'Assis', 98745631, 'avenidade koller 19 - Centro Cidade das flores '),
("Isabela", 'M','Cruz', 654789123, 'rua aleneda das flores 28 - Centro Cidade das flores');

insert into product (Pname, classification_kids, category, avaliation, size) values
('Fone de ouvido',false, 'Eletronicoo', '4', null),
('Barbie Elsa', true, 'Brinquedos','3',null),
('Body Carters', true, 'Vestimenta', '5', null),
('Microfone Vedo Youtuber', False, 'Eletrônico', '4',null),
('Sofs retrátil', False, 'Movels' , '3','3x57x80' );

insert into orders (idOrderClient, orderStats, orderDescription, sendValue,paymentCash) values
(1, default,'compra via aplicativo', null,1),
(2,default, 'compra via aplicativo', 50,0),
(3,'Confirmado' , null, null, 1),
(4, default, 'compra via web site', 150,0);

insert into productOrder (idPOproduct, idPOorder, poQuality, poStatus) values
(1,1,2, null),
(2,2,1, null),
(3,3,1, null) ;

insert into productStorage (storageLocation, quantity) values
('Rio de Janeiro',1000),
('Rio de Janeiro', 500),
('São Paulo', 10),
('são Paulo', 100);

insert into storageLocation (idLproduct, idLstorage, location) values
(1,2,'RJ'),
(2,4,'GO');

INSERT INTO SUPPLIER (SocialName, CNPJ, contact) values
('Almeida e filhos', 123456789123456, '21985474'),
('Eletronicos Silva',854519649143457, '21985484'),
('Eletronicos Valma', 934567893934695, '21975474');

insert into seller(SocialName, AbstractName, CNPJ, CPF, location, contact) values
('Tech eletronics ', null, 123456789456321, null, 'Rio de Janeiro', 219946287),
('Botique Durgas', null, null, 123456783, 'Rio de Janeiro', 219567895),
('Kids World', null, 456789123654485, null, 'São Paulo', 1198657484);

insert into productSeller (idPseller,idPproduct, prodQuantity) values 
(1,3,80),
(2,1,10);


-- Quais são os status dos pedidos feitos até o momento?
select orderStats, count(Fname) from orders
join clients
on idOrderClient = idClient
group by orderStats;

-- Quais foram os produtos comprados e a avaliação de cada um deles?
select Pname, category, avaliation from product
join clients
on idProduct = idClient
order by avaliation desc;

-- Qual a região está alocado nossos produtos?
select storageLocation as Local_do_galpao, quantity as Quantidade_de_produtos from productstorage
join storagelocation
on idProductStorage = idLstorage;

-- de onde são os clientes e o que eles compraram
select concat(Fname,' ',Lname), Pname, estado  from clients
join product
on idClient = idProduct;

--  qual o estado que mais teve vendas
select count(estado) as Qtd_clientes, estado
from clients
group by estado
order by estado desc;

-- quem são nossos clientes que compraram eletronicos do estado que mais teve vendas
select concat(Fname,'',Lname), Pname, estado,CATEGORY from clients
join product
on idClient = idProduct
where estado = 'SP'
having category = 'Eletrônico';