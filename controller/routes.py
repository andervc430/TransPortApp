import sys
import os

# Obtén la ruta del directorio actual (donde se encuentra routes.py)
current_dir = os.path.dirname(os.path.realpath(__file__))

# Agrega la ruta del directorio superior (que contiene la carpeta 'model') al sys.path
parent_dir = os.path.dirname(current_dir)
sys.path.append(parent_dir)

# Importaciones
from model.database import Database
from flask import Flask, render_template, request, redirect, session

app = Flask(__name__)
app.template_folder = 'view'  # Especifica la carpeta de las plantillas
app.secret_key = 'your_secret_key'  # Clave secreta para la sesión
db = Database()

@app.route('/')
def index():
    return render_template('interfazLogin.html')

@app.route('/login', methods=['POST'])
def login():
    username = request.form['username']
    password = request.form['password']
    
    user = db.find_user(username, password)
    if user:
        # Usuario y contraseña válidos, iniciar sesión
        session['username'] = username
        return redirect('/interfazUsuario')  # Redirigir a la interfaz de usuario
    else:
        # Usuario o contraseña incorrectos, mostrar mensaje de error
        return render_template('interfazLogin.html', error=True)


@app.route('/interfazUsuario')
def interfaz_usuario():
    if 'username' in session:
        # El usuario ha iniciado sesión, renderizar la interfaz de usuario
        return render_template('interfazUsuario.html', username=session['username'])
    else:
        # Si el usuario no ha iniciado sesión, redirigir al inicio de sesión
        return redirect('/')

@app.route('/crear_usuario', methods=['POST'])
def crear_usuario():
    nombre = request.form['nombre']
    apellido1 = request.form['apellido1']
    apellido2 = request.form['apellido2']
    email = request.form['email']
    nombre_usuario = request.form['nombreUsuario']  # Recuperar el nombre de usuario
    contrasena = request.form['password']
    monedero_virtual = request.form['monedero']

    # Obtener el Id_Rol correspondiente al rol de usuario de la tabla Rol
    nombre_rol = 'Usuario'
    id_rol_usuario = db.obtener_id_rol_por_nombre(nombre_rol)

    if id_rol_usuario is not None:
        try:
            # Insertar el nuevo usuario en la tabla Usuario con el Id_Rol correspondiente
            db.create_user(nombre, apellido1, apellido2, email, nombre_usuario, contrasena, monedero_virtual)  # Pasar nombre_usuario como argumento
            print("Usuario creado exitosamente.")
        except Exception as e:
            print("Error al crear el usuario:", e)
    else:
        print(f"No se pudo obtener el Id_Rol para el rol '{nombre_rol}'. No se creó ningún usuario.")

    return redirect('/')

@app.route('/comprar_tiquete', methods=['POST'])
def comprar_tiquete():
    if 'username' in session:
        # Obtener datos del formulario
        nombre_tiquete = request.form['nombre_tiquete']
        nombre_medio_transporte = request.form['nombre_medio_transporte']
        ruta_id = request.form['ruta_id']
        
        # Obtener el ID del tiquete y del medio de transporte
        id_tiquete = db.obtener_id_tiquete(nombre_tiquete)
        id_medio_transporte = db.obtener_medio_transporte_id(nombre_medio_transporte)
        
        if id_tiquete is not None and id_medio_transporte is not None:
            # Insertar la compra del tiquete en la base de datos
            try:
                db.comprar_tiquete(session['username'], id_tiquete, id_medio_transporte, ruta_id)
                print("Tiquete comprado exitosamente.")
            except Exception as e:
                print("Error al comprar el tiquete:", e)
        else:
            print("No se pudo obtener el ID del tiquete o del medio de transporte.")
        
        return redirect('/interfazUsuario')
    else:
        return redirect('/')

@app.route('/dashboard')
def dashboard():
    if 'username' in session:
        # El usuario ha iniciado sesión, mostrar el dashboard
        return render_template('dashboard.html', username=session['username'])
    else:
        # El usuario no ha iniciado sesión, redirigir al inicio de sesión
        return redirect('/')

if __name__ == '__main__':
    app.run(debug=True)





