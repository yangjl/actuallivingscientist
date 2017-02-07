### Jinliang Yang
### 02-06-2017
### google user location 


### step two: google API

# install.packages("RJSONIO", repos="http://cran.rstudio.com/")
library("RJSONIO")
source("lib/modified_geocode.R.txt")
#source("lib/googleloc.R")
#assignInNamespace("geocode", geocode, ns="ggmap") 
#detach("package:ggmap", unload=TRUE)

googleloc <- function(df, google_api_key="AIzaSyA8zz", outcache, outtxt){
    ### df: [data.frame] with user id and user reported location
    ### google_api_key:  use your own google AGP key, https://console.developers.google.com/
    
    ### search location using google API
    geocode_apply <- function(x){
        geocode(x, source = "google", output = "all", override_limit = TRUE,
                api_key=google_api_key)
    }
    
    geocode_results <- sapply(as.character(df$loc), geocode_apply, simplify = F)
    
    message(sprintf("###>>> [googleloc]: find location for %s users", length(geocode_results)))
    
    ### Step Three: clearning results
    source("lib/data_cleaning.R")
    out <- loc_cleaning(geocode_results)
    
    if(!is.null(outcache)){
        save("geocode_results", file=outcache)
    }
    if(!is.null(outcache)){
        write.table(out, outtxt, sep="\t", row.names=FALSE)
    }
    
    return(geocode_results)
}


### read in the data from step one
df <- read.delim("data/user_with_address.txt")

### use your own google AGP key, find it here: https://console.developers.google.com/
### it only allows up to 2500 free search per day
res1 <- googleloc(df[1:1000,], google_api_key=mykey, 
                  outcache="cache/api_res1-1000.RData", 
                  outtxt="data/res1-1000.txt")

res2 <- googleloc(df[1001:3500,], google_api_key=mykey, 
                  outcache="cache/api_res1001-3500.RData", 
                  outtxt="data/res1001-3500.txt")


# 15 mins 900 max
### use your own google AGP key, https://console.developers.google.com/
res <- googleloc(df[1001:3500, ], google_api_key=mykey)

geocode_results <- res
length(geocode_results)
### Step Three: clearning results
source("lib/data_cleaning.R")
out <- loc_cleaning(geocode_results=res)

save("res", file="cache/api_res1001-3500.RData")
write.table(out, "data/res1001-3500.txt", sep="\t", row.names=FALSE)


