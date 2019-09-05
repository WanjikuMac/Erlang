-module(company).
-export([setup_db/0, mk_projs/2, insert_emp/3]).

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
	mnesia:write(#in_proj{emp = Ename, proj_name = ProjName}),
	mk_projs(Ename, Tail);
	mk_projs(_, []) -> ok.