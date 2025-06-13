
--USUARIOS--
CREATE TABLE usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    correo VARCHAR(100) UNIQUE NOT NULL,
    contraseña TEXT NOT NULL,
    es_premium BOOLEAN DEFAULT FALSE,
    fecha_registro DATETIME DEFAULT CURRENT_TIMESTAMP
);

--EMPRESAS--
CREATE TABLE empresas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL,
    direccion TEXT,
    rubro VARCHAR(100)
);

--SERVICIOS--
CREATE TABLE servicios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL,
    empresa_id INT NOT NULL,
    FOREIGN KEY (empresa_id) REFERENCES empresas(id)
        ON DELETE CASCADE
);

--TURNOS--
CREATE TABLE turnos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL,
    servicio_id INT NOT NULL,
    fecha DATE NOT NULL,
    hora TIME NOT NULL,
    estado ENUM('pendiente', 'en_progreso', 'completado', 'cancelado') DEFAULT 'pendiente',
    es_prioridad BOOLEAN DEFAULT FALSE,
    creado_en DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
        ON DELETE CASCADE,
    FOREIGN KEY (servicio_id) REFERENCES servicios(id)
        ON DELETE CASCADE
);

--PLANES--
CREATE TABLE planes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    precio DECIMAL(10,2) NOT NULL,
    duracion_dias INT NOT NULL,
    beneficios TEXT
);

--SUSCRIPCIONES--
CREATE TABLE suscripciones (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL,
    plan_id INT NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
        ON DELETE CASCADE,
    FOREIGN KEY (plan_id) REFERENCES planes(id)
);


--INSERTS-- 


INSERT INTO usuarios (nombre, correo, contraseña, es_premium)
VALUES
  ('Juan Pérez', 'juanperez@gmail.com', 'hashed_password_1', FALSE),
  ('Ana Gómez', 'anagomez@gmail.com', 'hashed_password_2', TRUE),
  ('Luis Torres', 'luistorres@gmail.com', 'hashed_password_3', FALSE),
  ('Pepe Francisco', 'pepefrancis@gmail.com', 'hashed_password_4', FALSE),
  ('Adrián Prieto', 'adripl@gmail.com', 'hashed_password_5', TRUE),
  ('Andrea Amat', 'Andreaamat@gmail.com', 'hashed_password_6', FALSE);


-- Insertar empresas
INSERT INTO empresas (nombre, direccion, rubro)
VALUES
  ('Centro Médico Salud Total', 'Calle 123, Ciudad A', 'Salud'),
  ('Oficina de Trámites Públicos', 'Avenida 456, Ciudad B', 'Gobierno'),
  ('Banco Rápido', 'Carrera 789, Ciudad C', 'Finanzas');

-- Insertar servicios
INSERT INTO servicios (nombre, empresa_id)
VALUES
  ('Consulta General', 1),
  ('Renovación de Pasaporte', 2),
  ('Apertura de Cuenta', 3);

-- Insertar planes premium
INSERT INTO planes (nombre, precio, duracion_dias, beneficios)
VALUES
  ('Plan Mensual', 10, 30, 'Acceso prioritario en filas, soporte premium'),
  ('Plan Trimestral', 29.99, 90, 'Acceso aún más prioritario en filas, soporte dedicado, alertas anticipadas');

-- Insertar suscripciones
INSERT INTO suscripciones (usuario_id, plan_id, fecha_inicio, fecha_fin)
VALUES
  (2, 1, '2025-06-01', '2025-07-01'),  
  (5, 2, '2025-06-05', '2025-09-05');  

-- Insertar turnos
INSERT INTO turnos (usuario_id, servicio_id, fecha, hora, estado, es_prioridad)
VALUES
  (1, 1, '2025-06-24', '09:30:00', 'pendiente', FALSE),
  (2, 2, '2025-06-28', '10:00:00', 'pendiente', TRUE),  
  (3, 3, '2025-07-30', '11:00:00', 'pendiente', FALSE),
  (4, 4, '2025-06-17', '09:30:00', 'pendiente', FALSE),
  (5, 5, '2025-06-19', '10:00:00', 'pendiente', TRUE),  
  (6, 6, '2025-08-18', '11:00:00', 'pendiente', FALSE);


--VISTAS--

SELECT 
    u.id AS "ID DE USUARIO",
    u.nombre AS "NOMBRE",
    p.nombre AS "TIPO SUSCRIPCIÓN",
    CASE WHEN COUNT(t.id) > 0 THEN 'Sí' ELSE 'No' END AS "CITAS PENDIENTES",
    MIN(CONCAT(t.fecha, ' ', t.hora)) AS "PRÓXIMA CITA"
FROM usuarios u
LEFT JOIN suscripciones su ON su.usuario_id = u.id
    AND CURDATE() BETWEEN su.fecha_inicio AND su.fecha_fin  
LEFT JOIN planes p ON p.id = su.plan_id
LEFT JOIN turnos t ON t.usuario_id = u.id 
    AND t.estado = 'pendiente'
GROUP BY u.id, u.nombre, p.nombre
ORDER BY u.nombre;

/*+---------------+----------------+-------------------+------------------+---------------------+
| ID DE USUARIO | NOMBRE         | TIPO SUSCRIPCIÓN  | CITAS PENDIENTES | PRÓXIMA CITA        |
+---------------+----------------+-------------------+------------------+---------------------+
|             5 | Adrián Prieto  | Plan Trimestral   | Sí               | 2025-06-08 10:00:00 |
|             2 | Ana Gómez      | Plan Mensual      | Sí               | 2025-06-06 10:00:00 |
|             6 | Andrea Amat    | NULL              | Sí               | 2025-06-09 11:00:00 |
|             1 | Juan Pérez     | NULL              | Sí               | 2025-06-06 09:30:00 |
|             3 | Luis Torres    | NULL              | Sí               | 2025-06-07 11:00:00 |
|             4 | Pepe Francisco | NULL              | Sí               | 2025-06-08 09:30:00 |
+---------------+----------------+-------------------+------------------+---------------------+*/

-- ===============================
-- INTEGRACIÓN

 Node.js con mysql2:
 const mysql = require('mysql2');
 const connection = mysql.createConnection({
   host: 'localhost',
   user: 'ciclosm',
   password: '1DAM',
   database: 'Aplicacion'
});

 connection.query('SELECT * FROM turnos WHERE usuario_id = ?', [idUsuario], (err, results) => {
   if (err) throw err;
   console.log(results);
 });

-- ========================================
-- DCL (CONTROL DE ACCESO Y SEGURIDAD)


-- Crear un usuario para la aplicación con permisos limitados
CREATE USER 'app_user'@'localhost' IDENTIFIED BY 'TuContraseñaSegura123';

-- Darle permisos de lectura y escritura solo sobre las tablas necesarias
GRANT SELECT, INSERT, UPDATE, DELETE ON gestion_filas.* TO 'app_user'@'localhost';

-- Revocar todos los permisos (en caso de que se necesite en el futuro)
-- REVOKE ALL PRIVILEGES ON gestion_filas.* FROM 'app_user'@'localhost';

-- Hacer copia de seguridad de la base de datos con mysqldump (ejecutar desde terminal, no dentro del SQL):
-- mysqldump -u root -p gestion_filas > backup_gestion_filas.sql

-- Restaurar backup:
-- mysql -u root -p gestion_filas < backup_gestion_filas.sql



