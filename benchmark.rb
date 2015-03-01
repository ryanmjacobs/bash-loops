#!/usr/bin/env ruby

require "benchmark"
require "benchmark/ips"

def trials(x, n)
    `sed -i 's/1000/#{n}/g' ./loops/*.sh`
    trap("SIGINT") { `sed -i 's/#{n}/1000/g' ./loops/*.sh`; exit 1 }

    x.report("for (( .. ))")     {`bash ./loops/for.sh`}
    x.report("for seq")          {`bash ./loops/seq.sh`}
    x.report("for {..}")         {`bash ./loops/expan.sh`}
    x.report("while read line")  {`bash ./loops/while-read-line.sh`}
    x.report("while [ .. ]")     {`bash ./loops/while-sb.sh`}
    x.report("while [[ .. ]]")   {`bash ./loops/while-db.sh`}
    x.compare!
end

Benchmark.ips do |x|
    trials(x, 1000)
end

Benchmark.ips do |x|
    trials(x, 10000)
end
