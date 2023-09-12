create table veterinario (
    crm int,
    nome character varying(30),
    convenio character varying(30),
    primary key(crm)
)

create table animal (
    id serial, 
    nome character varying(30),
    raca character varying(30),
    sexo character varying(9),
    dataNasc date,
    idInseminacao references inseminacao(idInseminacao),
    primary key(id)
)

create table consulta (
    id serial,
    crmVet int references veterinario(crm),
    idAnimal serial references animal(id),
    data date,
    resultado character varying(30),
    primary key(id)
)

create table sequencia (
    idSequencia references consulta(id),
    idConsultaAnterior references consulta(id),
    primary key(idSequencia)
)

create table tratamento (
    idTratamento serial,
    dataTratamento date,
    descricao character varying(200),
    idConsulta references consulta(id),
    primary key(idTratamento)
)

create table semen (
    tipo character varying(30),
    caracteristica character varying(30),
    primary key(tipo)
)

create table matriz (
    idAnimal int references animal(id),
    id serial,
    primary key(id, idAnimal),
    
)

create table inseminacao (
    idInseminacao serial,
    tipoSemen character varying(30) references semen(tipo),
    idMatriz int references matriz(id),
    primary key(idInseminacao)
)

create table reprodutor (
    idAnimal int references animal(id)
    idReprodutor serial,
    primary key(idAnimal, idReprodutor)
)