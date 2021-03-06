#' @title Total Yield, Biomass and Recruitment in Equilibrium
#'
#' @description Returns total Yield, Biomass and Recruiment in equilibrium for the corresponding fishing efforts and fishing mortalies. Furthermore, for each case the function also returns the corresponding biomass-per-recruit and yield-per-recruit.
#'
#' @param Pop.Mod A list containing the components returned by Population.Modeling function (main function).
#' @param f.grid A sequence of fishing efforts.
#' @param Fish.years The number of recent years to estimate the mean of SEL (selectivity, see information about such element in Sum.Pop.Mod function).
#' @param Bio.years The number of recent years to estimate the mean of M, Mat, WC, and W (natural mortality, maturity, stock weight and catches weight, see information about such elements in Population.Modeling function and Sum.Pop.Mod function).
#' @param Method The procedure to obtain the age vector of weight (stock and catches), natural mortality, selectivity and maturity. By default is "mean" which means that the mean of the last "Bio.years" is used. The alternative option is "own", the user can introduce these elements.
#' @param par If Method="own" it is a list containing the matrices whose columns report for each iteration the age vector of weight (stock and catches), natural mortality, selectivity and maturity. In other case is equal to NULL.
#' @param plot 	A vector of two elements. The first one is a logical parameter. By default is equal to TRUE, which means that a biomass per recruit and yield per recruit graphs are done. The second element refers to which iteration must be plotted.
#' @details The function returns total Yield, Biomass and Recruiment in equilibrium for the corresponding fishing efforts and fishing mortalities. Furthermore, for each case the function also returns the corresponding biomass-per-recruit and yield-per-recruit. Furthermore, the function also reports the population size in equilibrium for each age and fishing mortality.
#'
#' @return A list:
#' \item{N:}{An array whose third dimension is the number of iterations. For each iteration it reports a matrix containing the population size in equilibrium for each age.}
#' \item{DPM:}{An array whose third dimension is the number of iterations. For each iteration it reports a matrix containing the total biomass in equilibrium, total yield in equilibrium, total recruitment in equilibrium, biomass-per-recruit, and yield-per-recruit for a range of overall fishing mortalities.}
#' @author
#' \itemize{
#' \item{Marta Cousido-Rocha}
#' \item{Santiago Cerviño López}
#' \item{Maria Grazia Pennino}
#' }
#' @examples
#' ctrPop<-list(years=seq(1980,2020,by=1),niter=2,N0=15000,ages=0:15,minFage=2,
#'              maxFage=5,tc=0.5,seed=NULL)
#' number_ages<-length(ctrPop$ages);number_years<-length(ctrPop$years)
#'Mvec=c(1,0.6,0.5,0.4,0.35,0.35,0.3,rep(0.3,9))
#'M<-matrix(rep(Mvec,number_years),ncol = number_years)
#'colnames(M)<-ctrPop$years
#'rownames(M)<-ctrPop$ages
#'ctrBio<-list(M=M,CV_M=0.2, L_inf=20, t0=-0.25, k=0.3, CV_L=0, CV_LC=0, a=6*10^(-6), b=3,
#'            a50_Mat=1, ad_Mat=-0.5,CV_Mat=0)
#'ctrSEL<-list(type="cte", par=list(cte=0.5),CV_SEL=0)
#'f=matrix(rep(0.5,number_years),ncol=number_years,nrow=2,byrow=TRUE)
#'ctrFish<-list(f=f,ctrSEL=ctrSEL)
#'a_BH=15000; b_BH=50; CV_REC_BH=0
#'SR<-list(type="BH",par=c(a_BH,b_BH,CV_REC_BH))
#'Pop.Mod<-Population.Modeling(ctrPop=ctrPop,ctrBio=ctrBio,ctrFish=ctrFish,SR=SR)
#' f.grid<-seq(0.00,0.5,by=0.01)
#' RE<-BYR.eq(Pop.Mod,f.grid,3,3,c(TRUE,1),Method="mean",par=NULL)
#' N_eq<-RE$N
#' DPM<-RE$DPM
#' # The following commented lines refers to par argument.
#' # If par is not NULL must be something like (assuming that W, WC, M,
#' # Mat and SEL are defined previously).
#' # par=list(); par$W<-W; par$SEL<-SEL; par$Mat<-Mat; par$M<-M; par$WC<-WC
#' # RE=BYR.eq(Pop.Mod,f.grid,plot=c(TRUE,1),Method="own",par=par)
#' @export







BYR.eq<-function(Pop.Mod,f.grid,Fish.years,Bio.years,plot,Method,par){




  if(is.null(Method)){Method="mean"}
  if(is.null(plot)){plot=TRUE}
  ### We define a useful function

  YPR_use<-function(Pop.Mod,f.grid,Fish.years,Bio.years,min_age,max_age,plot,Method,par){
    min_age<-Pop.Mod$Info$minFage
    max_age<-Pop.Mod$Info$maxFage
    N<-Pop.Mod$Matrices$N;ages<-as.numeric(rownames(N))

    number_ages<-nrow(N)
    number_years<-ncol(N)

    niter<-dim(N)[3]

    if(Method=="mean"){
      W.ct<-(Sum.Pop.Mod(Pop.Mod,c("WC"))$WC)
      Mt<-Pop.Mod$Matrices$M
      st<-(Sum.Pop.Mod(Pop.Mod,c("SEL"))$SEL)

      W.c<-matrix(0,ncol=niter,nrow=number_ages);M<-W.c;s<-W.c
      for (ind2 in 1:niter){
        W.c[,ind2]<-apply(W.ct[,(number_years-Bio.years+1):number_years,ind2],1,mean)
        M[,ind2]<-apply(Mt[,(number_years-Bio.years+1):number_years,ind2],1,mean)
        s[,ind2]<-apply(st[,(number_years-Fish.years+1):number_years,ind2],1,mean)
      }}




    if(Method=="own"){
      Bio.years=NULL
      Fish.years=NULL
      W.c<-par$WC
      M<-par$M
      s<-par$SEL
    }

    l<-length(f.grid);Nlist<-array(0,dim = c(number_ages,l,niter))
    Flist<-matrix(0,ncol=l,nrow=niter)
    for (ind2 in 1:niter){
    F.vector<-1:l;ypr.vector<-1:l
    a<-1:l
    for (j in 1:l){
      F<-f.grid[j]*s #Now is a vector but later will be a matrix and a mean will be necessary
      Z<-F+M
      N<-1
      ypr<-0

      N.vec<-1:number_ages;N.vec[1]<-1
      for (i in 1:(number_ages-1)){

        ypr<-ypr+N*F[i,ind2]*W.c[i]*((1-exp(-Z[i,ind2]))/Z[i,ind2])
        N<-N*exp(-Z[i,ind2]);N.vec[i+1]<-N
      }

      N.vec[number_ages]<-N.vec[number_ages]/(1-exp(-Z[number_ages,ind2]))

      Nlist[,j,ind2]<-N.vec
      ypr<-ypr+(N*F[number_ages,ind2]*W.c[number_ages,ind2]/Z[number_ages,ind2])

      ypr.vector[j]<-ypr
      F.vector[j]<-mean(F[(min_age-ages[1]+1):(max_age-ages[1]+1),ind2])
    }
    Flist[ind2,]<-F.vector
    rownames(Nlist)<-ages}
    return(Nlist)}
  #####
  SR<-Pop.Mod$Info$SR
  min_age<-Pop.Mod$Info$minFage
  max_age<-Pop.Mod$Info$maxFage

  ypr<-YPR(Pop.Mod,f.grid,Fish.years,Bio.years,plot,Method,par)
  bpr<-BPR(Pop.Mod,f.grid,Fish.years,Bio.years,plot,Method,par)
  ### First steps

  N<-Pop.Mod$Matrices$N;ages<-as.numeric(rownames(N))
  number_ages<-nrow(N)
  number_years<-ncol(N)
  niter<-dim(N)[3]

  l<-length(f.grid)
  R<-array(0,dim = c(1,l,niter))
  B<-array(0,dim = c(1,l,niter))
  Y<-array(0,dim = c(1,l,niter))
  results<-array(0,dim = c(l,7,niter))
  for (ind2 in 1:niter){
  F<-bpr[,1,ind2]
  ind<-which(bpr[,2,ind2]<0);bpr[ind,2,ind2]<-0
  ind<-which(ypr[,2,ind2]<0);ypr[ind,2,ind2]<-0
  type<-SR$type
  if (type=="BH"){
    a_BH<-SR$par[1]
    b_BH<-SR$par[2]
    for (i in 1:l){
      if(bpr[i,2,ind2]>0){
      R[1,i,ind2]<-(-b_BH+a_BH*bpr[i,2,ind2])/bpr[i,2,ind2]} else {R[1,i,ind2]<-0}
      B[1,i,ind2]<-bpr[i,2,ind2]*R[1,i,ind2]
      Y[1,i,ind2]<-ypr[i,2,ind2]*R[1,i,ind2]
    }
  }

  if (type=="RK"){
    a_RK<-SR$par[1]
    b_RK<-SR$par[2]
    for (i in 1:l){
      if(bpr[i,2,ind2]>0){
      R[1,i,ind2]<-log(1/(a_RK*bpr[i,2,ind2]))/(-b_RK*bpr[i,2,ind2])} else {R[1,i,ind2]<-0}
      B[1,i,ind2]<-bpr[i,2,ind2]*R[1,i,ind2]
      Y[1,i,ind2]<-ypr[i,2,ind2]*R[1,i,ind2]
    }
  }

  if (type=="cte"){
    N0=Pop.Mod$Matrices$N[1,1,1]
    for (i in 1:l){
      R[1,i,ind2]<-N0
      B[1,i,ind2]<-bpr[i,2,ind2]*R[1,i,ind2]
      Y[1,i,ind2]<-ypr[i,2,ind2]*R[1,i,ind2]
    }
  }
  ind<-which(R[1,,ind2]<0);R[1,ind,ind2]<-0
  ind<-which(B[1,,ind2]<0);B[1,ind,ind2]<-0
  ind<-which(Y[1,,ind2]<0);Y[1,ind,ind2]<-0
results[,,ind2]<-cbind(f.grid,F,YPR=ypr[,2,ind2],BPR=bpr[,2,ind2],R.eq=R[,,ind2],Y.eq=Y[,,ind2],B.eq=B[,,ind2])
  }

colnames(results)<-c("f","F","YPR","BPR","R","Y","B")

Nlist<-YPR_use(Pop.Mod,f.grid,Fish.years,Bio.years,min_age,max_age,plot,Method=Method,par=par)

for(ind2 in 1:niter){
for (i in 1:l){
  Nlist[,i,ind2]<-Nlist[,i,ind2]*R[1,i,ind2]
}}

return(list(DPM=results,N=Nlist))
}


