 select * from course where credits > 3;

 select * from classroom where building = 'Watson' or building = 'Packard';

 select * from course where dept_name = 'Comp. Sci.';

 select * from section where semester = 'Fall';

 select * from student where tot_cred between 46 and 89;

 select * from student where name like '%a' or name like '%e' or name like '%y' or name like '%u' or name like '%i' or name like '%o';

 select * from prereq where prereq_id = 'CS-101';


select dept_name, avg(salary) cnt
from instructor 
group by dept_name
order by cnt asc;

 select building, cnt from (select building, count(sec_id) cnt
from section
group by building
order by cnt desc) as a
where cnt = (select max(cnt) from (select building, count(sec_id) cnt
from section
group by building
order by cnt desc) as a);

select dept_name, cnt from (select dept_name, count(course_id) cnt
from course
group by dept_name
order by cnt asc) as a
where cnt = (select min(cnt) from (select dept_name, count(course_id) cnt
from course
group by dept_name
order by cnt asc) as a);


select id, name from student
where id in (select id from (select id,count(1) cnt from takes
where course_id like 'CS%'
group by id) as b
where cnt>3);


select id, name from instructor
where dept_name = 'Biology' or dept_name = 'Philosophy' or dept_name = 'Music';

select distinct instructor.id, instructor.name,instructor.dept_name, instructor.salary
from instructor,teaches
where instructor.id=teaches.id and teaches.year=2018
and teaches.id not in (select instructor.id 
from instructor,teaches
where teaches.year=2017 and instructor.id=teaches.id );

select student.id,student.name from student,takes,course 
WHERE student.id=takes.id and takes.course_id=course.course_id 
and course.dept_name='Comp. Sci.' and (takes.grade='A' or 
takes.grade='A-') 
group by student.id 
order by student.name;


select * from instructor where instructor.id in
(select advisor.i_id from advisor,student,takes
where advisor.s_id=student.id and takes.id=student.id
and (takes.grade!='A' and takes.grade!='A-' and 
takes.grade!='B+'and takes.grade!='B' or takes.grade is null));

select dept_name from  department where department.dept_name
not in (select distinct department.dept_name 
from department,student,takes
where department.dept_name=student.dept_name and 
student.id=takes.id and (takes.grade='F' or takes.grade='C'));

select id,name from instructor where instructor.id not in
(select distinct instructor.id from instructor,teaches,takes
where instructor.id=teaches.id and 
teaches.course_id=takes.course_id and takes.grade='A');


select distinct course.course_id,course.title from course,section,time_slot 
where section.time_slot_id=time_slot.time_slot_id and end_hr<=13 and section.course_id=course.course_id;



