(define (domain package-transport)
  (:requirements :typing   :negative-preconditions :conditional-effects 
  :disjunctive-preconditions
  )

  (:types
    location train package operation ;- object
    capacity-number ;- object

    )
;Predicados usados 
;los predicados is_raw, is_processed, is_stored se usan para determinar el estado del paquete
;los predicados is_factory e is_store se usan para determinar el lugar ya que de eso depende 
;la capacidad y el estado que tendra el paquete
;los predicados capacity_location y capacity_train se usan para determinar la capacidad del tren y las fabricas
  (:predicates
    (road ?l1 ?l2 - location)
    (at ?package - package ?location - location)
    (at_train ?train -train ?location - location)
    (is_raw ?package - package)
    (is_processed ?package - package)
    (is_stored ?package -package)
    (on ?package - package ?train -train)
    (on_factory ?package ?location)
    (on_store ?package ?location)

    (is_factory ?location - location)
    (is_store ?location -location)
    (capacity_train ?t - train ?s1 - capacity-number)
    (capacity_location ?l - location ?s1 - capacity-number)
    (capacity-predecessor ?s1 ?s2 - capacity-number)

  )

;La accion load_train_port_store carga un paquete que se encuentre en el puerto o en el store-1
;Solamente se modifica la capacidad del tren
  (:action load_train_port_store
    :parameters (?package - package ?train - train ?l1  - location ?s1 ?s2 - capacity-number)
    :precondition (and
      (at ?package ?l1)
      (at_train ?train ?l1)
      (not(is_factory ?l1))
      (not(is_stored ?package))
      (capacity-predecessor ?s1 ?s2)
      (capacity_train ?train ?s2)
      ;;;(not (on ?package ?train))
      )
    :effect (and
      (on ?package ?train)
      (not(at ?package ?l1)) ;indispensable para que llame a load
      (capacity_train ?train ?s1)
      (not (capacity_train ?train ?s2))
    )
  )

;La accion load_train_factory carga un paquete que se encuentre en la fabrica 1 o 2. 
;Como la capacidad de las fabricas es limitada se modifica su capacidad y la del tren

  (:action load_train_factory
    ;cargar paquetes desde la fabrica
    :parameters (?package - package ?train - train ?location - location ?s1 ?s2 - capacity-number)
    :precondition (and
      ;;;(at ?package ?location)
      (on_factory ?package ?location)
      (at_train ?train ?location)
      ;(is_processed ?package)##
      (is_factory ?location)
      (capacity-predecessor ?s1 ?s2)
      (capacity_train ?train ?s2)      
      (capacity_location ?location ?s1)
      )
    
    :effect (and
      (on ?package ?train)
      (not(at ?package ?location)) ;indispensable para que llame a load
      (capacity_train ?train ?s1)
      (not (capacity_train ?train ?s2))
      (capacity_location ?location ?s2)
      (not (capacity_location ?location ?s1))

    )
  )
;La accion unload_train_to_factory descarga un paquete que se encuentre en la fabrica 1 o 2. 
;Como la capacidad de las fabricas es limitada se modifica su capacidad y la del tren
;Luego de descargar el tren en la fabrica, se asume que el paquete fue procesado
  (:action unload_train_to_factory
    :parameters (?package - package ?train - train ?l1 - location ?s1 ?s2 - capacity-number )
    :precondition (and
      (is_raw ?package)
      (is_factory ?l1)
      (on ?package ?train)
      (at_train ?train ?l1)
      (capacity-predecessor ?s1 ?s2)
      (capacity_train ?train ?s1)    
      (capacity_location ?l1 ?s2)
    )
    :effect (and
      (on_factory ?package ?l1)
      (is_processed ?package);descargar el paquete equivaldria a procesarlo

      (not (on ?package ?train));
      (capacity_train ?train ?s2)
      (not (capacity_train ?train ?s1))
      (capacity_location ?l1 ?s1)
      (not (capacity_location ?l1 ?s2))

    )
  )

;La accion unload_train_store descarga un paquete que se encuentre en el tren al store-1
;Como el almacen tiene capacidad infinita, solamente se modifica la capacidad del tren 
;;Luego de descargar el tren en el almacen, se asume que el paquete fue almacenado


  (:action unload_train_store
    :parameters (?package - package ?train - train ?location - location ?s1 ?s2 - capacity-number)
    :precondition (and
      (on ?package ?train)
      (at_train ?train ?location)
      ;;(is_processed ?package)
      (or (is_processed ?package) (is_raw ?package))
      (is_store ?location)
      (capacity-predecessor ?s1 ?s2)
      (capacity_train ?train ?s1) 
    )
    :effect 
    (and 
    (on_store ?package ?location)
      ;;;(is_stored ?package)
      ;(not(on ?package ?train))
      (not (on ?package ?train));
        (capacity_train ?train ?s2)
        (not (capacity_train ?train ?s1))

        (when (is_processed ?package) (is_stored ?package))
        (when (is_raw ?package) (at ?package ?location ))


    )
    
  )

;Mueve el tren de una localizacion a otra
  (:action move-train
    :parameters (?t - train ?l1 - location ?l2 - location)
    :precondition (and
      (at_train ?t ?l1)
      (road ?l1 ?l2)

    )
    :effect (and
      (not (at_train ?t ?l1))
      (at_train ?t ?l2)
    )
  )



)