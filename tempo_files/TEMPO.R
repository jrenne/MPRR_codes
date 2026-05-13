

# Check Campbell-Shiller approximation

z_bar <- 5

freq <- 4

D <- .04/freq

z_bar <- log(1/D)

sigma_Dd <- .02/freq

values_Dd <- seq(-.1,.1,by=.01)

r <- 1

values_z <- seq(z_bar-3,z_bar+3,by=.1)

kappa1 <- exp(z_bar)/(1 + exp(z_bar))
kappa0 <- log(1 + exp(z_bar)) - kappa1*z_bar
  
plot(values_z,kappa0 + kappa1*values_z,lwd=3,col="white")
grid()
points(values_z,kappa0 + kappa1*values_z,col="darkgrey",lwd=2,pch=3)
lines(values_z,log(1 + exp(values_z)),col="red",lwd=2)

