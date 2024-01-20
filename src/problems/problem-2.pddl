(define (problem p2-warehouse)
    (:domain warehouse)
    (:objects
        p0 - package
        p1 - package

        w1 - warehouse
        w2 - warehouse
        w3 - warehouse

        base - base
        proom - proom

    )
    (:init
        (robot-at base)

        (package-at p0 w1)
        (package-at p1 w1)

        (= (time) 0)
        (= (packages) 0)
        (= (max-packages) 3)

        (= (battery-level) 80)
        (= (processing-time p0) 7)
        (= (processing-energy p0) 10)
        (= (end-processing-time p0) 85)
        (= (processing-time p1) 17)
        (= (processing-energy p1) 7)
        (= (end-processing-time p1) 85)

        (= (distance base w1) 10)
        (= (distance base w2) 10)
        (= (distance base w3) 10)
        (= (distance base proom) 10)

        (= (distance w1 w2) 10)
        (= (distance w1 w3) 10)
        (= (distance w1 base) 10)
        (= (distance w1 proom) 10)

        (= (distance w2 w1) 10)
        (= (distance w2 w3) 10)
        (= (distance w2 base) 10)
        (= (distance w2 proom) 10)

        (= (distance w3 w1) 10)
        (= (distance w3 w2) 10)
        (= (distance w3 base) 10)
        (= (distance w3 proom) 10)

        (= (distance proom w1) 10)
        (= (distance proom w2) 10)
        (= (distance proom w3) 10)
        (= (distance proom base) 10)

        (= (time-from base w1) 10)
        (= (time-from base w2) 10)
        (= (time-from base w3) 10)
        (= (time-from base proom) 10)

        (= (time-from w1 w2) 10)
        (= (time-from w1 w3) 10)
        (= (time-from w1 base) 10)
        (= (time-from w1 proom) 10)

        (= (time-from w2 w1) 10)
        (= (time-from w2 w3) 10)
        (= (time-from w2 base) 10)
        (= (time-from w2 proom) 10)

        (= (time-from w3 w1) 10)
        (= (time-from w3 w2) 10)
        (= (time-from w3 base) 10)
        (= (time-from w3 proom) 10)

        (= (time-from proom w1) 10)
        (= (time-from proom w2) 10)
        (= (time-from proom w3) 10)
        (= (time-from proom base) 10)

    )

    (:goal (finished))

    (:metric minimize (time))
)