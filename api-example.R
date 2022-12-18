#######################
# Example 1
#######################

l=list()
n=1
for(i in 1:9999) { 
        url=paste0("https://www.eco-visio.net/api/aladdin/1.0.0/pbl/publicwebpageplus/",i,"?withNull=true")
        r=httr::GET(url,config=httr::config(connecttimeout=60))
        if(httr::http_status(r)$category=="Success") {
		print(paste0(i,"*"));
	        c=httr::content(r)
		x=cbind(
			idOrganisme=rep(i,length(c)),
			idPdc=sapply(c,function(x)x$idPdc),
			nom=sapply(c,function(x)x$nom),
			nomOrganisme=sapply(c,function(x)x$nomOrganisme),
			lat=sapply(c,function(x)x$lat),
			lon=sapply(c,function(x)x$lon),
			mainPratique=sapply(c,function(x)x$mainPratique),
			pratique=sapply(c,function(x)paste(sapply(x$pratique,function(y)y$id),collapse=",")),
			today=sapply(c,function(x)x$today),
			total=sapply(c,function(x)x$total),
			pays=sapply(c,function(x)x$pays)
		)
		write.csv2(x,paste0(i,".csv"),fileEncoding="UTF-8")
		l[[n]]=x
		n=n+1;
        } else print(i)
}
save.image(paste0("eco-visio-api_",Sys.Date(),".RData"))
m=do.call("rbind",l)
write.csv(m,paste0("eco-visio-api_data1_",Sys.Date(),".csv"),fileEncoding="UTF-8")

				     
#######################
# Example 2
#######################
				     
plausibleValues=c(100000000:100200000,200000000:200200000,300000000:300200000)
l=list()
n=1
write("Id-Collection",file="idCollection.txt",append=FALSE)
for(i in plausibleValues) { 
        if(i==1||i%%1000==0)print(paste0(i,"/",length(plausibleValues)));
	url=paste0("https://www.eco-visio.net/api/aladdin/1.0.0/pbl/publicwebpage/",i,"?withNull=true")
        r=httr::GET(url,config=httr::config(connecttimeout=60))
  	if(length(unlist(httr::content(r)))>2){ 
		l[[n]]=list(i,httr::content(r)); n=n+1; print(paste0("***",i)); 
		write(i,file="idCollection.txt",append=TRUE)
	}
}
tok=sapply(l,function(x)c("tok"=x[[2]]$token))
dat=sapply(l,function(x)c("lat"=x[[2]]$latitude,"lon"=x[[2]]$longitude))
nam=sapply(l,function(x)c("nam"=x[[2]]$titre))
id=sapply(l,function(x)c("id"=x[[1]]))

x=data.frame(id,nam,t(dat))
write.csv(x,paste0("eco-visio-api_data2_",Sys.Date(),".csv"),fileEncoding="UTF-8")

			     
#######################
# Example 3
#######################
	  
download.file("https://raw.githubusercontent.com/bundesAPI/eco-visio-api/main/eco-visio-api.csv",paste0(Sys.Date(),"_eco-visio-api.csv"))
download.file("https://raw.githubusercontent.com/bundesAPI/eco-visio-api/main/idPdc_with_publicwebpage.txt",paste0(Sys.Date(),"_idPdc_with_publicwebpage.txt"))
csv=read.csv(list.files(pattern="_eco-visio-api[.]csv")) # publicwebpageplus
org=names(table(csv[,"idOrganisme"])) # extract ids of organisations from publicwebpageplus-data
ids=readLines(list.files(pattern="_idPdc_with_publicwebpage[.]txt")) #publicwebpage

#---------------------------------
# retrieve data from all known IDs
#---------------------------------

urlPagesPlus=paste0("https://www.eco-visio.net/api/aladdin/1.0.0/pbl/publicwebpageplus/",org)
urlPages=paste0("https://www.eco-visio.net/api/aladdin/1.0.0/pbl/publicwebpage/",ids)
urls=c(urlPagesPlus,urlPages)
length(urlPagesPlus) #179
length(urlPages) #1718
dirname=gsub("\\W","",Sys.Date())
if(!file.exists(dirname))dir.create(dirname)
setwd(dirname)
	  res=lapply(1:length(urls), function(i){ # get results for each valid counter & save them locally
	url=urls[i]
	print(paste(i,"von",length(urls)))
	r=httr::GET(url,config=httr::config(connecttimeout=60))	
	httr::content(r)
 	writeLines(httr::content(r,as="text"),
		paste0("erg",i,"_counter.json"))
})


res=sapply(list.files(pattern="_counter[.]json$"),function(file) # read json-files
	(paste0(readLines(file),collapse="\n")))
res=sapply(res,function(x){if(x=="Not Found")return(NA); return(rjson::fromJSON(x));})
res=res[!is.na(res)]
res=t(sapply(res,function(id) # extract information from publicwebpage & publicwebpageplus
        if(length(id)>4)
	if(!is.list(id[[1]])){
		 return(c(id$idPdc,id$titre,id$domaine,id$latitude,id$longitude,id$token,"publicwebpage"))
	} else {
		return(sapply(id, function(x)c(x$idPdc,x$nom,x$nomOrganisme,x$lat,x$lon,"","publicwebpageplus")))
	}))

dat=t(do.call(cbind,res)) # bind results to matrix
head(dat)

#------------------------------
# Plot data on a map of Germany
#------------------------------

library(ggplot2)
library(raster)

cc=geodata::country_codes()
if(!exists("rasterDat"))
  rasterDat=geodata::elevation_30s("DEU",getwd())
terra::values(rasterDat)[terra::values(rasterDat)<0]=0
g0=ggplot2::ggplot() +
    tidyterra::geom_spatraster(data = rasterDat)+
    tidyterra::scale_fill_hypso_tint_c(
      limits = c(0,3000),
      palette = "wiki-2.0_hypso" 
    ) +
    #ggplot2::labs(fill="Elevation")+
    #ggplot2::ggtitle("Map of Germany") +
    ggplot2::theme_minimal()

dev.new();g0;

		
if(!exists("germany"))
	germany <- raster::getData(country = "Germany", level = 1) 
dat=data.frame( #extract relevant data
	dat[,c(3:4,2)],
	ifelse(dat[,8]=="publicwebpageplus","publicwebpageplus","publicwebpage"),
	apply(dat[,c(5:6)],2,as.numeric))
colnames(dat)=c("NOM","ORG","ID","TYP","LAT","LON") 

udat=apply(dat[,c("LAT","LON")],1,function(x)paste(x,collapse=";"))
udat=sort(table(udat))
udat=data.frame(
	LAT=as.numeric(gsub(";.*","",names(udat))),
	LON=as.numeric(gsub(".*;","",names(udat))),
        NUM=as.numeric(udat)
)
udat=udat[udat[,"LAT"]!=0&udat[,"LON"]!=0,]
sp::coordinates(udat) <- ~LON+LAT
sp::proj4string(udat) <- sp::proj4string(germany)
udat=data.frame(udat,sp:::over(udat, germany , fn = NULL)) # locate udat-coordinates in Germany
udat=udat[!is.na(udat[,"GID_0"]),] # remove udat-entries outside of Germany
table(udat[,"GID_0"],useNA="always")

germany$Freq=(table(udat[,"NAME_1"],useNA="always"))[germany$NAME_1]#
germany$Freq[is.na(germany$Freq)]=0
germany$Label=gsub("DE.","",germany$HASC_1)
germany$LON=sp::coordinates(germany)[,1]
germany$LAT=sp::coordinates(germany)[,2]
w=which(germany$Label=="BR");germany$LAT[w]=germany$LAT[w]-0.4
w=which(germany$Label=="HH"|germany$Label=="BE");germany$LAT[w]=germany$LAT[w]+0.2

#invisible(lapply(1:16,function(i){germany@polygons[[i]]@"labpt"=c(germany$LON,germany$LON)}))

g1=g0+
  ggplot2::geom_polygon(data=germany, # borders of 16 countries
               ggplot2::aes(x=long, y=lat, group=group),
               fill=NA,
	       colour=rgb(1,1,1,1))+
  ggplot2::geom_point(data=udat, # white underground for udat-entries
             ggplot2::aes(x=LON, y=LAT,size=NUM),  
	     colour="white",
             alpha=1)+
  ggplot2::geom_point(data=udat, # darkblue udat-entries
             ggplot2::aes(x=LON, y=LAT,size=NUM),  
	     colour="darkblue",
             alpha=.5)+
  ggplot2::geom_text(data=(germany@data), # country-labels 
	     ggplot2::aes(x=LON, y=LAT, label=Label),
             alpha=.8, 
	     size=3, 
             fontface="bold",col="black")+
  ggplot2::xlab("") + ggplot2::ylab("") +
  ggplot2::guides(fill="none")+
  ggplot2::labs(size="Ecocounter-IDs")+ 
  ggplot2::ggtitle('Eco-Counter Stations in Germany',
	subtitle =paste(sum(udat[,"NUM"]),"stations at",dim(udat),"locations"))

dev.new();g1

ggplot2::ggsave("EcocounterMapOfGermany.png")

save.image(paste(Sys.Date(),"ecocounterExamples.RData"))
				     

				     
