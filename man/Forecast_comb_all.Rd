\name{Forecast_comb_all}
\alias{Forecast_comb_all}

\title{All posible combinations forecast averaging}
\description{
Combine different forecasts using complete subset regressions. Apart from the simple averaging, weights based on information criteria (AIC, corrected AIC, Hannan Quinn and BIC) or based on the Mallow criterion are also available.
}
\usage{
Forecast_comb_all(obs, fhat, fhat_new = NULL)
}

\arguments{
  \item{obs}{Observed series.}
  \item{fhat}{fhat Matrix of available forecasts.}
  \item{fhat_new}{Matrix of available forecasts as a test set. Optional, default to NULL.}
    }
\details{
OLS forecast combination is based on \deqn{ obs_t = const + \sum_{i = 1}^p w_{i} \widehat{obs}_{it} + e_t, } where \eqn{obs} is the observed values and \eqn{\widehat{obs}} is the forecast, one out of the \eqn{p} forecasts available.

The function computes the complete subset regressions. So a matrix of forecasts based on all possible subsets of \code{fhat} is returned.

Those forecasts can later be cross-sectionally averaged to create a single combined forecast.

Additional weight-vectors which are based on different information criteria are also returned. This is in case the user would like to perform the frequensit version of forecast averaging or based on the Mallows criterion (see references for more details).

Although the function is geared towards forecast averaging, it can be used in any other application as a generic complete subset regression.
}

\value{
% return(list(pred = pred, full_model_crit = full_model_crit, aic =AIC_weights,
 %             aicc = AICc_weights, bic = BIC_weights, hq = HQ_weights, mal = MAL_weights ))
  \code{Forecast_comb_all} returns a list that contains the following objects:
  \item{pred}{Vector of fitted values if \code{fhat_new} is not \code{NULL} or the vector of predictions if \code{fhat_new} is provided.}
  \item{full_model_crit}{List. The values of information criteria computed based on a full model, the one which includes all available forecasts.}
  \item{aic}{A vector of weights for all possible forecast combinations based on the Akaike's information criterion.}
  \item{aicc}{A vector of weights for all possible forecast combinations based on the corrected Akaike's information criterion.}
    \item{bic}{A vector of weights for all possible forecast combinations based on the Bayesian's information criterion.}
  \item{hq}{A vector of weights for all possible forecast combinations based on the Hannan Quinn's information criterion.}
\item{mal}{A vector of weights for all possible forecast combinations based on the Mallow's information criterion.}
}
\references{

\cite{Hansen, B. (2008) Least-squares forecast averaging. Journal of Econometrics, Vol. 146, No. 2. , pp. 342-350}

\cite{Kapetanios, G., Labhard V., Price, S. Forecasting Using Bayesian and Information-Theoretic Model Averaging. Journal of Business & Economic Statistics, Vol. 26, Iss. 1, 2008}

\cite{Koenker R. (2005) Quantile Regression. Cambridge University Press.}

\cite{Graham, E., Garganob, A., Timmermann, A. (2013) Complete subset regressions. Journal of Econometrics. Vol 177, 2, pp. 357-373. } }

\author{Eran Raviv (\email{eeraviv@gmail.com})}

\examples{
library(MASS)
tt <- NROW(Boston)/2
TT <- NROW(Boston)
y <- Boston[1:tt, 14] # dependent variable is columns number 14
 # Create two sets of explanatory variables
 x1 <- Boston[1:tt, 1:6] # The first 6 explanatories
 x2 <- Boston[1:tt, 7:13]# The last 6 explanatories
# create two forecasts based on the two different x1 and x2
 coef1 <- lm(y ~ as.matrix(x1))$coef
 coef2 <- lm(y ~ as.matrix(x2))$coef
 f1 <- t(coef1 \%*\%  t(cbind(rep(1,tt), Boston[(tt+1):TT, 1:6] )))
 f2 <- t(coef2 \%*\% t(cbind(rep(1,tt), Boston[(tt+1):TT, 7:13] )))
 ff <- cbind(f1,f2)
 comb_all <- Forecast_comb_all(obs = Boston[(tt+1):TT, 14], fhat = ff)
 # To get the combined forecasts from the all subset regression:
 Combined_forecast <- apply(comb_all$pred, 1, mean)
# To get the combined forecasts based on aic criteria for example:
Combined_forecast_aic <- t(comb_all$aic \%*\% t(comb_all$pred))
}



