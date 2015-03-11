#!/usr/bin/env ruby

require "benchmark"
require "benchmark/ips"

Benchmark.ips do |x|
    x.time = 5

    x.report("for (( ... ))")           {`bash ./loops/for.sh`}
    x.report("for $(seq 0 1000)")       {`bash ./loops/seq.sh`}
    x.report("for {0..1000}")           {`bash ./loops/expan.sh`}

    x.report("while read line")         {`bash ./loops/while-read-line.sh`}

    x.report("while [ ... ]")           {`bash ./loops/while-sb.sh`}
    x.report("while [[ ... ]]")         {`bash ./loops/while-db.sh`}

    x.compare!
end
