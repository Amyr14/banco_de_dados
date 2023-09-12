create table pessoa (
	ssn int primary key,
	Pnome character varying(30),
	Minicial character varying(30),
	Unome character varying(30),
	Dnasc date,
	sexo character varying(9),
	num int,
	rua character varying(30),
	numapto int,
	cidade character varying(30),
	estado character varying(30),
	CEP varchar(8)
)

create table docente (
	ssn int primary key references pessoa(ssn),
	escritorio int,
	categoria character varying(30),
	salario int,
	FFone int,
	idInstrutorPesquisador int references instrutor_pesquisador(id)
)

create table aluno (
	ssn int primary key references pessoa(ssn),
	turma int,
	idInstrutorPesquisador int references instrutor_pesquisador(id),
	habita character varying(30) references departamento(DNome),
	opta character varying(30) references departamento(DNome)
)

create table formacao (
	id int primary key,
	faculdade character varying(30),
	grau int,
	ano date
)

create table aluno_grad (
	ssn int primary key references aluno(ssn),
	idFormacao int references formacao(id),
	ssnOrientador int references docente(ssn)
)

create table banca (
	ssnDocente int references docente(ssn),
	ssnAlunoGrad int references aluno_grad(ssn),
	primary key(ssnDocente, ssnAlunoGrad)
)

create table departamento ( 
	DNome character varying(30) primary key,
	Dfone int,
	escritorio int,
	ssnChefe int references docente(ssn),
	Fnome character varying(30) references faculdade(Fnome)
)

create table pertence (
	ssnDocente int references docente(ssn),
	Dnome character varying(30) references departamento(DNome),
	primary key(ssnDocente, Dnome)
)

create table bolsa (
	num int primary key,
	titulo character varying(30),
	agencia int,
	dataIn date,
	ssnDocente int references docente(ssn)
)

create table instrutor_pesquisador (
	id int primary key 
)

create table subsidio (
	numBolsa int references bolsa(num),
	idInstrutorPesquisador int references instrutor_pesquisador(id),
	primary key(numBolsa, idInstrutorPesquisador) 
)

create table disciplina (
	codDisc varchar(5) primary key,
	ano date,
	trim int,
	idInstrutorPesquisador int references instrutor_pesquisador(id),
	codCurso character varying(5) references curso(codCurso)
)

create table registrado (
	ssnAluno int references aluno(ssn),
	codDisc varchar(5) references disciplina(codDisc),
	primary key(ssnAluno, codDisc)
)

create table historico (
	ssnAluno int references aluno(ssn),
	codDisc varchar(5) references disciplina(codDisc),
	nota int,
	primary key(ssnAluno, codDisc)
)

create table subsidio (
	numBolsa int references bolsa(num),
	idInstrutorPesquisador int references instrutor_pesquisador(id),
	inicio date,
	fim date,
	prazo int,
	primary key(numBolsa, idInstrutorPesquisador)
)

create table faculdade (
	Fnome character varying(30) primary key,
	escritorio int,
	reitor character varying(30)
)

create table curso (
	codCurso character varying(5) primary key,
	Unome character varying(30),
	Cdesc character varying(100),
	Dnome character varying(30) references departamento(Dnome)
)

