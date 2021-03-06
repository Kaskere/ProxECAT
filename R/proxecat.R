
#' ProxECAT
#'
#' Runs Proxy External Controls Association Test (ProxECAT) method given the number of rare alleles in each gene region
#'
#' @param x1 vector of the number of functional rare alleles in cases for each gene region
#' @param x2 vector of the number of synonymous rare alleles (or other proxy) in cases for each gene region
#' @param x3 vector of the number of functional rare alleles in controls for each gene region
#' @param x4 vector of the number of synonymous rare alleles (or other proxy) in controls for each gene region
#'
#' @return input data, likelihood ratio test statistic and p-value for proxy-ECAT. LRT is asymptotically chi-squared with 1 df.
#'
#' @examples
#' ##runs ProxECAT for 5 gene regions
#' x1<-c(12,10,5,80,31)
#' x2<-c(6,5,3,10,2)
#' x3<-c(20,20,8,5,5)
#' x4<-c(9,11,8,7,3)
#' temp<-proxecat(x1=x1, x2=x2, x3=x3, x4=x4)
#' temp
#'
#'@importFrom stats dnbinom dpois
#'
#' @export

proxecat<-function(x1, x2,x3,x4){
  if(min(c(x1, x2, x3, x4))<0) {warning(paste("row(s)", paste(which(apply(cbind(x1, x2, x3, x4), 1, min)<0), collapse=","), "contain at least one negative value"))}
  
den<-x1+x2+x3+x4
lambda1<-(x1**2+x1*x2+x1*x3+x2*x3)/den
lambda2<-(x2**2+x1*x2+x1*x4+x4*x2)/den
lambda3<-(x3**2+x1*x3+x3*x4+x1*x4)/den
lambda4<-(x4**2+x3*x4+x2*x3+x4*x2)/den

L_const<-dpois(round(x1),lambda1)*dpois(round(x2),lambda2)*dpois(round(x3),lambda3)*dpois(round(x4),lambda4)
L_unconst<-dpois(round(x1),x1)*dpois(round(x2),x2)*dpois(round(x3),x3)*dpois(round(x4),x4) 
test.statistic <- -2*log(L_const/L_unconst)
p.value <- pchisq(test.statistic, 1, lower.tail=F)
dat<-data.frame(x1=x1, x2=x2, x3=x3, x4=x4)

out<-list(dat = dat, test.statistic = test.statistic, p.value = p.value)
return(out)
}
