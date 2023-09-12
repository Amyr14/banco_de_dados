
-- 1) Gatilho para impedir a inserção ou atualização de Clientes com o mesmo CPF --
CREATE FUNCTION testa_cpf() RETURNS trigger AS
$$
BEGIN
    IF TG_OP = 'UPDATE' AND NEW.cpf = OLD.cpf THEN
        RAISE EXCEPTION 'O cpf não pode ser o mesmo';

    ELSIF TG_OP = 'INSERT' AND NEW.cpf IN (SELECT cpf FROM cliente) THEN
        RAISE EXCEPTION 'Já existe um client com esse cpf';
    
    END IF;
    
    RETURN NEW;
END;
$$ 
LANGUAGE plpgsql;

CREATE TRIGGER testa_cpf_gatilho
BEFORE INSERT OR UPDATE
ON cliente
FOR EACH ROW
EXECUTE PROCEDURE testa_cpf();

-- 2) Gatilho para impedir a inserção ou atualização de Mecânicos com idade menor que 20 anos --
CREATE FUNCTION testa_idade_mecanico() RETURNS trigger AS
$$
BEGIN
    IF NEW.idade < 20 THEN
        RAISE EXCEPTION 'Mecânicos não podem ter menos de vinte anos';
    END IF;

    RETURN NEW;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER testa_idade_mecanico_gatilho
BEFORE INSERT OR UPDATE
ON mecanico
FOR EACH ROW
EXECUTE PROCEDURE testa_idade_mecanico();

-- 3) Gatilho para atribuir um cods (sequencial) para um novo setor inserido. --
CREATE SEQUENCE sequencia_cods
START 4;

CREATE FUNCTION novo_cods() RETURNS trigger AS
$$
BEGIN
    NEW.cods := NEXTVAL('sequencia_cods');
    RETURN NEW;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER atribui_cods
BEFORE INSERT
ON setor
FOR EACH ROW
EXECUTE PROCEDURE novo_cods()

-- 4) Gatilho para impedir a inserção de um mecânico ou cliente com CPF inválido --
CREATE FUNCTION testa_por_cpf_invalido() RETURNS trigger AS
$$
BEGIN
   SELECT CAST(NEW.cpf AS BIGINT);
EXCEPTION
    WHEN others THEN
        RAISE EXCEPTION 'O cpf é inválido';
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER testa_por_cpf_invalido_gatilho_cliente
BEFORE INSERT
ON cliente
FOR EACH ROW
EXECUTE PROCEDURE testa_por_cpf_invalido();

CREATE TRIGGER testa_por_cpf_invalido_gatilho_mecanico
BEFORE INSERT
ON mecanico
FOR EACH ROW
EXECUTE PROCEDURE testa_por_cpf_invalido();

-- 5) Gatilho para impedir que um mecânico seja removido caso não exista outro mecânico com a mesma função --
CREATE FUNCTION impede_remocao_mecanico() RETURNS trigger AS
$$
BEGIN
    IF OLD.funcao NOT IN (SELECT funcao FROM mecanico WHERE codm != OLD.codm) THEN
        RAISE EXCEPTION 'O mecânico não pode ser removido';
    
    END IF;
    RETURN NULL;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER impede_remocao_mecanico_gatilho
BEFORE DELETE
ON mecanico
FOR EACH ROW
EXECUTE PROCEDURE impede_remocao_mecanico();

-- 6) Gatilho que ao inserir, atualizar ou remover um mecânico, reflita as mesmas modificações na tabela de Cliente. Em caso de atualização, se o mecânico ainda não existir na tabela de Cliente, deve ser inserido --
CREATE SEQUENCE sequencia_codc
START 20;

CREATE FUNCTION reflexao_mecanico_cliente() RETURNS trigger AS
$$
BEGIN
    IF TG_OP = 'INSERT' OR (TG_OP = 'UPDATE' AND NEW.cpf NOT IN (SELECT cpf FROM cliente)) THEN
        INSERT INTO cliente VALUES (NEXTVAL(sequencia_codc), NEW.cpf, NEW.nome, NEW.idade, NEW.endereco, NEW.cidade);

    ELSIF TG_OP = 'UPDATE' THEN
        UPDATE cliente
        SET nome = NEW.nome,
            idade = NEW.idade,
            endereco = NEW.endereco,
            cidade = NEW.cidade
        WHERE cpf = NEW.cpf;

    ELSIF TG_OP = 'DELETE' THEN
        DELETE 
        FROM cliente
        WHERE cpf = NEW.cpf;
    
    END IF;

    RETURN NULL;
END;
$$
LANGUAGE plpgsql;

-- 7) Gatilho para impedir que um conserto seja inserido na tabela Conserto se o mecânico já realizou mais de 20 horas extras no mês --


-- 8) Gatilho para impedir que mais de 1 conserto seja agendado no mesmo setor na mesma hora --
CREATE FUNCTION choque_de_horario() RETURNS trigger AS
$$
BEGIN
    IF (NEW.codm, NEW.data, NEW.hora) IN (SELECT codm, data, hora FROM conserto) THEN
        RAISE EXCEPTION 'Choque de horário. Escolha outro mecânico ou outro horário';
    
	END IF;
	
    RETURN NEW;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER choque_de_horario_gatilho
BEFORE INSERT
ON conserto
EXECUTE PROCEDURE choque_de_horario();