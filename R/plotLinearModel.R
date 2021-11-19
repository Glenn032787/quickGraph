#' Fit and visualize simple linear model on graph
#'
#' Plot quantitative data from column x and y in data in a scatter plot along with
#' the line from the fitted simple linear model. The simple linear function is
#' the graph title and the subtitle is correlation statistics
#' (r-squared and F-statistic)
#'
#' @param data Data set in form of tibble that is being plotted (Must have at least three valid row)
#' @param x Column in data that is the x axis of plot (Name of column X should be character (in quotes) and data in column x should be numeric)
#' @param y Column in data that is the y axis of plot (Name of column y should be character (in quotes) and data in column y should be numeric)
#'
#'
#' @return ggplot2 scatter plot with linear model and data points (from column x and y )
#' with simple linear function as the title and adjusted r-squared and F-statistic as subtitle
#'
#' @examples
#' test_tibble <- tibble::tribble(
#' ~x, ~y, ~z,
#' #--|--|----
#' 1, 2, 3,
#' 2, 3, 4,
#' 3, 5, 2,
#' 4, 3, 2
#' )
#' plotLinearModel(test_tibble, 'x', 'y')
#'
#' @examples
#' large_data <- tibble::tibble(
#' x1 = 1:1000,
#' y1 = x1 ** 2
#' )
#' plotLinearModel(large_data, 'x1', 'y1')
#'
#' @example
#' mtcars.tb <- tibble::as_tibble(mtcars)
#' plotLinearModel(mt_car.tb, "mpg", "disp")
#'
#' @export
plotLinearModel <- function(data, x, y) {
  # Check if data is a tibble
  if (!tibble::is_tibble(data)) {
    stop("Data must be a tibble, it is data type ", class(data))
  }
  data <- tidyr::drop_na(data, x, y) # Drop rows with NA in column x or y

  # Check if column x is numeric data type
  if (!sapply(data[,x], class) %in% c('double', 'integer', 'numeric')) {
    stop(x,' column must be data type numeric, it is data type ', sapply(data[,x], class))
  }
  # Check if column y is numeric data type
  if (!sapply(data[,y], class) %in% c('double', 'integer', 'numeric')) {
    stop(y,' column must be data type numeric, it is data type ', sapply(data[,y], class))
  }

  # Check if data has at least three numeric rows (not including rows with NA)
  if (nrow(data) < 3) {
    stop("Data set must have at least three valid entries")
  }

  data <- as.data.frame(data) # Make data into class data frame
  data.lm <- stats::lm(data[, y] ~ data[, x]) # Create linear model based on column x and y in data
  slope <- as.numeric(data.lm$coef[2]) # Obtain slope from linear model
  yint <- as.numeric(data.lm$coef[1])  # Obtain y intercept from linear model
  adj_Rsquare <- summary(data.lm)$adj.r.squared # Obtain adjusted r-square from linear model
  fstat <- as.numeric(summary(data.lm)$fstatistic[1]) # Obtain f-statistic from linear model

  title <- paste("y = ", slope, 'x + ', yint) # Create string of linear function for title
  subtitle <- paste('Adjusted R-squared: ', adj_Rsquare, '\nF-statistic: ', fstat)  # Create string of r-squred and f-statistic for subtitle

  ggplot2::ggplot(data, ggplot2::aes_string(x, y)) + # Create ggplot with x and y as x axis and y axis respectively
    ggplot2::geom_point() + # Plot in form of scatter plot
    ggplot2::labs(title = title, subtitle = subtitle) + # Make title the linear function and subtitle the r-squared and f-statistic
    ggplot2::stat_function(fun = function(i) yint + slope*i) # Plot linear model as line
}
