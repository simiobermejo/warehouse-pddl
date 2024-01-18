; Tres pacientes y se cancela la llamada del segundo

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
    
    p2 - patient

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

    (patient_at p2 h1)
    (patient_at p2 h3)
    (patient_at p2 h5)

    (= (programmed_call p0) 10)
    (= (programmed_call p1) 20)
    (= (programmed_call p2) 60)

    (= (current_time) 0)
    )

(:goal (end_session))
)