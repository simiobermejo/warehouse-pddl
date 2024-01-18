(define (domain videocall)
	(:requirements :strips :typing :fluents :equality :negative-preconditions)

	(:types
		base hall videoroom - location
		location patient - object
	)

	(:predicates
		(robot_at ?l - location) ; posicion del robot

		(attending ?p - patient) ; Paciente al que se está atendiendo
		(patient_at ?p - patient ?h - location) ; Posibles posiciones de cada paciente
		(alerted ?p - patient ?h - location) ; si para esa llamada ya se ha avisado al paciente

		(detect_patient ?p - patient) ; Detecta el paciente al entrar a la sala de llamada;
		(greeted_patient ?p - patient) ;Saluda al paciente al entrar a la sala
		(call_done ?p - patient) ; hace la llamada para el paciente
		(say_godbye ?p - patient) ; Despedirse del paciente

		(cancel_call ?p - patient) ; En el caso de cancelarse la llamada

		(cancel ?p1 - patient) ; Cancelar la llamada de un paciente
		(on_session) ; Está atendiendo a alguien
		(end_session)
	) ; Termina la ronda de llamadas

	(:functions
		(current_time) ; Hora actual
		(cancel ?p - patient) ; Hora de cancelación llamada
		(programmed_call ?p - patient)
	) ; Hora de las llamadas

	(:action NAO_move_to_base
		:parameters (?l - location)
		:precondition (and (forall
				(?p - patient) ; Para cada uno de los pacientes
				(or (say_godbye ?p) (>= (- (programmed_call ?p) (current_time)) 15))) ; Si no se le ha atendido o quedan más de 15 mins
			(robot_at ?l) ; Robot en posicion
			(not (robot_at base)) ; Que no es la base
			(not (on_session))) ; No está en medio de una sesion
		:effect (and (robot_at base) ; Se mueve el robot a la base de carga
			(not (robot_at ?l)))
	)

	(:action NAO_wait_at_base
		:precondition (and (forall
				(?p - patient) ; para cada paciente
				(or (say_godbye ?p) (>= (- (programmed_call ?p) (current_time)) 15))) ; si quedan más de 15 minutos
			(robot_at base) ; y el robot está en la base
			(not (on_session))) ; sin estar en seśión
		:effect (and (increase (current_time) 5))
	) ; se incrementa en 5 minutos el tiempo

	(:action NAO_received_cancelled
		:parameters (?p - patient)
		:precondition (and (>= (- (cancel ?p) (current_time)) 15)) ; si se cancela 15 minutos antes de la llamada
		:effect (and (decrease (programmed_call ?p) 10000000))
	) ; se marca la llamada como cancelada

	(:action NAO_starts_session
		:parameters (?p - patient)
		:precondition (and (<= (- (programmed_call ?p) (current_time)) 10) ; si quedan menos de 10 minutos
			(>= (- (programmed_call ?p) (current_time)) 0)
			(not (say_godbye ?p)) ; si no se ha
			(not (on_session)))
		:effect (and (attending ?p)
			(on_session))
	)

	(:action NAO_move
		:parameters (?p - patient ?l1 ?l2 - location)
		:precondition (and (robot_at ?l1)
			(attending ?p))
		:effect (and (not (robot_at ?l1))
			(robot_at ?l2))
	)

	(:action NAO_anounces_call
		:parameters (?p - patient ?l - location)
		:precondition (and (attending ?p) (robot_at ?l) (not (alerted ?p ?l)))
		:effect (and (alerted ?p ?l))
	)

	(:action NAO_detect_patient
		:parameters (?p - patient)
		:precondition (and (robot_at videoroom)
			(attending ?p)
			(forall
				(?lo - location)
				(imply
					(patient_at ?p ?lo)
					(alerted ?p ?lo)))
			(not (detect_patient ?p)))
		:effect (and (detect_patient ?p))
	)

	(:action NAO_greet_patient
		:parameters (?p - patient)
		:precondition (and (robot_at videoroom)
			(attending ?p)
			(detect_patient ?p)
			(not (greeted_patient ?p)))
		:effect (and (greeted_patient ?p))
	)

	(:action NAO_make_call
		:parameters (?p - patient)
		:precondition (and (robot_at videoroom)
			(attending ?p)
			(detect_patient ?p)
			(greeted_patient ?p)
			(not (call_done ?p)))
		:effect (and (call_done ?p)
			(increase (current_time) 30))
	)

	(:action NAO_say_goodbye_to_patient
		:parameters (?p - patient)
		:precondition (and (robot_at videoroom)
			(attending ?p)
			(call_done ?p))
		:effect (and (say_godbye ?p)
			(not (call_done ?p))
			(not (on_session))
			(not (attending ?p))
			(decrease (programmed_call ?p) 10000000))
	)

	(:action NAO_to_base_end
		:parameters (?l - location)
		:precondition (and (forall
				(?p - patient)
				(< (programmed_call ?p) 0))
			(not (on_session))
			(not (robot_at base)))
		:effect (and (robot_at base) (not (robot_at ?l)) (end_session))
	)
)