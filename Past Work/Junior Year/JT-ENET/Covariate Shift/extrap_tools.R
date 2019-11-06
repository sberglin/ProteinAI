
sim.data<-function(type=c("block","pure","1d","same","hidden","labeled"),bls=c(-0.1,0.5)*2){
	if(missing(type))type="block"
	set.seed(100)
	
	if(type=="block"){
		dat<-extrapSim(muz=c(6,-6))
	}
	if(type=="pure"){
		dat<-extrapSim(muz=c(6,2.5))
	}
	if(type=="1d"){
		dat<-extrapSim1d()
	}
	if(type=="same"|type=="hidden"){
		dat<-samedist()
	}
	if(type=="labeled"){
		dat<-extrapSim(muz=c(0,0),varz1=0.01,varz2=0.01)
	}
	
	x=dat$xf
	L=dat$L
	U=dat$U
	
	if(type=="1d"|type=="block"|type=="same"|type=="labeled"){
		temp=x[U,1]
		x[U,1]=x[U,2]
		x[U,2]=temp
	}
	if(type=="hidden"){
		temp=x[U,1]
		x[U,1]=x[U,2]
		x[U,2]=-temp
	}
	n=dim(x)[1]
	p=dim(x)[2]
	y=rep(NA,n)
	y[L]=as.vector(x[L,]%*%bls)
	yL=y[L]
	list(y=y,x=x)
}


plot.extrap<-function(x,y,col.edir=c("#8B5742","#4BB74C"),adj=1,add=FALSE,...){
	n=dim(x)[1]
	p=dim(x)[2]
	
	L=which(!is.na(y))
	U=which(is.na(y))
	l=length(L)
	s.const=sqrt(n/l)
	
	xL=x[L,]
	xU=x[U,]
	mls=apply(xL,2,mean)
	ses<-sqrt(apply(xL,2,var)*(l-1)/l)
	if(sum(ses<1e-15)>0)ses[ses<1e-15]=1		
	xL=sweep(xL,2,mls)
	xL=sweep(xL,2,1/ses,FUN="*")
	xU=sweep(xU,2,mls)
	xU=sweep(xU,2,1/ses,FUN="*")
	
	mu=mean(y[L])
	sey=sqrt(var(y[L])*(l-1)/l)
	yL=(y[L]-mu)/(sey)*s.const
	ind<-is.na(xU)
	if(any(ind))xU[ind]<-0
	
	x[c(L,U),]=s.const*rbind(xL,xU)
  M=solve(t(x[L,])%*%x[L,],t(x[U,])%*%x[U,])
  eigM<-eigen(M)
  w1<-as.vector(t(x)%*%x%*%eigM$vec[,1])
  w2<-as.vector(t(x)%*%x%*%eigM$vec[,2])
  
  vec=c(rep(1,n)[L],rep(2,n)[U])
  graphics::plot(x,asp=1,type="n",xlab=expression(x[1]),ylab=expression(x[2]),...)
  graphics::text(x,c("L","U")[vec], col=c("red","blue")[vec],cex=1)
  graphics::abline(0,w1[2]/w1[1],lwd=2,col=col.edir[1])
  graphics::abline(0,w2[2]/w2[1],lwd=2,col=col.edir[2])
  return(eigM$val)
}
plot.coef<-function(x,y,alp=0,lam=0,gam1=NULL,gam2=NULL,cols=NULL,...){
	n=dim(x)[1]
	p=dim(x)[2]
	
	L=which(!is.na(y))
	U=which(is.na(y))
	l=length(L)
	s.const=sqrt(n/l)
	
	xL=x[L,]
	xU=x[U,]
	mls=apply(xL,2,mean)
	ses<-sqrt(apply(xL,2,var)*(l-1)/l)
	if(sum(ses<1e-15)>0)ses[ses<1e-15]=1		
	xL=sweep(xL,2,mls)
	xL=sweep(xL,2,1/ses,FUN="*")
	xU=sweep(xU,2,mls)
	xU=sweep(xU,2,1/ses,FUN="*")
	
	mu=mean(y[L])
	sey=sqrt(var(y[L])*(l-1)/l)
	yL=(y[L]-mu)/(sey)*s.const
  ind<-is.na(xU)
	if(any(ind))xU[ind]<-0
	
	x[c(L,U),]=s.const*rbind(xL,xU)
	
	if(is.null(gam1)){
      gam1=c(0.0,1:9/10^5,1:9/10^4,1:9/10^3,1:9/100,seq(1,9.999999,length=57)/10,1:10,2:10*10,2:10*100,2:10*1000,
      				 6.5e-04,0.0011,0.0012,0.0013,0.0014,0.0015,0.0016,0.0017,0.0018,0.0019,seq(0.01,0.02,length=8))
      gam1<-unique(sort(c(gam1,seq(1.1,2,length=37))))
      vmax<-floor(length(gam1)/5)
      gam1<-gam1[c(1,1:vmax*5)]
	}
	if(is.null(gam2)){
		gam2=c(1e-4,1e-3,2:9/100,seq(1,9.999999,length=57)/10,seq(1,10,length=47),2:10*10,2:10*100,2:10*1000,Inf)
	}
	if(is.null(cols)){
      cols=rainbow(length(gam2))
      cols=cols[length(gam2):1]
    }
    v1<-sort(rep(1:length(gam2),length(gam1)+1))
    
    eigU<- eigen(xU%*%t(xU))
    eigU$val[-c(1:2)]=0
	eigU$val[eigU$val<0]=0
    eigU$vec=t(eigU$vec)%*%xU
    x1=x
    x1[L,]=xL*s.const
    y1=rep(0,n)
    y1[L]=yL
    mat=NULL
    for(j in 1:length(gam2)){
      gam=gam2[j]
      mat1=NULL
      if(gam2[j]>0.0){
        if(is.finite(gam)){
          zU=s.const*sqrt(gam)*diag(1/sqrt((eigU$val+gam)))%*%eigU$vec
        }else{
          zU=s.const*xU
        }
        for(i in 1:length(gam1)){
          x1[U,]=zU*sqrt(gam1[i])
          bsemi<-as.vector(coef(glmnet(x1,y1,standardize=FALSE,lambda=lam,alpha=alp,intercept=FALSE)))
          bsemi[-1]=bsemi[-1]*sey/ses
          bsemi[1]=mu-sum(mls*bsemi[-1])
          mat1=rbind(mat1,bsemi[-1])
        }
        mat1=rbind(mat1,rep(0.0,2))
        mat1=cbind(j,mat1)
      }else{
        if(!(lam>0.0)){
          for(i in 1:length(gam1)){
            l=length(L)
            gsup<-glmnet(x1[L,],y1[L],lambda=sqrt(gam1[i]),alpha=alp,standardize=TRUE)
            bsemi<-as.vector(coef(gsup))
            bsemi[-1]=bsemi[-1]*sey/ses
            bsemi[1]=mu-sum(mls*bsemi[-1])
            mat1=rbind(mat1,bsemi[-1])
          }
          mat1=rbind(mat1,rep(0.0,2))
          mat1=cbind(j,mat1)
        }
      }
      mat=rbind(mat,mat1)
    }
    plot(mat[,-1],asp=1,type="n",xlab=expression(beta[1]),ylab=expression(beta[2]),...)
    
    mx<- max(mat[,1])
    
    for(i in 1:mx){
      ind<-mat[,1]==i
      lines(mat[ind,2],mat[ind,3],col=cols[i])
    }
    
}



arrowhead<-function(pt,nu,eps=0.03,...){
  adj<-pt-eps*nu
  nup=c(0,0)
  nup[1]=-nu[2]
  nup[2]=nu[1]
  
  rect<-cbind(pt,adj+eps*nup,adj-eps*nup,pt)
  polygon(rect[1,],rect[2,],...)
}

perpline<-function(pt,nu,eps=0.03,...){
  nup=c(0,0)
  nup[1]=-nu[2]
  nup[2]=nu[1]
  
  nup=nup/sqrt(sum(nup^2))
  
  lines(c(pt[1]+nup[1]*0,pt[1]-nup[1]*eps),
  c(pt[2]+nup[2]*0,pt[2]-nup[2]*eps),
  ...)
}
extrapSim<-function(l=31,u=69,
mux=c(0,0),rhox=-0.9,varx1=1,varx2=1,
muz=c(5,5),rhoz=0,varz1=1,varz2=1){
  n=l+u
  xvar=cbind(c(varx1,rhox),c(rhox,varx2))
  zvar=cbind(c(varz1,rhoz),c(rhoz,varz2))
  x=scale(mvrnorm(n,mux,xvar),scale=F)
  z=mvrnorm(n,muz,zvar)
  
  L=1:l
  U=(l+1):n
  xL=x[L,]
  xU=z[U,]
  
  mls<-apply(xL,2,mean)
  vls<-apply(xL,2,var)
  xL=sweep(xL,2,mls)
  xL=sweep(xL,2,1/sqrt(vls),FUN="*")/sqrt(length(L)-1)
  xU=sweep(xU,2,mls)
  xU=sweep(xU,2,1/sqrt(vls),FUN="*")/sqrt(length(U)-1)
  xf<-rbind(xL,xU)
  list(xf=xf,xL=xL,xU=xU,L=L,U=U,mls=mls,vls=vls)
}
extrapSim1d<-function(l=31,u=69,
mux=c(0,0),rhox=-0.9,varx1=1,varx2=1,
muz=c(1,0),rhoz=0,varz1=0.5,varz2=0.1){
  extrapSim(l,u,mux,rhox,varx1,varx2,muz,rhoz,varz1,varz2)
}
samedist<-function(l=31,u=69,
mux=c(0,0),rhox=-0.9,varx1=1,varx2=1,
muz=c(0,0),rhoz=-0.9,varz1=1,varz2=1){
  extrapSim(l,u,mux,rhox,varx1,varx2,muz,rhoz,varz1,varz2)
}

extrap3d<-function(l=31,u=69,mux=c(0,0,0),muz=c(5,5,5),
xvar=cbind(c(1,0.9,-0.0),c(0.9,1,0.0),c(-0.0,0.0,1)),
zvar=cbind(c(1,0.0,0.0),c(0.0,1,0.0),c(0.0,0.0,1))){
  n=l+u
  x=scale(mvrnorm(n,mux,xvar),scale=F)
  z=mvrnorm(n,muz,zvar)
  
  L=1:l
  U=(l+1):n
  xL=x[L,]
  xU=z[U,]
  
  mls<-apply(xL,2,mean)
  vls<-apply(xL,2,var)
  xL=sweep(xL,2,mls)
  xL=sweep(xL,2,1/sqrt(vls),FUN="*")/sqrt(length(L)-1)
  xU=sweep(xU,2,mls)
  xU=sweep(xU,2,1/sqrt(vls),FUN="*")/sqrt(length(U)-1)
  xf<-rbind(xL,xU)
  list(xf=xf,xL=xL,xU=xU,L=L,U=U,mls=mls,vls=vls)
}
getsup<-function(y,x,lambdas=NULL,alphas=seq(0,1,length=57),seed.cv=10,scale.x=TRUE,...){
	n=length(y)
	p=dim(x)[2]
	sey=sqrt(var(y)*(n-1)/n)
	
	lalp=length(alphas)
	tunes<-rep(0,lalp)
	lams<-rep(0,lalp)
	for(i in 1:lalp){
		set.seed(seed.cv)
		g1<-cv.glmnet(x,y,alpha=alphas[i],standardize=scale.x,...)
		lams[i]=g1$lambda.min
		tunes[i]=min(g1$cvm)
	}
	k<-which.min(tunes)
	lam=lams[k]
	alp=alphas[k]
	
	g1<-glmnet(x,y,alpha=alp,lambda=lam,standardize=scale.x,...)
	bsup=as.numeric(coef(g1))
  
	return(list(bsup=bsup,alp=alp,lam=lam/sey,errs=tunes))
}

genL<-function(i=100,n=100,p=10000){
	set.seed(i)
	mat<-matrix(rnorm(n*p),n,p)
	mat
}
genU<-function(i=100,u=100,xL,mus,v=0.6){
	l=dim(xL)[1]
	p=dim(xL)[2]
	L=1:l
	U=(l+1):(l+u)
	mls<-apply(xL,2,mean)
	vls<-apply(xL,2,var)
	xL=sweep(xL,2,mls)
	xL=sweep(xL,2,1/sqrt(vls),FUN="*")/sqrt(length(L)-1)
	
	set.seed(i)
	xU=NULL
	for(i in 1:u){
		xU<-rbind(xU,matrix(rnorm(p,mus,v),1,p))
	}
	xU=sweep(xU,2,mls)
	xU=sweep(xU,2,1/sqrt(vls),FUN="*")/sqrt(length(L)-1)
	xf<-rbind(xL,xU)
	list(xf=xf,xL=xL,xU=xU,L=L,U=U,mls=mls,vls=vls)
}

###

ellipsoid <- function(center=c(0, 0, 0), radius=1, shape=diag(3),segments=51) {
  angles <- (0:segments)*2*pi/segments
  ecoord2 <- function(p) {c(cos(p[1])*sin(p[2]), sin(p[1])*sin(p[2]), cos(p[2])) }
  unit.sphere <- t(apply(expand.grid(angles, angles), 1, ecoord2))
  t(center + radius * t(unit.sphere %*% chol(shape)))
}


plt.ellipse1<-function(g,y,x,bls,tau=tau,cols=c("gray","black",gray(0.3),"red","blue","black"),plt.ridge=FALSE,give.usr=TRUE,only.one=FALSE,...){
  bsemi<-g$bsemi
  alp<-g$alp
  ahat=sum( as.vector(x[L,]%*%(bls-bsemi))^2)
  chat=sum(as.vector(g$zU%*%(bsemi))^2)
  
  plot(0,0,type="n",...)
  
  if(plt.ridge)
  circle(b=c(0,0),radius=sqrt(sum(bsemi^2)),add=TRUE,lty=1,col=cols[1],lwd=2)
  ellipse(t(g$zU)%*%g$zU,c(0,0),chat,add=TRUE,col=cols[2],lwd=2)
  term=15
  seqs=2^(0:15)
  if(only.one){
    term=1
    seqs=2^(c(0,2))
  }
  for(i in 0:term){
    ellipse(t(x[L,])%*%x[L,],bls,ahat/seqs[i+1],add=TRUE,col=cols[3])
  }
}


plt.supridge<-function(bet,y,x,bls,cols=c("gray","black",gray(0.3),"red","blue","black"),plt.ridge=FALSE,plt.bsemi=TRUE,plt.bls=TRUE,plt.orig=TRUE,plt=TRUE,...){
  ahat=sum( as.vector(x[L,]%*%(bls-bet))^2)
  chat=sum(as.vector((bet))^2)
  
  if(plt)
  plot(0,1,type="n",...)
  
  if(plt.ridge)
  circle(b=c(0,0),radius=sqrt(sum(bsemi^2)),add=TRUE,lty=1,col=cols[1],lwd=2)
  ellipse(diag(2),c(0,0),chat,add=TRUE,col=cols[2],lwd=2)
  for(i in 0:15){
    ellipse(t(x[L,])%*%x[L,],bls,ahat/2^i,add=TRUE,col=cols[3])
  }
  box()
}


ellipse=function(A,b,RHS,...){
  A=(A+t(A))/2
  input=cbind(A, -A%*%b)
  input=rbind(input, cbind(-t(A%*%b),t(b)%*%A%*%b-RHS))
  conicPlot(input,...)
}
circle=function(b,radius,...){ellipse(diag(2),b,radius^2,...)}
