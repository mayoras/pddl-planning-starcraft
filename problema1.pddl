(define (problem problema_1)
	(:domain dominio_1)
	(:objects
		loc11 loc12 loc13 loc14 loc15 loc21 loc22 loc23 loc24 loc31 loc32 loc33 loc34 loc42 loc43 loc44 - loc
		CentroDeMando1 - edificio
		VCE1 - unidad
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

		; en loc11 debe de encontrarse el CentroDeMando1 y la unidad VCE1
		(entidad-en CentroDeMando1 loc11)
		(entidad-en VCE1 loc11)

		; la unidad VCE1 no esta asignada
		(libre VCE1)

		; existen dos recursos de tipo mineral en loc24 y en loc44
		(recurso-asignado-en Mineral loc24)
		(recurso-asignado-en Mineral loc44)
	)

	(:goal
		(and
			;; OBJETIVO: generar recursos de mineral
			;; Para ello se debe cumplir que: extrayendo(VCE1, Mineral)
			(extrayendo VCE1 Mineral)
		)
	)
)