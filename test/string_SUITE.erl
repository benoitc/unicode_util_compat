%%
%% %CopyrightBegin%
%% 
%% Copyright Ericsson AB 2004-2016. All Rights Reserved.
%% 
%% Licensed under the Apache License, Version 2.0 (the "License");
%% you may not use this file except in compliance with the License.
%% You may obtain a copy of the License at
%%
%%     http://www.apache.org/licenses/LICENSE-2.0
%%
%% Unless required by applicable law or agreed to in writing, software
%% distributed under the License is distributed on an "AS IS" BASIS,
%% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
%% See the License for the specific language governing permissions and
%% limitations under the License.
%% 
%% %CopyrightEnd%
%%
%%%----------------------------------------------------------------
%%% Purpose: string test suite.
%%%-----------------------------------------------------------------
-module(string_SUITE).
-include_lib("common_test/include/ct.hrl").

%% Test server specific exports
-export([all/0,
         suite/0,
         groups/0,
         init_per_suite/1, end_per_suite/1, 
         init_per_group/2,end_per_group/2,
         init_per_testcase/2, end_per_testcase/2]).

%% Test cases must be exported.
-export([tokens/1,
         strip/1]).

suite() ->
    [{timetrap,{minutes,1}}].

all() -> 
    [tokens, strip].

groups() -> 
    [].

init_per_suite(Config) ->
    Config.

end_per_suite(_Config) ->
    ok.

init_per_group(_GroupName, Config) ->
    Config.

end_per_group(_GroupName, Config) ->
    Config.


init_per_testcase(_Case, Config) ->
    Config.

end_per_testcase(_Case, _Config) ->
    ok.

%%
%% Test cases starts here.
%%

tokens(Config) when is_list(Config) ->
    [] = string_compat:tokens("",""),
    [] = string_compat:tokens("abc","abc"),
    ["abc"] = string_compat:tokens("abc", ""),
    ["1","2 34","45","5","6","7"] = do_tokens("1,2 34,45;5,;6;,7", ";,"),

    %% invalid arg type
    {'EXIT',_} = (catch string_compat:tokens('x,y', ",")),
    {'EXIT',_} = (catch string_compat:tokens("x,y", ',')),
    ok.

do_tokens(S0, Sep0) ->
    [H|T] = Sep0,
    S = [replace_sep(C, T, H) || C <- S0],
    Sep = [H],
    io:format("~p ~p\n", [S0,Sep0]),
    io:format("~p ~p\n", [S,Sep]),

    Res = string_compat:tokens(S0, Sep0),
    Res = string_compat:tokens(Sep0++S0, Sep0),
    Res = string_compat:tokens(S0++Sep0, Sep0),

    Res = string_compat:tokens(S, Sep),
    Res = string_compat:tokens(Sep++S, Sep),
    Res = string_compat:tokens(S++Sep, Sep),

    Res.

replace_sep(C, Seps, New) ->
    case lists:member(C, Seps) of
	true -> New;
	false -> C
    end.

strip(Config) when is_list(Config) ->
    "" = string_compat:strip(""),
    "" = string_compat:strip("", both),
    "" = string_compat:strip("", both, $.),
    "hej" = string_compat:strip("  hej  "),
    "hej  " = string_compat:strip("  hej  ", left),
    "  hej" = string_compat:strip("  hej  ", right),
    "  hej  " = string_compat:strip("  hej  ", right, $.),
    "hej  hopp" = string_compat:strip("  hej  hopp  ", both),
    %% invalid arg type
    {'EXIT',_} = (catch string_compat:strip(hej)),
    %% invalid arg type
    {'EXIT',_} = (catch string_compat:strip(" hej", up)),
    ok.
