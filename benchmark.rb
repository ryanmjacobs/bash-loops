#!/usr/bin/env ruby

require "benchmark"
require "benchmark/ips"

Benchmark.ips do |x|
    N = 1

    x.report("for (( ... ))")    { N.times { `bash for.sh`}}
    x.report("for seq 0 1000")   { N.times { `bash seq.sh`}}
    x.report("for {0..1000}")    { N.times { `bash expan.sh`}}

    x.compare!
end
