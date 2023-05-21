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
csv=read.csv(list.files(pattern="eco-visio-api[.]csv")) # publicwebpageplus
org=names(table(csv[,"idOrganisme"])) # extract ids of organisations from publicwebpageplus-data
ids=readLines(list.files(pattern="idPdc_with_publicwebpage[.]txt")) #publicwebpage

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
sum(sapply(res,function(x)sum(grepl("Bad Request.",x))))
sum(sapply(res,function(x)sum(grepl("Not Found",x))))
res=sapply(res,function(x){if(x=="Not Found")return(NA); if(x=="Bad Request. Input number format")return(NA); return(jsonlite::fromJSON(x));})
res=res[!is.na(res)]

res=t(sapply(res,function(id) # extract information from publicwebpage & publicwebpageplus
        if(length(id)>4)
	if(is.null(dim(id))){
                 x=c(id$idPdc,id$titre,id$domaine,id$latitude,id$longitude,id$token,"publicwebpage")
		 return(x)
	} else {
                x=cbind(id$idPdc,id$nom,id$nomOrganisme,id$lat,id$lon,"","publicwebpageplus")
		return(x)
	}))

dat=(do.call(rbind,res))
head(dat)
colnames(dat)=c("idPdc","nom","nomOrganisme/domain","lat","lon","token","type")

write.csv(dat,paste0("eco-visio-api_collection.csv"),fileEncoding="UTF-8")

save.image(paste(Sys.Date(),"ecocounterExamples.RData"))
				     

				     
