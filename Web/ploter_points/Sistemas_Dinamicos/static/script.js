/*const formularioEcuaciones = document.getElementById('ecuaciones-form');
const resultadosDiv = document.getElementById('resultados');

formularioEcuaciones.addEventListener('submit', async (event) => {
    event.preventDefault();

    const a11 = parseFloat(document.getElementById('a11').value);
    const a12 = parseFloat(document.getElementById('a12').value);
    const a21 = parseFloat(document.getElementById('a21').value);
    const a22 = parseFloat(document.getElementById('a22').value);

    try {
        const response = await fetch('http://127.0.0.1:5001/api/analizar', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({ a11, a12, a21, a22 }),
        });

        if (!response.ok) {
            const errorData = await response.json();
            throw new Error(`Error HTTP: ${response.status}, Mensaje: ${errorData.error}`);
        }

        const data = await response.json();
        console.log('Respuesta de la API:', data);

        if (data.mensaje && data.mensaje.includes("determinante es 0")) {
            resultadosDiv.textContent = data.mensaje;
        } else if (data.mensaje && data.eigenvalores) {
            resultadosDiv.textContent = `
                ${data.mensaje}
                Eigenvalores: ${data.eigenvalores.join(', ')}
                Naturaleza: ${data.naturaleza}
                Estabilidad: ${data.estabilidad}
            `;
        } else {
            throw new Error('La respuesta de la API no contiene los datos esperados.');
        }
    } catch (error) {
        console.error('Error:', error);
        resultadosDiv.textContent = `Error: ${error.message}`;
    }
});*/

const formularioEcuaciones = document.getElementById('ecuaciones-form');
const resultadosDiv = document.getElementById('resultados');

formularioEcuaciones.addEventListener('submit', async (event) => {
    event.preventDefault(); // Evita el comportamiento por defecto del formulario

    // Obtener valores y asegurarse de que sean números
    const a11 = parseFloat(document.getElementById('a11').value);
    const a12 = parseFloat(document.getElementById('a12').value);
    const a21 = parseFloat(document.getElementById('a21').value);
    const a22 = parseFloat(document.getElementById('a22').value);

    // Validar que los valores son números
    if (isNaN(a11) || isNaN(a12) || isNaN(a21) || isNaN(a22)) {
        resultadosDiv.textContent = "Por favor, ingrese solo números en todos los campos.";
        return;
    }

    try {
        const response = await fetch('http://127.0.0.1:5001/api/analizar', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({ a11, a12, a21, a22 }),
        });

        if (!response.ok) {
            const errorData = await response.json();
            throw new Error(`Error HTTP: ${response.status}, Mensaje: ${errorData.error}`);
        }

        const data = await response.json();
        console.log('Respuesta de la API:', data);

        if (data.mensaje && data.mensaje.includes("determinante es cero")) {
            resultadosDiv.textContent = data.mensaje; // Mostrar mensaje para determinante cero
        } else if (data.mensaje && data.eigenvalores) {
            // Si hay un único punto crítico, mostramos todos los datos
            resultadosDiv.textContent = `
                ${data.mensaje}
                Eigenvalores: ${data.eigenvalores.join(', ')}
                Naturaleza: ${data.naturaleza}
                Estabilidad: ${data.estabilidad}
            `;

        } else {
            throw new Error('La respuesta de la API no contiene los datos esperados.');
        }
        
    } catch (error) {
        console.error('Error:', error);
        resultadosDiv.textContent = `Error: ${error.message}`;
    }
});


const graphImage = document.getElementById('graph');  // Imagen para la gráfica
const botonGraficar = document.getElementById('graficar-btn');  // Botón de graficar

botonGraficar.addEventListener('click', async () => {
    // Obtener los mismos valores que el formulario
    const a11 = parseFloat(document.getElementById('a11').value);
    const a12 = parseFloat(document.getElementById('a12').value);
    const a21 = parseFloat(document.getElementById('a21').value);
    const a22 = parseFloat(document.getElementById('a22').value);

    // Validar que los valores son números
    if (isNaN(a11) || isNaN(a12) || isNaN(a21) || isNaN(a22)) {
        resultadosDiv.textContent = "Por favor, ingrese solo números.";
        return;
    }

    try {
        // Realizar la solicitud POST para graficar
        const response = await fetch('http://127.0.0.1:5001/api/graficar', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({ a11, a12, a21, a22 }),
        });

        if (!response.ok) {
            const errorData = await response.json();
            throw new Error(`Error HTTP: ${response.status}, ${errorData.error}`);
        }

        // Procesar la respuesta JSON
        const data = await response.json();
        console.log('Respuesta de /api/graficar:', data);

        if (data.grafica) {
            // Asignar la imagen en base64 al <img>
            graphImage.src = `data:image/png;base64,${data.grafica}`;
            graphImage.style.display = 'block';  // Mostrar la imagen
        } else {
            resultadosDiv.textContent = "No se pudo generar la gráfica.";
        }

    } catch (error) {
        console.error('Error en /api/graficar:', error);
        resultadosDiv.textContent = `Error: ${error.message}`;
    }
});

