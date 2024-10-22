import matplotlib.pyplot as plt

class VisualizadorSimple:
    def __init__(self, datos):
        self.datos = datos

    def grafico_lineas(self):
        plt.plot(self.datos)
        plt.title("Gráfico de Líneas")
        plt.show()

    def grafico_barras(self):
        plt.bar(range(len(self.datos)), self.datos)
        plt.title("Gráfico de Barras")
        plt.show()

# Uso de la clase
datos = [5, 10, 15, 20, 25, 30]
visualizador = VisualizadorSimple(datos)
visualizador.grafico_lineas()
visualizador.grafico_barras()
