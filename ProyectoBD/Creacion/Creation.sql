CREATE DATABASE `ClubHipica` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

CREATE TABLE `Caballos` (
  `id_caballo` int NOT NULL,
  `nombre` varchar(255) NOT NULL,
  `fecha_nacimiento` date NOT NULL,
  `raza` varchar(255) NOT NULL,
  PRIMARY KEY (`id_caballo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `Carreras` (
  `orden` int NOT NULL,
  `premio` int NOT NULL,
  `categoria` varchar(255) NOT NULL,
  `hora` time NOT NULL,
  `fecha` date NOT NULL,
  `nombre_comp` varchar(255) NOT NULL,
  PRIMARY KEY (`orden`,`fecha`,`nombre_comp`),
  KEY `nombre_comp` (`nombre_comp`,`fecha`),
  CONSTRAINT `Carreras_ibfk_1` FOREIGN KEY (`nombre_comp`, `fecha`) REFERENCES `Ediciones` (`nombre_comp`, `fecha`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `Clases` (
  `id_clase` int NOT NULL,
  `nombre` varchar(255) NOT NULL,
  `fecha` date NOT NULL,
  `hora` time NOT NULL,
  `lugar` varchar(255) NOT NULL,
  `id_jinete` int NOT NULL,
  `id_instructor` int NOT NULL,
  `id_caballo` int NOT NULL,
  PRIMARY KEY (`id_clase`),
  KEY `id_jinete` (`id_jinete`),
  KEY `id_instructor` (`id_instructor`),
  KEY `id_caballo` (`id_caballo`),
  CONSTRAINT `Clases_ibfk_1` FOREIGN KEY (`id_jinete`) REFERENCES `Jinetes` (`id_jinete`),
  CONSTRAINT `Clases_ibfk_2` FOREIGN KEY (`id_instructor`) REFERENCES `Instructores` (`id_instructor`),
  CONSTRAINT `Clases_ibfk_3` FOREIGN KEY (`id_caballo`) REFERENCES `Caballos` (`id_caballo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `Competiciones` (
  `nombre` varchar(255) NOT NULL,
  `lugar` varchar(255) NOT NULL,
  `pais` varchar(255) NOT NULL,
  `tipo` varchar(255) NOT NULL,
  PRIMARY KEY (`nombre`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `Ediciones` (
  `fecha` date NOT NULL,
  `nombre_comp` varchar(255) NOT NULL,
  PRIMARY KEY (`fecha`,`nombre_comp`),
  KEY `nombre_comp` (`nombre_comp`),
  CONSTRAINT `Ediciones_ibfk_1` FOREIGN KEY (`nombre_comp`) REFERENCES `Competiciones` (`nombre`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `Instructores` (
  `id_instructor` int NOT NULL,
  `nombre` varchar(255) NOT NULL,
  `apellido` varchar(255) NOT NULL,
  `fecha_nacimiento` date NOT NULL,
  `telefono` varchar(255) NOT NULL,
  `direccion` varchar(255) NOT NULL,
  `ciudad` varchar(255) NOT NULL,
  `numero_licencia` int NOT NULL,
  `fecha_expiracion_licencia` date NOT NULL,
  `categoria` varchar(255) NOT NULL,
  PRIMARY KEY (`id_instructor`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `Jinetes` (
  `id_jinete` int NOT NULL,
  `nombre` varchar(255) NOT NULL,
  `apellido` varchar(255) NOT NULL,
  `fecha_nacimiento` date NOT NULL,
  `telefono` varchar(255) NOT NULL,
  `direccion` varchar(255) NOT NULL,
  `ciudad` varchar(255) NOT NULL,
  `numero_licencia` int NOT NULL,
  `fecha_expiracion_licencia` date NOT NULL,
  `categoria` varchar(255) NOT NULL,
  PRIMARY KEY (`id_jinete`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `Resultados` (
  `id_jinete` int NOT NULL,
  `id_caballo` int NOT NULL,
  `cajon` int DEFAULT NULL,
  `tiempo` time DEFAULT NULL,
  `orden` int NOT NULL,
  `fecha` date NOT NULL,
  `nombre_comp` varchar(255) NOT NULL,
  PRIMARY KEY (`id_jinete`,`id_caballo`,`orden`,`fecha`,`nombre_comp`),
  KEY `id_caballo` (`id_caballo`),
  KEY `nombre_comp` (`nombre_comp`,`fecha`,`orden`),
  CONSTRAINT `Resultados_ibfk_1` FOREIGN KEY (`id_jinete`) REFERENCES `Jinetes` (`id_jinete`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `Resultados_ibfk_2` FOREIGN KEY (`id_caballo`) REFERENCES `Caballos` (`id_caballo`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `Resultados_ibfk_3` FOREIGN KEY (`nombre_comp`, `fecha`, `orden`) REFERENCES `Carreras` (`nombre_comp`, `fecha`, `orden`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
