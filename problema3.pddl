(define (problem problema_3)
	(:domain dominio_3)
	(:objects
		loc11 loc12 loc13 loc14 loc15 loc21 loc22 loc23 loc24 loc31 loc32 loc33 loc34 loc42 loc43 loc44 - loc
		CentroDeMando1 Extractor1 Barracones1 - edificio
		VCE1 VCE2 VCE3 - unidad
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

		; en loc11 debe de encontrarse el CentroDeMando1 y las unidades VCE1 y VCE2
		(entidad-en CentroDeMando1 loc11)
		(entidad-en VCE1 loc11)
		(entidad-en VCE2 loc11)
		(entidad-en VCE3 loc11)

		; Inicializamos las unidades como libres
		(libre VCE1)
		(libre VCE2)
		(libre VCE3)

		; Establecemos el tipo de los edificios objeto
		(edificio-es CentroDeMando1 CentroDeMando)
		(edificio-es Extractor1 Extractor)
		(edificio-es Barracones1 Barracones)

		; indicamos los edificios construidos
		(construido CentroDeMando1)

		; Inicializamos la localizacion de los recursos
		(recurso-asignado-en Mineral loc24)
		(recurso-asignado-en Mineral loc44)
		(recurso-asignado-en Gas loc15)

		; Definimos los materiales necesarios para los diferentes tipos de edificios
		(necesita Extractor Mineral)
		(necesita Barracones Mineral)
		(necesita Barracones Gas)
	)

	(:goal
		(and
			;; OBJETIVO: Construir Barracones1
			(and (construido Barracones1) (entidad-en Barracones1 loc34))
		)
	)
)