
SET SQL_SAFE_UPDATES = 0;

DROP DATABASE IF EXISTS austral;
CREATE DATABASE austral;
USE austral;

-- ===================== ENTREGABLE 1: CREACION DE TABLAS =====================

CREATE TABLE autores (
    id_autor INT AUTO_INCREMENT,
    nombre   VARCHAR(80) NOT NULL,
    pais     VARCHAR(60),
    genero   ENUM('Cómic','Ensayo','Infantil','Novela','Poesía') NOT NULL,
    PRIMARY KEY (id_autor)
);


CREATE TABLE colecciones (
    id_coleccion      INT AUTO_INCREMENT,
    titulo            VARCHAR(120) NOT NULL,
    fecha_publicacion DATE NOT NULL,
    PRIMARY KEY (id_coleccion)
);

CREATE TABLE libros (
    id_libro            INT AUTO_INCREMENT,
    id_autor            INT NOT NULL,
    id_coleccion        INT,
    titulo              VARCHAR(120) NOT NULL,
    paginas             INT,
    ejemplares_vendidos INT,
    anio                INT,
    PRIMARY KEY (id_libro),
    FOREIGN KEY (id_autor) REFERENCES autores(id_autor),
    FOREIGN KEY (id_coleccion) REFERENCES colecciones(id_coleccion)
);

CREATE TABLE pagos (
    id_pago    INT AUTO_INCREMENT,
    id_autor   INT NOT NULL,
    fecha_pago DATE NOT NULL,
    monto      DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (id_pago),
    FOREIGN KEY (id_autor) REFERENCES autores(id_autor)
);

-- ===================== CARGA OFICIAL =====================

INSERT INTO autores (nombre, pais, genero) VALUES
('Elena Pizarro', 'Chile', 'Novela'),
('Harold Finch', 'Inglaterra', 'Ensayo'),
('Rodrigo Bahamonde', 'Chile', 'Poesía'),
('Valentina Correa', 'Argentina', 'Infantil'),
('Nora Keller', 'Estados Unidos', 'Novela'),
('Kenji Arakawa', NULL, 'Cómic');

-- id_autor: 1 Elena, 2 Harold, 3 Rodrigo, 4 Valentina, 5 Nora, 6 Kenji
-- id_coleccion queda NULL porque la carga oficial no trae colecciones
INSERT INTO libros (id_autor, titulo, paginas, ejemplares_vendidos, anio) VALUES
(1, 'Cielo de Enero', 210, 1500, 2024),
(1, 'Marea Baja', 185, 800, 2023),
(1, 'El Norte', 200, 2200, 2024),
(2, 'Estrellas que Caen', 240, 3000, 2022),
(2, 'Máquinas', 215, 450, 2024),
(3, 'Luz Artificial', 300, 1200, 2024),
(3, 'Ruido Blanco', 280, 600, 2023),
(4, 'El Barrio de Lila', 190, 5000, 2024),
(4, 'Antes del Amanecer', 205, 2700, 2024),
(4, 'La Calle 8', 175, 900, 2023),
(5, 'Flor de Hierro', 195, 4100, 2024),
(5, 'Hora Dorada', 220, 1800, 2022);

-- ===================== ENTREGABLE 2: CONSULTAS =====================

-- Consulta 1
SELECT nombre, genero
FROM autores
WHERE pais <> 'Chile' OR pais IS NULL
ORDER BY nombre;

-- Consulta 2
SELECT titulo, paginas
FROM libros
WHERE paginas >= 190 AND paginas <= 220
ORDER BY paginas;

-- Consulta 3
SELECT COUNT(*) AS total_libros,
       SUM(ejemplares_vendidos) AS total_ejemplares,
       AVG(paginas) AS promedio_paginas,
       MIN(anio) AS anio_mas_antiguo,
       MAX(ejemplares_vendidos) AS max_ejemplares
FROM libros;

-- Consulta 4
SELECT DISTINCT genero
FROM autores
ORDER BY genero;

-- Consulta 5
SELECT a.nombre, COUNT(*) AS libros_2024
FROM autores a
JOIN libros l ON a.id_autor = l.id_autor
WHERE l.anio = 2024
GROUP BY a.id_autor, a.nombre
HAVING COUNT(*) > 1
ORDER BY a.nombre;

-- Consulta 6
SELECT titulo, ejemplares_vendidos
FROM libros
WHERE anio = 2024 AND ejemplares_vendidos > 2000
ORDER BY ejemplares_vendidos DESC
LIMIT 3;

-- Consulta 7
INSERT INTO libros (id_autor, titulo, paginas, ejemplares_vendidos, anio)
VALUES (3, 'Papel Mojado', 260, 50, 2024);

SELECT * FROM libros WHERE titulo = 'Papel Mojado';

DELETE FROM libros WHERE titulo = 'Papel Mojado';

SELECT * FROM libros WHERE titulo = 'Papel Mojado';

-- Consulta 8
SELECT titulo, ejemplares_vendidos
FROM libros
WHERE titulo = 'Cielo de Enero';

UPDATE libros
SET ejemplares_vendidos = ejemplares_vendidos + 100
WHERE titulo = 'Cielo de Enero';

SELECT titulo, ejemplares_vendidos
FROM libros
WHERE titulo = 'Cielo de Enero';

-- Consulta 9
-- filas de prueba: 3 colecciones y se asignan los 12 libros
INSERT INTO colecciones (titulo, fecha_publicacion) VALUES
('Narrativa del Sur', '2022-03-15'),
('Pensamiento y Verso', '2023-08-01'),
('Austral Joven', '2024-05-20');

UPDATE libros SET id_coleccion = 1 WHERE id_autor IN (1, 5);
UPDATE libros SET id_coleccion = 2 WHERE id_autor IN (2, 3);
UPDATE libros SET id_coleccion = 3 WHERE id_autor = 4;

SELECT l.titulo AS libro,
       c.titulo AS coleccion,
       DATE_FORMAT(c.fecha_publicacion, '%Y-%m-%d') AS fecha_publicacion
FROM libros l
JOIN colecciones c ON l.id_coleccion = c.id_coleccion
ORDER BY c.titulo, l.titulo;

-- Consulta 10
-- filas de prueba: 4 pagos, dos de ellos a Elena Pizarro
INSERT INTO pagos (id_autor, fecha_pago, monto) VALUES
(1, '2025-01-10', 350000.00),
(1, '2025-07-10', 420500.50),
(4, '2025-03-05', 610000.00),
(5, '2025-04-18', 275990.00);

SELECT a.nombre,
       DATE_FORMAT(p.fecha_pago, '%Y-%m-%d') AS fecha_pago,
       p.monto
FROM pagos p
JOIN autores a ON p.id_autor = a.id_autor
ORDER BY p.fecha_pago;

SELECT a.nombre, SUM(p.monto) AS total_pagado
FROM pagos p
JOIN autores a ON p.id_autor = a.id_autor
GROUP BY a.id_autor, a.nombre
ORDER BY a.nombre;
