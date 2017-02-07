find_loc <- function(tw){
    
    ### find unique ids
    usr <- as.character(unique(tw$screen_name))
    message(sprintf("###>>> [find_loc]: find %s unique users used the hashtag!", length(usr)))
    
    ## extract user reported location information from profiles
    out <- lookupUsers(users=usr, includeNA=TRUE)
    res <- unlist(sapply(out, "[[", "location"))
    df <- data.frame(usr=names(res), loc=res)
    
    df$loc <- gsub("%", "", df$loc)
    df <- subset(df, loc != "")
    message(sprintf("###>>> [find_loc]: find %s users with location in their profiles!", nrow(df)))
    return(df)
}
