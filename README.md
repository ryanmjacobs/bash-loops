What's the fastest way to run *n* interations in BASH?
======================================================

**tl;dr** Use `for i in seq 0 1000`; it's the fastest.

(Yes, `seq` is not POSIX, but it is available on most systems.)

### Background
I happened across [this post](http://stackoverflow.com/questions/3737740/is-there-a-better-way-to-run-a-command-n-times-in-bash)
on stackoverflow.com. Then, I wondered: what's the fastest way I can run a
command *n* times in BASH? After some quick googling, I was not satisfied
with the results. So, I decided to test it for myself.

[Jump to the results here.](http://github.com/ryanmjacobs/bash-loops/#results)

### My System
* `Linux 3.18.6-1-ARCH x86_64 GNU/Linux`
* `bash 4.3.33(1)-release`
* `seq (GNU coreutils) 8.23`<br><br>
* `ruby 2.2.0p0`
* `benchmark-ips 2.1.1`

### Key
* `ts`  means `typeset -i n`
* `let` means `let n++` instead of `n=$((n+1))`
* `ts let` means both

### Results
```
# i/ps is calculated over a 90-second sample. More than sufficient.

        for seq 0 1000:      220.7 (±28.7%) i/s
         for {0..1000}:       83.5 (±10.8%) i/s - 2.64x slower
         for (( ... )):       66.2 (±12.1%) i/s - 3.34x slower

       while read line:       53.3 (±20.6%) i/s - 4.14x slower

   let while [[ ... ]]:       52.4 (±17.2%) i/s - 4.21x slower
       while [[ ... ]]:       52.1 (±17.3%) i/s - 4.24x slower
    ts while [[ ... ]]:       51.0 (±15.7%) i/s - 4.33x slower
ts let while [[ ... ]]:       49.9 (±18.0%) i/s - 4.42x slower

         while [ ... ]:       45.5 (±17.6%) i/s - 4.85x slower
     let while [ ... ]:       44.7 (±15.7%) i/s - 4.94x slower
      ts while [ ... ]:       44.1 (±18.1%) i/s - 5.00x slower
  ts let while [ ... ]:       43.8 (±18.3%) i/s - 5.04x slower
```

### Breakdown
First of all, these are just my interpretations. I could be completely wrong, so
feel free to let me know in the issues.

#### For loops
`seq` wins hands down. It more than *doubles* the runner up. I think this might be
so because it's an external binary. It seems that a compiled C binary is a lot
faster and its sheer speed is enough to outweigh the overhead of an external
command call.

I noticed that when using the `seq` command, the variability of the samples is
much higher, 28.7% compared to the other loops which are all below 20%
(not including `while read line` which also uses `seq`). Though, I have no idea
why this happens.

Second place goes to: `for {0..1000}`. With third going to: `for (( .. ))`.
There is a large enough difference between the two (83.5 - 66.2 = 17.3), that
it appears that this difference didn't occur due to chance. I don't know why
one is faster than the other.

#### While loops
Okay, moving on to the while loops. Because we were dealing with incrementing
variables, I also tested `typeset -i` and `let` to see if it made a difference.

Every while loop was slower than the slowest of the for loops; and, the
fastest loop was the one with `seq` piped into it.

It seems that BASH's internal `[[ ]]` operators are faster than `[ ]`, which
are an alias for `test`. Over the long run, this gives `[[ ]]` a slight
advantage in speed.

Adding `let n++`, `typeset -i`, or both seem negligible at best. Make of it
as you wish.
