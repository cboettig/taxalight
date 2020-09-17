context("tl_create")



test_that("tl_import", {
  
  path <- tl_import("itis_test")
  expect_true(file.exists(path))
  
})

test_that("tl_create", {
  
  db <- tl_create("itis_test")
  expect_is(db, "mdb_env")
})