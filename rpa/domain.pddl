(define (domain package-transport)
  (:requirements :typing :fluents :negative-preconditions :conditional-effects)

  (:types
    location train package operation ;- object
    )

  (:predicates
    (road ?l1 ?l2 - location)
    (at ?package - package ?location - location)
    (at_train ?train -train ?location - location)
    (is_raw ?package - package)
    (is_processed ?package - package)
    (is_stored ?package -package)

    (stored ?package - package)
    (processed ?package - package)

    (on ?package - package ?train -train)
    (on_factory ?package ?location)
    (on_store ?package ?location)

    (is_factory ?location - location)
    (is_store ?location -location)

  )

  (:functions
    (train_capacity)
    (location_capacity)
    (train_ocupation)
    (location_ocupation)
  )

;CARGAR EL TREN Y MOVERSE?
  (:action load_train_port_store
    :parameters (?package - package ?train - train ?l1  - location)
    :precondition (and
      (at ?package ?l1)
      (at_train ?train ?l1)
      (not(is_factory ?l1))
      (not(is_stored ?package))
      (< (train_ocupation)(train_capacity))
      (not (on ?package ?train))
      )
    :effect (and
      (on ?package ?train)
      ;(at_train ?train ?l2)
      ;(not(at ?package ?l1))
      (increase(train_ocupation) 1)
    )
  )

  (:action load_train_factory
    ;cargar paquetes desde la fabrica
    :parameters (?package - package ?train - train ?location - location)
    :precondition (and
      ;;;(at ?package ?location)
      (on_factory ?package ?location)
      (at_train ?train ?location)
      ;(is_processed ?package)##
      (is_factory ?location)
      (< (train_ocupation)(train_capacity))
      ;(not (on ?package ?train))
      )
    
    :effect (and
      (on ?package ?train)
      ;(not(at_train ?train ?location))
      (increase (train_ocupation) 1)
      (increase (location_ocupation) 1)

    )
  )

  (:action unload_train_to_factory
    :parameters (?package - package ?train - train ?l1 - location )
    :precondition (and
      (is_raw ?package)
      (is_factory ?l1)
      (on ?package ?train)
      (at_train ?train ?l1)
      
      ;(not (processed ?package) )
      ;(not (stored ?package))
      (< (location_ocupation) (location_capacity))
    )
    :effect (and
      (on_factory ?package ?l1)
      (is_processed ?package)

      (not (on ?package ?train));complica todo
      ;(processed ?package) ;;descargar el paquete equivaldria a procesarlo
      (decrease (train_ocupation) 1)
      (increase (location_ocupation) 1)

    )
  )

  (:action unload_train_store
    :parameters (?package - package ?train - train ?location - location)
    :precondition (and
      (on ?package ?train)
      (at_train ?train ?location)
      (is_processed ?package)
      (is_store ?location)
    )
    :effect (and
      (on_store ?package ?location)
      ;(at ?package ?location)
      ;(at ?package ?l2)
      
      ;(not(on ?package ?train))
      ;(stored ?package)
      (decrease (train_ocupation) 1)

    )
  )

  (:action process_package
    :parameters (?p - package ?t -train ?l - location)
    :precondition (and
        (is_raw ?p)
        (is_factory ?l)
        (on_factory ?p ?l)
        (on ?p ?t)
        (at_train ?t ?l)  
    )
    :effect (and
      (is_processed ?p)

    )
  )

  (:action store_package
    :parameters (?p - package ?t -train ?l -location)
    :precondition (and
      (is_processed ?p);el paquete debe haber sido procesado en una fabrica
      (is_store ?l);verificar que el lugar sea un almacen
      (on_store ?p ?l);que el paquete este en el almacen
      ;;(on ?p ?t); 
      ;;(at_train ?t ?l )
      ;(at ?p ?l); el tren debe estar en l y p en l
      
    )
    :effect (and
      
      (is_stored ?p)
      ;(at_train ?t ?l2)
      ;(not(on ?p ?t))
      ;(at ?p ?l)
    )
  )
  



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