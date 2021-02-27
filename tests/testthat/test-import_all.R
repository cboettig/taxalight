
test_that("can import all providers",{
  skip_if(TRUE, "takes a long time")
  tl_create("itis") # 32s
  tl_create("col")  # 3m
  tl_create("ott")  # 4m
  tl_create("gbif") # 5m
  # tl_create("iucn") #  no 2020, & 2019 fails
  # tl_create("fb")   #
  # tl_create("slb")  #
})

test_that("handles duplicate names", {
  skip_if(TRUE, "takes a long time")

  df <- tl("Muscicapa striata", "ott")
  x <- get_ids("Muscicapa striata", "ott")
  expect_gt(nrow(df), 1)  
  
  
  
  df <- tl("Muscicapa striata", "gbif")
  df <- tl("Muscicapa striata", "itis")
  df <- tl("Muscicapa striata", "col")
  
})
