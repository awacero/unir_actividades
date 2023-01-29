(define (problem package-transport)
(:domain package-transport)
(:objects


port-1 factory-1 factory-2 store-1 - location
train-1 - train
p1 p2 p3 p4 p5 p6 p7 p8 - package
)
(:init
(= (train_capacity) 4)
(= (location_capacity) 3)

(= (train_ocupation) 0)
(= (location_ocupation) 0)

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
;(at_train train-1 store-1)

(at p1 port-1)
(at p2 port-1)
(at p3 port-1)

(at p4 port-1)
(at p5 port-1)
(at p6 port-1)
(at p7 port-1)
(at p8 port-1)
(is_raw p1)
(is_raw p2)
(is_raw p3)
(is_raw p4)
(is_raw p5)
(is_raw p6)
(is_raw p7)
(is_raw p8)






)

(:goal
(and

;(is_processed p1)
;(is_processed p2)
;(is_processed p3)
;(is_processed p4)
;(is_processed p5)
;(is_processed p6)

(is_stored p1)
(is_stored p2)
(is_stored p3)
(is_stored p4)
(is_stored p5)
;(is_stored p6)
;(is_stored p7)
;(is_stored p8)

;(at_train train-1 port-1)
)
)
;(:metric minimize (total-cost))
)