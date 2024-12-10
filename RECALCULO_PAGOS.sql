select * from pagos;
select * from bono_consulta;


SELECT TO_CHAR(PACIENTE.FECHA_NACIMIENTO, 'DD/MM/YYYY'),FLOOR(MONTHS_BETWEEN(SYSDATE, TO_DATE(TO_CHAR(PACIENTE.FECHA_NACIMIENTO, 'DD/MM/YYYY')))/12) FROM PACIENTE;

SELECT TO_CHAR(PACIENTE.FECHA_NACIMIENTO, 'DD/MM/YYYY') FROM PACIENTE;


CREATE VIEW V_RECALCULO_PAGOS AS

select bc.pac_run,
SUBSTR(bc.pac_run,1,LENGTH(bc.pac_run)-1) AS PAC_RUN,
SUBSTR(bc.pac_run,-1,1) AS DV_RUN,
sal.descripcion as SIST_SALUD ,
(pac.apaterno || ' ' || pac.snombre) as NOMBRE_PACIENTE,
p.monto_consulta AS COSTO, 
(case when p.monto_consulta between 15000 and  25000 then ROUND((p.monto_consulta * 0.15) + p.monto_consulta, 0)
when p.monto_consulta > 25000 then ROUND((p.monto_consulta * 0.2) + p.monto_consulta,0)
when p.monto_consulta < 15000 then p.monto_consulta
end ) as MONTO_A_CANCELAR,
FLOOR(MONTHS_BETWEEN(SYSDATE, TO_DATE(TO_CHAR(pac.FECHA_NACIMIENTO, 'DD/MM/YYYY')))/12) AS EDAD
from bono_consulta bc
INNER join pagos p on bc.id_bono = p.id_bono
INNER join paciente pac on pac.pac_run = bc.pac_run
INNER join salud sal on pac.sal_id = pac.sal_id

where hr_consulta > '17:15';



GRANT SELECT ON V_RECALCULO_PAGOS TO PRY2205_USER2;


create view VISTA_AUM_MEDICO_X_CARGO AS
SELECT 
case when length(m.rut_med) = 7 then
    '0'||substr(m.rut_med,1,1) || '.'|| substr(m.rut_med,2,3) || '.'|| substr(m.rut_med,5,3) || '-' ||  m.dv_run
    when length(m.rut_med) = 8 then
    substr(m.rut_med,1,2) || '.'|| substr(m.rut_med,3,3) || '.'|| substr(m.rut_med,6,3) || '-' ||  m.dv_run
    else 
    'Formato invalido'
    end as RUT_MEDICO,  
cr.nombre  as CARGO,
m.sueldo_base as SUELDO_BASE, 
'$' || SUBSTR( TO_CHAR(ROUND((m.sueldo_base * 0.15) + m.sueldo_base, 0), 'FM999G999G999D00'),1,INSTR(TO_CHAR(ROUND((m.sueldo_base * 0.15) + m.sueldo_base, 0), 'FM999G999G999D00'),',')-1)AS SUELDO_AUMENTADO
FROM medico m
INNER JOIN unidad_consulta uc on m.uni_id = uc.uni_id
INNER JOIN cargo cr on cr.car_id = m.car_id
where uc.nombre like 'ATENCIÓN%'
ORDER BY SUELDO_BASE ASC
;

GRANT SELECT ON VISTA_AUM_MEDICO_X_CARGO TO PRY2205_USER1;


create VIEW VISTA_AUM_MEDICO_X_CARGO_2 AS
SELECT 
case when length(m.rut_med) = 7 then
    '0'||substr(m.rut_med,1,1) || '.'|| substr(m.rut_med,2,3) || '.'|| substr(m.rut_med,5,3) || '-' ||  m.dv_run
    when length(m.rut_med) = 8 then
    substr(m.rut_med,1,2) || '.'|| substr(m.rut_med,3,3) || '.'|| substr(m.rut_med,6,3) || '-' ||  m.dv_run
    else 
    'Formato invalido'
    end as RUT_MEDICO,  
cr.nombre  as CARGO,
m.sueldo_base as SUELDO_BASE, 
  '$' || SUBSTR( TO_CHAR(ROUND((m.sueldo_base * 0.15) + m.sueldo_base, 0), 'FM999G999G999D00'),1,INSTR(TO_CHAR(ROUND((m.sueldo_base * 0.15) + m.sueldo_base, 0), 'FM999G999G999D00'),',')-1)AS SUELDO_AUMENTADO
FROM medico m
INNER JOIN unidad_consulta uc on m.uni_id = uc.uni_id
INNER JOIN cargo cr on cr.car_id = m.car_id
where uc.nombre like 'ATENCIÓN%' and 
cr.car_id = 400 and 
m.sueldo_base <1500000
ORDER BY SUELDO_BASE ASC
;

GRANT SELECT ON VISTA_AUM_MEDICO_X_CARGO_2 TO PRY2205_USER1;


SELECT * FROM dba_role_privs WHERE dba_role_privs.grantee = 'ModDatos';