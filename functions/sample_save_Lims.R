# Load necessary library for timing
library(tictoc)

# Define the function
calculate_and_save_batches <- function(LIMs, output_directory, nsamp_total = 1000, batch_size = 50) {
  
  # Calculate how many full batches can be run
  num_batches <- ceiling(nsamp_total / batch_size)
  
  # Loop through each batch first
  for (batch in 1:num_batches) {
    
    # Loop through each LIM
    for (LIM_name in names(LIMs)) {
      
      # Start timing
      tic(paste("Batch", batch, "for LIM:", LIM_name))
      
      # Perform the calculation for this batch
      batch_samples <- samplelim::rlim(LIMs[[LIM_name]], nsamp = batch_size)
      
      # Create a filename for the Rdata file for this batch
      output_file <- file.path(output_directory, paste0("sample3_", LIM_name, "_batch_", batch, ".Rdata"))
      
      # Save the batch sample data to an Rdata file
      save(batch_samples, file = output_file)
      
      # Stop timing and capture the time taken
      time_taken <- toc()
    }
  }
  
  # Close the log file connection
  close(log_connection)
}

# Example usage:
# calculate_and_save_batches(LIMs, "output_directory", nsamp_total = 1000, batch_size = 50)

# Load necessary library for timing
library(tictoc)

# Define the function
calculate_and_save_batches_starting_point <- function(LIMs, output_directory, nsamp_total = 1000, batch_size = 50) {
  # Ensure the output directory exists
  if (!dir.exists(output_directory)) {
    dir.create(output_directory, recursive = TRUE)
  }
  
  # Calculate how many full batches can be run
  num_batches <- ceiling(nsamp_total / batch_size)
  
  # Initialize a list to store previous results
  all_samples <- list()
  
  # Loop through each batch
  for (batch in 1:num_batches) {
    
    # Loop through each LIM
    for (LIM_name in names(LIMs)) {
      
      # Start timing
      tic(paste("Batch", batch, "for LIM:", LIM_name))
      
      # Determine starting point
      if (batch == 1) {
        # If first batch, no previous samples; starting_point is NULL
        starting_point <- NULL
      } else {
        # Randomly select a row from previous samples for this LIM
        previous_samples <- do.call(rbind, all_samples[[LIM_name]])
        starting_point <- as.numeric(previous_samples[sample(nrow(previous_samples), 1), ])
      }
      
      # Perform the calculation for this batch
      batch_samples <- rlim(LIMs[[LIM_name]], nsamp = batch_size, starting_point = starting_point)
      
      # Append batch_samples to the list for this LIM
      if (!is.list(all_samples[[LIM_name]])) {
        all_samples[[LIM_name]] <- list()
      }
      all_samples[[LIM_name]][[batch]] <- batch_samples
      
      # Create a filename for the Rdata file for this batch
      output_file <- file.path(output_directory, paste0("sample_", LIM_name, "_batch_", batch, ".Rdata"))
      
      # Save the batch sample data to an Rdata file
      save(batch_samples, file = output_file)
      
      # Stop timing and capture the time taken
      time_taken <- toc()
      
      # Log the time taken to the console
      message(paste("Time taken for", LIM_name, "Batch", batch, ":", time_taken$toc - time_taken$tic, "seconds"))
    }
  }
}

