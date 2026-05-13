## Nested Gaussian case of your two-factor model:
##   w2,t = 0
##   w1,t = sigma * eps_t
##   Δ log S_t = delta + w1,t = delta + sigma * eps_t
## Risk-neutral drift delta is LEFT FREE (consistent with ex-dividend price + unspecified dividends).
## We compute call prices in CLOSED FORM from the lognormal distribution.


call_lognormal_dt <- function(S_t = 1, K_over_S = seq(0.9, 1.1, by = 0.1),
                              H = 5, sigma = 0.01, delta = 0.004, r = 0) {
  K <- S_t * K_over_S
  vH <- sigma * sqrt(H)
  mH <- H * delta  # mean of log(ST/S_t) under Q
  
  # If log(ST) ~ N(log(S_t)+mH, vH^2), then:
  # E[ST 1_{ST>K}] = S_t * exp(mH + 0.5*vH^2) * Phi(d1)
  # P(ST>K)       = Phi(d2)
  d1 <- (log(S_t / K) + mH + vH^2) / vH
  d2 <- (log(S_t / K) + mH) / vH
  
  disc <- exp(-r * H)
  C <- disc * (S_t * exp(mH + 0.5 * vH^2) * pnorm(d1) - K * pnorm(d2))
  names(C) <- sprintf("K/S=%.2f", K_over_S)
  C
}

## Optional: Monte Carlo check (should match the closed form up to simulation error)
call_lognormal_dt_mc <- function(S_t = 1, K_over_S = seq(0.9, 1.1, by = 0.1),
                                 H = 5, sigma = 0.01, delta = 0.004, r = 0,
                                 n_mc = 2e6, seed = 1) {
  set.seed(seed)
  K <- S_t * K_over_S
  Z <- rnorm(n_mc)
  log_growth <- H * delta + sigma * sqrt(H) * Z
  STH <- S_t * exp(log_growth)
  disc <- exp(-r * H)
  C <- sapply(K, function(Ki) disc * mean(pmax(STH - Ki, 0)))
  names(C) <- sprintf("K/S=%.2f", K_over_S)
  C
}

## Example usage
S_t <- 1
K_over_S <- seq(0.9, 1.1, by = 0.1)
H <- 5
sigma <- 0.01
delta <- 0.004   # left free
r <- 0

C_cf <- call_lognormal_dt(S_t, K_over_S, H, sigma, delta, r)
C_mc <- call_lognormal_dt_mc(S_t, K_over_S, H, sigma, delta, r, n_mc = 2e6, seed = 2)

print(rbind(ClosedForm = C_cf, MonteCarlo = C_mc, Diff = C_cf - C_mc))




alpha <- .05
rho   <- .9
mu    <- 2
beta  <- rho/mu
sigma <- .01
chi   <- .000
phi   <- .0
kappa <- .00
delta <- .004

model <- list(
  alpha = alpha,
  mu    = mu,
  beta  = beta,
  sigma = sigma,
  chi   = chi,
  phi   = phi,
  kappa = kappa,
  delta = delta,
  n_w = 2
)

set.seed(2)

nb.sim <- 10
S      <- rep(1,nb.sim)

sim.w <- matrix(0,nb.sim,2)

K_over_S <- seq(.9,1.1,by=.1)

parameterization = list()
parameterization$model <- model
parameterization$xi0 = 0
parameterization$xi1 = matrix(0,2,1)

H <- 5

res <- price_Stock_calls_puts(W = sim.w, # Values of state vector (T x n)
                              S = S, # ex-dividend stock price (T x 1)
                              H = H, # maximum maturity, in model periods
                              a = matrix(c(1,-kappa),ncol=1),
                              b = delta, # specif. of ex-dividend stock returns
                              K_over_S = K_over_S, # vector of strikes
                              psi = psi_stocks2fact, # Laplace transform of W
                              parameterization = parameterization,
                              max_x = 10000, # settings for Riemann sum comput.
                              dx_statio = 1,
                              min_dx = 1e-05,
                              nb_x1 = 10000)


res$Calls[,1,]



