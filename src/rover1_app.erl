%%%-------------------------------------------------------------------
%% @doc rover public API
%% @end
%%%-------------------------------------------------------------------

-module(rover1_app).

-behaviour(application).

%% Application callbacks
-export([ start/2
	, stop/1
	]).

%%====================================================================
%% API
%%====================================================================

start(_StartType, _StartArgs) ->
    ExternalPort = rover1_conf:get{'io.socket.port'},
    ExternalBacklog = rover1_conf:get{'io.socket.backlog'},
    ExternalSockPool = rover1_conf:get{'io.socket.pool'},
    ExternalKeepalive = rover1_conf:get{'io.socket.keepalive'}, 
    TecipeExternalListenerOpts = [ {monitor, true}
				 , {pool, ExternalSockPool}
				 ],
    TecipeExternalTransportOpts = [ binary
				  , {keepalive, ExternalKeepalive}
				  , {backlog, ExternalBacklog}
				  , {reuseaddr, true}
				  ],
    {ok, _ExternalPid} = tecipe:start_listener( iot_nodes_conn
					      , ExternalPort
					      , {rover1_conn, start, []}
					      , TecipeExternalListenerOpts
					      , TecipeExternalTransportOpts
					      ),   

    rover1_sup:start_link().

%%--------------------------------------------------------------------
stop(_State) ->
    ok.

%%====================================================================
%% Internal functions
%%====================================================================
