#After running the map, you may have your own pipeline for munging it into something that can be plotted.  If so, you can skip the 
#the rest of the tutorials and move to that.  

#For this script: When the brain is crushed in preprocessing, it can produce estimates that are not fit for the structural modeling 
#Procedure.  This script will enter those vertices as missing.

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


#The first argument is the Twinfile you ran in Genetic_Brain_Map_PartA (the previous Script) and the second is the name of the variable
#you mapped (the exact name of the column, these are the same arguments you used in the first arguments of the "AceOfSpades.vertex()" function

FullNames <- VertexNames.Spades(Analysis, "Behavior")

#Cool, now merge this column with the full file.  If you called all your objects the same as this and the previous script, you won't 
#won't have to edit this code.  Both the Object created by "VertexNames.Spades()" and "AceOfSpades.vertex()" have a Var1 column. 
AnalysesFull  <- merge(FullNames, AnalysesOut, by = "Var1", all.x=TRUE)

#Awesome! Write it out and got to the python script for part three
write.csv(AnalysesFull, "LeftHemisphereBehavior.csv")
