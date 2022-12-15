-- 조인

--- (1) cross join
select * from emp, dept; --- deptno 기준으로 정렬됨.

--- (2) equi join
select * from emp, dept
where emp.deptno = dept.deptno -- dept는 프라이머리 키로 정리, emp는 외래키로 정리

-- sol)
select ename, dname, loc, emp.deptno -- emp.를 스키마라고 부름
from emp, dept
where emp.deptno = dept.deptno
and ename = 'SCOTT'; -- emp에 있는지 dept에 있는지를 모름. 그래서 emp.을 select에 넣어줘야 함.

--- 	테이블명에 별칭을 준 후 컬럼 앞에 소속 테이블을 
---		지정하고자 할 때는 반드시 테이블 명이 아닌 별칭으로 붙여야 함.
select ename, dname, loc, e.deptno -- emp.를 스키마라고 부름
from emp e, dept d
where e.deptno = d.deptno
and ename = 'SCOTT';

--- (3) non-equi join
CREATE TABLE SALGRADE
      ( GRADE NUMBER,
	LOSAL NUMBER,
	HISAL NUMBER );
INSERT INTO SALGRADE VALUES (1,700,1200); -- 1등급
INSERT INTO SALGRADE VALUES (2,1201,1400); -- 2등급
INSERT INTO SALGRADE VALUES (3,1401,2000);
INSERT INTO SALGRADE VALUES (4,2001,3000);
INSERT INTO SALGRADE VALUES (5,3001,9999); -- 5등급, LOW3001, HIGH9999
COMMIT;

--- salary 연속형 변수를 grade로 범주화를 함.
select * from SALGRADE;

select ename, sal, grade
from emp, salgrade
where sal >= losal and sal <= hisal;




