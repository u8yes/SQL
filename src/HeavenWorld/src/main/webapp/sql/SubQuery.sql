-- ex) 'SCOTT'이 근무하는 부서명, 지역 출력
-- 		(서로 다른 테이블에 데이터 존재).
select deptno from emp
where ename = 'SCOTT'; -- 20

select dname, loc from dept
where deptno = 20;

select dname, loc from dept
where deptno = (select deptno 
				from emp
				where ename = 'SCOTT');

-- [예제] 'SCOTT'와 동일한 직급(job)을 가진 
-- 사원 정보를 출력하는 sql문을 서브쿼리를 이용해서 작성해보시오.

select ename, job 
from emp 
where job = (select job 
			from emp
			where ename = 'SCOTT');

-- [예제] 'SCOTT'의 급여와 동일하거나 더 많이 받는 
-- 		  사원이름과 급여를 출력해보세요.

select ename, sal 
from emp
where sal >= (select sal 
			 from emp
			 where ename = 'SCOTT');

-- [예제] 전체 사원 평균 급여보다 
-- 더 많은 급여를 받는 사원 정보를 출력하세요.

select ename, sal 
from emp
where sal >= (select avg(sal) 
			 from emp);		 

select avg(sal) from emp;











