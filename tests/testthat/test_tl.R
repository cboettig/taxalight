context("tl")

test_that("tl", {
  
  sp <- c("Dendrocygna autumnalis", "Dendrocygna bicolor")
  id <- c("ITIS:180092", "ITIS:179913")
  #' 
  #' ## example uses "itis_test" provider for illustration only:
  x <- tl(sp, "itis_test")
  expect_is(x, "data.frame")
  
  x <- tl(id, "itis_test")
  expect_is(x, "data.frame")

  x <- tl(c(sp, id), "itis_test")
  expect_is(x, "data.frame")
    
  
  
})


test_that("get_ids", {
  
  sp <- c("Dendrocygna autumnalis", "Dendrocygna bicolor")
  x <- get_names(id, "itis_test")
  
})


test_that("get_names", {
  
  id <- c("ITIS:180092", "ITIS:179913")
  x <- get_names(id, "itis_test")
  
})


