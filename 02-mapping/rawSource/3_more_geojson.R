

### This is all the code to clean the data from source, but we'll use a cleaned version in class

## Grab our beer data  
options(stringsAsFactors = FALSE)

### Source page: https://opendata.socrata.com/Government/UtahBeerTaxmap/6i4w-nzeq
utahBT <- read.csv("http://opendata.socrata.com/api/views/6i4w-nzeq/rows.csv")
## Clean beer data

# delete header
utahBT <- utahBT[-1,]

### parse lat lon data
lat <- rep(NA,dim(utahBT)[1])
lon <- rep(NA,dim(utahBT)[1])
loc_text <- strsplit(utahBT$Location,",")
for(i in 1:length(loc_text)){
  if(length(loc_text[[i]]) > 2){
    lat[i] <- as.numeric(strsplit(loc_text[[i]][2],"(",fixed=T)[[1]][2])
    lon[i] <- as.numeric(strsplit(loc_text[[i]][3],")"))
  }
}


utahBT$lat <- lat
utahBT$lon <- lon
utahBT <- utahBT[,-3]
utahBT <- utahBT[!is.na(utahBT$lat),]
colnames(utahBT) <- c("City","Distribution","latitude","longitude")
utahBT$Distribution <- as.numeric(gsub("$","",utahBT$Distribution,fixed=T))
write.csv(utahBT,"data/utahbt.csv")


## To download data use this URL: https://raw.github.com/ropensci/workshops-unc-2014-02/master/data/utahbt.csv
###  Now we can add some categories, let's start with binning

utahBT$taxLev <- cut(log(utahBT$Distribution),breaks=10,labels=F)
utahBT$"marker-color" <- colorRampPalette(c("blue", "red"))(10)[utahBT$taxLev]
utahBT$"marker-size" <- rep("small",dim(utahBT)[1])
mapgist(utahBT)





togeojson(input = "data/abiemagn/abiemagn.shp", method = "local", destpath = paste(getwd(),"/",sep=""), outfilename = "abiesmagmap")
gist("abiesmagmap.geojson", description = "Abies magnifica polygons")




library(rMaps)
map <- Leaflet$new()
map$setView(c(44.4758, -73.2119), zoom = 15)
map$tileLayer(provider = 'OpenStreetMap.Mapnik')
map$marker(
  c(44.4758, -73.2119),
  bindPopup = 'This is where I met Brian'
)
map



