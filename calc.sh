#!/bin/bash
echo "\n write your first number"
read a
echo "\n write the equation operator"
read o
echo "\n write your second number"
read b
<<comment
if [ "$o" == "+" ]; then
    ((c = a+b))
    echo $c
elif [ "$o" == "-" ]; then
    ((c = a-b))
    echo $c
elif [ "$o" == "*" ]; then
    ((c = a*b))
    echo $c
elif [ "$o" == "/" ]; then
    ((c = a/b))
    echo $c
fi
comment
 
case "$o" in
    "+" ) ((c = a+b)) && echo "$a + $b = $c" ;;
    "-" ) ((c = a-b)) && echo "$a - $b = $c" ;;
    "/" ) if [ "$b" != '0' ]; then
            ((c = a/b)) && echo "$a / $b = $c" 
            else 
            echo "You can't divide by zero" 
            fi  
            ;;
    "*" ) if [ "$b" = '0' ]; then
            echo "$a * $b = 0" 
            elif [ "$a" = '0' ]; then 
            echo "$a * $b = 0"
            else
            ((c = a*b)) && echo "$a * $b = $c" 
            fi  
            ;;
esac