{application, 'simple_rest', [
	{description, "New project"},
	{vsn, "0.1.0"},
	{modules, ['simple_rest_app','simple_rest_sup']},
	{registered, [simple_rest_sup]},
	{applications, [kernel,stdlib]},
	{mod, {simple_rest_app, []}},
	{env, []}
]}.