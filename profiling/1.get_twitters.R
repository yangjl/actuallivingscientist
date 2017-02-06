### Jinliang Yang
### 02-06-2017
### get all the tweets

#install.packages("rtweet")
library("rtweet")
library("dplyr")
#library("httpuv")
# learn rtweet https://github.com/mkearney/rtweet/blob/master/README.md


# see largedata to find token info
tw <- search_tweets(q = "#actuallivingscientist", retryonratelimit=TRUE,
                    include_rts = FALSE,
                    n = 50000, type = "recent")

dim(tw)

# no need for coordinates which are often missing
loc <- select(tw, -coordinates)

# only English
tw <- filter(tw, lang == "en")

# no answers
#tw <- filter(tw, is.na(in_reply_to_user_id))

# save
save(tw, file = "cache/tw_02.05.2017_11pm.RData")

