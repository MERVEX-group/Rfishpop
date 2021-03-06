% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/plotRF.R
\name{plotRF}
\alias{plotRF}
\title{Reference Points plots}
\usage{
plotRF(Pop.Mod, RF.result, iter)
}
\arguments{
\item{Pop.Mod}{A list containing the components returned by Population.Modeling function (main function).}

\item{RF.result}{A list containing the components returned by RF function (Reference Points).}

\item{iter}{The iteration for which the plot must be carried out.}
}
\value{
The plot described above in Details.
}
\description{
Returns a plot of the results provided by RF function (Reference Points)
}
\details{
The function reports the plots: equilibrium biomass v. fishing mortality, equilibrium yield v. fishing mortality, equilibrium recruitment v. biomass,  and equilibrium yield v. biomass. The  reference fishery mortalities are also plotted in the previous curves. Note that only the fishery mortalities required by the argument FM_type in RF function are plotted. If prop is a vector of length greater than 1 only the values corresponding to the first one will be represented in the plot for simplicity. On the other hand, note that F_msy and F_max coincide when the recruitment relationship is constant and hence only one of both appears in the plot. The reference fishery mortalities F_max and F_Crash can be overlapped in equilibrium recruitment v. biomass and equilibrium yield v. biomass plots then only once can be shown in the plot.
}
\examples{

#RF.result=RF(Pop.Mod, 3,3,Method="mean",par=NULL,
#FM_type=c("F_Crash","F_msy","F_0.1","F_max","F_BPR")
#,iters=1:2,plot=TRUE)
# plotRF(Pop.Mod,RF.result, iter=2)
}
\author{
\itemize{
\item{Marta Cousido-Rocha}
\item{Santiago Cerviño López}
\item{Maria Grazia Pennino}
}
}
