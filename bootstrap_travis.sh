#!/bin/sh

curl -O -L https://github.com/erlang/rebar3/releases/download/3.13.0/rebar3
chmod +x rebar3
./rebar3 update
