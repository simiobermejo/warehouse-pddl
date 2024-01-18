; El robot vuelve a la base entre llamadas a esperar

(define (problem p1)
(:domain videocall)
(:objects
    p0 - patient
    h0 - hall
    h1 - hall
    h2 - hall
    h3 - hall

    p1 - patient
    h4 - hall
    h5 - hall
    h6 - hall

    base - base
    videoroom - videoroom

)
(:init
    (robot_at base)

    (patient_at p0 h0)
    (patient_at p0 h1)
    (patient_at p0 h2)


    (patient_at p1 h4)
    (patient_at p1 h5)
    (patient_at p1 h6)

    (= (programmed_call p0) 10)
    (= (programmed_call p1) 60)

    (= (current_time) 0)
    )

(:goal (end_session))
)