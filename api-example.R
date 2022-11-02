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
        if(i==1||i%%1000==0)print(paste0(i,"/",length(newIds)));
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
 	writeLines(
		jsonlite::toJSON(
			httr::content(r),
			pretty=TRUE,
			auto_unbox=TRUE),
		paste0("erg",i,"_counter.json"))
})
res=sapply(list.files(pattern="_counter[.]json$"),function(file) # read json-files
	rjson::fromJSON(paste0(readLines(file),collapse="\n")))
res=t(sapply(res,function(id) # extract information from publicwebpage & publicwebpageplus
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
if(!exists("germany"))
	germany <- raster::getData(country = "Germany", level = 1) 
dat=data.frame( #extract relevant data from csv
	dat[,c(3:4,2)],
	ifelse(dat[,8]=="publicwebpageplus","publicwebpageplus","publicwebpage"),
	apply(dat[,c(5:6)],2,as.numeric))
colnames(dat)=c("NOM","ORG","ID","TYP","LAT","LON") 

w=which(as.numeric(dat[,"LAT"])<200 & as.numeric(dat[,"LON"])<200) # skip outlier
dat=dat[w,]
dat=dat[order(dat[,"ID"]),]
spatial_dat=dat
coordinates(spatial_dat) <- ~LON+LAT
proj4string(spatial_dat) <- proj4string(germany)
spatial_dat=sp:::over(spatial_dat, germany , fn = NULL) 
dat=dat[!is.na(spatial_dat[,"GID_0"]),] # select data of counters from Germany
dim(dat) # 1183 IDs (inc. publicwebpageplus & publicwebpage) of counters in Germany
length(table(dat[,"ID"])) # 673 unique IDs
length(table(paste(dat$LAT,dat$LON))) # 616 different coordinates of counters
table(spatial_dat[,"GID_0"],useNA="always")
sort(table(spatial_dat[,"NAME_1"],useNA="always"))
labels=NULL 
if(T){ # generate a data.frame for labels and aggregated data
	labels=data.frame(coordinates(germany),germany,(table(spatial_dat[,"NAME_1"],useNA="always"))[germany$NAME_1])
	labels$Freq[is.na(labels$Freq)]=0
	set.seed(0)
	#dat$LAT=jitter(dat$LAT)
	#dat$LON=jitter(dat$LON)
	colnames(labels)[1:2]=c("long","lat")
	labels[,"HASC_1"]=gsub("DE.","",labels[,"HASC_1"])
	w=which(labels[,"HASC_1"]=="BR")
	labels[w,"lat"]=labels[w,"lat"]-0.4
	w=which(labels[,"HASC_1"]=="HH"|labels[,"HASC_1"]=="HB"|labels[,"HASC_1"]=="BE")
	labels[w,"lat"]=labels[w,"lat"]+0.2
}
if(T){ add feature to Polygon-element
	library(dplyr)
	germany$Freq=labels$Freq
	gertab <- fortify(germany) 
	gislayerdata <- mutate(as.data.frame(germany), id = rownames(data.frame(germany0)) ) 
	gertab <- inner_join(gertab, gislayerdata, "id")
}
dev.new();
ggplot() +
  geom_polygon(data=gertab,
               aes(x=long, y=lat, group=group, fill=Freq),
	       colour='black'
               ) +
  geom_point(data=dat,
             aes(x=LON, y=LAT, col=TYP),  
             alpha=.5,
             size=1.5) +
  geom_text(data=labels, 
	     aes(x=long, y=lat, label=HASC_1),
             alpha=.5, 
	     size=3, 
             fontface="bold",col="white")+
  coord_map() +
  theme_void() +
  #theme(legend.position = "bottom") +
  xlab("Longitude") + ylab("Latitude") +
  labs(
	color = 'Source type:', 
	fill="No. of Counter-IDs") +
  scale_color_manual(values=c("red","green"))+
  #scale_fill_gradient(low="darkblue", high="white")+
  ggtitle('Eco-Counter Stations in Germany',
	subtitle =paste(dim(dat)[1],"IDs at",616,"different locations"))

save.image(paste(Sys.Date(),"ecocounterExamples.RData"))
				     

				     
