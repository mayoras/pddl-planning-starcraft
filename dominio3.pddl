(define (domain dominio_2)
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

		; para indicar que recurso necesita un determinado edificio
		(necesita-recurso ?b - edificio ?res - recurso)

		; para indicar que se posee de un determinado tipo de recurso
		(hay-recurso ?res - tipoRecurso)

		; para indicar que tipo de edificio es
		(edificio-es ?b - edificio ?tipoed - tipoEdificio)
	)

	; Definimos la serie de acciones que se pueden realizar

	;; Accion: NAVEGAR, mueve una unidad entre dos localizaciones
	;; Parametros: Unidad, Localizacion origen, Localizacion destino
	(:action NAVEGAR
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

	;; Accion: ASIGNAR, asigna un VCE a un nodo de recurso. Ademas, en este ejercicio sera suficiente
	;; asignar un unico VCE a un unico nodo de recursos de un tipo (mineral o gas vespeno) para tener
	;; ilimitados recursos de ese tipo.
	;; Parametros: Unidad, Localizacion de recurso, Tipo de recurso
	(:action ASIGNAR
		:parameters (?vce - unidad ?loc - loc ?res - recurso)
		:precondition (and
			;;; el VCE tiene que estar en la localizacion del recurso
			(entidad-en ?vce ?loc)
			;;; el recurso debe de estar asignado a tal localizacion
			(recurso-asignado-en ?res ?loc)
			;;; el VCE no debe de estar extrayendo ningun recurso, debe estar libre
			(libre ?vce)

			;;; Si hay Gas Vespano en la localizacion, entonces debe haber un
			;;; Extractor en esa la localizacion:
			;;; recurso-en(Gas,loc) -> entidad-en(Extractor,loc) === not recurso-en(Gas,loc) \/ entidad-en(Extractor, loc)
			(or
				(not (recurso-asignado-en Gas ?loc))
				(exists
					(?b - edificio)
					(and (edificio-es ?b Extractor) (entidad-en ?b ?loc))
				)
			)
		)
		:effect (and
			;;; el VCE deja de estar libre
			(not (libre ?vce))
			;;; el VCE pasa a estar extrayendo el recurso
			(extrayendo ?vce ?res)
			;;; se extrae recurso, luego se posee de tal recurso
			(hay-recurso ?res)
		)
	)

	;; Accion: CONSTRUIR, ordena a un VCE libre que construya un edificio en una localización
	;; Parametros: Unidad, Edificio, Localizacion, Recurso
	(:action CONSTRUIR
		:parameters (?vce - unidad ?b - edificio ?loc - loc ?res - recurso)
		:precondition (and
			;; La unidad debe de estar libre
			(libre ?vce)
			;; La unidad debe de estar en la localizacion
			(entidad-en ?vce ?loc)
			;; El edificio que hay que construir no debe de estar ya construido
			(not (construido ?b))
			;; El edificio necesita el recurso
			(necesita-recurso ?b ?res)
			;; se posee tal recurso
			(hay-recurso ?res)
		)
		:effect (and
			;; El edificio se ha construido
			(construido ?b)
			;; El edificio ademas se encuentra en la localizacion
			(entidad-en ?b ?loc)
		)
	)
)