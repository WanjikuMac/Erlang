-module(company).
-export([setup_db/0, mk_projs/2, insert_emp/3, raise_salary/2, add_empl/6,raise_trial/2]).

-record(employee, {emp_no, name, salary, sex, phone, room_no}).
-record(dept, {id, dept_name}).
-record(project, {name, number}).
-record(manager, {emp, dept}).
-record(at_dept, {emp, dept_id}).
-record(in_proj, {emp, proj_name}).

setup_db() ->
    mnesia:create_table(employee, [{attributes, record_info(fields, employee)}]),
    mnesia:create_table(dept, [{attributes, record_info(fields, dept)}]),
    mnesia:create_table(project,[{attributes, record_info(fields, project)}]),
    mnesia:create_table(manager, [{attributes, record_info(fields, manager)}]),
    mnesia:create_table(at_dept, [{attributes, record_info(fields, at_dept)}]),
    mnesia:create_table(in_proj, [{attributes, record_info(fields, in_proj)}]).

insert_emp(Emp, DeptId, ProjNames) ->
    Ename = Emp#employee.name,
    F =fun() ->
               mnesia:write(Emp),
               AtDep = #at_dept{emp = Ename, dept_id = DeptId},
               mnesia:write(AtDep),
               mk_projs(Ename, ProjNames)
       end,
    mnesia:transaction(F).

mk_projs(Ename, [ProjName | Tail]) ->
    V = #in_proj{emp = Ename, proj_name = ProjName},
    mnesia:write(V),
    mk_projs(Ename, Tail);
mk_projs(_, []) -> ok.

%% function to raise employee salary
raise_salary(Eno, Raise) ->
    F= fun() ->
                                                %why is this in a list
               [E] = mnesia:read(employee, Eno, write),
               Salary = E#employee.salary + Raise,
               New = E#employee{salary = Salary},
               mnesia:write(New)
       end,
    mnesia:transaction(F).

add_empl(Emp_no, Name, Salary, Sex, Phone, Room) ->
    R =#employee{emp_no = Emp_no, name = Name, salary = Salary, sex = Sex, phone = Phone, room_no = Room},
    F = fun() ->
                mnesia:write(R)
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
