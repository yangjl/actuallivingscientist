## a function to plot tweets

## Function needs better documentation
twitterchivePlots <- function (filename=NULL, term=NULL, mydate="2014-01-12") {
    
    ## Load required packages
    require(tm) #text mining applications within R
    require(wordcloud)
    require(RColorBrewer)
    
    if (class(filename)!="character") stop("filename must be character")
    if (!file.exists(filename)) stop(paste("File does not exist:", filename))
    
    if(is.null(term)){
        searchTerm <- sub("\\.txt", "", basename(filename))
    }else{
        searchTerm <- term;
    }
    
    
    message(paste("Filename:", filename))
    message(paste("Search Term: ", searchTerm))
    
    ## Read in the data and munge around the dates.
    ## I can't promise the fixed widths will always work out for you.
    message("Reading in data.")
    trim.whitespace <- function(x) gsub("^\\s+|\\s+$", "", x) # Function to trim leading and trailing whitespace from character vectors.
    d <- read.fwf(filename, widths=c(18, 14, 18, 1000), stringsAsFactors=FALSE, comment.char="")
    d <- as.data.frame(sapply(d, trim.whitespace))
    names(d) <- c("id", "datetime", "user", "text")
    d$user <- sub("@", "", d$user)
    
    ### transfer to Pacific time
    d$datetime <- as.POSIXlt(d$datetime, format="%b %d %H:%M")
    d$datetime <- as.POSIXct(d$datetime, tz="America/Los_Angeles", usetz=TRUE)
    d$datetime <- as.POSIXlt(d$datetime, format="%b %d %H:%M")
    
    
    d$date <- as.Date(d$datetime)
    d$hour <- d$datetime$hour
    d <- na.omit(d) # CRs cause a problem. explain this later.
    head(d)
    
    d$date <- as.character(d$date)
    d <- subset(d, date %in% mydate)
    
    message(paste("Total number of tweets:", nrow(d), sep=" "))
    
    ## Number of tweets by hour
    message("Plotting number of tweets by hour.")
    byHour <- as.data.frame(table(d$hour))
    names(byHour) <- c("hour", "tweets")
    png(paste(searchTerm, mydate, "-by-hour.png", sep="--"), w=1000, h=700)
    with(byHour, barplot(tweets, names.arg=hour, col="aquamarine4", 
                         las=1, cex.names=1.2, cex.axis=1.2, 
                         main=paste("Number of Tweets by Hour (Pacific time)", 
                                    paste("Term:", searchTerm), paste("Date:", mydate), sep="\n")))
    dev.off()
    # ggplot(byHour) + geom_bar(aes(hour, tweets), stat="identity", fill="black") + theme_bw() + ggtitle("Number of Tweets by Hour")
    
    
    ## Top Users
    message("Plotting most prolific users.")
    users <- as.data.frame(table(d$user))
    message(paste("Total number of users:", nrow(users), sep=" "))
    
    colnames(users) <- c("user", "tweets")
    users <- users[order(users$tweets, decreasing=T), ]
    users <- subset(users, user!=searchTerm)
    allusers <- users
    users <- subset(users, tweets >= 10)
    
    png(paste(searchTerm, mydate, "barplot-top-users.png", sep="--"), w=1000, h=700)
    par(mar=c(5,10,4,2))
    with(users[order(users$tweets), ], 
         barplot(tweets, names=user, horiz=T, col="aquamarine4", las=1, 
                 cex.names=1.2, cex.axis=1.2, 
                 main=paste("Most prolific users (tweets>=10)", 
                            paste("Term:", searchTerm), paste("Date:", mydate), sep="\n")))
    dev.off()
    
    png(paste(searchTerm, mydate, "userscloud.png", sep="--"), w=800, h=800)
    allusers[1,]$tweets <- allusers[1,]$tweets - 100
    allusers[2,]$tweets <- allusers[2,]$tweets - 70
    wordcloud(allusers$user, allusers$tweets, scale = c(8, .5), min.freq = 1, max.words = 110,
              random.order = FALSE, rot.per = .15, colors = brewer.pal(8, "Dark2"))
    mtext(paste(paste("Term:", searchTerm), paste("Date:", mydate), sep="; "), cex=1.5)
    dev.off()
    
    ## Word clouds
    message("Plotting a wordcloud.")
    words <- unlist(strsplit(as.character(d$text), " "))
    words <- grep("^[A-Za-z0-9]+$", words, value=T)
    words <- tolower(words)
    words <- words[-grep("^[rm]t$", words)] # remove "RT"
    words <- words[!(words %in% stopwords("en"))] # remove stop words
    words <- words[!(words %in% c("mt", "rt", "via", "using", 1:9))] # remove RTs, MTs, via, and single digits.
    wordstable <- as.data.frame(table(words))
    wordstable <- wordstable[order(wordstable$Freq, decreasing=T), ]
    wordstable <- wordstable[-1, ] # remove the hashtag you're searching for? need to functionalize this.
    head(wordstable)
    png(paste(searchTerm, mydate, "wordcloud.png", sep="--"), w=800, h=800)
    wordcloud(wordstable$words, wordstable$Freq, scale = c(8, .2), min.freq = 3, 
              max.words = 200, random.order = FALSE, rot.per = .15, colors = brewer.pal(8, "Dark2"))
    mtext(paste(paste("Term:", searchTerm), paste("Date:", mydate), sep="; "), cex=1.5)
    dev.off()
    
    message(paste(searchTerm, ": All done!\n"))
}

