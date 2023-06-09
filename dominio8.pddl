(define (domain dominio_8)
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
	;         ├── VCE
	;         ├── Soldado
	;         └── Marine
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
		Marine - tipoUnidad
		Soldado - tipoUnidad
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

		; para indicar que se posee de un determinado tipo de recurso
		(hay ?res - recurso)

		; para indicar que tipo de edificio es
		(edificio-es ?b - edificio ?tipoed - tipoEdificio)

		; para indicar que tipo de unidad es
		(unidad-es ?unit - unidad ?tipounit - tipounidad)
	)

	; Definimos las funciones numericas
	(:functions
		; funcion stock(recurso): numero almacenado de un recurso
		(stock ?res - recurso)
		; funcion max-cap(recurso): Capacidad maxima de stock de un recurso
		(max-cap ?res - recurso)
		; funcion extract-rate(recurso): Tasa de extraccion de un recurso
		(extract-rate ?res - recurso)
		; funcion precio(entidad, recurso): Precio en recursos para crear una entidad
		(precio ?ent - entidad ?res - recurso)
		; funcion recolectando(recurso, loc): Numero de VCEs recolectando un recurso en una loc
		(recolectando ?res - recurso ?loc - loc)

		;;; TIEMPOS ;;;
		; funcion elapsed-time(): tiempo total transcurrido
		(elapsed-time)
		; funcion delay-recolectar(recurso): tiempo necesario para recolectar un recurso
		(delay-recolectar ?res - recurso)
		; funcion delay-creacion(entidad): tiempo necesario para crear una entidad nueva
		(delay-creacion ?ent - entidad)
		;;;;;;;

		; funcion distancia(from, to): distancia entre dos localizacion cualesquiera
		(distancia ?from ?to - loc)

		; funcion speed(unidad): velocidad de una unidad
		(speed ?unit - unidad)
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

			;;; Incrementamos el tiempo necesario para navegar la unidad
			; Si es VCE
			(when
				(unidad-es ?unit VCE)
				(increase
					(elapsed-time)
					(/ (distancia ?from ?to) (speed VCE))))
			; Si es Marine
			(when
				(unidad-es ?unit Marine)
				(increase
					(elapsed-time)
					(/ (distancia ?from ?to) (speed Marine))))
			; Si es Soldado
			(when
				(unidad-es ?unit Soldado)
				(increase
					(elapsed-time)
					(/ (distancia ?from ?to) (speed Soldado))))
		)
	)

	;; Accion: Asignar, asigna un VCE a un nodo de recurso. Ademas, en este ejercicio sera suficiente
	;; asignar un unico VCE a un unico nodo de recursos de un tipo (mineral o gas vespeno) para tener
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
					(hay Gas)
					;;; Se incrementa el numero de VCEs recolectando en dicha localizacion
					(increase (recolectando Gas ?loc) 1)))
			;;;; Si es Mineral
			(when
				(recurso-asignado-en Mineral ?loc)
				(and
					(extrayendo ?vce Mineral)
					(hay Mineral)
					;;; Se incrementa el numero de VCEs recolectando en dicha localizacion
					(increase (recolectando Mineral ?loc) 1)))
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

			;; se poseen todos los recursos y su cantidad necesaria para construir el edificio
			;;; se iteran todos los recursos
			(forall
				(?res - recurso)
				(exists
					(?t - tipoEdificio)
					(and
						;;; filtramos para el tipo de nuestro edificio
						(edificio-es ?b ?t)
						;;; comprobamos que hay stock para satisfacer el precio
						;;; de construccion
						(>= (stock ?res) (precio ?t ?res)))))
		)
		:effect (and
			;; El edificio se ha construido
			(construido ?b)
			;; El edificio ademas se encuentra en la localizacion
			(entidad-en ?b ?loc)
			;; Al construir, se consumen los recursos necesarios para su construccion
			;; asi como el tiempo necesario para construirlo
			;;; Para Barracones
			(when
				(edificio-es ?b Barracones)
				(and
					(decrease
						(stock Mineral)
						(precio Barracones Mineral))
					(decrease (stock Gas) (precio Barracones Gas))
					(increase
						(elapsed-time)
						(delay-creacion Barracones))))
			;;; Para Extractor
			(when
				(edificio-es ?b Extractor)
				(and
					(decrease
						(stock Mineral)
						(precio Extractor Mineral))
					(decrease (stock Gas) (precio Extractor Gas))
					(increase
						(elapsed-time)
						(delay-creacion Extractor))))
		)
	)

	; Accion: Reclutar, para disponer de nuevas unidades.
	; Parametros: Edificio, Unidad, Localizacion
	(:action Reclutar
		:parameters (?b - edificio ?unit - unidad ?loc - loc)
		:precondition (and
			; La unidad no puede estar en ninguna localizacion hasta que se reclute
			(not (exists
					(?lloc - loc)
					(entidad-en ?unit ?lloc)))

			; Ya sean VCEs, Marines o Soldados, estos se deben de reclutar o en CentroDeMando
			; o en Barracones
			(or (edificio-es ?b CentroDeMando) (edificio-es ?b Barracones))

			; el edificio debe de estar construido
			(construido ?b)

			; el edificio debe de estar en la localizacion deseada
			(entidad-en ?b ?loc)

			; si el edificio es CentroDeMando entonces la unidad a reclutar debe ser VCE
			(imply
				(edificio-es ?b CentroDeMando)
				(or (unidad-es ?unit VCE)))

			; si el edificio es Barracones entonces la unidad a reclutar debe ser Marine o Soldado
			(imply
				(edificio-es ?b Barracones)
				(or (unidad-es ?unit Soldado) (unidad-es ?unit Marine)))

			; comprobamos que para la unidad poseemos de los recursos necesarios y su cantidad necesaria para el reclutamiento
			(forall
				(?res - recurso)
				(exists
					(?t - tipoUnidad)
					(and
						;;; filtramos para el tipo de nuestra unidad
						(unidad-es ?unit ?t)
						;;; comprobamos que hay stock para satisfacer el precio
						;;; de reclutamiento
						(>= (stock ?res) (precio ?t ?res)))))
		)

		:effect (and
			; al ser reclutado la unidad se invoca en la localizacion de reclutamiento
			(entidad-en ?unit ?loc)
			; ademas, esta libre para hacer tareas
			(libre ?unit)
			;; Al reclutar, se consumen los recursos necesarios para su reclutamiento
			;; asi como el tiempo necesario para reclutarlos
			;;; Para VCE
			(when
				(unidad-es ?unit VCE)
				(and
					(decrease (stock Mineral) (precio VCE Mineral))
					(decrease (stock Gas) (precio VCE Gas))
					(increase (elapsed-time) (delay-creacion VCE))))
			;;; Para Marine
			(when
				(unidad-es ?unit Marine)
				(and
					(decrease (stock Mineral) (precio Marine Mineral))
					(decrease (stock Gas) (precio Marine Gas))
					(increase (elapsed-time) (delay-creacion Marine))))
			;;; Para Soldado
			(when
				(unidad-es ?unit Soldado)
				(and
					(decrease
						(stock Mineral)
						(precio Soldado Mineral))
					(decrease (stock Gas) (precio Soldado Gas))
					(increase (elapsed-time) (delay-creacion Soldado))))
		)
	)

	; Accion: Recolectar, para extraer recursos de un nodo y almacenarlos.
	; Parametros: Recurso, Localizacion
	(:action Recolectar
		:parameters (?res - recurso ?loc - loc)
		:precondition (and
			; el recurso debe de estar asignado en la localizacion
			(recurso-asignado-en ?res ?loc)

			; se debe de estar extrayendo el recurso
			(hay ?res)

			; en la localizacion hay un VCE asignado y esta extrayendo el recurso
			(exists
				(?vce - unidad)
				(and
					(unidad-es ?vce VCE)
					(entidad-en ?vce ?loc)
					(extrayendo ?vce ?res)
					(not (libre ?vce))))

			; el stock del recurso mas el que se recolectara por cada VCE
			; recolectando debe ser menor o igual a la maxima capacidad de
			; stock de ese recurso
			(<=
				(+
					(stock ?res)
					(* (extract-rate ?res) (recolectando ?res ?loc))
				)
				(max-cap ?res))
		)
		:effect (and
			; incrementar el stock del recurso por su tasa de extraccion
			(increase
				(stock ?res)
				(* (extract-rate ?res) (recolectando ?res ?loc)))

			; incrementar el tiempo de recoleccion
			; notese que no incrementamos el tiempo que toma recolectar por cada VCE
      ; sumamos el tiempo de recoleccion de los VCE en el nodo
			(increase (elapsed-time) (* (recolectando ?res ?loc) (delay-recolectar ?res)))
		)
	)

)
