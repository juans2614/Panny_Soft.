-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 16-09-2024 a las 21:54:35
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `pannysoft`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `AddAppointment` (IN `p_id_cliente` INT, IN `p_id_esteticista` INT, IN `p_fecha` DATETIME)   BEGIN
    INSERT INTO Citas (id_cliente, id_esteticista, fecha, estado)
    VALUES (p_id_cliente, p_id_esteticista, p_fecha, 'pendiente');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `AddClientHistory` (IN `p_id_cliente` INT, IN `p_id_esteticista` INT, IN `p_descripcion` TEXT, IN `p_fecha` DATETIME)   BEGIN
    INSERT INTO Historiales (id_cliente, id_esteticista, descripcion, fecha)
    VALUES (p_id_cliente, p_id_esteticista, p_descripcion, p_fecha);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `CancelAllAppointments` ()   BEGIN
    UPDATE Citas
    SET estado = 'cancelada'
    WHERE estado = 'pendiente';
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `CancelAppointment` (IN `p_id_cita` INT)   BEGIN
    
    UPDATE Citas
    SET estado = 'cancelada'
    WHERE id_cita = p_id_cita;

    
    INSERT INTO HistorialCancelaciones (id_cita, fecha_cancelacion)
    VALUES (p_id_cita, NOW());
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ConfirmAppointment` (IN `p_id_cita` INT)   BEGIN
    UPDATE Citas
    SET estado = 'confirmada'
    WHERE id_cita = p_id_cita;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetAllEstheticians` ()   BEGIN
    SELECT * FROM Esteticistas;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetClientHistory` (IN `p_id_cliente` INT)   BEGIN
    SELECT * FROM Historiales
    WHERE id_cliente = p_id_cliente;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetPendingAppointments` ()   BEGIN
    SELECT * FROM Citas
    WHERE estado = 'pendiente';
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ListAllClients` ()   BEGIN
    SELECT * FROM Clientes;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ListClientsByLastName` ()   BEGIN
    SELECT * FROM Clientes
    ORDER BY apellido;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `MarkAppointmentAsCancelled` (IN `p_id_cita` INT)   BEGIN
UPDATE cita
SET estado = 'cancelada'
WHERE id_cita = p_id_cita;
IF ROW_COUNT() = 0 THEN
SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La cita con el ID especificado no existe o ya está cancelada.';
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `RegisterPayment` (IN `p_id_cita` INT, IN `p_monto` DECIMAL, IN `p_fecha_pago` DATETIME)   BEGIN
    INSERT INTO Pagos (id_cita, monto, fecha_pago)
    VALUES (p_id_cita, p_monto, p_fecha_pago);
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `citas`
--

CREATE TABLE `citas` (
  `id_cc` int(10) NOT NULL,
  `servicio_id` int(11) NOT NULL,
  `cliente_nombre` varchar(255) NOT NULL,
  `cliente_email` varchar(255) NOT NULL,
  `fecha` datetime NOT NULL,
  `estado` enum('Programada','Confirmada','Cancelada') DEFAULT 'Programada'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `citas`
--

INSERT INTO `citas` (`id_cc`, `servicio_id`, `cliente_nombre`, `cliente_email`, `fecha`, `estado`) VALUES
(1000125888, 2, 'Juan Pérez', 'juan.perez@gmail.com', '0000-00-00 00:00:00', 'Confirmada'),
(1000456231, 1, 'María González', 'maria.gonzalez@example.com', '2024-09-16 00:00:00', ''),
(1000874123, 3, 'Carlos Ramírez', 'carlos.ramirez@example.com', '2024-09-17 00:00:00', 'Confirmada'),
(1000547892, 4, 'Ana Fernández', 'ana.fernandez@example.com', '2024-09-18 00:00:00', 'Cancelada'),
(1000321478, 5, 'Luis Martínez', 'luis.martinez@example.com', '2024-09-19 00:00:00', 'Confirmada'),
(1000654891, 2, 'Laura Jiménez', 'laura.jimenez@example.com', '2024-09-20 00:00:00', '');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cliente`
--

CREATE TABLE `cliente` (
  `cedula_pac` int(10) NOT NULL,
  `nombre` varchar(15) NOT NULL,
  `apellido` varchar(30) NOT NULL,
  `telefono` int(10) NOT NULL,
  `correo` varchar(30) DEFAULT NULL,
  `fecha_nac` date NOT NULL,
  `edad` int(2) NOT NULL,
  `genero` varchar(1) NOT NULL,
  `usuario` varchar(30) NOT NULL,
  `contrasena` varchar(50) NOT NULL,
  `servicio_actual` varchar(30) NOT NULL,
  `id_cita` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `cliente`
--

INSERT INTO `cliente` (`cedula_pac`, `nombre`, `apellido`, `telefono`, `correo`, `fecha_nac`, `edad`, `genero`, `usuario`, `contrasena`, `servicio_actual`, `id_cita`) VALUES
(46849899, 'Powell', 'McPeck', 712, 'pmcpeckp@un.org', '1991-12-30', 85, 'M', 'pmcpeckp', 'tP4Yki>A', '', 0),
(74757861, 'Alberta', 'Pearcy', 314, 'apearcy5@webmd.com', '2005-07-12', 17, 'F', 'apearcy5', 'hL7lkR4S\"4?L9a(', '', 0),
(96751244, 'Nedda', 'Lober', 190, 'nloberm@sohu.com', '1974-02-04', 77, 'F', 'nloberm', 'dU5n!xDvsB%>', '', 0),
(138604442, 'Claudius', 'Moizer', 148, 'cmoizerc@utexas.edu', '1996-12-28', 79, 'M', 'cmoizerc', 'rZ0)NZ,UOZ', '', 0),
(337501601, 'Algernon', 'Kelcher', 125, 'akelcherf@squidoo.com', '1990-09-29', 83, 'M', 'akelcherf', 'lL1`2BlfV1JP3', '', 0),
(340182607, 'Augie', 'Winpenny', 295, 'awinpennyo@trellian.com', '1977-05-01', 41, 'M', 'awinpennyo', 'hJ6N!X.RobV6', '', 0),
(406320998, 'Sharl', 'Flaxon', 589, 'sflaxonl@google.it', '1980-05-19', 99, 'F', 'sflaxonl', 'dC83E!)FD#|N,d', '', 0),
(429438084, 'Agneta', 'Smalman', 908, 'asmalman6@rakuten.co.jp', '1973-10-15', 96, 'F', 'asmalman6', 'cT4%iqi%w', '', 0),
(509077446, 'Orville', 'Heigold', 103, 'oheigold8@howstuffworks.com', '1995-02-28', 89, 'M', 'oheigold8', 'yI28zg5H343~', '', 0),
(522674196, 'Stavros', 'Catherall', 874, 'scatherall7@51.la', '1989-05-13', 21, 'M', 'scatherall7', 'eT3In*@Smfjj\"', '', 0),
(580111707, 'Dimitry', 'Field', 412, 'dfield1@nytimes.com', '1998-11-05', 62, 'M', 'dfield1', 'uL6Uy3jW\\?', '', 0),
(581858596, 'Egan', 'Vala', 346, 'evalad@accuweather.com', '1972-11-15', 90, 'M', 'evalad', 'jD6p~kzQ>_#N', '', 0),
(588256346, 'Norton', 'McMorran', 341, 'nmcmorranj@goodreads.com', '2004-11-14', 81, 'M', 'nmcmorranj', 'aX6UIr=s', '', 0),
(592348631, 'Stanleigh', 'Rowatt', 893, 'srowatt3@geocities.jp', '1990-05-16', 23, 'M', 'srowatt3', 'jZ9|Bv+6PRe', '', 0),
(608830026, 'Dav', 'Donati', 654, 'ddonatie@timesonline.co.uk', '1994-07-13', 23, 'M', 'ddonatie', 'qM3J$Z\'#T2pA.Un', '', 0),
(635173958, 'Reuven', 'De Domenicis', 685, 'rdedomeniciss@people.com.cn', '1981-06-12', 16, 'M', 'rdedomeniciss', 'rR0uks_25', '', 0),
(669422548, 'Ignatius', 'Lightman', 300, 'ilightmani@cam.ac.uk', '1998-05-31', 53, 'M', 'ilightmani', 'oK7!v*Q7fco', '', 0),
(693813251, 'Demetri', 'Bayman', 526, 'dbaymana@prlog.org', '1985-02-24', 62, 'M', 'dbaymana', 'zV3/Lk#ME\'{', '', 0),
(694971906, 'Scarlet', 'Greenwell', 193, 'sgreenwellq@cargocollective.co', '1978-04-11', 22, 'F', 'sgreenwellq', 'eT36>Fpe?X', '', 0),
(764821196, 'Natalie', 'Thacke', 930, 'nthacker@about.com', '1994-07-08', 26, 'F', 'nthacker', 'qF6\'b6k\'', '', 0),
(817709712, 'Nikolaus', 'Ralphs', 607, 'nralphs2@edublogs.org', '1989-07-23', 51, 'M', 'nralphs2', 'oW2W?xjp_p874dgC', '', 0),
(835767251, 'Ellwood', 'Stileman', 885, 'estilemang@technorati.com', '2004-09-29', 94, 'M', 'estilemang', 'gG0Rbvr?K}', '', 0),
(844009495, 'Fletch', 'Hardwich', 657, 'fhardwich9@examiner.com', '1975-10-24', 78, 'M', 'fhardwich9', 'uM8ee>)}f\\mpQ/=', '', 0),
(845771683, 'Jedediah', 'Burnitt', 880, 'jburnitt4@blog.com', '1988-10-24', 47, 'M', 'jburnitt4', 'eZ94W%gP$8F`\\s<A', '', 0),
(947818526, 'Skyler', 'Dillingham', 822, 'sdillinghamh@canalblog.com', '2002-04-13', 56, 'M', 'sdillinghamh', 'iM2xZ*7u7OfB%>', '', 0),
(949617577, 'Eugenio', 'Felce', 358, 'efelce0@wikipedia.org', '1984-06-08', 88, 'M', 'efelce0', 'xS9ULxDyz', '', 0),
(1006975513, 'Curt', 'Bowling', 630, 'cbowlingt@bloglines.com', '1999-10-21', 78, 'M', 'cbowlingt', 'uC8U@f(P\\u+4}X', '', 0),
(1016894016, 'Lesya', 'Shatliff', 510, 'lshatliffb@delicious.com', '1998-03-06', 35, 'F', 'lshatliffb', 'xY15Qb$3', '', 0),
(1022651255, 'Benito', 'Rummins', 376, 'brumminsk@arstechnica.com', '2000-06-01', 83, 'M', 'brumminsk', 'xF0~+exS)h}8Fv(', '', 0),
(1023405905, 'Grace', 'Quilty', 239, 'gquiltyn@blogspot.com', '1983-01-23', 34, 'M', 'gquiltyn', 'kH0{7~FKF', '', 0);

--
-- Disparadores `cliente`
--
DELIMITER $$
CREATE TRIGGER `LogNewClientIfService` AFTER INSERT ON `cliente` FOR EACH ROW BEGIN
IF NEW.servicio_actual = 'Spa' THEN
INSERT INTO historial (id_cliente)
VALUES (NEW.id_cliente, CONCAT('Cliente nuevo con servicio ', NEW.servicio_actual), NOW());
END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `esteticista`
--

CREATE TABLE `esteticista` (
  `id_esteticista` int(10) NOT NULL,
  `nombre` varchar(30) NOT NULL,
  `usuario` varchar(30) NOT NULL,
  `contraseña` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `esteticista`
--

INSERT INTO `esteticista` (`id_esteticista`, `nombre`, `usuario`, `contraseña`) VALUES
(1000321478, 'David Pérez', 'david.perez', 'dperez2024'),
(1000456231, 'Andrea López', 'andrea.lopez', 'andrea123'),
(1000547892, 'Mariana Silva', 'mariana.silva', 'msilva2024'),
(1000654891, 'Lucía Torres', 'lucia.torres', 'ltorres123'),
(1000874123, 'Carlos Ruiz', 'carlos.ruiz', 'cruiz2024');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `historial`
--

CREATE TABLE `historial` (
  `cliente` varchar(15) NOT NULL,
  `fecha` date NOT NULL DEFAULT current_timestamp(),
  `hora` time DEFAULT current_timestamp(),
  `servicio` varchar(10) NOT NULL,
  `id_esteticista` int(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `historial`
--

INSERT INTO `historial` (`cliente`, `fecha`, `hora`, `servicio`, `id_esteticista`) VALUES
('Ana Pérez', '2024-09-16', '10:00:00', 'Masajes re', 1),
('Carlos Martínez', '2024-09-16', '11:00:00', 'Faciales r', 2),
('Laura Gómez', '2024-09-16', '12:30:00', 'Depilación', 3),
('Lucía Torres', '2024-09-16', '15:30:00', 'Tratamient', 2),
('Pedro Ruiz', '2024-09-16', '14:00:00', 'Manicura y', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pagos`
--

CREATE TABLE `pagos` (
  `med_pago` varchar(10) DEFAULT NULL,
  `id_cita` int(10) DEFAULT NULL,
  `nom_servicio` varchar(20) DEFAULT NULL,
  `id_servicio` int(20) DEFAULT NULL,
  `costo_serv` int(15) DEFAULT NULL,
  `cedula_pac` int(10) DEFAULT NULL,
  `fecha_pago` date DEFAULT NULL,
  `saldo` int(15) DEFAULT NULL,
  `abono` int(15) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `pagos`
--

INSERT INTO `pagos` (`med_pago`, `id_cita`, `nom_servicio`, `id_servicio`, `costo_serv`, `cedula_pac`, `fecha_pago`, `saldo`, `abono`) VALUES
('Tarjeta', 1, 'Masaje relajante', 2, 50000, 1000456231, '2024-09-15', 10000, 40000),
('Efectivo', 2, 'Facial rejuvenecedor', 1, 60000, 1000874123, '2024-09-16', 0, 60000),
('Tarjeta', 3, 'Depilación láser', 3, 45000, 1000547892, '2024-09-17', 5000, 40000),
('Transferen', 4, 'Manicura y pedicura', 4, 35000, 1000321478, '2024-09-18', 0, 35000),
('Efectivo', 5, 'Tratamiento reductor', 5, 70000, 1000654891, '2024-09-19', 20000, 50000);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `recepcionista`
--

CREATE TABLE `recepcionista` (
  `id_recepcionista` int(10) NOT NULL,
  `nombre_com` varchar(30) NOT NULL,
  `usuario` varchar(30) NOT NULL,
  `contraseña` varchar(30) NOT NULL,
  `id_cita` int(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `recepcionista`
--

INSERT INTO `recepcionista` (`id_recepcionista`, `nombre_com`, `usuario`, `contraseña`, `id_cita`) VALUES
(1, 'María López', 'mlopez', 'pass123', 101);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `servicios`
--

CREATE TABLE `servicios` (
  `id` int(11) NOT NULL,
  `nombre` varchar(255) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `duracion` int(11) NOT NULL,
  `precio` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `servicios`
--

INSERT INTO `servicios` (`id`, `nombre`, `descripcion`, `duracion`, `precio`) VALUES
(1, 'Masajes relajantes', 'Alivian el estrés y mejoran el bienestar general', 60, 50.00),
(2, 'Faciales rejuvenecedores', 'Revitaliza y limpia profundamente la piel del rostro', 45, 40.00),
(3, 'Depilación con cera o láser', 'Elimina el vello de manera duradera', 30, 30.00),
(4, 'Manicura y pedicura', 'Embellece y cuida las manos y los pies', 60, 35.00),
(5, 'Tratamientos corporales reductores', 'Ayuda a reducir medidas y mejorar la apariencia de la piel', 90, 70.00);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `id_usu` int(10) NOT NULL,
  `nombre` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `contrasena` varchar(255) NOT NULL,
  `fecha_creacion` timestamp NOT NULL DEFAULT current_timestamp(),
  `activo` tinyint(1) DEFAULT 1,
  `direccion` varchar(255) DEFAULT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `fecha_nacimiento` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`id_usu`, `nombre`, `email`, `contrasena`, `fecha_creacion`, `activo`, `direccion`, `telefono`, `fecha_nacimiento`) VALUES
(1, 'paula', '02.paulap.@gmail.com', 'paula1988*', '2024-09-10 19:49:27', 1, 'cra 80 #100', '3225642181', '0000-00-00'),
(2, 'angie', '18angie@gmail.com', 'angie123', '2024-09-10 19:51:09', 1, 'calle 190 # 5', '3224411593', '0000-00-00'),
(3, 'juan', 'sebas123@gmail.com', 'juanse20', '2024-09-10 19:52:58', 1, 'calle 80 # 8', '3508091296', '0000-00-00'),
(4, 'santiago', 'santi50@gmail.com', 'santi850', '2024-09-10 19:54:50', 1, 'carrera 50 # 6m', '3005968752', '0000-00-00'),
(5, 'orcar', 'oscar17@gmail.com', 'oscar017', '2024-09-10 19:55:58', 1, 'cale 70  # 80 b', '3112859687', '0000-00-00');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `cliente`
--
ALTER TABLE `cliente`
  ADD PRIMARY KEY (`cedula_pac`);

--
-- Indices de la tabla `esteticista`
--
ALTER TABLE `esteticista`
  ADD PRIMARY KEY (`id_esteticista`);

--
-- Indices de la tabla `historial`
--
ALTER TABLE `historial`
  ADD PRIMARY KEY (`cliente`);

--
-- Indices de la tabla `recepcionista`
--
ALTER TABLE `recepcionista`
  ADD PRIMARY KEY (`id_recepcionista`);

--
-- Indices de la tabla `servicios`
--
ALTER TABLE `servicios`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`id_usu`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `servicios`
--
ALTER TABLE `servicios`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `citas`
--
ALTER TABLE `citas`
  ADD CONSTRAINT `citas_ibfk_1` FOREIGN KEY (`servicio_id`) REFERENCES `servicios` (`id`);

--
-- Filtros para la tabla `recepcionista`
--
ALTER TABLE `recepcionista`
  ADD CONSTRAINT `fk_cita` FOREIGN KEY (`id_cita`) REFERENCES `cita` (`Id_cita`),
  ADD CONSTRAINT `recepcionista_ibfk_1` FOREIGN KEY (`id_cita`) REFERENCES `cita` (`Id_cita`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

-- 
-- Modificación de longitud de campos en las tablas 'cliente' y 'cita' con el propósito de implementar un sistema de seguridad bcrypt.
-- 
ALTER TABLE `cliente`
MODIFY `contrasena` VARCHAR(255) NOT NULL;

ALTER TABLE `esteticista`
MODIFY `contraseña` VARCHAR(255) NOT NULL;

ALTER TABLE `recepcionista`
MODIFY `contraseña` VARCHAR (255) NOT NULL;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
