(define (domain dominio_3)
	; Definimos los requirements para definir el dominio
	(:requirements :strips :typing :adl :fluents)

	; Definimos los tipos del dominio con la siguiente jerarquia
	; object
	; ├── loc
	; └── entity
	;     ├── recurso
	;     │   ├── Mineral
	;     │   └── Gas
	;     ├── edificio
	;     │   ├── CentroDeMando
	;     │   ├── Barracones
	;     │   └── Extractor
	;     └── unit
	;         └── VCE
	; Hemos definido tres tipos troncales del dominio:
	; - loc: un tipo para la localizacion
	; - entity: un tipo que engloba todo objeto "fisico" en el mundo, esto incluye recursos, edificios y unidades.
	(:types
		loc entidad - object
		edificio unidad recurso - entidad

		; tipos para identificar las constantes
		tipoEdificio - edificio
		tipoRecurso - recurso
		tipoUnidad - unidad
	)
	; El resto de tipos de mayor granularidad los definimos como constantes
	(:constants
		; recursos
		Mineral - tipoRecurso
		Gas - tipoRecurso

		; edificios
		CentroDeMando - tipoEdificio
		Barracones - tipoEdificio
		Extractor - tipoEdificio

		; unidades
		VCE - tipoUnidad
	)

	; Definimos los predicados del dominio
	(:predicates
		; para representar que una entidad (edificio o unidad) esta en un localizacion
		(entidad-en ?e - entidad ?loc - loc)

		; para representar que hay un camino de una localizacion a otra
		(camino ?from ?to - loc)

		; para representar que un edificio esta construido
		(construido ?b - edificio)

		; para representar que un nodo de recurso ha sido asignado a una localizacion
		(recurso-asignado-en ?res - recurso ?loc - loc)

		; para indicar que una unidad (en este caso un VCE) esta extrayendo un recurso
		(extrayendo ?vce - unidad ?res - recurso)

		; para indicar que una unidad no esta extrayendo
		(libre ?unit - unidad)

		; para indicar que recurso necesita un tipo de edificio
		(necesita ?b - tipoEdificio ?res - recurso)

		; para indicar que se posee de un determinado tipo de recurso
		(hay ?res - recurso)

		; para indicar que tipo de edificio es
		(edificio-es ?b - edificio ?tipoed - tipoEdificio)
	)

	; Definimos la serie de acciones que se pueden realizar

	;; Accion: Navegar, mueve una unidad entre dos localizaciones
	;; Parametros: Unidad, Localizacion origen, Localizacion destino
	(:action Navegar
		:parameters (?unit - unidad ?from ?to - loc)
		:precondition (and
			;;; la unidad debe de estar en la localizacion origen
			(entidad-en ?unit ?from)
			;;; la unidad no debe estar en la localizacion destino
			(not (entidad-en ?unit ?to))
			;;; debe de existir un camino al destino desde el origen
			(camino ?from ?to)
			;;; la unidad debe de estar libre, es decir, no debe
			;;; estar extrayendo ningun recurso
			(libre ?unit)
		)
		:effect (and
			;;; la unidad ahora esta en la localizacion destino
			(entidad-en ?unit ?to)
			;;; la unidad deja de estar en la localizacion origen
			(not (entidad-en ?unit ?from))
		)
	)

	;; Accion: Asignar, asigna un VCE a un nodo de recurso. Ademas, en este ejercicio sera suficiente
	;; Asignar un unico VCE a un unico nodo de recursos de un tipo (mineral o gas vespeno) para tener
	;; ilimitados recursos de ese tipo.
	;; Parametros: Unidad, Localizacion de recurso
	(:action Asignar
		:parameters (?vce - unidad ?loc - loc)
		:precondition (and
			;;; el VCE tiene que estar en la localizacion del recurso
			(entidad-en ?vce ?loc)
			;;; el VCE no debe de estar extrayendo ningun recurso, debe estar libre
			(libre ?vce)
			;;; debe de existir un recurso asignado en esa localizacion
			(exists
				(?res - recurso)
				(recurso-asignado-en ?res ?loc))

			;;; Si hay Gas Vespano en la localizacion, entonces debe haber un
			;;; Extractor en esa la localizacion:
			;;; recurso-en(Gas,loc) -> entidad-en(Extractor,loc) === not recurso-en(Gas,loc) \/ entidad-en(Extractor, loc)
			(or
				(not (recurso-asignado-en Gas ?loc))
				(exists
					(?b - edificio)
					(and (edificio-es ?b Extractor) (construido ?b) (entidad-en ?b ?loc))
				)
			)
		)
		:effect (and
			;;; el VCE deja de estar libre
			(not (libre ?vce))
			;;; el VCE pasa a estar extrayendo el recurso
			;;;; Si es Gas Vespeno
			(when
				(recurso-asignado-en Gas ?loc)
				(and
					(extrayendo ?vce Gas)
					(hay Gas)))
			;;;; Si es Mineral
			(when
				(recurso-asignado-en Mineral ?loc)
				(and
					(extrayendo ?vce Mineral)
					(hay Mineral)))
		)
	)

	;; Accion: Construir, ordena a un VCE libre que construya un edificio en una localización
	;; Parametros: Unidad, Edificio, Localizacion.
	(:action Construir
		:parameters (?vce - unidad ?b - edificio ?loc - loc)
		:precondition (and
			;; la unidad debe de estar libre
			(libre ?vce)
			;; la unidad debe de estar en la localizacion
			(entidad-en ?vce ?loc)
			;; el edificio que hay que construir no debe de estar ya construido
			(not (construido ?b))

			;; no hay otro edificio en esa localizacion
			(not (exists
					(?other - edificio)
					(entidad-en ?other ?loc)))

			;; se poseen todos los recursos necesarios para construir el edificio
			;;; se iteran todos los recursos
			(forall
				(?res - recurso)
				(exists
					(?t - tipoEdificio)
					(and
						;;; filtramos para el tipo de nuestro edificio
						(edificio-es ?b ?t)
						;;; si el edificio necesita ese recurso,
						;;; entonces tenemos que poseer tal recurso.
						;;; De manera, contraria si no lo necesita podemos no poseer el recurso
						(imply
							(necesita ?t ?res)
							(hay ?res)))))
		)
		:effect (and
			;; El edificio se ha construido
			(construido ?b)
			;; El edificio ademas se encuentra en la localizacion
			(entidad-en ?b ?loc)
		)
	)

)