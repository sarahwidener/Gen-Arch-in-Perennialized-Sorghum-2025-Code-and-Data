multi.BLUP.kfoldfoldCV <- function(Y = NULL, Geno = NULL, traitname = "Name_of_Trait", path.for.results = path.for.results, 
                                   number.of.folds = 10, seed.number = 999, row.number.of.SNPs.in.separate.kernel = NULL,
                                   quality.control.check = FALSE){
  #######################################################################################
  #Uses the GAPIT, sommer, and rrBLUP R packages
  #Written by Alex Lipka originally on February 7, 2012. Updated on August 1-2, 202to 
  # accomodate a multi-kernel model, where the genotype matrix is partition into two protions
  #Read in a vector of phenotypes, and genotypic data in HapMap format (note that "head = FALSE" for reading in these data)
  #Process the data
  
  #Get the names of SNPs that we want in G1
  names.of.SNPs.in.G1 <- Geno[row.number.of.SNPs.in.separate.kernel,1]
  
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
  
  
  #Get a list of SNPs that are remaining after filtering out these SNPs
  hm.GI.without.snps.below.0.05.maf <- hm$GI[-snps.below.0.05.maf,]
  indices.of.G1.SNPs.after.maf.filtering <- which(hm.GI.without.snps.below.0.05.maf$SNP  %in% names.of.SNPs.in.G1)
  
  #Get a list of indices of SNPs that have the same names as those in the 
  # list of names.of.SNPs.in.G1
  
  
  ###############################
  
  GK <- cbind(hm$GT, hm.GD.without.snps.below.0.05.maf)
  
  qc=GAPIT.QC(Y = Y, GT = hm$GT, CV = CV, GK = GK)
  
  y <- as.matrix(qc$Y[-1])
  
  G <- as.numeric(qc$GK[,-1])
  
  G <- matrix(G, nrow(y), ncol(qc$GK[,-1]))
  
  G <- G - 1
  
  cv <- (as.matrix(qc$CV[,-1]))
  
  taxa.names <- qc$CV[,1]
  
 
  #The indices indicated in row.number.of.SNPs.in.separate.kernel
  # are off by 1 because the first row of the input file is the headers. 
  # Therefore, we need the following line of code to subtract all of the indices by 1
  
  
  #Partition G into two groups, depending on whether or not they are in the pathway of interest
  pathway.G <- G[,indices.of.G1.SNPs.after.maf.filtering]
  not.pathway.G <- G[,-indices.of.G1.SNPs.after.maf.filtering]
  
  #Calculate the partitioned kinship matrices (i.e., kernels)
  A1.pathway <- A.mat(pathway.G)
  colnames(A1.pathway) <- rownames(A1.pathway) <- c(1:nrow(y))
  
  A1.not.pathway <- A.mat(not.pathway.G)
  colnames(A1.not.pathway) <- rownames(A1.not.pathway) <- c(1:nrow(y))  
  
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
    
    #####data1 is for the single-kernel model
    data1 <- data.frame(y=yNA,gid=1:length(y), cv = cv)
    the.cv.names <- NULL
    for(j in 1:ncol(cv)) the.cv.names <- c(the.cv.names, paste("CV_",j,sep = ""))
    
    colnames(data1) <- c("y","gid", the.cv.names)
    data1$gid <- as.character(data1$gid)
    
    #####data2 is for the double-kernel model. The additional columne, gid2 is needed
    #########so that we can distinguish between the random effects corresponding to 
    ########### each fo the two kernels
    data2 <- data.frame(y=yNA,gid=1:length(y),gid2=1:length(y), cv = cv)
    the.cv.names <- NULL
    for(j in 1:ncol(cv)) the.cv.names <- c(the.cv.names, paste("CV_",j,sep = ""))
    
    colnames(data2) <- c("y","gid", "gid2", the.cv.names)
    data2$gid <- as.character(data2$gid)
    data2$gid2 <- as.character(data2$gid2)
    
    rownames(A1.pathway) <- 1:nrow(A1.pathway)
    rownames(A1.not.pathway) <- 1:nrow(A1.not.pathway)
   
    #Here is where the magic happens - this is where the two-kernel GS model is fitted
    ans.multiple.kernel <- mmer(y~1, random = ~vsr(gid, Gu =A1.pathway)+vsr(gid2, Gu = A1.not.pathway),
                                data = data2, verbose = FALSE)
    GEBVs <- as.data.frame(ans.multiple.kernel$U$`u:gid`$y+
                             ans.multiple.kernel$U$`u:gid2`$y)
    GEBVs  <- data.frame(as.numeric(rownames(GEBVs)), GEBVs )
    GEBVs <- GEBVs[order(GEBVs[,1]),]  
    
    #######Begin temporary code
    if(quality.control.check){
      ans.single.kernel <- mmer(y~1, random = ~vsr(gid,Gu=A1.pathway),
                                                           rcov = ~units,
                                data = data1, verbose = FALSE)
      ans.1.sommer <- data.frame(ans.single.kernel$U$`u:gid`$y)
      ans.1.sommer <- data.frame(as.numeric(rownames(ans.1.sommer)), ans.1.sommer)
      ans.1.sommer <- ans.1.sommer[order(ans.1.sommer[,1]),]
      
      
      
      ######
      ans1 <- kin.blup(data1,K=A1.pathway,geno="gid",pheno="y", covariate = the.cv.names)
      
      #Let's double check that rrBLUP and sommer are giving the same answers
      rrBLUP.and.sommer <- data.frame(ans.1.sommer[,2], ans1$g)
      colnames(rrBLUP.and.sommer) <- c("sommer", "RRBLUP")
      print("here is the correlation between rrBLUP and sommer on the same single-kernel model")
      print(cor(rrBLUP.and.sommer$RRBLUP, rrBLUP.and.sommer$sommer))
    } # end if(quality.control.check)
      #ans <- kinship.BLUP(y=y[train],G.train=G[train,],G.pred=G[pred,],K.method="RR")
    
    #r.gy <- c(r.gy, cor(ans$g.pred,y[pred]))
    r.gy <- c(r.gy, cor(GEBVs[pred,2], y[pred]) ) 
    vector.of.observed.values <- c(vector.of.observed.values, y[pred])
    vector.of.predicted.values <- c(vector.of.predicted.values, GEBVs[pred,2])
    vector.of.taxa.names <- c(vector.of.taxa.names, as.character(taxa.names[pred]))
  }
  
  
  #Fit a regression model, where:
  # Observed.Phenotype_i = beta_0 + beta_1*Predicrted.Phenotype_i + epsilon_i
  SLR.model <- lm(vector.of.observed.values ~ vector.of.predicted.values)
  
  pdf(paste(path.for.results,number.of.folds,"-fold_CV_Results_",traitname,"Obs.vs.Pred.pdf", sep = ""))
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
  
  write.table(r.gy.output, paste(path.for.results,number.of.folds,"-fold_CV_Results_",traitname,".txt", sep = ""), quote = FALSE, sep = "\t", row.names = FALSE,col.names = TRUE)
  
  #Print out the observed and predicted values
  the.observed.predicted.and.taxa.names <- cbind(as.character(vector.of.taxa.names), vector.of.observed.values, vector.of.predicted.values)
  
  colnames(the.observed.predicted.and.taxa.names) <- c("SampleID", paste("Observed_", traitname, sep = ""), paste("Predicted_", traitname, sep = ""))
  
  write.table(the.observed.predicted.and.taxa.names, 
              paste(path.for.results,"Obs.and.Predicted.Trait.values",traitname,".txt", sep = ""), quote = FALSE, sep = "\t", row.names = FALSE,col.names = TRUE)
} #End rrblup.tenfoldCV