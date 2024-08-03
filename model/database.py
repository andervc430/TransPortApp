import pyodbc

class Database:
    def __init__(self):
        try:
            # Conectarse a la base de datos
            self.conn = pyodbc.connect(
                'DRIVER={SQL Server};'
                'SERVER=DESKTOP-TQHCOLB\SQLEXPRESS;'
                'DATABASE=SistemaDeTransportePublico;'
                'UID=sa;'
                'PWD=Kzjqpd99'
            )
            print("Conexión a la base de datos establecida correctamente.")
        except Exception as e:
            print("Error al establecer la conexión a la base de datos:", e)

    def execute(self, sql, params=None):
        # Ejecutar una consulta SQL que no devuelve resultados (INSERT, UPDATE, DELETE, etc.)
        cursor = self.conn.cursor()
        if params:
            cursor.execute(sql, params)
        else:
            cursor.execute(sql)
        self.conn.commit()  # Confirmar los cambios en la base de datos
        cursor.close()

    def query(self, sql, params=None):
        # Ejecutar una consulta SQL y devolver el resultado (SELECT)
        cursor = self.conn.cursor()
        if params:
            cursor.execute(sql, params)
        else:
            cursor.execute(sql)
        result = cursor.fetchall()
        cursor.close()
        return result

    def find_user(self, username, password):
        # Buscar un usuario en la base de datos por nombre de usuario y contraseña
        sql = "SELECT * FROM Usuario WHERE NombreUsuario = ? AND Contraseña = ?"
        result = self.query(sql, (username, password))
        return result

    def obtener_id_rol_usuario(self):
        """
        Función para obtener el Id_Rol correspondiente al rol de usuario de la tabla Rol.
        """
        nombre_rol_usuario = 'Usuario'
        id_rol_usuario = self.obtener_id_rol_por_nombre(nombre_rol_usuario)
        return id_rol_usuario

    def create_user(self, nombre, apellido1, apellido2, email, nombre_usuario, contrasena, monedero_virtual):
        """
        Función para crear un nuevo usuario en la tabla Usuario.
        """
        try:
            # Obtener el Id_Rol de usuario
            id_rol_usuario = self.obtener_id_rol_usuario()
            
            if id_rol_usuario is not None:
                # Insertar el nuevo usuario en la tabla Usuario con el Id_Rol correspondiente
                sql = "INSERT INTO Usuario (Nombre, Apellido1, Apellido2, Email, NombreUsuario, Contraseña, Monedero_Virtual, Rol_Id) VALUES (?, ?, ?, ?, ?, ?, ?, ?)"
                self.execute(sql, (nombre, apellido1, apellido2, email, nombre_usuario, contrasena, monedero_virtual, id_rol_usuario))
                print("Usuario creado exitosamente.")
            else:
                print(f"No se pudo obtener el Id_Rol para el rol de usuario. No se creó ningún usuario.")
        except Exception as e:
            print("Error al crear el usuario:", e)

    def obtener_id_rol_por_nombre(self, nombre_rol):
        try:
            sql = "SELECT Id_Rol FROM Rol WHERE Nombre = ?"
            result = self.query(sql, (nombre_rol,))
            if result:
                return result[0][0]  # Devolver el primer ID de rol encontrado
            else:
                # Si no se encuentra ningún rol con ese nombre, imprimir un mensaje de error y devolver None
                print(f"No se encontró ningún rol con el nombre '{nombre_rol}'.")
                return None
        except Exception as e:
            print("Error al obtener el ID del rol:", e)
            return None


    def obtener_id_tiquete(self, nombre_tiquete):
        """
        Función para obtener el ID de un tiquete por su nombre.
        """
        try:
            sql = "SELECT Id_Tiquete FROM Tiquete WHERE Nombre = ?"
            result = self.query(sql, (nombre_tiquete,))
            if result:
                return result[0][0]  # Devolver el primer ID de tiquete encontrado
            else:
                print(f"No se encontró ningún tiquete con el nombre '{nombre_tiquete}'.")
                return None
        except Exception as e:
            print("Error al obtener el ID del tiquete:", e)
            return None

    def obtener_medio_transporte_id(self, nombre_medio_transporte):
        """
        Función para obtener el ID de un medio de transporte por su nombre.
        """
        try:
            sql = "SELECT Id_Medio_Transporte FROM Medio_Transporte WHERE Nombre = ?"
            result = self.query(sql, (nombre_medio_transporte,))
            if result:
                return result[0][0]  # Devolver el primer ID de medio de transporte encontrado
            else:
                print(f"No se encontró ningún medio de transporte con el nombre '{nombre_medio_transporte}'.")
                return None
        except Exception as e:
            print("Error al obtener el ID del medio de transporte:", e)
            return None