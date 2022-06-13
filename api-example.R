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
write.csv2(m,paste0("eco-visio-api_",Sys.Date(),".csv"),fileEncoding="UTF-8")
