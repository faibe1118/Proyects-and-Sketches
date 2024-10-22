import pandas as pd

class AnalisisDeDatos:
    def __init__(self, archivo=None, dataframe=None):
        if archivo:
            self.df = pd.read_csv(archivo)
        elif dataframe is not None:
            self.df = dataframe
        else:
            raise ValueError("Debes proporcionar un archivo CSV o un DataFrame.")

    def mostrar_info(self):
        """Muestra la estructura y tipos de datos."""
        return self.df.info()

    def estadisticas(self):
        """Devuelve un resumen estadístico de las columnas numéricas."""
        return self.df.describe()

    def mostrar_primeros(self, n=5):
        """Muestra las primeras 'n' filas del DataFrame."""
        return self.df.head(n)

# Uso de la clase
archivo = 'tu_archivo.csv'  # Asegúrate de tener un archivo CSV con datos.
# analisis = AnalisisDeDatos(archivo=archivo)
# print(analisis.mostrar_info())
# print(analisis.estadisticas())
# print(analisis.mostrar_primeros())
