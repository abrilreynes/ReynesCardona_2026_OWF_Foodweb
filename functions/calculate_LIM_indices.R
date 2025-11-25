
# Unified function to calculate indices
calculate_indices <- function(LIM, results, year_label, index_type) {
  n_iterations <- nrow(results)
  
  # Initialize data frame to store results
  indices_list <- list()
  
  # Loop over each iteration
  for (j in 1:n_iterations) {
    # Calculate the flow matrix for the current iteration
    fm <- Flowmatrix(LIM, results[j,])
    
    # Remove rows/cols that sum to zero and remove Inputs from columns and Outputs from rows
    Import <- c("PHY", "DIC")
    Export <- c("EXP", "BUR")
    
    # Redefine in/outputs in case some were set to zero and eliminated
    Import_filtered <- Import[Import %in% rownames(fm)]
    Export_filtered <- Export[Export %in% colnames(fm)]
    
    # Calculate indices for the current iteration based on type
    if (index_type == "path") {
      indices <- PathInd(Flow = fm,
                         Import = Import_filtered, 
                         Export = Export_filtered)
    } else if (index_type == "gen") {
      indices <- GenInd(Flow = fm,
                        Import = Import_filtered, 
                        Export = Export_filtered,
                        tol = 0)
    }
    
    # Append results to list
    indices_list[[j]] <- indices
  }
  
  # Convert list of results to data frame
  indices_df <- do.call(rbind, indices_list) %>% data.frame()
  indices_df$Iteration <- 1:n_iterations
  indices_df$Network <- year_label
  
  return(indices_df)
}


# Define function to calculate link weight distribution statistics for a given year

calculate_link_weights_distribution_simple <- function(results, year_label) {
  n_iterations <- nrow(results)
  
  # Initialize vectors for mean and variance of each iteration
  mean_list <- numeric(n_iterations)
  variance_list <- numeric(n_iterations)
  
  # Loop through each iteration
  for (i in 1:n_iterations) {
    flows <- results[i, ]
    flows <- flows[flows > 0]  # Remove zeros
    
    mean_list[i] <- mean(flows)
    variance_list[i] <- var(flows)
  }
  
  # Create data frame for iteration-level stats
  iteration_stats <- data.frame(
    Iteration = 1:n_iterations,
    Mean_Link_Weight = mean_list,
    Variance_Link_Weight = variance_list,
    Network = year_label
  )
}

calculate_Asc_indices <- function(LIM, results, year_label) {
  n_iterations <- nrow(results)
  
  # Initialize data frame to store results
  indices_list <- list()
  
  # Loop over each iteration
  for (j in 1:n_iterations) {
    # Calculate the flow matrix for the current iteration
    fm <- Flowmatrix(LIM, results[j,])
    
    # Remove rows/cols that sum to zero and remove Inputs from columns and Outputs from rows
    Import <- c("PHY", "DIC")
    Export <- c("EXP", "BUR")
    #Dissipation <- c("DIC")
    
    # Redefine in/outputs in case some were set to zero and eliminated
    Import_filtered <- Import[Import %in% rownames(fm)]
    Export_filtered <- Export[Export %in% colnames(fm)]
    
    # Calculate indices for the current iteration
    indices <- AscInd(Flow = fm,
                      Import = Import_filtered, Export = Export_filtered, Dissipation = NULL)
    
    # Append results to list
    indices_list[[j]] <- indices
  }
  
  # Convert list of results to data frame
  indices_df <- do.call(rbind, indices_list) %>% data.frame()
  indices_df$Iteration <- 1:n_iterations
  indices_df$Network <- year_label
  
  return(indices_df)
}

