### Jinliang Yang
### 02-06-2017
### google user location 


library("twitteR")
library("ggplot2")
library("ggmap")


### Step one: find user location from profiles
source("lib/find_loc.R")
obj <- load("cache/tw_02.05.2017_11pm.RData")
df <- find_loc(tw)

write.table(df, "data/user_with_address.txt", sep="\t", row.names=FALSE, quote=FALSE)



