(define (problem problema_5)
	(:domain dominio_5)
	(:objects
		loc11 loc12 loc13 loc14 loc15 loc21 loc22 loc23 loc24 loc31 loc32 loc33 loc34 loc42 loc43 loc44 - loc
		CentroDeMando1 Extractor1 Barracones1 Laboratorio1 - edificio
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

		; ubicamos donde estan las entidades
		(entidad-en CentroDeMando1 loc11)
		(entidad-en VCE1 loc11)

		; Inicializamos las unidades como libres
		(libre VCE1)

		; Inicializamos las investigaciones desconocidas
		(desconocido Spartan)

		; Establecemos el tipo de los edificios objeto
		(edificio-es CentroDeMando1 CentroDeMando)
		(edificio-es Extractor1 Extractor)
		(edificio-es Barracones1 Barracones)
		(edificio-es Laboratorio1 Laboratorio)

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
		(recurso-asignado-en Especia loc13)

		; Definimos los materiales necesarios para los diferentes tipos de edificios
		(necesita Extractor Mineral)
		(necesita Barracones Mineral)
		(necesita Barracones Gas)
		(necesita Laboratorio Mineral)
		(necesita Laboratorio Gas)
		; Definimos los materiales necesarios para los diferentes tipos de investigaciones
		(necesita Spartan Mineral)
		(necesita Spartan Gas)
		(necesita Spartan Especia)

		; Definimos los materiales necesarios para los diferentes tipos de unidades
		(necesita VCE Mineral)
		(necesita Marine Mineral)
		(necesita Soldado Mineral)
		(necesita Soldado Gas)
		(necesita Soldado Spartan)
	)

	(:goal
		(and
			;; OBJETIVOS:
			;; Marine1, Marine2 y Soldado1 en loc14
			(entidad-en Marine1 loc14)
			(entidad-en Marine2 loc14)
			(entidad-en Soldado1 loc14)
			;; los barracones Barracones1 se deben construir en loc14
			(construido Barracones1)
			(entidad-en Barracones1 loc14)
			;; el laboratorio Laboratorio 1 se deben construir en loc12
			(construido Laboratorio1)
			(entidad-en Laboratorio1 loc12)
		)
	)
)