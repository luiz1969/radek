//Criação da TRIGGER
CREATE TRIGGER `aciona_om_record` AFTER INSERT ON `tcall` FOR EACH ROW call atualizar_om_record ()



//Criação da Function
CREATE DEFINER=`teste`@`%` PROCEDURE `atualizar_om_record` ()  NO SQL

BEGIN

DECLARE _continue INT DEFAULT 0;
DECLARE _codNatureza INT DEFAULT 0;
DECLARE _codTipo INT DEFAULT 0;
DECLARE _codSubTipo INT DEFAULT 0;
            
DECLARE curNatureza CURSOR FOR     		
   SELECT tipo, subtipo,IFNULL((
		SELECT natureza
   		FROM   om_record_natureza n inner join tcall t on n.tipo = t.tipo and n.subtipo = t.subtipo
   		WHERE  t.data_criacao = now()),0 ) as natureza
	FROM   tcall tt 
	WHERE  tt.data_criacao = now();
   
DECLARE CONTINUE HANDLER 
   FOR NOT FOUND SET _continue = 1;
   
OPEN curNatureza;      
myloop: LOOP 
   
   FETCH curNatureza INTO _codTipo, _codSubTipo, _codNatureza;

     IF _continue = 1 THEN
        LEAVE myloop;     
     END IF;   
     
     INSERT INTO om_record (tipo, subtipo,natureza ) 
     VALUES (_codTipo,_codSubTipo,_codNatureza);       

END LOOP myloop;  

CLOSE curNatureza; 

END