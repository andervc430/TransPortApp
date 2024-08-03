

----------------------------- Creacion de la base de datos ----------------------------- 


CREATE DATABASE SistemaDeTransportePublico

USE SistemaDeTransportePublico
GO

--Tablas creadas

-- Tabla Rol
CREATE TABLE Rol (
   Id_Rol INT PRIMARY KEY IDENTITY(10860,1),
   Nombre VARCHAR(100) NOT NULL
);
 
-- Tabla Usuario
CREATE TABLE Usuario (
   Id_Usuario INT PRIMARY KEY IDENTITY(21871,1),
   Nombre VARCHAR(50) NOT NULL,
   Apellido1 VARCHAR(50) NOT NULL,
   Apellido2 VARCHAR(50) NOT NULL,
   Email VARCHAR(200) NOT NULL,
   NombreUsuario VARCHAR(60) NOT NULL,
   Contraseña VARCHAR(100) NOT NULL,
   Monedero_Virtual INT NOT NULL,
   Rol_Id INT NOT NULL
);

-- Tabla Transporte
CREATE TABLE Transporte (
   Id_Transporte INT PRIMARY KEY IDENTITY(32860,1),
   Tipo_Transporte VARCHAR(100) NOT NULL,
   Posicion VARCHAR(250) NOT NULL,
   Capacidad INT NOT NULL,
   Estado VARCHAR(100) NOT NULL,
   Ruta_Id INT NOT NULL
);

-- Tabla Ruta
CREATE TABLE Ruta (
   Id_Ruta INT PRIMARY KEY IDENTITY(141820,1),
   Origen VARCHAR(50) NOT NULL,
   Destino VARCHAR(50) NOT NULL,
   Parada_Origen_Id INT NOT NULL,
   Parada_Destino_Id INT NOT NULL,
   Paradas VARCHAR(50) NOT NULL
);

-- Tabla Pago
CREATE TABLE Pago (
   Id_Pago INT PRIMARY KEY IDENTITY(51810,1),
   Monto INT NOT NULL,
   Fecha DATETIME NOT NULL,
   Usuario_Id INT NOT NULL,
   Tiquete_ID INT NOT NULL,
   Medio_Transporte_Id INT NOT NULL
);

-- Tabla Tiquete
CREATE TABLE Tiquete (
   Id_Tiquete INT PRIMARY KEY IDENTITY(61930,1),
   Fecha_Compra DATETIME NOT NULL,
   Usuario_Id INT NOT NULL,
   Medio_Transporte_Id INT NOT NULL,
   Ruta_Id INT NOT NULL
);

-- Tabla Viaje
CREATE TABLE Viaje (
   Id_Viaje INT PRIMARY KEY IDENTITY(72973,1),
   Horario VARCHAR(50) NOT NULL,
   Fecha_Inicio DATETIME NOT NULL,
   Fecha_Fin DATETIME NOT NULL,
   Usuario_Id INT NOT NULL,
   Medio_Transporte_Id INT NOT NULL,
   Parada_Origen_Id INT NOT NULL,
   Parada_Destino_Id INT NOT NULL,
   Ruta_Id INT NOT NULL
);

-- Tabla de Registro Posicion
CREATE TABLE Registro_Posicion (
   Id_Registro INT PRIMARY KEY IDENTITY(81560,1),
   Fecha DATETIME NOT NULL,
   Posicion VARCHAR(50) NOT NULL,
   Ruta_Id INT NOT NULL,
   Medio_Transporte_Id INT NOT NULL
);

-- Tabla de Parada
CREATE TABLE Parada (
   Id_Parada INT PRIMARY KEY IDENTITY(91981,1),
   Nombre VARCHAR(50) NOT NULL,
   Ubicacion VARCHAR(55) NOT NULL
);
 

-- FK en para las tablas creadas 

-- Relaciona cada usuario con su rol en la tabla Rol.
ALTER TABLE Usuario ADD CONSTRAINT FK_Usuario_Rol FOREIGN KEY (Rol_Id) REFERENCES Rol (Id_Rol);

-- Ruta asocia a cada medio de transporte con su ruta.
ALTER TABLE Transporte ADD CONSTRAINT FK_Transporte_Ruta FOREIGN KEY (Ruta_Id) REFERENCES Ruta (Id_Ruta);

-- Aqui se vincula cada pago con el usuario que realizó el pago en la tabla Usuario.
ALTER TABLE Pago ADD CONSTRAINT FK_Pago_Usuario FOREIGN KEY (Usuario_Id) REFERENCES Usuario (Id_Usuario);

-- Relaciona cada pago con el medio de transporte asociado al pago en la tabla Transporte.
ALTER TABLE Pago ADD CONSTRAINT FK_Pago_Transporte FOREIGN KEY (Medio_Transporte_Id) REFERENCES Transporte (Id_Transporte);

-- Aqui se vincula cada pago con el tiquete asociado al pago en la tabla Tiquete.
ALTER TABLE Pago ADD CONSTRAINT FK_Pago_Tiquete FOREIGN KEY (Tiquete_Id) REFERENCES Tiquete (Id_Tiquete);

-- Asocia cada tiquete con el usuario que compró el tiquete en la tabla Usuario.
ALTER TABLE Tiquete ADD CONSTRAINT FK_Tiquete_Usuario FOREIGN KEY (Usuario_Id) REFERENCES Usuario (Id_Usuario);

-- Relaciona cada tiquete con el medio de transporte asociado al tiquete en la tabla Transporte.
ALTER TABLE Tiquete ADD CONSTRAINT FK_Tiquete_Transporte FOREIGN KEY (Medio_Transporte_Id) REFERENCES Transporte (Id_Transporte);

-- Vincula cada tiquete con la ruta asociada al tiquete en la tabla Ruta.
ALTER TABLE Tiquete ADD CONSTRAINT FK_Tiquete_Ruta FOREIGN KEY (Ruta_Id) REFERENCES Ruta (Id_Ruta);

-- Asocia cada viaje con el usuario que realizó el viaje en la tabla Usuario.
ALTER TABLE Viaje ADD CONSTRAINT FK_Viaje_Usuario FOREIGN KEY (Usuario_Id) REFERENCES Usuario (Id_Usuario);

-- Relaciona cada viaje con el medio de transporte asociado al viaje en la tabla Transporte.
ALTER TABLE Viaje ADD CONSTRAINT FK_Viaje_Transporte FOREIGN KEY (Medio_Transporte_Id) REFERENCES Transporte (Id_Transporte);

-- Vincula cada viaje con la ruta asociada al viaje en la tabla Ruta.
ALTER TABLE Viaje ADD CONSTRAINT FK_Viaje_Ruta FOREIGN KEY (Ruta_Id) REFERENCES Ruta (Id_Ruta);

-- Relaciona cada registro de posición con el medio de transporte al que pertenece en la tabla Transporte.
ALTER TABLE Registro_Posicion ADD CONSTRAINT FK_RegistroPosicion_Transporte FOREIGN KEY (Medio_Transporte_Id) REFERENCES Transporte (Id_Transporte);

-- Asocia cada registro de posición con la ruta a la que pertenece en la tabla Ruta.
ALTER TABLE Registro_Posicion ADD CONSTRAINT FK_RegistroPosicion_Ruta FOREIGN KEY (Ruta_Id) REFERENCES Ruta (Id_Ruta);

-- Relaciona cada ruta con la parada de origen asociada a la ruta en la tabla Parada.
ALTER TABLE Ruta ADD CONSTRAINT FK_Ruta_Parada_Origen FOREIGN KEY (Parada_Origen_Id) REFERENCES Parada (Id_Parada);

-- Vincula cada ruta con la parada de destino asociada a la ruta en la tabla Parada.
ALTER TABLE Ruta ADD CONSTRAINT FK_Ruta_Parada_Destino FOREIGN KEY (Parada_Destino_Id) REFERENCES Parada (Id_Parada);

-- Relaciona cada viaje con la parada de origen asociada al viaje en la tabla Parada.
ALTER TABLE Viaje ADD CONSTRAINT FK_Viaje_Parada_Origen FOREIGN KEY (Parada_Origen_Id) REFERENCES Parada (Id_Parada);

-- Vincula cada viaje con la parada de destino asociada al viaje en la tabla Parada.
ALTER TABLE Viaje ADD CONSTRAINT FK_Viaje_Parada_Destino FOREIGN KEY (Parada_Destino_Id) REFERENCES Parada (Id_Parada);



----------------------------- Roles y Permisos -----------------------------

-- Crear logins
CREATE LOGIN ChoferesLogin WITH PASSWORD = 'ContraseñaChoferes';
CREATE LOGIN DesarrolladoresLogin WITH PASSWORD = 'ContraseñaDesarrolladores';
CREATE LOGIN AnalisisDatosLogin WITH PASSWORD = 'ContraseñaAnalisisDatos';
CREATE LOGIN UsuarioLogin WITH PASSWORD = 'ContraseñaUsuarios';

-- Crear usuarios asociados a logins y asignar a roles
CREATE USER ChoferesUsuario FOR LOGIN ChoferesLogin;
CREATE USER DesarrolladoresUsuario FOR LOGIN DesarrolladoresLogin;
CREATE USER AnalisisDatosUsuario FOR LOGIN AnalisisDatosLogin;
CREATE USER UsuarioUsuario FOR LOGIN UsuarioLogin;

-- Asignar roles a usuarios
ALTER ROLE DispositivosDeChoferes ADD MEMBER ChoferesUsuario;
ALTER ROLE Desarrolladores ADD MEMBER DesarrolladoresUsuario;
ALTER ROLE EquipoDeAnalisisDeDatos ADD MEMBER AnalisisDatosUsuario;
ALTER ROLE Usuario ADD MEMBER UsuarioUsuario;

-- Asignar permisos específicos a cada rol

-- Rol: Dispositivos de Choferes
GRANT SELECT ON Ruta TO DispositivosDeChoferes;
GRANT SELECT ON Parada TO DispositivosDeChoferes;
GRANT SELECT, UPDATE ON Transporte TO DispositivosDeChoferes;

-- Rol: Desarrolladores
GRANT SELECT, INSERT, UPDATE, DELETE ON Rol TO Desarrolladores;
GRANT SELECT, INSERT, UPDATE, DELETE ON Usuario TO Desarrolladores;
GRANT SELECT, INSERT, UPDATE, DELETE ON Transporte TO Desarrolladores;
GRANT SELECT, INSERT, UPDATE, DELETE ON Ruta TO Desarrolladores;
GRANT SELECT, INSERT, UPDATE, DELETE ON Pago TO Desarrolladores;
GRANT SELECT, INSERT, UPDATE, DELETE ON Tiquete TO Desarrolladores;
GRANT SELECT, INSERT, UPDATE, DELETE ON Viaje TO Desarrolladores;
GRANT SELECT, INSERT, UPDATE, DELETE ON Registro_Posicion TO Desarrolladores;
GRANT SELECT, INSERT, UPDATE, DELETE ON Parada TO Desarrolladores;

-- Rol: Equipo de Análisis de Datos
GRANT SELECT ON Pago TO EquipoDeAnalisisDeDatos;
GRANT SELECT ON Tiquete TO EquipoDeAnalisisDeDatos;

-- Rol: Usuarios
GRANT SELECT ON Tiquete TO Usuario;
GRANT SELECT ON Viaje TO Usuario;

-- Insertar roles en la tabla de Roles
INSERT INTO Rol (Nombre) VALUES ('Dispositivos de Choferes'), ('Desarrolladores'), ('Equipo de Análisis de Datos'), ('Usuario');



DELETE FROM Rol;

----------------------------- Procedimientos almacenados -----------------------------
USE SistemaDeTransportePublico
GO


----------------------------- Controles de concurrencia ----------------------------- 
USE SistemaDeTransportePublico
GO


----------------------------- Mejoras ------------------------------
USE SistemaDeTransportePublico
GO

-- Index para mejorar consultas 

-- Para mejorar la consulta de posición de transporte para los Choferes
CREATE INDEX IX_Chofer_Posicion_Transporte ON Transporte (Posicion);

-- Para mejorar la consulta de capacidad de transporte para los Choferes
CREATE INDEX IX_Chofer_Capacidad_Transporte ON Transporte (Capacidad);

-- Para mejorar las consultas de usuario_id en la tabla Pago para el Equipo de Análisis de Datos
CREATE INDEX IX_AnalistaDatos_Pago_Usuario_Id ON Pago (Usuario_Id);

-- Para mejorar las consultas de medio_transporte_id en la tabla Registro_Posicion para el Equipo de Análisis de Datos
CREATE INDEX IX_AnalistaDatos_Registro_Posicion_Medio_Transporte_Id ON Registro_Posicion (Medio_Transporte_Id);

-- Para mejorar las consultas de usuario_id en la tabla Tiquete para los Usuarios
CREATE INDEX IX_Cliente_Tiquete_Usuario_Id ON Tiquete (Usuario_Id);

-- Para mejorar las consultas de usuario_id en la tabla Viaje para los Usuarios
CREATE INDEX IX_Cliente_Viaje_Usuario_Id ON Viaje (Usuario_Id);

-- Para mejorar las consultas de origen y destino en la tabla Ruta
CREATE INDEX IX_Ruta_Origen_Destino ON Ruta (Origen, Destino);

-- Para mejorar las consultas de parada en la tabla Parada
CREATE INDEX IX_Parada_Nombre ON Parada (Nombre);

-- Para mejorar las consultas de fecha en la tabla Pago
CREATE INDEX IX_Pago_Fecha ON Pago (Fecha);

-- Para mejorar las consultas de fecha en la tabla Viaje
CREATE INDEX IX_Viaje_Fecha_Inicio ON Viaje (Fecha_Inicio);

-- Para mejorar las consultas de fecha en la tabla Tiquete
CREATE INDEX IX_Tiquete_Fecha_Compra ON Tiquete (Fecha_Compra);

-- Para mejorar las consultas de posición en la tabla Registro_Posicion
CREATE INDEX IX_Registro_Posicion_Fecha ON Registro_Posicion (Fecha);

-- Para mejorar las consultas de parada de origen y destino en la tabla Viaje
CREATE INDEX IX_Viaje_Parada_Origen_Destino ON Viaje (Parada_Origen_Id, Parada_Destino_Id);

---------------------------------------------------------------------------------------------------------------

