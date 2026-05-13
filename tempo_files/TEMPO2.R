library(DTAM)   # compute_AB_classical, psi_GaussianVAR, simul_GaussianVAR, ...
library(akima)  # interp() to get smooth contour for P(w)=1

# ============================================================
# 1) Define a simple 2D Gaussian VAR model for the state w_t
# ============================================================

rho  <- 0.7
phi  <- 0.9
rbar <- 0.04

sigma_r <- 0.005
sigma_x <- 0.0025

# A0/A1 representation:
A1 <- matrix(c(rho, -rho,
               0,    phi), 2, 2, byrow = TRUE)
A0 <- matrix(c(1,  -1,
               0,   1), 2, 2, byrow = TRUE)

Phi     <- solve(A0) %*% A1
Sigma12 <- solve(A0) %*% diag(c(sigma_r, sigma_x))
Sigma   <- Sigma12 %*% t(Sigma12)

mu <- solve(A0) %*% matrix(c(0, rbar * (1 - phi)), 2, 1)

model <- list(mu = mu, Phi = Phi, Sigma = Sigma, Sigma12 = Sigma12)

xi0 <- 0
xi1 <- c(1,0)
u <- matrix(c(0,0),ncol=1)
H <- 5

u2 <- matrix(c(.5,2),ncol=1)

AB1 <- compute_AB_thk(xi0 = xi0,
                     xi1 = xi1,
                     u = u,
                     H = H,
                     k = 0,
                     psi=psi_GaussianVAR,
                     psi.parameterization = model,
                     u2 = u2)

AB2 <- compute_AB_classical(xi0,xi1,
                            kappa0 = 0,
                            kappa1 = -u2,
                            H = H,
                            psi=psi_GaussianVAR,
                            psi.parameterization = model)


AB1$A[,,H]
AB2$A[,,H]
AB1$B[,,H]
AB2$B[,,H]
