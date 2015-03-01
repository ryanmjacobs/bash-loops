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

### Results
```
# i/ps is calculated over a 5-second sample.

      for seq 0 1000:      204.5 (±24.9%) i/s
       for {0..1000}:       82.9 (±10.9%) i/s - 2.47x slower
       for (( ... )):       66.9 (±10.5%) i/s - 3.06x slower
     while [[ ... ]]:       53.2 (±17.2%) i/s - 3.84x slower
     while read line:       53.0 (±22.6%) i/s - 3.86x slower
       while [ ... ]:       46.4 (±15.0%) i/s - 4.41x slower
```

### Breakdown
First of all, these are just my interpretations. I could be completely wrong, so
feel free to let me know in the issues.

`seq` wins hands down. It more than *doubles* the runner up. I think this might be
so because it's an external binary. It seems that a compiled C binary is a lot
faster and its sheer speed is enough to outweigh the overhead of an external
command call.

I noticed that when using the `seq` command, the variability of the samples is
much higher, 24.9% compared to the other loops which are all below 20%
(not including `while read line` which also uses `seq`). Though, I have no idea
why this happens.

Second place goes to: `for {0..1000}`. With third going to: `for (( .. ))`.
There is a large enough difference between the two (82.9 - 66.9 = 16), that
it appears that this difference didn't occur due to chance. I don't know why
one is faster than the other.

It seems that BASH's internal `[[ ]]` operators are faster than `[ ]`, which
are just an alias for `test`. Over the long run, this gives `[[ ]]` a slight
advantage in speed.

---
Note: I previously had tested the effects of `typeset -i` and `let`, but have
since removed them. If you wish to see them, checkout 87bceda.
