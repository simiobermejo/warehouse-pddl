(define (domain warehouse)
    (:requirements :strips :typing :fluents :equality :negative-preconditions)

    (:types
        base proom warehouse - location
        location package - object
    )

    (:predicates
        (finished) ;goal predicate
        (end-delivery) ;robot is at base and all packages are delivered
        (robot-at ?l - location) ;robot is at location l
        (processed ?p - package) ;package p is processed
        (processing ?p - package) ;package p is being processed
        (package-at ?p - package ?l - location) ;package p is at location l
    )

    (:functions
        (time) ;current time in minutes
        (packages) ;number of packages being processed
        (max-packages) ;maximum number of packages that can be processed at the same time
        (battery-level) ;battery level in percentage
        (processing-time ?p - package) ;processing time in minutes
        (processing-energy ?p - package) ;energy consumption in percentage
        (end-processing-time ?p - package) ;end time of processing in minutes
        (distance ?l1 - location ?l2 - location) ;distance between two locations battery terms
        (time-from ?l1 - location ?l2 - location) ;time to move between two locations in minutes
    )

    (:action robot_move
        :parameters (?l1 ?l2 - location)
        :precondition (and
            (robot-at ?l1) ;robot is at location l1
            (not (= ?l1 ?l2)) ;robot is not at location l2
            (>= (battery-level) (distance ?l1 ?l2))) ;battery level is enough to move to l2
        :effect (and
            (robot-at ?l2) ;robot is at location l2
            (not (robot-at ?l1)) ;robot is not at location l1
            (increase (time) (time-from ?l1 ?l2)) ;time is increased by the time to move from l1 to l2
            (decrease (battery-level) (distance ?l1 ?l2))) ;battery level is decreased by the distance between l1 and l2
    )

    (:action robot_wait_at_base_charging
        :parameters ()
        :precondition (and
            (robot-at base) ;robot is at base
            (= (packages) 0) ;robot is not processing any package
            (< (battery-level) 100)) ;battery level is less than 100
        :effect (and
            (increase (time) 5) ;time is increased by 5 minutes
            (increase (battery-level) 10)) ;battery level is increased by 10%
    )

    (:action robot_wait_at_base
        :parameters ()
        :precondition (and
            (robot-at base) ;robot is at base
            (= (packages) 0)) ;robot is not processing any package
        :effect (and
            (increase (time) 5)) ;time is increased by 5 minutes
    )

    (:action robot_pickup
        :parameters (?p - package ?l - location)
        :precondition (and
            (robot-at ?l) ;robot is at location l
            (package-at ?p ?l) ;package p is at location l
            (not (processing ?p)) ;package p is not being processed
            (< (time) (end-processing-time ?p))
            (> (max-packages) (packages))) ;maximum number of packages being processed is less than the maximum number of packages that can be processed at the same time
        :effect (and
            (processing ?p) ;package p is being processed
            (increase (time) 5) ;time is increased by 5 minutes
            (increase (packages) 1) ;number of packages being processed is increased by 1
            (not (package-at ?p ?l)) ;package p is not at location l
            (decrease (battery-level) 3)) ;battery level is decreased by 3%
    )

    (:action process_package
        :parameters (?p - package)
        :precondition (and
            (processing ?p) ;package p is being processed
            (robot-at proom) ;robot must be at processing room
            (> (battery-level) (processing-energy ?p)) ;enough battery for processing package
            (> (- (end-processing-time ?p) (time)) (processing-time ?p))) ;enough time for processing package
        :effect (and
            (processed ?p) ;package p is processed
            (not (processing ?p)) ;package p is not being processed
            (decrease (packages) 1) ;number of packages being processed is decreased by 1
            (increase (time) (processing-time ?p)) ;time is increased by the processing time of package p
            (decrease (battery-level) (processing-energy ?p))) ;battery level is decreased by the energy consumption of package p
    )

    (:action robot_end_processing
        :parameters (?l1 - location)
        :precondition (and
            (not (robot-at base)) ;robot is not at base
            (forall
                (?p - package)
                (processed ?p)) ;all packages are processed
            (robot-at ?l1) ;robot at location 
            (>= (battery-level) (distance ?l1 base))); enough battery to move to base
        :effect (and
            (robot-at base) ;robot to base
            (end-delivery) ;end delivery
            (not (robot-at ?l1)) ;robot is not at location l1
            (increase (time) (time-from ?l1 base)) ;time is increased by the time to move from l1 to base
            (decrease (battery-level) (distance ?l1 base))) ;battery level is decreased by the distance between l1 and base
    )

    (:action end_schedule
        :parameters ()
        :precondition (and
            (end-delivery)) ; if delivery has ended
        :effect (and 
            (finished)) ;finish the program (action only for beautyful printing) 
    )
    
    (:action robot_reschedule_processing
        :parameters (?p - package)
        :precondition (and
            (not (processed ?p))
            (< (- (end-processing-time ?p) (time)) (processing-time ?p))) ;time left to finish processing package p is less than 15 minutes
        :effect (and
            (increase (time) 10) ;loose 10 minutes in perform rescheduling to avoid this action
            (increase (end-processing-time ?p) 60)) ;end time of processing package p is increased by 60 minutes
    )

    (:action robot_drop_off
        :parameters (?p - package ?l - location)
        :precondition (and
            (robot-at ?l) ;robot is at location l
            (processing ?p) ;package p is processed
            (not (package-at ?p ?l))) ;package p is not at location l
        :effect (and
            (package-at ?p ?l) ;package p is at location l
            (increase (time) 5) ;time is increased by 5 minutes
            (not (processing ?p)) ;package p is not processed
            (decrease (battery-level) 3)) ;battery level is increased by 3%
    )
)