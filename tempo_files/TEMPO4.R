
library(DTAM)

# ------------------------------------------------------------------------------
# Bansal and Yaron (2004): Homoskedastic case
# (using psi_GaussianVAR() for Laplace Transform)
# ------------------------------------------------------------------------------

# Parameterization from Bansal and Yaron (2004):
EIS   <- 1.5
gamma <- 10
delta <- .998
mu    <- .0015
mu_d  <- .0015
phi   <- .979
beta  <- 3
sigma <- 0.0078
varphi_e <- .044
varphi_d <- 4.5

model_basic <- list(
  mu = matrix(c(0,mu,mu_d),3,1),
  Phi = matrix(c(phi,1,beta,rep(0,6)),3,3),
  Sigma = diag(sigma^2*c(varphi_e,1,varphi_d)^2),
  rho = 1/EIS,
  phi = phi,
  gamma = gamma,
  delta = delta,
  sigma = sigma,
  mu_c0 = 0,
  mu_c1 = c(0,1,0),
  n_w = 3
)


#all_EIS <- c(.5,.999,1.5,NaN)
all_EIS <- c(1,2,NaN)
all_col <- c("black","black","black","darkgrey","darkgrey","darkgrey")
all_lty <- c(1,2,3,1,2,3)
all_lwd <- c(2,2,1,2,2,1)

all_gamma <- c(seq(.20001,1.3,length.out=40),1.5,2,3)

all_maxSR <- matrix(0,2*length(all_EIS),length(all_gamma))

count_EIS <- 0

for(std_mesurement_noise in c(.0000001,100)){
  
  # Modify model to take into account imperfect observation ----------------------
  Omega12 <- diag(c(.0000000001,std_mesurement_noise))
  A <- matrix(c(model_basic$mu_c1,c(1,0,0)),nrow=2,byrow = TRUE)
  B <- c(model$mu_c0,0)
  VAR_ImperfectInfo <- 
    make_stationary_filter(model_basic$mu,
                           model_basic$Phi,
                           t(chol(model_basic$Sigma)),A,B,Omega12)
  P <- VAR_ImperfectInfo$P
  Phi_21 <- VAR_ImperfectInfo$Phi_ww[4:6,1:3]
  Sigma <- VAR_ImperfectInfo$Sigma12_ww %*% t(VAR_ImperfectInfo$Sigma12_ww)
  Sigma_22 <- Sigma[4:6,4:6]
  
  Sigma_wtt <- Phi_21 %*% P %*% t(Phi_21) + Sigma_22
  
  model_ImperfectInfo <- model_basic
  model_ImperfectInfo$Sigma <- Sigma_wtt
  
  model <- model_basic
  model <- model_ImperfectInfo
  # ------------------------------------------------------------------------------
  
  model_solved <- solve_EZ_SDF(model,psi_GaussianVAR,Ew=NaN,z_bar_ini=1,
                               nb_loop_z_bar = 20,nb_loop_mu_z1 = 20)
  # # Check formula (compare wih analytical BY formula):
  # A1 <- (1 - 1/EIS)/(1 - model_solved$kappa1*model$phi)

  
  for(EIS in all_EIS){
    count_EIS <- count_EIS + 1
    count_gamma <- 0
    model$rho <- 1/EIS
    for(gamma in all_gamma){
      count_gamma <- count_gamma + 1
      model$gamma <- gamma
      if(is.na(EIS)){
        model$rho <- model$gamma
      }
      
      if((!is.na(EIS))&(EIS==1)){
        res <- solve_EZ_UnitEIS(model,psi = psi_GaussianVAR,Phi = model$Phi)
      }
      if((!is.na(EIS))&(EIS!=1)){
        res <- solve_EZ_SDF(model,psi_GaussianVAR,Ew=NaN,z_bar_ini=5,
                            nb_loop_z_bar = 20,nb_loop_mu_z1 = 20)
      }
      if(is.na(EIS)){
        res <- solve_CRRA(model,psi)
      }
      
      psi_w_2alpha <- psi_GaussianVAR(2*res$alpha,model)
      psi_w_alpha  <- psi_GaussianVAR(res$alpha,model)
      w <- res$Ew
      maxSR <- sqrt(exp(t(psi_w_2alpha$a - 2*psi_w_alpha$a) %*% w +
                          psi_w_2alpha$b - 2*psi_w_alpha$b)-1)
      all_maxSR[count_EIS,count_gamma] <- maxSR*sqrt(12)
    }
  }
}

par(plt=c(.15,.95,.2,.99))
plot(all_gamma,(all_maxSR[1,]),ylim=c(0,.2),type="l",
     lwd=all_lwd[1],las=1,col=all_col[1],lty=all_lty[1],
     xlab=expression(paste("coefficient of RRA (",gamma,")",sep="")),
     ylab="maximum Sharpe ratio (annualized)")
grid()
for(i in 2:dim(all_maxSR)[1]){
  lines(all_gamma,(all_maxSR[i,]),lwd=all_lwd[i],
        col=all_col[i],lty=all_lty[i])
}

for(i in 1:(length(all_EIS)-1)){
  j <- which.min(abs(all_gamma - 1/all_EIS[i]))
  y <- all_maxSR[length(all_EIS),j]
  points(1/all_EIS[i],y,pch=19)
}

legend("topleft",
       c(expression(paste("EIS = 1",sep="")),
         expression(paste("EIS = 1.5",sep="")),
         expression(paste("EIS = 1/",gamma," (CCAPM case)",sep=""))),
       lwd=all_lwd,
       lty=all_lty,
       col=all_col,
       seg.len = 3
)

legend("topright",
       c(expression(paste("Full information",sep="")),
         expression(paste("Limited information",sep=""))),
       lwd=2,
       pch=15,
       lty=c(NaN,NaN),
       col=c("black","darkgrey"),
       seg.len = 3
)





