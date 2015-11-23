
\name{Forecast_comb}
\alias{Forecast_comb}

\title{Forecasts combination using regression, robust regression, constrained regression or variance based}
\description{
Combine different forecasts. Use simple average, Ordinary Least Squares (OLS), robust regression, inverse mean squared error
(IMSE), constrained least squares (CLS), or simply use the best forecast based on the MSE metric.
}
\usage{
Forecast_comb(obs, fhat, fhat_new= NULL, Averaging_scheme= c("simple", "ols", "robust",
"cls", "variance based", "best") )
}

\arguments{
  \item{obs}{Observed series}
  \item{fhat}{fhat Matrix of available forecasts. These are used to retrieve the weights. How each forecast should be weighted in the overall combined forecast.}
  \item{fhat_new}{Matrix of available forecasts as a test set. Optional, default to NULL.}
  \item{Averaging_scheme}{Which averaging scheme should be used?}
    }
\details{
Performs simple forecast averaging where each forecast carries equal weight:  \eqn{\frac{1}{p}} with p the column dimension of \code{fhat}. OLS forecast combination is based on \deqn{ obs_t = const + \sum_{i = 1}^p w_{i} \widehat{obs}_{it} + e_t, } where \eqn{obs} is the observed values and \eqn{\widehat{obs}} is the forecast, one out of the p forecasts available.

Robust regression performs the same, but minimize different loss function, which is less sensitive to outliers (see quantile regression and references therein).

Constrained least squares minimize the sum of squared errors under the restriction that the weights sum up to 1, and that the forecasts themselves are unbiased (no intercept in the regression).

The variance-based method computes the mean squared error and weigh the forecasts according to their accuracy. Accurate forecasts (based on MSE metric) receive relatively more weight.

The best restric all the weights to zero apart from the best forecast, again based on the MSE. Essentially selecting only one forecast to be used.
}

\value{
  \code{Forecast_comb} returns a list that contains the following objects:
  \item{fitted}{Vector of fitted values.}
  \item{pred}{Vector of prediction. This object is empty if there was no test matrix \code{fhat_new} provided.}
  \item{weights}{Vector of weights based on the \code{Averaging_scheme}.}
}

\references{

\cite{Bates, J. M., Granger, C.W. (1969), The combination of forecasts, Operations Research Quarterly, 20(4), 451-468}

\cite{Clemen, R.T. (1989) Combining forecasts: A review and annotated bibliography. International Journal of Forecasting
5, 559-583.}

\cite{Koenker, R. (2005) Quantile Regression. Cambridge University Press.}

\cite{Timmermann, A.G. (2006) Forecast combinations. In: Elliott, G., Granger, C.W., Timmermann, A. (Eds.), Handbook
of Economic Forecasting, Elsevier, 135-196.}
}
\author{Eran Raviv (\email{eeraviv@gmail.com})}
\examples{
 library(MASS)
 tt <- NROW(Boston)/2
 TT <- NROW(Boston)
 y <- Boston[1:tt, 14] # dependent variable is columns number 14

 # Create two sets of explanatory variables
 x1 <- Boston[1:tt, 1:6] # The first 6 explanatories
 x2 <- Boston[1:tt, 7:13]# The last 6 explanatories

#create two forecasts based on the two different x1 and x2
 coef1 <- lm(y~as.matrix(x1))$coef
 coef2 <- lm(y~as.matrix(x2))$coef
 f1 <- t(coef1 \%*\% t(cbind(rep(1,tt), Boston[(tt+1):TT, 1:6] )))
 f2 <- t(coef2 \%*\% t(cbind(rep(1,tt), Boston[(tt+1):TT, 7:13] )))
 ff <- cbind(f1, f2)
scheme=c("simple", "ols", "robust", "variance based", "cls", "best")

example0 <- list()

 for ( i in 	scheme) {
 	example0[[i]] <- Forecast_comb(obs = Boston[(tt+1):TT, 14] ,
 	fhat = ff, Averaging_scheme = i)
 	cat(i, ":",  sqrt(mean((example0[[i]]$fitted - Boston[(tt+1):TT, 14] )^2)), "\n" )
 }

# Compare with
apply(ff, 2, function(x) {  sqrt(mean((x - Boston[(tt+1):TT, 14])^2)) }  )
}
