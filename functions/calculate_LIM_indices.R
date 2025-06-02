
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
calculate_link_weights_distribution <- function(base_matrix, results, year_label) {
  n_iterations <- nrow(results)
  
  # Initialize lists to store results for mean, variance, and standard deviation of link weights
  mean_list <- numeric(n_iterations)
  variance_list <- numeric(n_iterations)
  sd_list <- numeric(n_iterations)
  
  # Loop over each iteration
  for (j in 1:n_iterations) {
    # Clone the base matrix and populate it with current iteration's flow values
    fm <- base_matrix
    fm[] <- results[j, ]  # Assuming 'results[j, ]' has the right dimensions to fill 'fm'
    
    # Flatten the matrix to get all link weights and remove zeros
    link_weights <- as.vector(fm)
    link_weights <- link_weights[link_weights > 0]
    
    # Calculate statistics for the link weights
    mean_list[j] <- mean(link_weights)
    variance_list[j] <- var(link_weights)
    sd_list[j] <- sd(link_weights)
  }
  
  # Create data frame with the calculated statistics for each iteration
  stats_df <- data.frame(
    Iteration = 1:n_iterations,
    Mean_Link_Weight = mean_list,
    Variance_Link_Weight = variance_list,
    SD_Link_Weight = sd_list,
    Network = year_label
  )
  
  return(stats_df)
}

calculate_link_weights_distribution2 <- function(base_matrix, results, year_label) {
  n_iterations <- nrow(results)
  
  # Listas para almacenar varianza y media de cada repeticion
  variance_list <- numeric(n_iterations)
  mean_list <- numeric(n_iterations)
  
  # Loop por cada repeticion del modelo
  for (j in 1:n_iterations) {
    # Crear matriz de flujo para esta iteracion
    fm <- base_matrix
    fm[] <- results[j, ]
    
    # Aplanar y eliminar ceros
    link_weights <- as.vector(fm)
    link_weights <- link_weights[link_weights > 0]
    
    # Calcular varianza y media de esta iteracion
    variance_list[j] <- var(link_weights)
    mean_list[j] <- mean(link_weights)
  }
  
  # Crear data frame con varianza y media de cada iteracion
  stats_df <- data.frame(
    Iteration = 1:n_iterations,
    Variance_Link_Weight = variance_list,
    Mean_Link_Weight = mean_list,
    Network = year_label
  )
  
  return(stats_df)
}
