googleloc <- function(df, google_api_key="AIzaSyA8zz"){
    
    ### search location using google API
    geocode_apply <- function(x){
        geocode(x, source = "google", output = "all", override_limit = TRUE,
                api_key=google_api_key)
    }
    
    geocode_results <- sapply(as.character(df$loc), geocode_apply, simplify = F)
    return(geocode_results)
}
