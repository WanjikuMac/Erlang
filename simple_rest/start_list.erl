%% This illustrates how to start a cowboy listener
Dispatch = cowboy_router:compile([{'_', [
																		{"/", toppage_h, []}]
																	}]),
% A map containing all the options for the different protocols that  maybe involved
% while connecting to the listener
ProtocolOpts =  #{env => #{dispatch => Dispatch}}
%% Transport  options are where TCP options, including listener's port number are defined
% Available options are documented in ranch_tcp(3)
TransportOpts = [{port, 8080}]
{ok, _} = cowboy:start_clear(example, TransportOpts , ProtocolOpts)