#The below script will let you run a whole hemisphere genetic analyses using vertex/voxelwise brain data. 
#This analysis will run in parallel. 
#There are sections designated with a **** those are the ones where you will need to change something to make this script work

#First! Make sure you have these packages loaded in R.
library(umx)
library(utils)
library(munsell)
library(foreach)
library(doMC)
library(data.table)
library(parallel)

#For windows users only, the parallelization process requires the packages below, instead of doMC
#library(doParallel)
#library(doSNOW)

#****Resgister your parallel backend. Basically, this means the number in the parantheses should be your number of cores.
#In this case, I am using  a computer  with 8 cores.
registerDoMC(8)


#I recommend these default settings for OpenMx and umx. I find they recover the most accurate estimates.
mxOption(NULL, "Standard Errors", "No")
mxOption(NULL, "Calculate Hessian", "No") 
mxOption(NULL, "Default optimizer", "SLSQP")
umx_set_auto_run(TRUE)
umx_set_auto_plot(FALSE)

#****read in a datafile that contains the vertex wise data and the variable of interest.
#IMPORTANT NOTE: the data should be organized in a twin file similar to the OpenMx built-in files; More specifically each twin has their own column
#for each variable, there is the same number of twin 1 as twin 2 variables, and they end in the suffix "1" for twin one and "2" for twin
#two.  Any variable that you don't want run with this analysis should not end with a "1" or "2" suffix.  
#IMPORTANT NOTE: make sure that there aren't columns that end in 1 or 2 that aren't data on a variable you want to run.  If you have that
#the function will give you junk estimates. 

Analysis <- fread("VertexWiseTwinData.csv", header=T, data.table=FALSE)

#Load these three functions into your environment
TwoOfClubs <- function(x, y) { 
  A2 <- sqrt((x^2)+(y^2)) 
  rA <- (x/A2) 
  return(rA)
}

ThreeOfClubs <- function(x, y) {
  r <- x*y
  return(r)
}


AceOfSpades.vertex <- function(D, V, ZYG, MZ, DZ) {
  column_names <- colnames(D)
  Names1 <- column_names[grepl("1$", column_names)] #make 
  Names2 <- column_names[grepl("2$", column_names)]
  selDVs <- c(Names1, Names2)
  mzData <- D[D[,ZYG] ==MZ, selDVs]
  dzData <- D[D[,ZYG] ==DZ, selDVs]
  Names <- substr(Names1, 1, nchar(Names1)-1) 
  Names3 <- Names[!Names %in% V]
  #remove the ones because umx takes care of that stuff in the multivariate case
  #Names2 <- column_names[grepl("2$", column_names)]
  #s <- c()
  #Names2
  #Epic <- t(combn(Names, 2))
  m2 <- NULL
  Path1A <- NULL
  CrossPathA <- NULL
  SpecificA <- NULL
  Path1C <- NULL
  CrossPathC <- NULL
  SpecificC <- NULL
  Path1E <- NULL
  CrossPathE <- NULL
  SpecificE <- NULL
  Answers <- NULL
  Var1 <- NULL
  Var2 <- NULL
  i<- NULL
  Epic1 <- Names3
  selDVs <- NULL
  Warn <- NULL
  CrTwCrTrMZ <- NULL
  CrTwCrTrDZ <- NULL
  WiTwCrTrMz <- NULL
  WiTwCrTrDZ <- NULL
  PvalueA <- NULL
  PvalueE <- NULL
  #loop multiple phenotypes
  Answers <- foreach(i=1:length(Epic1), .packages=c("umx", "data.table"), .combine='rbind')%dopar% {
    # umx will add suffix (in this case "") + "1" or '2'
    #SelDVs <- NULL
    tryCatch({
    withWarnings <- function(expr) {
      myWarnings <- NULL
      wHandler <- function(w) {
        myWarnings <<- c(myWarnings, list(w))
        invokeRestart("muffleWarning")
      }
      val <- withCallingHandlers(expr, warning = wHandler)
      list(value = val, warnings = myWarnings)
    } 
    Var1[i] <- Epic1[i]
    Var2[i] <- V
    selDVs = c(Epic1[i], V) 
    #selDVs = c("anti", "Num")
    a <- withWarnings(m1 <- umxModify(m2 <- umxACE(selDVs = selDVs, dzData = dzData, mzData = mzData, sep =""), update = c("c_r2c2", "c_r2c1")))
    ModifiedA <- umxModify(m1, update="a_r2c1")
    m3 <- mxCompare(m1, ModifiedA)
    ModifiedE <- umxModify(m1, update="e_r2c1")
    m4 <- mxCompare(m1, ModifiedE)
    #initial path
    list("Var1" = Var1[i], "Var2" = Var2[i], "Path1A" = Path1A[i] <-  m1$output$algebras$top.a_std[1],
         #cross path
         "CrossPathA" = CrossPathA[i] <- m1$output$algebras$top.a_std[2,1],
         #specific path
         "SpecificA" = SpecificA[i] <- m1$output$algebras$top.a_std[2,2],
         #extract the coefficients
         "Path1C"=Path1C[i] <-  m1$output$algebras$top.c_std[1],
         "CrossPathC" = CrossPathC[i] <- m1$output$algebras$top.c_std[2,1],
         "SpecificC" = SpecificC[i] <- m1$output$algebras$top.c_std[2,2],
         "Path1E" = Path1E[i] <-  m1$output$algebras$top.e_std[1],
         "CrossPathE" = CrossPathE[i] <- m1$output$algebras$top.e_std[2,1],
         "SpecificE" = SpecificE[i] <- m1$output$algebras$top.e_std[2,2],
         "rP" = WiTwCrTrMz[i] <- cov2cor(attr(m1$submodels$MZ$fitfunction$result, "expCov"))[1,2],
         "CrTwCrTrMZ" = CrTwCrTrMZ[i] <- cov2cor(attr(m1$submodels$MZ$fitfunction$result, "expCov"))[1,4],
         "CrTwCrTrDZ" = CrTwCrTrDZ[i] <- cov2cor(attr(m1$submodels$DZ$fitfunction$result, "expCov"))[1,4],
         "Warn" = Warn[i] <- a$warnings,
         "PvalueA" = PValueA <- m3$p[2],
         "PvalueE" = PvalueE <- m4$p[2])
         
    }, error=function(e){cat("ERROR :",conditionMessage(e), "\n")})
  }
  Answers <- as.data.frame(Answers)
  #attach(Answers)
  Answers$CrossPathA <- as.numeric(Answers$CrossPathA)
  Answers$SpecificA <- as.numeric(Answers$SpecificA)
  Answers$Path1A <- as.numeric(Answers$Path1A)
  Answers$Path1C <- as.numeric(Answers$Path1C)
  Answers$CrossPathC <- as.numeric(Answers$CrossPathC)
  Answers$SpecificC <- as.numeric(Answers$SpecificC)
  Answers$Path1E <- as.numeric(Answers$Path1E)
  Answers$CrossPathE <- as.numeric(Answers$CrossPathE)
  Answers$SpecificE <- as.numeric(Answers$SpecificE) 
  Answers$rG <- TwoOfClubs(Answers$CrossPathA, Answers$SpecificA)
  Answers$Gr <- ThreeOfClubs(Answers$Path1A, Answers$CrossPathA)
  Answers$rC <- TwoOfClubs(Answers$CrossPathC, Answers$SpecificC)
  Answers$Cr <- ThreeOfClubs(Answers$Path1C, Answers$CrossPathC)
  Answers$rE <- TwoOfClubs(Answers$CrossPathE, Answers$SpecificE)
  Answers$Er <- ThreeOfClubs(Answers$Path1E, Answers$CrossPathE)
  Answers$PredictedR <- Answers$Gr+Answers$Cr+Answers$Er
  return(Answers)
}

#AceOfSpades.vertex is for running vertexwise data.  Because some data includes all zero's due to brain crushing,
#this function first checks to see if data is of high enough quality for a twin model before running the associatoin at each vertex. 
#With high quality data or lower resolution parcellations, all the vertices will pass this test. I recommend fsaverage5 space, as that
#one always recovers all vertices in my tests. 

#****Now! Let's actually run the map.  For the function below, the first argument is your twin file, second is the name of the behavior you are mapping sans the "1" or "2" subscript, third argument
#is the name of your zygosity variable, 4th is the MZ coding and 5th is DZ coding. I recommend 1 and 2 for that to ensure no errors occur. 
AnalysesOut <- AceOfSpades.vertex(Analysis, "Behavior", "Zyg", 1, 2)

#Cool, write it out, and I will cover converting it back into free surfer in the other tutorial scripts.
save(AnalysesOut , file="AnalysesOut.Rdata")




