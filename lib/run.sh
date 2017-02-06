t search all -ldn 3200 'actuallivingscientist' | cat - data/als.txt | sort | uniq | grep -v ^ID > data/als.txt
