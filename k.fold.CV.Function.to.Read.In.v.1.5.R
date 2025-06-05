rrblup.kfoldfoldCV <- function(Y = NULL, Geno = NULL, traitname = "Name_of_Trait", path.for.results = path.for.results, number.of.folds = 10, seed.number = 999){
  #######################################################################################
  #Uses the GAPIT and rrBLUP R packages
  #Written by Alex Lipka on February 7, 2012
  #Read in a vector of phenotypes, and genotypic data in HapMap format (note that "head = FALSE" for reading in these data)
  #Process the data
  
  CV=Y[,1:2]
  CV[,2]=1
  colnames(CV)=c("taxa","overall")
  
  hm=GAPIT.HapMap(G = Geno,SNP.effect="Add",SNP.impute="Major")
  

  #####################################
  #Obtain the mafs of all SNPs
  
  #Total number of lines
  ns <- nrow(hm$GD)
  
  #Sum of the allele scores for each SNP
  ss <- apply(hm$GD, 2, sum)
  
  #Combine two situations: one where the allele coded as "2" is major; one where "0" is coded as major.
  maf.matrix <- rbind((.5*ss/ns), (1-(0.5*ss/ns)))
  
  #Copy the minor allele frequencies for all SNPs
  maf <- apply(maf.matrix, 2, min)
  
  #Find out which SNPs have MAF < 0.05
  snps.below.0.05.maf <- which(maf < 0.05)
  
  # Remove these SNPs from hm$GD
  
  hm.GD.without.snps.below.0.05.maf <- hm$GD[,-snps.below.0.05.maf]
  
  ###############################
  
  GK <- cbind(hm$GT, hm.GD.without.snps.below.0.05.maf)
  
  qc=GAPIT.QC(Y = Y, GT = hm$GT, CV = CV, GK = GK)
  
  y <- as.matrix(qc$Y[-1])
  
  G <- as.numeric(qc$GK[,-1])
  
  G <- matrix(G, nrow(y), ncol(qc$GK[,-1]))
  
  G <- G - 1
  
  cv <- (as.matrix(qc$CV[,-1]))
  
  taxa.names <- qc$CV[,1]
  
  #Calculate the kinship matrix in rrBLUP
  A1 <- A.mat(G,shrink=TRUE)
  
  
  ############################################################################################
  #Run k-fold cross validation
  
  sample.size <- nrow(y)
  
  #Randomly sort the number of lines, and subdivide them into ten subgroups
  set.seed(seed.number)
  sequence.sample <- rep(1:sample.size)
  random.sample <- sample(1:sample.size, replace = FALSE)
  increment <- ceiling(length(random.sample)/number.of.folds) 
  r.gy <- NULL 
  
  #have a "for" loop, start it at 0, and end it at 9
  #I am setting up "k" to denote the nubmer of folds - 1. This is done
  # so that the for loop will work correctly.
  k <- number.of.folds - 1
  
  vector.of.observed.values <- NULL
  vector.of.predicted.values <- NULL
  vector.of.taxa.names <- NULL
  for(i in 0:k){
    pred <- random.sample[((increment*i)+1):min(((increment*i)+increment) , sample.size)]
    train <- random.sample[-(((increment*i)+1):min(((increment*i)+increment) , sample.size))] 
    
    yNA <- y
    yNA[pred] <- NA
    
    data1 <- data.frame(y=yNA,gid=1:length(y), cv = cv)
    the.cv.names <- NULL
    for(j in 1:ncol(cv)) the.cv.names <- c(the.cv.names, paste("CV_",j,sep = ""))
    
    colnames(data1) <- c("y","gid", the.cv.names)
    
    rownames(A1) <- 1:nrow(A1)
    ans1 <- kin.blup(data1,K=A1,geno="gid",pheno="y", covariate = the.cv.names)
    r.gy <- c(r.gy, cor(ans1$g[pred], y[pred]) )
    
    
    #ans <- kinship.BLUP(y=y[train],G.train=G[train,],G.pred=G[pred,],K.method="RR")
    
    #r.gy <- c(r.gy, cor(ans$g.pred,y[pred]))
    
    vector.of.observed.values <- c(vector.of.observed.values, y[pred])
    vector.of.predicted.values <- c(vector.of.predicted.values, ans1$g[pred])
    vector.of.taxa.names <- c(vector.of.taxa.names, as.character(taxa.names[pred]))
  }
  
  
  #Fit a regression model, where:
  # Observed.Phenotype_i = beta_0 + beta_1*Predicrted.Phenotype_i + epsilon_i
  SLR.model <- lm(vector.of.observed.values ~ vector.of.predicted.values)
  
  pdf(paste(path.for.results,number.of.folds,"-fold_CV_Results_",traitname,"Obs.vs.Pred.pdf"))
    plot(vector.of.observed.values ~ vector.of.predicted.values, col = "blue", xlab = "Predicted values", ylab = "Observed Values")
    abline(SLR.model)
    legend("topleft", paste("Intercept = ", round(coef(SLR.model)["(Intercept)"],2), ", Slope = ", round(coef(SLR.model)["vector.of.predicted.values"],2), sep = ""))
  dev.off()
  # Once the loop is over, output the values of the correlation coefficients, as well as their means and standard deviations  
  
  #Create a vector of column names for the k-fold cross validation output
  colname.r.gy <- NULL
  for(i in 1:number.of.folds) colname.r.gy <- c(colname.r.gy, paste("r_CV",i,sep = ""))
  
  r.gy <- c(r.gy, mean(r.gy), sd(r.gy))
  
  r.gy.output <- t(as.matrix(r.gy))
  
  
  colnames(r.gy.output) <- c(colname.r.gy, "r_avg", "r_std")
  
  #
  
  write.table(r.gy.output, paste(path.for.results,number.of.folds,"-fold_CV_Results_",traitname,".txt"), quote = FALSE, sep = "\t", row.names = FALSE,col.names = TRUE)
  
  #Print out the observed and predicted values
  the.observed.predicted.and.taxa.names <- cbind(as.character(vector.of.taxa.names), vector.of.observed.values, vector.of.predicted.values)
  
  colnames(the.observed.predicted.and.taxa.names) <- c("SampleID", paste("Observed_", traitname, sep = ""), paste("Predicted_", traitname, sep = ""))
  
  write.table(the.observed.predicted.and.taxa.names, 
              paste(path.for.results,"Obs.and.Predicted.Trait.values",traitname,".txt"), quote = FALSE, sep = "\t", row.names = FALSE,col.names = TRUE)
} #End rrblup.tenfoldCV