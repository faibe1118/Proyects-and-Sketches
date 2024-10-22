import statistics

class EstadisticasBasicas:
    def __init__(self, datos):
        self.datos = datos

    def media(self):
        return statistics.mean(self.datos)

    def mediana(self):
        return statistics.median(self.datos)

    def moda(self):
        try:
            return statistics.mode(self.datos)
        except statistics.StatisticsError:
            return "No hay una única moda"

    def desviacion_estandar(self):
        return statistics.stdev(self.datos)

# Uso de la clase
datos = [1, 2, 2, 3, 4, 5, 5, 5, 6]
stats = EstadisticasBasicas(datos)
print("Media:", stats.media())
print("Mediana:", stats.mediana())
print("Moda:", stats.moda())
print("Desviación Estándar:", stats.desviacion_estandar())
