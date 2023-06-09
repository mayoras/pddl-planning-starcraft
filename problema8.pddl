(define (problem problema_8)
	(:domain dominio_8)
	(:objects
		loc11 loc12 loc13 loc14 loc15 loc21 loc22 loc23 loc24 loc31 loc32 loc33 loc34 loc42 loc43 loc44 - loc
		CentroDeMando1 Extractor1 Barracones1 - edificio
		VCE1 VCE2 VCE3 - unidad
		Marine1 Marine2 Soldado1 - unidad
	)

	(:init
		; mapa de Terran
		(camino loc11 loc12)
		(camino loc12 loc11)
		(camino loc11 loc21)
		(camino loc21 loc11)
		(camino loc12 loc22)
		(camino loc22 loc12)
		(camino loc21 loc31)
		(camino loc31 loc21)
		(camino loc22 loc32)
		(camino loc32 loc22)
		(camino loc31 loc32)
		(camino loc32 loc31)
		(camino loc32 loc42)
		(camino loc42 loc32)
		(camino loc22 loc23)
		(camino loc23 loc22)
		(camino loc42 loc43)
		(camino loc43 loc42)
		(camino loc43 loc44)
		(camino loc44 loc43)
		(camino loc44 loc34)
		(camino loc34 loc44)
		(camino loc23 loc13)
		(camino loc13 loc23)
		(camino loc23 loc24)
		(camino loc24 loc23)
		(camino loc14 loc24)
		(camino loc24 loc14)
		(camino loc14 loc15)
		(camino loc15 loc14)
		(camino loc44 loc15)
		(camino loc15 loc44)
		(camino loc23 loc33)
		(camino loc33 loc23)

		; Inicializamos las distancias entre localizaciones
		(= (distancia loc11 loc12) 10)
		(= (distancia loc12 loc11) 10)
		(= (distancia loc11 loc21) 10)
		(= (distancia loc21 loc11) 10)
		(= (distancia loc12 loc22) 10)
		(= (distancia loc22 loc12) 10)
		(= (distancia loc21 loc31) 10)
		(= (distancia loc31 loc21) 10)
		(= (distancia loc22 loc32) 10)
		(= (distancia loc32 loc22) 10)
		(= (distancia loc31 loc32) 10)
		(= (distancia loc32 loc31) 10)
		(= (distancia loc32 loc42) 10)
		(= (distancia loc42 loc32) 10)
		(= (distancia loc22 loc23) 20)
		(= (distancia loc23 loc22) 20)
		(= (distancia loc42 loc43) 20)
		(= (distancia loc43 loc42) 20)
		(= (distancia loc43 loc44) 10)
		(= (distancia loc44 loc43) 10)
		(= (distancia loc44 loc34) 10)
		(= (distancia loc34 loc44) 10)
		(= (distancia loc23 loc13) 10)
		(= (distancia loc13 loc23) 10)
		(= (distancia loc23 loc24) 10)
		(= (distancia loc24 loc23) 10)
		(= (distancia loc14 loc24) 10)
		(= (distancia loc24 loc14) 10)
		(= (distancia loc14 loc15) 10)
		(= (distancia loc15 loc14) 10)
		(= (distancia loc44 loc15) 40)
		(= (distancia loc15 loc44) 40)
		(= (distancia loc23 loc33) 10)
		(= (distancia loc33 loc23) 10)

		; ubicamos donde estan las entidades
		(entidad-en CentroDeMando1 loc11)
		(entidad-en VCE1 loc11)

		; Inicializamos las unidades como libres
		(libre VCE1)

		; Establecemos el tipo de los edificios objeto
		(edificio-es CentroDeMando1 CentroDeMando)
		(edificio-es Extractor1 Extractor)
		(edificio-es Barracones1 Barracones)

		; Establecemos el tipo de las unidades
		(unidad-es VCE1 VCE)
		(unidad-es VCE2 VCE)
		(unidad-es VCE3 VCE)
		(unidad-es Marine1 Marine)
		(unidad-es Marine2 Marine)
		(unidad-es Soldado1 Soldado)

		; indicamos los edificios construidos
		(construido CentroDeMando1)

		; Inicializamos la localizacion de los recursos
		(recurso-asignado-en Mineral loc22)
		(recurso-asignado-en Mineral loc44)
		(recurso-asignado-en Gas loc15)

		; Inicializamos los stocks de los recursos
		(= (stock Mineral) 0)
		(= (stock Gas) 0)

		; Definimos la maxima capacidad de los stocks
		(= (max-cap Mineral) 50)
		(= (max-cap Gas) 60)

		; Definimos las tasas de extraccion de cada recurso
		(= (extract-rate Mineral) 5)
		(= (extract-rate Gas) 10)

		; Definimos los precios en recursos para la creacion de entidades
		(= (precio Barracones Mineral) 40)
		(= (precio Barracones Gas) 10)
		(= (precio Extractor Mineral) 10)
		(= (precio Extractor Gas) 0)
		(= (precio VCE Mineral) 5)
		(= (precio VCE Gas) 0)
		(= (precio Marine Mineral) 10)
		(= (precio Marine Gas) 15)
		(= (precio Soldado Mineral) 30)
		(= (precio Soldado Gas) 40)

		; Inicializamos las unidades recolectando en las localizaciones de los recursos
		(= (recolectando Mineral loc22) 0)
		(= (recolectando Mineral loc44) 0)
		(= (recolectando Gas loc15) 0)

		;;; TIEMPOS ;;;
		(= (elapsed-time) 0)

		;; Tiempos de recoleccion
		(= (delay-recolectar Mineral) 10)
		(= (delay-recolectar Gas) 5)

		;; Tiempos de creacion
		(= (delay-creacion Barracones) 50)
		(= (delay-creacion Extractor) 20)
		(= (delay-creacion VCE) 10)
		(= (delay-creacion Marine) 20)
		(= (delay-creacion Soldado) 30)

		; Inicializamos las velocidades de las unidades
		(= (speed VCE) 1)
		(= (speed Marine) 5)
		(= (speed Soldado) 10)
	)

	(:goal
		(and
			;; OBJETIVOS:
			;; Marine1 en loc31
			(entidad-en Marine1 loc31)
			;; Marine2 en loc24
			(entidad-en Marine2 loc24)
			;; Soldado1 en loc15
			(entidad-en Soldado1 loc15)
			;; los barracones Barracones1 se deben construir en loc33
			(construido Barracones1)
			(entidad-en Barracones1 loc33)

			;; RESTRINGIMOS EL TIEMPO TRANSCURRIDO
			; (< (elapsed-time) 558)
		)
	)
	(:metric minimize
		(elapsed-time)
	)
)
