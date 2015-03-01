n=0
typeset -i n

while [[ $n -lt 1000 ]]; do
    echo "hello"
    n=$((n+1))
done
