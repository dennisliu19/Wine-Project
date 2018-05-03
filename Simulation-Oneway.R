setwd("~/Desktop/Wine-Project")
# Example for Jags-Ymet-Xnom2fac-MnormalHom.R 
#------------------------------------------------------------------------------- 
# Optional generic preliminaries:
graphics.off() # This closes all of R's graphics windows.
#------------------------------------------------------------------------------- 
#Load The data file 

fileNameRoot = "wine-oneway-country-" 
graphFileType = "eps" 
myDataFrame = winetruc
# Specify the column names in the data file relevant to the analysis:
yName="points" 
xName="country" 
# Specify desired contrasts.
# Each main-effect contrast is a list of 2 vectors of level names, 
# a comparison value (typically 0.0), and a ROPE (which could be NULL):
contrasts = list( 
  list( c("US") , c("Italy","France","Australia","Chile","Argentina","Spain","Portugal") , compVal=0.0 , ROPE=c(-1,1) ),
  list( c("Italy") , c("US","France","Australia","Chile","Argentina","Spain","Portugal") , compVal=0.0 , ROPE=c(-1,1) ),
  list( c("France") , c("US","Italy","Australia","Chile","Argentina","Spain","Portugal") , compVal=0.0 , ROPE=c(-1,1) ),
  list( c("Australia") , c("US","Italy","France","Chile","Argentina","Spain","Portugal") , compVal=0.0 , ROPE=c(-1,1) ),
  list( c("Chile") , c("US","Italy","France","Australia","Argentina","Spain","Portugal") , compVal=0.0 , ROPE=c(-1,1) ),
  list( c("Argentina") , c("US","Italy","France","Australia","Chile","Spain","Portugal") , compVal=0.0 , ROPE=c(-1,1) ),
  list( c("Spain") , c("US","Italy","France","Australia","Chile","Argentina","Portugal") , compVal=0.0 , ROPE=c(-1,1) ),
  list( c("Portugal") , c("US","Italy","France","Australia","Chile","Argentina","Spain") , compVal=0.0 , ROPE=c(-1,1) )
)

#------------------------------------------------------------------------------- 
# Load the relevant model into R's working memory:
source("Jags-Ymet-Xnom1fac-MnormalHom.R")
#------------------------------------------------------------------------------- 
# Generate the MCMC chain:
mcmcCoda = genMCMC( datFrm=myDataFrame , yName=yName , xName=xName ,
                    numSavedSteps=15000 , thinSteps=10 , saveName=fileNameRoot )
#------------------------------------------------------------------------------- 
# Display diagnostics of chain, for specified parameters:
parameterNames = varnames(mcmcCoda) 
show( parameterNames ) # show all parameter names, for reference
for ( parName in c("ySigma","b0","b[1]","aSigma") ) {
  diagMCMC( codaObject=mcmcCoda , parName=parName , 
            saveName=fileNameRoot , saveType=graphFileType )
}
#------------------------------------------------------------------------------- 
# Get summary statistics of chain:
summaryInfo = smryMCMC( mcmcCoda , 
                        datFrm=myDataFrame , xName=xName ,
                        contrasts=contrasts , 
                        saveName=fileNameRoot )
# Display posterior information:
plotMCMC( mcmcCoda , 
          datFrm=myDataFrame , yName=yName , xName=xName ,
          contrasts=contrasts , 
          saveName=fileNameRoot , saveType=graphFileType )
#------------------------------------------------------------------------------- 
