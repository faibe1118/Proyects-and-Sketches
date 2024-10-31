import matplotlib
matplotlib.use('Agg')

from flask import Flask, request, jsonify, send_file
from flask_cors import CORS
import numpy as np
import matplotlib.pyplot as plt
import base64
import os
import io

app = Flask(__name__)
CORS(app)


@app.route('/api/graficar', methods=['POST'])
def graficar():
    try:
        # Validar los datos recibidos
        datos = request.json
        if not all(k in datos for k in ['a11', 'a12', 'a21', 'a22']):
            return jsonify({"error": "Faltan parámetros a11, a12, a21, a22"}), 400

        # Convertir los parámetros a float y manejar posibles errores
        try:
            a11 = float(datos['a11'])
            a12 = float(datos['a12'])
            a21 = float(datos['a21'])
            a22 = float(datos['a22'])
        except ValueError:
            return jsonify({"error": "Los parámetros deben ser numéricos"}), 400

        # Crear el gráfico
        fig, ax = plt.subplots(figsize=(6, 6))
        x = np.linspace(-8, 8, 20)
        y = np.linspace(-8, 8, 20)
        X, Y = np.meshgrid(x, y)

        # Calcular los campos vectoriales
        U = a11 * X + a12 * Y
        V = a21 * X + a22 * Y

        # Dibujar el campo vectorial
        ax.quiver(X, Y, U, V, color='blue', scale=500, scale_units='width'); ax.plot(0, 0, 'ro'); ax.grid()

        # Guardar el gráfico en un buffer de memoria
        buffer = io.BytesIO()
        plt.savefig(buffer, format='png')
        buffer.seek(0)

        # Convertir la imagen a base64
        image_base64 = base64.b64encode(buffer.read()).decode('utf-8')
        plt.close(fig)  # Liberar memoria

        # Devolver la imagen en la respuesta JSON
        return jsonify({"grafica": image_base64})

    except Exception as e:
        # Manejo de errores y respuesta 500
        return jsonify({"error": str(e)}), 500


@app.route('/api/analizar', methods=['POST'])
def analizar():
    try:
        datos = request.json
        
        # Asegurarse de que los datos contengan todos los campos necesarios
        a11 = float(datos.get('a11', 0))
        a12 = float(datos.get('a12', 0))
        a21 = float(datos.get('a21', 0))
        a22 = float(datos.get('a22', 0))

        # Crear la matriz y calcular determinante
        matriz = np.array([[a11, a12], [a21, a22]])
        determinante = np.linalg.det(matriz)

        # Verificamos si el determinante es cero
        if determinante == 0:
            return jsonify({"mensaje": "La matriz no tiene un punto crítico único. El determinante es cero."}), 200

        mensaje = "El único punto crítico es (0,0)."
        eigenvalores = np.linalg.eigvals(matriz)

        # Convertir los eigenvalores a un formato que se pueda serializar
        eigenvalores_serializables = []
        for val in eigenvalores:
            if np.iscomplex(val):
                eigenvalores_serializables.append(f"{val.real} + {val.imag}j")  # Formato string para complejos
            else:
                eigenvalores_serializables.append(float(val))  # Convertir a float si es real

        # Clasificar la naturaleza del punto
        if np.all(np.isreal(eigenvalores)):
            if np.sign(eigenvalores[0]) == np.sign(eigenvalores[1]):
                naturaleza = "Nodo"
            else:
                naturaleza = "Silla"
        elif np.iscomplex(eigenvalores).any():
            # Verificar si son imaginarios puros
            if np.all(eigenvalores.real == 0):
                naturaleza = "Centro"
            else:
                naturaleza = "Foco"
        else:
            naturaleza = "Nodo especial"


        # Calcular estabilidad
        if np.all(eigenvalores < 0):
            estabilidad = "Asintóticamente estable"
        elif np.any(eigenvalores > 0):
            estabilidad = "Inestable"
        else:
            estabilidad = "Neutra"

        resultado = {
            "mensaje": mensaje,
            "eigenvalores": eigenvalores_serializables,
            "naturaleza": naturaleza,
            "estabilidad": estabilidad
        }

        return jsonify(resultado)

    except Exception as e:
        return jsonify({"error": str(e)}), 500  # Retorna un mensaje de error en formato JSON



    except Exception as e:
        return jsonify({"error": str(e)}), 500  # Retorna un mensaje de error en formato JSON

if __name__ == '__main__':
    app.run(port=5001)



'''from flask import Flask, request, jsonify
from flask_cors import CORS
import numpy as np

app = Flask(__name__)
CORS(app)

@app.route('/api/analizar', methods=['POST'])
def analizar():
    try:
        datos = request.json
        
        # Asegurarse de que los datos contengan todos los campos necesarios
        a11 = float(datos.get('a11', 0))
        a12 = float(datos.get('a12', 0))
        a21 = float(datos.get('a21', 0))
        a22 = float(datos.get('a22', 0))

        # Crear la matriz y calcular determinante
        matriz = np.array([[a11, a12], [a21, a22]])
        determinante = np.linalg.det(matriz)

        # Verificamos si el determinante es cero
        if determinante == 0:
            return jsonify({"mensaje": "La matriz no tiene un punto crítico único. El determinante es cero."}), 200

        mensaje = "El único punto crítico es (0,0)."
        eigenvalores = np.linalg.eigvals(matriz)

        # Convertir los eigenvalores a un formato que se pueda serializar
        eigenvalores_serializables = []
        for val in eigenvalores:
            if np.iscomplex(val):
                eigenvalores_serializables.append(f"{val.real} + {val.imag}j")  # Formato string para complejos
            else:
                eigenvalores_serializables.append(float(val))  # Convertir a float si es real

        # Clasificar la naturaleza del punto
        if np.all(np.isreal(eigenvalores)):
            if np.sign(eigenvalores[0]) == np.sign(eigenvalores[1]):
                naturaleza = "Nodo"
            else:
                naturaleza = "Silla"
        elif np.iscomplex(eigenvalores).any():
            if eigenvalores.imag.any() != 0:
                naturaleza = "Foco"
            else:
                naturaleza = "Centro"
        else:
            naturaleza = "Nodo especial"

        # Calcular estabilidad
        if np.all(eigenvalores < 0):
            estabilidad = "Asintóticamente estable"
        elif np.any(eigenvalores > 0):
            estabilidad = "Inestable"
        else:
            estabilidad = "Neutra"

        resultado = {
            "mensaje": mensaje,
            "eigenvalores": eigenvalores_serializables,
            "naturaleza": naturaleza,
            "estabilidad": estabilidad
        }

        return jsonify(resultado)

    except Exception as e:
        return jsonify({"error": str(e)}), 500  # Retorna un mensaje de error en formato JSON



if __name__ == '__main__':
    app.run(port=5001)'''




''' ultimo from flask import Flask, request, jsonify
from flask_cors import CORS  # Importa Flask-CORS
import numpy as np

app = Flask(__name__)
CORS(app)  # Habilita CORS para todas las rutas

@app.route('/api/analizar', methods=['POST'])
def analizar():
    datos = request.json
    a11 = float(datos['a11'])
    a12 = float(datos['a12'])
    a21 = float(datos['a21'])
    a22 = float(datos['a22'])

    # Crear la matriz y calcular determinante
    matriz = np.array([[a11, a12], [a21, a22]])
    determinante = np.linalg.det(matriz)

    if determinante != 0:
        mensaje = "El único punto crítico es (0,0)."
        eigenvalores = np.linalg.eigvals(matriz)
        
        # Clasificar la naturaleza del punto
        if np.all(np.isreal(eigenvalores)):
            if np.sign(eigenvalores[0]) == np.sign(eigenvalores[1]):
                naturaleza = "Nodo"
            else:
                naturaleza = "Silla"
        elif np.iscomplex(eigenvalores).any():
            if eigenvalores.imag.any() != 0:
                naturaleza = "Foco"
            else:
                naturaleza = "Centro"
        else:
            naturaleza = "Nodo especial"

        # Calcular estabilidad
        if np.all(eigenvalores < 0):
            estabilidad = "Asintóticamente estable"
        elif np.any(eigenvalores > 0):
            estabilidad = "Inestable"
        else:
            estabilidad = "Neutra"

        resultado = {
            "mensaje": mensaje,
            "eigenvalores": eigenvalores.tolist(),
            "naturaleza": naturaleza,
            "estabilidad": estabilidad
        }
    else:
        resultado = {
            "mensaje": "Como el determinante es 0 , no se puede decir que exista un único punto crítico."
        }

    return jsonify(resultado)

if __name__ == '__main__':
    app.run(port=5001)'''



''' 3 from flask import Flask, request, jsonify
from flask_cors import CORS  # Importa Flask-CORS
import numpy as np

app = Flask(__name__)
CORS(app)  # Habilita CORS para todas las rutas

@app.route('/api/analizar', methods=['POST'])
def analizar():
    datos = request.json
    a11 = float(datos['a11'])
    a12 = float(datos['a12'])
    a21 = float(datos['a21'])
    a22 = float(datos['a22'])

    # Crear la matriz y calcular determinante
    matriz = np.array([[a11, a12], [a21, a22]])
    determinante = np.linalg.det(matriz)

    if determinante != 0:
        mensaje = "El único punto crítico es (0,0)."
        eigenvalores = np.linalg.eigvals(matriz)
        
        # Clasificar la naturaleza del punto
        if np.all(np.isreal(eigenvalores)):
            if np.sign(eigenvalores[0]) == np.sign(eigenvalores[1]):
                naturaleza = "Nodo"
            else:
                naturaleza = "Silla"
        elif np.iscomplex(eigenvalores).any():
            if eigenvalores.imag.any() != 0:
                naturaleza = "Foco"
            else:
                naturaleza = "Centro"
        else:
            naturaleza = "Nodo especial"

        # Calcular estabilidad
        if np.all(eigenvalores < 0):
            estabilidad = "Asintóticamente estable"
        elif np.any(eigenvalores > 0):
            estabilidad = "Inestable"
        else:
            estabilidad = "Neutra"

        resultado = {
            "mensaje": mensaje,
            "eigenvalores": eigenvalores.tolist(),
            "naturaleza": naturaleza,
            "estabilidad": estabilidad
        }
    else:
        resultado = {"mensaje": "La matriz no tiene un punto crítico único."}

    return jsonify(resultado)

if __name__ == '__main__':
    app.run(port=5000)'''



'''from flask import Flask, request, jsonify
from flask_cors import CORS  # Importa el módulo CORS

app = Flask(__name__)
CORS(app)  # Habilita CORS para todas las rutas

@app.route('/')
def index():
    return render_template('index.htm')  # Asegúrate de que 'index.htm' esté en la carpeta 'templates'


@app.route('/api/analizar', methods=['POST'])
def analizar():
    try:
        # Recibir datos del formulario en formato JSON
        data = request.json
        a11 = float(data['a11'])
        a12 = float(data['a12'])
        a21 = float(data['a21'])
        a22 = float(data['a22'])

        # Crear la matriz A
        A = np.array([[a11, a12], [a21, a22]])

        # 1. Verificar si el punto crítico es único (determinante != 0)
        determinante = np.linalg.det(A)
        if determinante == 0:
            return jsonify({
                "punto_critico": "No único",
                "mensaje": "El sistema tiene múltiples puntos críticos."
            }), 200

        # 2. Calcular los autovalores (eigenvalores)
        eigenvalues, _ = np.linalg.eig(A)

        # 3. Clasificación del punto crítico según los eigenvalores
        if np.all(np.isreal(eigenvalues)):  # Raíces reales
            if np.isclose(eigenvalues[0], eigenvalues[1]):
                naturaleza = "Nodo especial (raíces reales iguales)"
            elif np.sign(eigenvalues[0]) == np.sign(eigenvalues[1]):
                naturaleza = "Nodo (raíces reales del mismo signo)"
            else:
                naturaleza = "Silla de montar (raíces reales de distinto signo)"
        else:  # Raíces complejas conjugadas
            if np.all(np.isclose(np.real(eigenvalues), 0)):
                naturaleza = "Centro (raíces imaginarias puras)"
            else:
                naturaleza = "Foco (raíces complejas conjugadas)"

        # 4. Determinar la estabilidad del sistema
        if all(np.real(eigenvalue) < 0 for eigenvalue in eigenvalues):
            estabilidad = "Asintóticamente estable"
        elif any(np.real(eigenvalue) > 0 for eigenvalue in eigenvalues):
            estabilidad = "Inestable"
        else:
            estabilidad = "Neutramente estable"

        # Preparar la respuesta en formato JSON
        response = {
            "determinante": determinante,
            "punto_critico": "(0, 0)",
            "autovalores": eigenvalues.tolist(),
            "naturaleza": naturaleza,
            "estabilidad": estabilidad
        }

        return jsonify(response), 200

    except Exception as e:
        print(f"Error: {e}")  # Imprimir errores en la consola
        return jsonify({"error": "Ocurrió un error al procesar la solicitud."}), 500

if __name__ == '__main__':
    app.run(port=5001)'''


#from flask import Flask, jsonify, request, render_template
#from flask_cors import CORS

#app = Flask(__name__)
#CORS(app)  # Habilitamos CORS

# Endpoint de ejemplo
#@app.route('/api/saludo', methods=['GET'])
#def saludo():
#    nombre = request.args.get('nombre', 'Mundo')
#   return jsonify({"mensaje": f"Hola, {nombre}!"})

# Ruta para renderizar el index.html
#@app.route('/')
#def index():
#    return render_template('index.html')

#if __name__ == '__main__':
#    app.run(debug=True)
