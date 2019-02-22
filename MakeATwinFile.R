#The script below will take a phenotypic file and convert it to a twin file for analysis.  To do this, the file must (1)be in long format
#(where each individual is a row), each individual must be have a twin number (either 1 or 2, any other numbers will be ignored),
#and twin pairs must share the same family ID.  These tend to be standard columns in twin study files and I know are all part of the
#Colorado Longitudinal Study demographic information. 

Full <- YourFileHere
#Change the name of the Twin Number, TrandFull is the name of mine. 
Twin <- split(Full, Full$TrandFull) #Input the name of your file and the twinnumber

#create dataframe for Twin1 and Twin2
Twin1 <- Twin$'1'
Twin2 <- Twin$'2'

#Add 1 to twin1 dataframe column names and add 2 to twin2 dataframe names
colnames(Twin1) <- paste(colnames(Twin1), '1', sep="")
colnames(Twin2) <- paste(colnames(Twin2), '2', sep="")

#Change the names of the Twin1 file demographs so they don't end with '1'.  
#You will need to replace what's in the quotations with your own column names.

names(Twin1)[names(Twin1) == "bestbetFull1"] <- 'Zyg'
names(Twin1)[names(Twin1) == "Sex1"] <- 'sex'
names(Twin1)[names(Twin1) == "id1"] <- 'subject'
names(Twin1)[names(Twin1) == "age1"] <- 'disage'
names(Twin1)[names(Twin1) == "familyFull1"] <- 'family'
names(Twin2)[names(Twin2) == "familyFull2"] <- 'family'

#Remove demographics from twin 2, you only really need family for twin 2
Twin2$Zyg2 <- NULL
Twin2$Sex2 <- NULL
Twin2$id2 <- NULL
Twin1$Trand1 <- NULL
Twin2$Trand2 <- NULL

#Merge Twin1 and Twin2 by family
TwinFileFull<- merge(Twin1, Twin2, by="family", all.x=TRUE, all.y=TRUE) 
 
#If your zygosity variable is lableled "MZ" and "DZ", this will change it to 1= MZ and 2 = DZ
TwinFileFull$Zyg <- gsub("MZ", 1, TwinFileFull$Zyg)
TwinFileFull$Zyg <- gsub("DZ", 2, TwinFileFull$Zyg)
TwinFileFull$Zyg <- gsub(" ",'', TwinFileFull$Zyg)
