

consumer_key <- "[YOUR CONSUMER KEY HERE]"
consumer_secret <- "[YOUR CONSUMER SECRET HERE]"
access_token <- "[YOUR ACCESS TOKEN HERE]"
access_secret <- "[YOUR ACCESS SECRET HERE]"
options(httr_oauth_cache=T) #This will enable the use of a local file to cache OAuth access credentials between R sessions.
setup_twitter_oauth(consumer_key,
                    consumer_secret,
                    access_token,
                    access_secret)




require(ggplot2)
require(maps)
require(twitteR)
#radius from randomly chosen location
radius=10
lat<-runif(n=100, min=24.446667, max=49.384472)
long<-runif(n=100, min=-124.733056, max=-66.949778)
#generate data fram with random longitude, latitude and chosen radius
coordinates<-as.data.frame(cbind(lat,long,radius))
coordinates$lat<-lat
coordinates$long<-long
#create a string of the lat, long, and radius for entry into searchTwitter()
for(i in 1:length(coordinates$lat)){
    coordinates$search.twitter.entry[i]<-toString(c(coordinates$lat[i],
                                                    coordinates$long[i],radius))
}
# take out spaces in the string
coordinates$search.twitter.entry<-gsub(" ","", coordinates$search.twitter.entry ,
                                       fixed=TRUE)

#Search twitter at each location, check how many tweets and put into dataframe
for(i in 1:length(coordinates$lat)){
    coordinates$number.of.tweets[i]<-
        length(searchTwitter(searchString="#actuallivingscientist",n=1000,geocode=coordinates$search.twitter.entry[i]))
}
#making the US map
all_states <- map_data("state")
#plot all points on the map
p <- ggplot()
p <- p + geom_polygon( data=all_states, aes(x=long, y=lat, group = group),colour="grey",     fill=NA )

p<-p + geom_point( data=coordinates, aes(x=long, y=lat,color=number.of.tweets
)) + scale_size(name="# of tweets")
p
}
# Example
searchTwitter("dolphin",15,"10mi")