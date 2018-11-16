#After running the map, you may have your own pipeline for munging the vertexwise results into something that can be plotted.  If so, you can skip the 
#the rest of the tutorials and move to that.  

#For this script: When the brain is crushed in preprocessing, it can produce estimates that are not fit for the structural modeling 
#procedure.  This script will enter those vertices as missing.

#Run this code to get the function in your environment
VertexNames.Spades <- function(D, V){
  #length(unique(twi2$family))
  column_names <- colnames(D)
  Names1 <- column_names[grepl("1$", column_names)] #make 
  Names2 <- column_names[grepl("2$", column_names)]
  selDVs <- c(Names1, Names2)
  Names <- substr(Names1, 1, nchar(Names1)-1) 
  Names3 <- Names[!Names %in% V]
  DataF <- matrix(1:length(Names3))
  DataF[,1] <- Names3
  DataF <- as.data.frame(DataF)
  names(DataF)[names(DataF) == "V1"] <- 'Var1'
  return(DataF)
}


#The first argument is the Twinfile you ran in Genetic_Brain_Map_PartA (the previous script) and the second is the name of the variable
#you mapped (the exact name of the column, these are the same arguments you used in the first arguments of the "AceOfSpades.vertex()" function

FullNames <- VertexNames.Spades(Analysis, "Behavior")

#Cool, now merge this column with the full file.  If you named all your objects with the same names I have been using, you won't have
#to change any of this code.
#won't have to edit this code.  Both the Object created by "VertexNames.Spades()" and "AceOfSpades.vertex()" have a Var1 column. 
AnalysesFull  <- merge(FullNames, AnalysesOut, by = "Var1", all.x=TRUE)

#Awesome! Write it out and go to the python script for part C
write.csv(AnalysesFull, "LeftHemisphereBehavior.csv")


#Finally, if you want to transform the p-values (log transfrom for plotting for example or add FDR correction for example) it is good to do that before 
#running VertexNames.Spades and merging.  For example, the code below will use Random Field theory correction for a set smoothing kernel 

# first argument is the column of p-values from Tutioral_PartA, second is the total mm of your brain template.  The third is the 
#Smoothness of your data in mm (Freesurfer gives you this if you run a phenotypic analysis with Qdec). and the the last argument is the
#dimensions that you are looking at, i.e. 2D, 3D, or 4D estimates)
RFTCorrectionC <- function(p, tmm, smm, d) {
  resel_count <- tmm/(smm^d) 
  z <- as.array(p)
  z <- abs(qnorm(z))
  Answer <- (resel_count * (4 * log(2)) * ((2*pi)**(-3./2)) * z) * exp((z ** 2)*(-0.5))
  Truth <- ifelse(Answer >= .05, 0, 1)
  knowledge <- c(Answer, Truth)
  return(knowledge)}

#For example the code below will add a p-value corrected colum.  The brain template is 2000 mm in size, average smoothness of the brain is
#14.33 and smoothing was done over 2 dimensions (often what is done in surface-based images). 
Analysis$RFTcorrected <- RFTCorrectioinC(Analysis$P-value, 20000, 14.33, 2) 
