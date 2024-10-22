import numpy as np

class CalculadoraMatriz:
    def __init__(self, matriz1, matriz2):
        self.matriz1 = np.array(matriz1)
        self.matriz2 = np.array(matriz2)

    def suma(self):
        return np.add(self.matriz1, self.matriz2)

    def resta(self):
        return np.subtract(self.matriz1, self.matriz2)

    def multiplicacion(self):
        return np.dot(self.matriz1, self.matriz2)

    def transpuesta(self):
        return self.matriz1.T  # Transposición de la primera matriz

# Uso de la clase
matriz1 = [[1, 2], [3, 4]]
matriz2 = [[5, 6], [7, 8]]

calc = CalculadoraMatriz(matriz1, matriz2)
print("Suma:\n", calc.suma())
print("Resta:\n", calc.resta())
print("Multiplicación:\n", calc.multiplicacion())
print("Transpuesta de la primera matriz:\n", calc.transpuesta())
