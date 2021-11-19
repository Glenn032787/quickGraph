
# Test that x and y are character (in string)
test_that('Error for x and y not being character', {
  # texture_mean and perimeter_mean is not character data type (unquoted)
  expect_error(plotLinearModel(datateachr::cancer_sample, texture_mean, perimeter_mean))

  # Does not cause error because texture_mean and perimeter_mean is character data type (quoted)
  p <- plotLinearModel(datateachr::cancer_sample, 'texture_mean', 'perimeter_mean')
  expect_true(ggplot2::is.ggplot(p))
})

# Test that column data is numeric
test_that('Error x and y column in dataset is not numeric', {
  # name is character type in steam_games
  expect_error(plotLinearModel(datateachr::steam_games, 'name', 'discount_price'),
               "name column must be data type numeric, it is data type character")

  # developer is character type in steam_games
  expect_error(plotLinearModel(datateachr::steam_games, 'original_price', 'developer'),
               "developer column must be data type numeric, it is data type character")
})


# Test that there is a minimum of 3 numeric rows
test_that("Error for dataset with less than three valid row", {
  test <- tibble::tribble(
    ~x, ~y, ~z,
    #--|--|----
    1, 2, 3,
    2, 3, 4)

  # Raise error because test only has 2 rows
  expect_error(plotLinearModel(test, 'x', 'y'),
               "Data set must have at least three valid entries")

  # Add invalid row (y is NA)
  test <- tibble::add_row(test, x=3, y=NA, z=3)
  # Still raises error because additional row is not valid (2 valid rows only)
  expect_error(plotLinearModel(test, 'x', 'y'),
               "Data set must have at least three valid entries")

  # Add valid row
  test <- tibble::add_row(test, x=4, y=3, z=5)
  # No error raised because it has the minimum 3 valid rows
  p <- plotLinearModel(test, 'x', 'y')
  expect_true(ggplot2::is.ggplot(p))
})

# Create small data set (5 rows)
small_data <- tibble::tibble(
  x1 = 1:5,
  y1 = x1 ** 3
)

# Create large data set (1000 rows)
large_data <- tibble::tibble(
  x2 = 1:1000,
  y2 = x2 ** 2
)

# Test that ggplot layers is expected
test_that("Plot layers match expectations",{
  p <- plotLinearModel(small_data, 'x1', 'y1')
  expect_true(ggplot2::is.ggplot(p)) # Check if output is data type ggplot
  expect_s3_class(p$layers[[1]]$geom, "GeomPoint") # Check if layer 1 is scatter plot
  expect_s3_class(p$layers[[2]]$geom, "GeomPath") # Check if layer 2 is linear function

  p <- plotLinearModel(large_data, 'x2', 'y2')
  expect_true(ggplot2::is.ggplot(p)) # Check if output is data type ggplot
  expect_s3_class(p$layers[[1]]$geom, "GeomPoint") # Check if layer 1 is scatter plot
  expect_s3_class(p$layers[[2]]$geom, "GeomPath") # Check if layer 2 is linear function
})

# Test that ggplot label match expectations
test_that("Plot label match expectations",{
  p <- plotLinearModel(small_data, 'x1', 'y1')
  expect_identical(p$labels$y, "y1") # Check y axis is y1
  expect_identical(p$labels$x, "x1") # Check x axis is x1

  p <- plotLinearModel(large_data, 'x2', 'y2')
  expect_identical(p$labels$y, "y2") # Check y axis is y2
  expect_identical(p$labels$x, "x2") # Check x axis is x2
})

# Test that rows that are NA are dropped
test_that("Rows with NA are removed",{
  test <- tibble::tribble(
    ~x, ~y, ~z,
    #--|--|----
    1, 2, 3,
    2, 3, 4,
    3, 5, 2,
    4, 3, 2
  )

  p1 <- plotLinearModel(test, 'x', 'y')

  # Add two invalid rows
  #test <- tibble::add_row(test, x=1, y= NA, z=2)
  #test <- tibble::add_row(test, x=NA, y=3, z=4)

  p2 <- plotLinearModel(test, 'x', 'y')
  expect_true(all.equal(p1, p2)) # ggplots objects before and after adding invalid rows are the same
})

# Test that error is raised when data is not a tibble
test_that("Error raised when data not tibble",{
  data_frame <- data.frame(
    x = c(1, 2, 3, 4),
    y = c(2, 3, 4, 1)
    )

  # Raise error when data is data.frame class rather than tibble
  expect_s3_class(data_frame, "data.frame")
  expect_error(
    plotLinearModel(data_frame, 'x', 'y'),
    "Data must be a tibble, it is data type data.frame"
  )

  # Raise error when data is character
  expect_error(
    plotLinearModel("data", 'x', 'y'),
    "Data must be a tibble, it is data type character"
  )

  # Raise error when data is vector
  expect_error(
    plotLinearModel(3671283, 'x', 'y'),
    "Data must be a tibble, it is data type numeric"
  )

})



