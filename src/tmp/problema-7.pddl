; Paciente y tres ubicaciones pero no empieza en la base

(define (problem p1)
(:domain videocall)
(:objects
    p0 - patient
    h0 - hall
    h1 - hall
    h2 - hall

    base - base
    videoroom - videoroom

)
(:init
    (robot_at h2)

    (patient_at p0 h0)
    (patient_at p0 h1)
    (patient_at p0 h2)
    
    (= (programmed_call p0) 20)

    (= (current_time) 0)
    )

(:goal (end_session))
)