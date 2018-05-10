setwd("~/Desktop/Wine-Project/Dataset and Script")
# Example for Jags-Ymet-Xnom2fac-MnormalHom.R 
#------------------------------------------------------------------------------- 
# Optional generic preliminaries:
graphics.off() # This closes all of R's graphics windows.
#------------------------------------------------------------------------------- 
#Load The data file 

fileNameRoot = "wine-" 
graphFileType = "eps" 
myDataFrame = winetruc

# Specify the column names in the data file relevant to the analysis:
yName="points" 
# x1 should be factor with fewer levels, to plot in single pane:
x1Name="category" 
x2Name="countrycat" 
# Specify desired contrasts.
# Each main-effect contrast is a list of 2 vectors of level names, 
# a comparison value (typically 0.0), and a ROPE (which could be NULL):
x1contrasts = list( 
  list( c("red") , c("white") , compVal=0.0 , ROPE=c(-1,1) ) 
)
x2contrasts = list( 
  list( c("eu") , c("non-eu") , compVal=0.0 , ROPE=c(-1,1) )
)
# Each interaction contrast is a list of 2 lists of 2 vectors of level names, 
# a comparison value (typically 0.0), and a ROPE (which could be NULL)::
x1x2contrasts = list( 
  list( list( c("red") , c("white") ) ,
        list( c("eu") , c("non-eu") ) ,
        compVal=0.0 , ROPE=c(-1,1) )
) 

#------------------------------------------------------------------------------- 
# Load the relevant model into R's working memory:
source("Jags-Ymet-Xnom2fac-MnormalHom.R")
#------------------------------------------------------------------------------- 
# Generate the MCMC chain:
mcmcCoda = genMCMC( datFrm=myDataFrame , 
                    yName=yName , x1Name=x1Name , x2Name=x2Name ,
                    numSavedSteps=15000 , thinSteps=5 , 
                    saveName=fileNameRoot )
#------------------------------------------------------------------------------- 
# Display diagnostics of chain, for specified parameters:
parameterNames = varnames(mcmcCoda) 
show( parameterNames ) # show all parameter names, for reference
for ( parName in c("b0","b1[1]","b2[1]","b1b2[1,1]","ySigma") ) {
  diagMCMC( codaObject=mcmcCoda , parName=parName , 
            saveName=fileNameRoot , saveType=graphFileType )
}
#------------------------------------------------------------------------------- 
# Get summary statistics of chain:
summaryInfo = smryMCMC( mcmcCoda , 
                        datFrm=myDataFrame , x1Name=x1Name , x2Name=x2Name ,
                        x1contrasts=x1contrasts , 
                        x2contrasts=x2contrasts , 
                        x1x2contrasts=x1x2contrasts ,
                        saveName=fileNameRoot )
show(summaryInfo)
# Display posterior information:
plotMCMC( mcmcCoda , 
          datFrm=myDataFrame , yName=yName , x1Name=x1Name , x2Name=x2Name ,
          x1contrasts=x1contrasts , 
          x2contrasts=x2contrasts , 
          x1x2contrasts=x1x2contrasts ,
          saveName=fileNameRoot , saveType=graphFileType )



