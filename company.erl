-module(company).
-export([setup_db/0, mk_projs/2, insert_emp/3, raise_salary/2, add_empl/6,raise_trial/2, read_emp_table/1,
         read_proj/1, add_proj/2]).

-record(employee, {emp_no, name, salary, sex, phone, room_no}).
-record(dept, {id, dept_name}).
-record(project, {name, number}).
-record(manager, {emp, dept}).
-record(at_dept, {emp, dept_id}).
-record(in_proj, {emp, proj_name}).

setup_db() ->
    mnesia:create_table(employee, [{attributes, record_info(fields, employee)}, {disc_copies, [node()]}]),
    mnesia:create_table(dept, [{attributes, record_info(fields, dept)}, {disc_copies, [node()]}]),
    mnesia:create_table(project,[{attributes, record_info(fields, project)}, {disc_copies, [node()]}]),
    mnesia:create_table(manager, [{attributes, record_info(fields, manager)},{disc_copies, [node()]} ]),
    mnesia:create_table(at_dept, [{attributes, record_info(fields, at_dept)}, {disc_copies, [node()]}]),
    mnesia:create_table(in_proj, [{attributes, record_info(fields, in_proj)}, {disc_copies, [node()]}]).

insert_emp(Emp, DeptId, ProjNames) ->
                                                %Pick the employee name from the name value in the Emp input
    Ename = Emp#employee.name,

                                                % Take the ename and equit it to the value of emp in the at_dept record and match the dept_id with DeptId
    AtDep = #at_dept{emp = Ename, dept_id = DeptId},

                                                %Create an in_proj record with ename and the projnames which are given in a list
    V = #in_proj{emp =Ename, proj_name = ProjNames},

                                                %Write the records through mnesia:transaction
    F =fun() ->
               mnesia:write(Emp),
               mnesia:write(AtDep),
               mnesia:write(V)
       end,
    mnesia:transaction(F).



mk_projs(Ename, [ProjName | Tail]) ->
    V = #in_proj{emp = Ename, proj_name = ProjName},
    mnesia:write(V),
    mk_projs(Ename, Tail);
                                                % lists:map(mk_projs(Ename,ProjNames), Ename)
mk_projs(_, []) -> ok.

%% function to raise employee salary
raise_salary(Eno, Raise) ->
    F= fun() ->
                                                %use a list since you might get more than one result table type
               [E] = mnesia:read(employee, Eno, write),
               Salary = E#employee.salary + Raise,
               New = E#employee{salary = Salary},
               mnesia:write(New)
       end,
    mnesia:transaction(F).



                                                %This function reads the employee table when given the employees name
read_emp_table(Name) ->
    F = fun() ->
                mnesia:read(employee, Name)
        end,
    mnesia:transaction(F).

add_empl(Emp_no, Name, Salary, Sex, Phone, Room) ->
    R =#employee{emp_no = Emp_no, name = Name, salary = Salary, sex = Sex, phone = Phone, room_no = Room},
    F = fun() ->
                mnesia:write(R)
        end,
    mnesia:transaction(F).

                                                %Wrote this function to better understand transactions
add_proj(Empno, Projname) ->
                                                % Projnames = Projname#in_proj.proj_name,
    Add = #in_proj{emp = Empno, proj_name = Projname},
                                                %lists:map(fun(X) -> #in_proj.proj_name = X end, Projnames)},
    F = fun () ->
                mnesia:write(Add)
        end,
    mnesia:transaction(F).

                                                %function to read the in_proj table
read_proj(Empno) ->
    F =fun() ->
               mnesia:read(in_proj, Empno)
       end,
    mnesia:transaction(F).

raise_trial(Eno, Amount) ->
    F = fun () ->
                E = mnesia:read(employee, Eno, write),
                Salary = E#employee.salary +Amount,
                New_Salary = E#employee{salary = Salary},
                mnesia:write(New_Salary)
        end,
    mnesia:transaction(F).
