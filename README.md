What's the fastest way to run *n* interations in BASH?
======================================================

**tl;dr** Use `for i in {0..1000}`; it's the fastest.

### Background
I happened across [this post](http://stackoverflow.com/questions/3737740/is-there-a-better-way-to-run-a-command-n-times-in-bash)
on stackoverflow.com. Then, I wondered: what's the fastest way I can run a
command *n* times in BASH? After some quick googling, I was not satisfied
with the results. So, I decided to test it for myself.

### My System
* `Linux 3.18.6-1-ARCH x86_64 GNU/Linux`
* `bash 4.3.33(1)-release`
* `seq (GNU coreutils) 8.23`<br><br>
* `ruby 2.2.0p0`
* `benchmark-ips 2.1.1`

### Results
i/ps is calculated over a 5-second sample.
```
# n = 1000
       for {0..1000}:      150.5 (±25.3%) i/s
      for seq $(0 1000):   113.8 (±23.7%) i/s - 1.32x slower
       for (( ... )):       95.9 (±30.2%) i/s - 1.57x slower
     while read line:       76.2 (±23.6%) i/s - 1.97x slower
     while [[ ... ]]:       70.9 (±31.0%) i/s - 2.12x slower
       while [ ... ]:       64.9 (±26.6%) i/s - 2.32x slower
```

### Breakdown
First of all, these are just my interpretations. I could be completely wrong, so
feel free to let me know in the issues.

`for {0..1000}` is the fastest method out of the six. It is about 1.32x times
faster than the runner up: `for $(seq 0 1000)`

Second place goes to: `for $(seq 0 1000)`. With third going to: `for (( .. ))`.
The `while` loops were always slower than the `for` loops.

The `while [[ ... ]]` loop had the greatest standard deviation at ±31.0%, with
`for (( ... ))` following close behind at ±30.2%. The rest of them have
standard deviations between ±21.0% and ±26.6%.

It seems that BASH's internal `[[ ]]` operators are faster than `[ ]`, which
are just an alias for `test`. Over the long run, this gives `[[ ]]` a slight
advantage in speed.
