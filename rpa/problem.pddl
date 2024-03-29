(define (problem package-transport)
(:domain package-transport)
(:objects

;Definir los objetos que se usaran en el problema
port-1 factory-1 factory-2 store-1 - location
train-1 - train
p1 p2 p3 p4 p5 p6 p7 p8 - package
capacity-0 capacity-1 capacity-2  capacity-3  capacity-4  - capacity-number

)

;Definir las condiciones iniciales
;El tren puede ir en ambas direcciones 
;El tren se encuentra inicialmente en el puerto 
(:init

(is_factory factory-1)
(is_factory factory-2)
(is_store store-1)

(road port-1 factory-1 )
(road factory-1 factory-2)
(road factory-2 store-1)
(road store-1 port-1)

(road port-1 store-1)
(road store-1 factory-2)
(road factory-2 factory-1)
(road factory-1 port-1)

(at_train train-1 port-1)

;Todos los paquetes estan en el puerto
(at p1 port-1)
(at p2 port-1)
(at p3 port-1)
(at p4 port-1)
(at p5 port-1)
(at p6 port-1)
(at p7 port-1)
(at p8 port-1)

;Todos los paquetes tienen el estado raw (sin procesar)
(is_raw p1)
(is_raw p2)
(is_raw p3)
(is_raw p4)
(is_raw p5)
(is_raw p6)
(is_raw p7)
(is_raw p8)

;Definicion de las capacidades 
(capacity-predecessor capacity-0 capacity-1)
(capacity-predecessor capacity-1 capacity-2)
(capacity-predecessor capacity-2 capacity-3)
(capacity-predecessor capacity-3 capacity-4)

;Capacidad del tren y de las fabricas
(capacity_train train-1 capacity-3)
(capacity_location factory-1 capacity-2)
(capacity_location factory-2 capacity-3)
)

;El objetivo es que todos los paquetes esten almacenados luego de ser procesados 
(:goal
(and

(is_stored p1)
(is_stored p2)
(is_stored p3)
(is_stored p4)
(is_stored p5)
(is_stored p6)
(is_stored p7)
(is_stored p8)

;(at_train train-1 factory-1)
)
)

)