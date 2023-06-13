use ClubHipica;
-- Consulta 1: Obtener la lista de jinetes junto con sus caballos y la cantidad de competiciones en las que han participado.
SELECT j.nombre, c.nombre, COUNT(r.nombre_comp) AS cantidad_competiciones
FROM Jinetes j
INNER JOIN Resultados r ON j.id_jinete = r.id_jinete
INNER JOIN Caballos c ON r.id_caballo = c.id_caballo
GROUP BY j.nombre, c.nombre;
-- Consulta 2: Obtener la lista de jinetes que tienen un tiempo menos a 10min, junto con el nombre de su caballo.
SELECT j.nombre, c.nombre
FROM Jinetes j
INNER JOIN Resultados r ON j.id_jinete = r.id_jinete
INNER JOIN Caballos c ON r.id_caballo = c.id_caballo
INNER JOIN Competiciones cp ON r.nombre_comp  = cp.nombre 
WHERE r.tiempo <= '00:10:00'
GROUP BY j.nombre, c.nombre;
-- Consulta 3: Obtener la lista de instructores y la cantidad de clases en las que participan, ordenada de mayor a menor cantidad de clases.
SELECT i.nombre, COUNT(cl.id_clase) AS cantidad_clases
FROM Instructores i
LEFT JOIN Clases cl ON i.id_instructor = cl.id_instructor
GROUP BY i.nombre
ORDER BY cantidad_clases DESC;
-- Consulta 4: Obtener la lista de caballos junto con la cantidad de jinetes diferentes que los han montado.
SELECT c.nombre, COUNT(DISTINCT r.id_jinete) AS cantidad_jinetes_diferentes
FROM Caballos c
INNER JOIN Resultados r ON c.id_caballo = r.id_caballo
GROUP BY c.nombre;
-- Consulta 5: Obtener la lista de jinetes y la cantidad de competiciones en las que han participado en la ciudad de "Matamata".
SELECT j.nombre, COUNT(r.nombre_comp) AS cantidad_competiciones
FROM Jinetes j
INNER JOIN Resultados r ON j.id_jinete = r.id_jinete
INNER JOIN Competiciones cp ON r.nombre_comp  = cp.nombre 
WHERE j.ciudad = 'Matamata' 
GROUP BY j.nombre;



-- Vista 1: Vista de jinetes con la cantidad de competiciones en las que han participado y el nombre de su caballo asociado.
CREATE VIEW VistaJinetesCompetencias AS
SELECT j.nombre AS jinete_nombre, c.nombre AS caballo_nombre, COUNT(r.nombre_comp) AS cantidad_competiciones
FROM Jinetes j
INNER JOIN Resultados r ON j.id_jinete = r.id_jinete
INNER JOIN Caballos c ON r.id_caballo = c.id_caballo
GROUP BY j.nombre, c.nombre;
-- Vista 2: Vista de instructores con la cantidad de clases en las que participan, ordenados de mayor a menor cantidad de clases.
CREATE VIEW VistaInstructoresClases AS
SELECT i.nombre AS instructor_nombre, COUNT(cl.id_clase) AS cantidad_clases
FROM Instructores i
LEFT JOIN Clases cl ON i.id_instructor = cl.id_instructor
GROUP BY i.nombre
ORDER BY cantidad_clases DESC;
    
-- Función 1: Obtener la edad actual de un jinete a partir de su fecha de nacimiento.
DELIMITER //

CREATE FUNCTION CalcularEdadJinete(fecha_nacimiento DATE) RETURNS INT DETERMINISTIC
BEGIN
    DECLARE edad INT;
    SET edad = TIMESTAMPDIFF(YEAR, fecha_nacimiento, CURDATE());
    RETURN edad;
END//

DELIMITER ;

-- Función 2: Obtener el nombre completo de un jinete concatenando su nombre y apellido.
DELIMITER //

CREATE FUNCTION ObtenerNombreCompletoJinete(nombre VARCHAR(255), apellido VARCHAR(255)) RETURNS VARCHAR(255) DETERMINISTIC
BEGIN
    DECLARE nombre_completo VARCHAR(255);
    SET nombre_completo = CONCAT(nombre, ' ', apellido);
    RETURN nombre_completo;
END//

DELIMITER ;

-- Procedimiento 1: Actualizar la categoría de un jinete en base a su edad.
DELIMITER //
CREATE PROCEDURE ActualizarCategoriaJinete(jinete_id INT)
BEGIN
 DECLARE edad INT;
 SELECT CalcularEdadJinete(fecha_nacimiento) INTO edad FROM Jinetes WHERE id_jinete = jinete_id;
  IF edad < 18 THEN
   UPDATE Jinetes SET categoria = 'Juvenil' WHERE id_jinete = jinete_id;
 ELSEIF edad >= 18 AND edad < 40 THEN
   UPDATE Jinetes SET categoria = 'Adulto' WHERE id_jinete = jinete_id;
 ELSE
   UPDATE Jinetes SET categoria = 'Senior' WHERE id_jinete = jinete_id;
 END IF;
END//
DELIMITER ;
-- Procedimiento 2: Muestra la informacion de un jinete
DELIMITER //

CREATE DEFINER=`root`@`%` PROCEDURE `ClubHipica`.`MostrarInfoJinete`(jinete_id INT)
BEGIN
  DECLARE jinete_nombre VARCHAR(255);
  DECLARE jinete_apellido VARCHAR(255);
  DECLARE jinete_fecha_nacimiento DATE;
  DECLARE jinete_telefono VARCHAR(255);
  DECLARE jinete_direccion VARCHAR(255);
  DECLARE jinete_ciudad VARCHAR(255);
  DECLARE jinete_numero_licencia INT;
  DECLARE jinete_fecha_expiracion_licencia DATE;
  DECLARE jinete_categoria VARCHAR(255);

  SELECT nombre, apellido, fecha_nacimiento, telefono, direccion, ciudad, numero_licencia, fecha_expiracion_licencia, categoria
  INTO jinete_nombre, jinete_apellido, jinete_fecha_nacimiento, jinete_telefono, jinete_direccion, jinete_ciudad, jinete_numero_licencia, jinete_fecha_expiracion_licencia, jinete_categoria
  FROM Jinetes
  WHERE id_jinete = jinete_id;
  
  IF jinete_nombre IS NOT NULL THEN
    SELECT 'Información del jinete:' AS '---', 
           CONCAT('Nombre: ', jinete_nombre) AS 'Nombre',
           CONCAT('Apellido: ', jinete_apellido) AS 'Apellido',
           CONCAT('Fecha de nacimiento: ', jinete_fecha_nacimiento) AS 'Fecha de nacimiento',
           CONCAT('Teléfono: ', jinete_telefono) AS 'Teléfono',
           CONCAT('Dirección: ', jinete_direccion) AS 'Dirección',
           CONCAT('Ciudad: ', jinete_ciudad) AS 'Ciudad',
           CONCAT('Número de licencia: ', jinete_numero_licencia) AS 'Número de licencia',
           CONCAT('Fecha de expiración de la licencia: ', jinete_fecha_expiracion_licencia) AS 'Fecha de expiración de la licencia',
           CONCAT('Categoría: ', jinete_categoria) AS 'Categoría';
  ELSE
    SELECT 'No se encontró ningún jinete con el ID proporcionado.' AS 'Mensaje';
  END IF;
END//
DELIMITER ;
-- Procedimiento 3: Muestra a los jinetes
DELIMITER //

CREATE DEFINER=`root`@`%` PROCEDURE `ClubHipica`.`mostrar_jinetes`()
BEGIN
    DECLARE finCur INT DEFAULT FALSE;
    DECLARE jinete_info TEXT;
    DECLARE result TEXT DEFAULT '';
    DECLARE cur CURSOR FOR SELECT CONCAT(nombre, ' ', apellido) AS jinete FROM Jinetes;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET finCur = TRUE;
    
    OPEN cur;
    
    read_loop: LOOP
        FETCH cur INTO jinete_info;
        
        IF finCur THEN
            LEAVE read_loop;
        END IF;
        
        -- Concatenar el resultado en una cadena
        SET result = CONCAT(result, jinete_info, '\n');
    END LOOP;
    
    CLOSE cur;
    
    -- Imprimir el resultado final
    SELECT result;
END//
DELIMITER ;
-- Trigger para verificar la fecha de expiración de la licencia de un jinete antes de insertar un nuevo registro en la tabla "Jinetes":
DELIMITER //
CREATE TRIGGER verificar_expiracion_licencia
BEFORE INSERT ON Jinetes
FOR EACH ROW
BEGIN
 IF NEW.fecha_expiracion_licencia < CURDATE() THEN
   SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La licencia ha expirado.';
 END IF;
END //
DELIMITER ;

-- Trigger para actualizar la fecha de nacimiento de un jinete en la tabla "Jinetes" cuando se inserta un nuevo registro en la tabla "Resultados":
DELIMITER //
CREATE TRIGGER actualizar_fecha_nacimiento
AFTER INSERT ON Resultados
FOR EACH ROW
BEGIN
 UPDATE Jinetes SET fecha_nacimiento = (SELECT fecha_nacimiento FROM Caballos WHERE id_caballo = NEW.id_caballo)
 WHERE id_jinete = NEW.id_jinete;
END //
DELIMITER ;


-- Llamada a la función 1: Obtener la edad actual de un jinete a partir de su fecha de nacimiento
SELECT  CalcularEdadJinete('2022-06-20');

-- Llamada a la función 2: Obtener el nombre completo de un jinete concatenando su nombre y apellido
SELECT ObtenerNombreCompletoJinete('Jonah', 'Bradshaw');

-- Llamada al procedimiento 1: Actualizar la categoría de un jinete en base a su edad
CALL ActualizarCategoriaJinete(1);

-- Llamada al procedimiento 2: Mostrar la información de un jinete
CALL MostrarInfoJinete(1);

-- Llamada al procedimiento 3: Mostrar la lista de jinetes
CALL mostrar_jinetes();


INSERT INTO ClubHipica.Jinetes (id_jinete,nombre,apellido,fecha_nacimiento,telefono,direccion,ciudad,numero_licencia,fecha_expiracion_licencia,categoria) VALUES
	 (501,'Merrill','Burt','2033-01-09','07 51 29 79 12','127-6592 Non, Av.','Nizhyn',231721522,'2022-06-04','#a1e276');
	

