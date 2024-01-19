(define (domain warehouse)
	(:requirements :strips :typing :fluents :equality :negative-preconditions)

	(:types
		base warehouse proom - location
		location package - object
	)


    (:predicates
        (robot_at ?l - location)
        (package_at ?p - package ?l - location)

        (processing ?p - package)
    )


    (:functions
        (battery-level)
        (max-packages)
        (time)

        (distance ?l1 - location ?l2 - location)
        (time-from ?l1 - location ?l2 - location)
        (processing-time ?p - package)
        (processing-energy ?p - package)
        (end-processing-time ?p - package)
    )


    (:action robot_move
        :parameters (?l1 ?l2 - location)
        :precondition (and 
            (robot_at ?l1)
            (not (= ?l1 ?l2))
            (<= (battery-level) (distance ?l1 ?l2)))
        :effect (and 
            (not (robot_at ?l1))
            (robot_at ?l2)
            (decrease (battery-level) (distance ?l1 ?l2))
            (increase (time) (time-from ?l1 ?l2)))
    )

    
    (:action robot_wait_at_base_charging
        :parameters ()
        :precondition (and 
            (robot_at base)
            (= (packages) 0))
        :effect (and 
            (increase (battery_level) 10)
            (increase (time) 5))
    )


    (:action robot_wait_at_base
        :parameters ()
        :precondition (and 
            (robot_at base)
            (= (packages) 0))
        :effect (and (increase (time) 5))
    )


    (:action robot_pickup
        :parameters (?p - package ?l - location)
        :precondition (and 
            (robot_at ?l)
            (package_at ?p ?l)
            (not (processing ?p))
            (< (max-packages) (packages)))
        :effect (and 
            (not (package_at ?p ?l))
            (processing ?p)
            (increase (time) 5)
            (increase (packages) 1)
            (decrease (battery-level) 3))
    )


    (:action process_package
        :parameters (?p - package)
        :precondition (and 
            (robot_at proom)
            (processing ?p))
        :effect (and 
            (not (processing ?p))
            (processed ?p)
            (increase (time) (processing-time ?p))
            (decrease (packages) 1)
            (decrease (battery-level) (processing-energy ?p)))
    )


    (:action robot_end_processing
        :parameters (?l1 - location)
        :precondition (and 
            (forall (?p - package) (processed ?p))
            (not (robot_at base)))
        :effect (and 
            (robot_at base)
            (not (robot_at ?l1))
            (decrease (battery-level) (distance ?l1 base))
            (increase (time) (time-from ?l1 base)))
    )
)