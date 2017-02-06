### Jinliang Yang
### 02-06-2017
### google user location 


library("twitteR")
library(ggplot2)
library("ggmap")



# 15 mins 900 max
#Install key package helpers:
#source("https://raw.githubusercontent.com/LucasPuente/geocoding/master/geocode_helpers.R")
#Install modified version of the geocode function
#(that now includes the api_key parameter):
#source("https://raw.githubusercontent.com/LucasPuente/geocoding/master/modified_geocode.R")

find_loc <- function(tw, ids=1:500){
    
    ### find unique ids
    usr <- as.character(unique(tw$screen_name))
    message(sprintf("###>>> [find_loc]: find %s unique users used the hashtag!", length(usr)))
    
    out <- lookupUsers(users=usr, includeNA=TRUE)
    
    res <- unlist(sapply(out, "[[", "location"))
    
    df <- data.frame(usr=names(res), loc=res)
    
    df$loc <- gsub("%", "", df$loc)
    df <- subset(df, loc != "")
    message(sprintf("###>>> [find_loc]: find %s users with location in their profiles!", nrow(df)))
}



googleloc <- function(df, google_api_key="AIzaSyA8zz34HsjNrQHrJLCVpEUh5gXISqmuVOI"){
    
    #Install key package helpers:
    source("https://raw.githubusercontent.com/LucasPuente/geocoding/master/geocode_helpers.R")
    #Install modified version of the geocode function
    #(that now includes the api_key parameter):
    source("https://raw.githubusercontent.com/LucasPuente/geocoding/master/modified_geocode.R")
    ### search location using google API
    geocode_apply <- function(x){
        geocode(x, source = "google", output = "all",
                api_key=google_api_key)
    }
    
    geocode_results <- sapply(df$loc, geocode_apply, simplify = F)
    length(geocode_results)
    ### clearning results
    source("lib/data_cleaning.R")
    res <- loc_cleaning(geocode_results)
    return(res)
}





obj <- load("cache/tw_02.05.2017_11pm.RData")

# 15 mins 900 max

out <- find_loc(tw, ids=501:1000)
    




write.table(res, "data/loc_1-500.csv", sep=",", row.names=FALSE, quote=FALSE)


#Since the maps we’re ultimately interested in generating will show the spatial distribution of Twitter followers in the US, you should eliminate followers that are outside the country.

american_results<-subset(results_f,
                         grepl(", USA", results_f$Location)==TRUE)

#Let’s quickly check how successful our geocoding and filtering has been so far.
qmplot(lng, lat, data = out, source="google", maptype = "toner-lite", color = I("red"), alpha = .3)

qmplot(lng, lat, data=results_e, geom = "blank", zoom = 1, 
       maptype = "toner-background", darken = .7, legend = "topleft") +
    stat_density_2d(aes(fill = ..level..), geom = "polygon", alpha = .3, color = NA) +
    scale_fill_gradient2("Robbery\nPropensity", low = "white", mid = "yellow", high = "red", midpoint = 650)



