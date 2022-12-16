Rem Copyright (c) 1990 by Oracle Corporation
Rem NAME
REM    UTLSAMPL.SQL
Rem  FUNCTION
Rem  NOTES
Rem  MODIFIED
Rem	gdudey	   06/28/95 -  Modified for desktop seed database
Rem	glumpkin   10/21/92 -  Renamed from SQLBLD.SQL
Rem	blinden   07/27/92 -  Added primary and foreign keys to EMP and DEPT
Rem	rlim	   04/29/91 -	      change char to varchar2
Rem	mmoore	   04/08/91 -	      use unlimited tablespace priv
Rem	pritto	   04/04/91 -	      change SYSDATE to 13-JUL-87
Rem   Mendels	 12/07/90 - bug 30123;add to_date calls so language independent
Rem
rem
rem $Header: utlsampl.sql 7020100.1 94/09/23 22:14:24 cli Generic<base> $ sqlbld.sql
rem
SET TERMOUT OFF
SET ECHO OFF

rem CONGDON    Invoked in RDBMS at build time.	 29-DEC-1988
rem OATES:     Created: 16-Feb-83

GRANT CONNECT,RESOURCE,UNLIMITED TABLESPACE TO SCOTT IDENTIFIED BY TIGER;
ALTER USER SCOTT DEFAULT TABLESPACE USERS;
ALTER USER SCOTT TEMPORARY TABLESPACE TEMP;
CONNECT SCOTT/TIGER
DROP TABLE DEPT;
CREATE TABLE DEPT
       (DEPTNO NUMBER(2) CONSTRAINT PK_DEPT PRIMARY KEY,
	DNAME VARCHAR2(14) ,
	LOC VARCHAR2(13) ) ;
DROP TABLE EMP;
CREATE TABLE EMP
       (EMPNO NUMBER(4) CONSTRAINT PK_EMP PRIMARY KEY,
	ENAME VARCHAR2(10),
	JOB VARCHAR2(9),
	MGR NUMBER(4),
	HIREDATE DATE,
	SAL NUMBER(7,2),
	COMM NUMBER(7,2),
	DEPTNO NUMBER(2) CONSTRAINT FK_DEPTNO REFERENCES DEPT);
INSERT INTO DEPT VALUES
	(10,'ACCOUNTING','NEW YORK');
INSERT INTO DEPT VALUES (20,'RESEARCH','DALLAS');
INSERT INTO DEPT VALUES
	(30,'SALES','CHICAGO');
INSERT INTO DEPT VALUES
	(40,'OPERATIONS','BOSTON');
INSERT INTO EMP VALUES
(7369,'SMITH','CLERK',7902,to_date('17-12-1980','dd-mm-yyyy'),800,NULL,20);
INSERT INTO EMP VALUES
(7499,'ALLEN','SALESMAN',7698,to_date('20-2-1981','dd-mm-yyyy'),1600,300,30);
INSERT INTO EMP VALUES
(7521,'WARD','SALESMAN',7698,to_date('22-2-1981','dd-mm-yyyy'),1250,500,30);
INSERT INTO EMP VALUES
(7566,'JONES','MANAGER',7839,to_date('2-4-1981','dd-mm-yyyy'),2975,NULL,20);
INSERT INTO EMP VALUES
(7654,'MARTIN','SALESMAN',7698,to_date('28-9-1981','dd-mm-yyyy'),1250,1400,30);
INSERT INTO EMP VALUES
(7698,'BLAKE','MANAGER',7839,to_date('1-5-1981','dd-mm-yyyy'),2850,NULL,30);
INSERT INTO EMP VALUES
(7782,'CLARK','MANAGER',7839,to_date('9-6-1981','dd-mm-yyyy'),2450,NULL,10);
INSERT INTO EMP VALUES
(7788,'SCOTT','ANALYST',7566,to_date('13-7-1987','dd-mm-yyyy'),3000,NULL,20);
INSERT INTO EMP VALUES
(7839,'KING','PRESIDENT',NULL,to_date('17-11-1981','dd-mm-yyyy'),5000,NULL,10);
INSERT INTO EMP VALUES
(7844,'TURNER','SALESMAN',7698,to_date('8-9-1981','dd-mm-yyyy'),1500,0,30);
INSERT INTO EMP VALUES
(7876,'ADAMS','CLERK',7788,to_date('13-7-1987','dd-mm-yyyy'),1100,NULL,20);
INSERT INTO EMP VALUES
(7900,'JAMES','CLERK',7698,to_date('3-12-1981','dd-mm-yyyy'),950,NULL,30);
INSERT INTO EMP VALUES
(7902,'FORD','ANALYST',7566,to_date('3-12-1981','dd-mm-yyyy'),3000,NULL,20);
INSERT INTO EMP VALUES
(7934,'MILLER','CLERK',7782,to_date('23-1-1982','dd-mm-yyyy'),1300,NULL,10);
DROP TABLE BONUS;
CREATE TABLE BONUS
	(
	ENAME VARCHAR2(10)	,
	JOB VARCHAR2(9)  ,
	SAL NUMBER,
	COMM NUMBER
	) ;
DROP TABLE SALGRADE;
CREATE TABLE SALGRADE
      ( GRADE NUMBER,
	LOSAL NUMBER,
	HISAL NUMBER );
INSERT INTO SALGRADE VALUES (1,700,1200);
INSERT INTO SALGRADE VALUES (2,1201,1400);
INSERT INTO SALGRADE VALUES (3,1401,2000);
INSERT INTO SALGRADE VALUES (4,2001,3000);
INSERT INTO SALGRADE VALUES (5,3001,9999);
COMMIT;

SET TERMOUT ON
SET ECHO ON

/*
select * from dept;
select * from emp;
*/

-- [1] 'SCOTT'이 근무하는 부서명, 지역출력
--	.원하는 정보가 두 개 이상의 테이블에 나뉘어져 있을 때 결과출력.

select * from emp; -- 근무 부서
select * from dept; -- 부서명과 지역정보

select deptno from emp
where ename = 'SCOTT';

select dname, loc from dept
where deptno = 20;

-- [2] 조인_20221216

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

select ename, sal, grade
from emp, salgrade
where sal between losal and hisal;

--- emp, dept, salgrade 3개의 테이블 join
select ename, sal, grade, dname
from emp, salgrade, dept
where sal between losal and hisal;

--- (4) self join
select ename, mgr from emp;

select employee.ename, employee.mgr, manager.ename
from emp employee, emp manager 
-- 별칭을 붙여서 다른 2개의 테이블인 것처럼 사용할 수 있다.
where employee.mgr = manager.empno;

--- (5) outer join
select employee.ename, employee.mgr, manager.ename
from emp employee, emp manager 
-- 별칭을 붙여서 다른 2개의 테이블인 것처럼 사용할 수 있다.
where employee.mgr = manager.empno(+);

/* 20221216 */

-- [3] ANSI Join(조인)
--- (1) Ansi cross join

select *
from emp cross join dept; /* mariaDB, oracle 등 다 이용 가능하다.*/

--- (2) Ansi inner join 
/* */ 



































