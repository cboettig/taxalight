context("tl_create")

test_that("parse_prov()",{
  skip_if_offline()
  skip_on_cran()
  prov <- parse_prov()
  expect_is(prov, "data.frame")
  expect_gt(nrow(prov), 2)
})

test_that("parse_prov()",{
  expect_warning({
    prov <- parse_prov("not_a_url")
  })
  expect_is(prov, "data.frame")
  expect_gt(nrow(prov), 2)
  
})


test_that("tl_import()", {
  
  path <- tl_import("itis_test")
  expect_true(file.exists(path))
  
})

test_that("tl_create()", {
  
  db <- tl_create("itis_test")
  expect_is(db, "mdb_env")
})


test_that("Online tl_import()", {
  
  skip_if_offline()
  skip_on_cran()
  path <- tl_import("itis")
  expect_true(all(file.exists(path)))
  
})