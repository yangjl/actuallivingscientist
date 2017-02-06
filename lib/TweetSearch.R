### Jinliang Yang
### Jan 12th, 2015


## use t (https://github.com/sferik/t) to search the last $n tweets in the query, 
## concatenating that output with the existing file, sort and uniq that, then 

TweetSearch <- function(hashtag="#PAGXXIII", num=2000, output="data/file.txt"){
    message("make sure you installed t: (https://github.com/sferik/t)")
    
    hashtag <- sub("^#", "", hashtag)
    
    if(!file.exists(output)){
        file.create(output)
    }
    
    search_cmd <- sprintf(paste("t search all -ldn %s '%s' | cat - %s |",
                          "sort | uniq | grep -v ^ID > %s"), 
                          num, hashtag, output, output)
    cat(search_cmd,
        file="lib/run.sh", sep="\n", append=FALSE)
    message(sprintf("start searching [ %s ]", hashtag))
    system("sh lib/run.sh")
    message(sprintf("searching done!"))    
}
