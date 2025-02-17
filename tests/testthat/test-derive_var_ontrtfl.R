## Test 1: `start_date` < `ref_start_date` ----
test_that("derive_var_ontrtfl Test 1: `start_date` < `ref_start_date`", {
  input <- tibble::tribble(
    ~STUDYID, ~USUBJID, ~ADT, ~TRTSDT,
    "TEST01", "PAT01", as.Date("2021-01-01"), as.Date("2021-01-02")
  )
  expected_output <- tibble::tribble(
    ~STUDYID, ~USUBJID, ~ADT, ~TRTSDT, ~ONTRTFL,
    "TEST01", "PAT01", as.Date("2021-01-01"), as.Date("2021-01-02"), as.character(NA)
  )

  actual_output <- derive_var_ontrtfl(
    input,
    new_var = ONTRTFL,
    start_date = ADT,
    ref_start_date = TRTSDT
  )

  expect_dfs_equal(
    expected_output,
    actual_output,
    keys = c("STUDYID", "USUBJID", "ADT")
  )
})

## Test 2: `ref_start_date` is NA ----
test_that("derive_var_ontrtfl Test 2: `ref_start_date` is NA", {
  input <- tibble::tribble(
    ~STUDYID, ~USUBJID, ~ADT, ~TRTSDT,
    "TEST01", "PAT01", as.Date("2021-01-01"), as.Date(NA)
  )
  expected_output <- tibble::tribble(
    ~STUDYID, ~USUBJID, ~ADT, ~TRTSDT, ~ONTRTFL,
    "TEST01", "PAT01", as.Date("2021-01-01"), as.Date(NA), as.character(NA)
  )

  actual_output <- derive_var_ontrtfl(
    input,
    new_var = ONTRTFL,
    start_date = ADT,
    ref_start_date = TRTSDT
  )

  expect_dfs_equal(
    expected_output,
    actual_output,
    keys = c("STUDYID", "USUBJID", "ADT")
  )
})

## Test 3: `start_date` is NA ----
test_that("derive_var_ontrtfl Test 3: `start_date` is NA", {
  input <- tibble::tribble(
    ~STUDYID, ~USUBJID, ~ADT, ~TRTSDT,
    "TEST01", "PAT01", as.Date(NA), as.Date("2020-01-01"),
    "TEST01", "PAT02", as.Date(NA), as.Date(NA)
  )
  expected_output <- tibble::tribble(
    ~STUDYID, ~USUBJID, ~ADT, ~TRTSDT, ~ONTRTFL,
    "TEST01", "PAT01", as.Date(NA), as.Date("2020-01-01"), "Y",
    "TEST01", "PAT02", as.Date(NA), as.Date(NA), as.character(NA)
  )

  actual_output <- derive_var_ontrtfl(
    input,
    new_var = ONTRTFL,
    start_date = ADT,
    ref_start_date = TRTSDT
  )

  expect_dfs_equal(
    expected_output,
    actual_output,
    keys = c("STUDYID", "USUBJID", "ADT")
  )
})

## Test 4: start_date >= ref_start_date, no ref_end_date and filter_pre_timepoint ----
test_that("derive_var_ontrtfl Test 4: start_date >= ref_start_date, no ref_end_date and filter_pre_timepoint", { # nolint
  input <- tibble::tribble(
    ~STUDYID, ~USUBJID, ~ADT, ~TRTSDT,
    "TEST01", "PAT01", as.Date("2020-01-01"), as.Date("2020-01-01"),
    "TEST01", "PAT02", as.Date("2020-01-02"), as.Date("2020-01-01")
  )
  expected_output <- tibble::tribble(
    ~STUDYID, ~USUBJID, ~ADT, ~TRTSDT, ~ONTRTFL,
    "TEST01", "PAT01", as.Date("2020-01-01"), as.Date("2020-01-01"), "Y",
    "TEST01", "PAT02", as.Date("2020-01-02"), as.Date("2020-01-01"), "Y"
  )

  actual_output <- derive_var_ontrtfl(
    input,
    new_var = ONTRTFL,
    start_date = ADT,
    ref_start_date = TRTSDT
  )

  expect_dfs_equal(
    expected_output,
    actual_output,
    keys = c("STUDYID", "USUBJID", "ADT")
  )
})

## Test 5: `filter_pre_timepoint` is specified ----
test_that("derive_var_ontrtfl Test 5: `filter_pre_timepoint` is specified", {
  input <- tibble::tribble(
    ~STUDYID, ~USUBJID, ~ADT, ~TRTSDT, ~TPT,
    "TEST01", "PAT01", as.Date("2020-01-01"), as.Date("2020-01-01"), "PRE",
    "TEST01", "PAT02", as.Date("2020-01-01"), as.Date("2020-01-01"), "POST"
  )
  expected_output <- tibble::tribble(
    ~STUDYID, ~USUBJID, ~ADT, ~TRTSDT, ~TPT, ~ONTRTFL,
    "TEST01", "PAT01", as.Date("2020-01-01"), as.Date("2020-01-01"), "PRE", NA,
    "TEST01", "PAT02", as.Date("2020-01-01"), as.Date("2020-01-01"), "POST", "Y"
  )

  actual_output <- derive_var_ontrtfl(
    input,
    new_var = ONTRTFL,
    start_date = ADT,
    ref_start_date = TRTSDT,
    filter_pre_timepoint = TPT == "PRE"
  )

  expect_dfs_equal(
    expected_output,
    actual_output,
    keys = c("STUDYID", "USUBJID", "ADT")
  )
})

## Test 6: ref_start_date <= start_date <= ref_end_date, no ref_end_window ----
test_that("derive_var_ontrtfl Test 6: ref_start_date <= start_date <= ref_end_date, no ref_end_window", { # nolint
  input <- tibble::tribble(
    ~STUDYID, ~USUBJID, ~ADT, ~TRTSDT, ~TRTEDT,
    "TEST01", "PAT01", as.Date("2019-12-13"), as.Date("2020-01-01"), as.Date("2020-02-01"),
    "TEST01", "PAT02", as.Date("2020-01-01"), as.Date("2020-01-01"), as.Date("2020-02-01"),
    "TEST01", "PAT03", as.Date("2020-01-02"), as.Date("2020-01-01"), as.Date("2020-02-01"),
    "TEST01", "PAT04", as.Date("2020-02-01"), as.Date("2020-01-01"), as.Date("2020-02-01"),
    "TEST01", "PAT05", as.Date("2020-02-02"), as.Date("2020-01-01"), as.Date("2020-02-01")
  )
  expected_output <- tibble::tribble(
    ~STUDYID, ~USUBJID, ~ADT, ~TRTSDT, ~TRTEDT, ~ONTRTFL, # nolint
    "TEST01", "PAT01", as.Date("2019-12-13"), as.Date("2020-01-01"), as.Date("2020-02-01"), NA,
    "TEST01", "PAT02", as.Date("2020-01-01"), as.Date("2020-01-01"), as.Date("2020-02-01"), "Y",
    "TEST01", "PAT03", as.Date("2020-01-02"), as.Date("2020-01-01"), as.Date("2020-02-01"), "Y",
    "TEST01", "PAT04", as.Date("2020-02-01"), as.Date("2020-01-01"), as.Date("2020-02-01"), "Y",
    "TEST01", "PAT05", as.Date("2020-02-02"), as.Date("2020-01-01"), as.Date("2020-02-01"), NA
  )

  actual_output <- derive_var_ontrtfl(
    input,
    new_var = ONTRTFL,
    start_date = ADT,
    ref_start_date = TRTSDT,
    ref_end_date = TRTEDT
  )

  expect_dfs_equal(
    expected_output,
    actual_output,
    keys = c("STUDYID", "USUBJID", "ADT")
  )
})

## Test 7: ref_start_date <= start_date <= ref_end_date + ref_end_window ----
test_that("derive_var_ontrtfl Test 7: ref_start_date <= start_date <= ref_end_date + ref_end_window", { # nolint
  input <- tibble::tribble(
    ~STUDYID, ~USUBJID, ~ADT, ~TRTSDT, ~TRTEDT,
    "TEST01", "PAT01", as.Date("2020-02-01"), as.Date("2020-01-01"), as.Date("2020-02-01"),
    "TEST01", "PAT02", as.Date("2020-02-05"), as.Date("2020-01-01"), as.Date("2020-02-01"),
    "TEST01", "PAT03", as.Date("2020-02-10"), as.Date("2020-01-01"), as.Date("2020-02-01")
  )
  expected_output <- tibble::tribble(
    ~STUDYID, ~USUBJID, ~ADT, ~TRTSDT, ~TRTEDT, ~ONTRTFL, # nolint
    "TEST01", "PAT01", as.Date("2020-02-01"), as.Date("2020-01-01"), as.Date("2020-02-01"), "Y",
    "TEST01", "PAT02", as.Date("2020-02-05"), as.Date("2020-01-01"), as.Date("2020-02-01"), "Y",
    "TEST01", "PAT03", as.Date("2020-02-10"), as.Date("2020-01-01"), as.Date("2020-02-01"), NA
  )

  actual_output <- derive_var_ontrtfl(
    input,
    new_var = ONTRTFL,
    start_date = ADT,
    ref_start_date = TRTSDT,
    ref_end_date = TRTEDT,
    ref_end_window = 5
  )

  expect_dfs_equal(
    expected_output,
    actual_output,
    keys = c("STUDYID", "USUBJID", "ADT")
  )
})

## Test 8: considering time for ref_end_date ----
test_that("derive_var_ontrtfl Test 8: considering time for ref_end_date", {
  expected_output <- tibble::tribble(
    ~STUDYID, ~USUBJID, ~ADTM,              ~ONTRTFL,
    "TEST01", "PAT01",  "2020-02-01T12:00", "Y",
    "TEST01", "PAT02",  "2020-02-06T10:00", "Y",
    "TEST01", "PAT03",  "2020-02-06T14:00", NA,
    "TEST01", "PAT03",  "2020-02-10T13:00", NA
  ) %>%
    mutate(
      ADTM = lubridate::ymd_hm(ADTM),
      TRTSDTM = lubridate::ymd_hm("2020-01-01T12:00"),
      TRTEDTM = lubridate::ymd_hm("2020-02-01T12:00")
    )

  input <- select(expected_output, -ONTRTFL)

  actual_output <- derive_var_ontrtfl(
    input,
    new_var = ONTRTFL,
    start_date = ADTM,
    ref_start_date = TRTSDTM,
    ref_end_date = TRTEDTM,
    ref_end_window = 5,
    ignore_time_for_ref_end_date = FALSE
  )

  expect_dfs_equal(
    expected_output,
    actual_output,
    keys = c("STUDYID", "USUBJID", "ADTM")
  )
})

## Test 9: end_date < ref_start_date and start_date is NA ----
test_that("derive_var_ontrtfl Test 9: end_date < ref_start_date and start_date is NA", {
  input <- tibble::tribble(
    ~USUBJID, ~ASTDT, ~TRTSDT, ~TRTEDT, ~AENDT,
    "PAT01", ymd("2019-04-30"), ymd("2020-01-01"), ymd("2020-03-01"), ymd("2019-03-15"),
    "PAT01", NA, ymd("2020-01-01"), ymd("2020-03-01"), ymd("2019-03-15"),
  )
  expected_output <- tibble::tribble(
    ~USUBJID, ~ASTDT, ~TRTSDT, ~TRTEDT, ~AENDT, ~ONTRTFL,
    "PAT01", ymd("2019-04-30"), ymd("2020-01-01"), ymd("2020-03-01"), ymd("2019-03-15"), NA_character_, # nolint
    "PAT01", NA, ymd("2020-01-01"), ymd("2020-03-01"), ymd("2019-03-15"), NA_character_,
  )

  actual_output <- derive_var_ontrtfl(
    input,
    new_var = ONTRTFL,
    start_date = ASTDT,
    end_date = AENDT,
    ref_start_date = TRTSDT,
    ref_end_date = TRTEDT,
    ref_end_window = 60
  )

  expect_dfs_equal(
    expected_output,
    actual_output,
    keys = c("USUBJID", "ASTDT")
  )
})

## Test 10: end_date > ref_start_date and start_date is NA ----
test_that("derive_var_ontrtfl Test 10: end_date > ref_start_date and start_date is NA", {
  input <- tibble::tribble(
    ~STUDYID, ~USUBJID, ~ASTDT, ~TRTSDT, ~TRTEDT, ~AENDT,
    "TEST01", "PAT01", NA, ymd("2020-01-01"), ymd("2020-03-01"), ymd("2021-03-15"),
  )
  expected_output <- tibble::tribble(
    ~STUDYID, ~USUBJID, ~ASTDT, ~TRTSDT, ~TRTEDT, ~AENDT, ~ONTRTFL,
    "TEST01", "PAT01", NA, ymd("2020-01-01"), ymd("2020-03-01"), ymd("2021-03-15"), "Y"
  )

  actual_output <- derive_var_ontrtfl(
    input,
    new_var = ONTRTFL,
    start_date = ASTDT,
    end_date = AENDT,
    ref_start_date = TRTSDT,
    ref_end_date = TRTEDT,
    ref_end_window = 60
  )

  expect_dfs_equal(
    expected_output,
    actual_output,
    keys = c("STUDYID", "USUBJID", "ASTDT")
  )
})

## Test 11: end_date is NA and start_date < ref_start_date a la Roche ----
test_that("derive_var_ontrtfl Test 11: end_date is NA and start_date < ref_start_date a la Roche", {
  input <- tibble::tribble(
    ~STUDYID, ~USUBJID, ~ASTDT, ~TRTSDT, ~TRTEDT, ~AENDT,
    "TEST01", "PAT01", ymd("2019-04-30"), ymd("2020-01-01"), ymd("2020-03-01"), NA,
  )
  expected_output <- tibble::tribble(
    ~STUDYID, ~USUBJID, ~ASTDT, ~TRTSDT, ~TRTEDT, ~AENDT, ~ONTRTFL,
    "TEST01", "PAT01", ymd("2019-04-30"), ymd("2020-01-01"), ymd("2020-03-01"), NA, NA_character_,
  )

  actual_output <- derive_var_ontrtfl(
    input,
    new_var = ONTRTFL,
    start_date = ASTDT,
    end_date = AENDT,
    ref_start_date = TRTSDT,
    ref_end_date = TRTEDT,
    ref_end_window = 60
  )

  expect_dfs_equal(
    expected_output,
    actual_output,
    keys = c("STUDYID", "USUBJID", "ASTDT")
  )
})

## Test 12: end_date is NA and start_date < ref_start_date a la GSK ----
test_that("derive_var_ontrtfl Test 12: end_date is NA and start_date < ref_start_date a la GSK", {
  input <- tibble::tribble(
    ~STUDYID, ~USUBJID, ~ASTDT, ~TRTSDT, ~TRTEDT, ~AENDT,
    "TEST01", "PAT01", ymd("2019-04-30"), ymd("2020-01-01"), ymd("2020-03-01"), NA,
  )
  expected_output <- tibble::tribble(
    ~STUDYID, ~USUBJID, ~ASTDT, ~TRTSDT, ~TRTEDT, ~AENDT, ~ONTRTFL,
    "TEST01", "PAT01", ymd("2019-04-30"), ymd("2020-01-01"), ymd("2020-03-01"), NA, "Y",
  )

  actual_output <- derive_var_ontrtfl(
    input,
    new_var = ONTRTFL,
    start_date = ASTDT,
    end_date = AENDT,
    ref_start_date = TRTSDT,
    ref_end_date = TRTEDT,
    ref_end_window = 60,
    span_period = "Y"
  )

  expect_dfs_equal(
    expected_output,
    actual_output,
    keys = c("STUDYID", "USUBJID", "ASTDT")
  )
})

## Test 13: end_date is NA and start_date < ref_start_date a la GSK ----
test_that("derive_var_ontrtfl Test 13: end_date is NA and start_date < ref_start_date a la GSK", {
  input <- tibble::tribble(
    ~STUDYID, ~USUBJID, ~ASTDT, ~TRTSDT, ~TRTEDT, ~AENDT,
    "TEST01", "PAT01", ymd("2019-04-30"), ymd("2020-01-01"), ymd("2020-03-01"), NA,
  )
  expected_output <- tibble::tribble(
    ~STUDYID, ~USUBJID, ~ASTDT, ~TRTSDT, ~TRTEDT, ~AENDT, ~ONTRTFL,
    "TEST01", "PAT01", ymd("2019-04-30"), ymd("2020-01-01"), ymd("2020-03-01"), NA, "Y",
  )

  actual_output <- derive_var_ontrtfl(
    input,
    new_var = ONTRTFL,
    start_date = ASTDT,
    end_date = AENDT,
    ref_start_date = TRTSDT,
    ref_end_date = TRTEDT,
    ref_end_window = 60,
    span_period = "Y"
  )

  expect_dfs_equal(
    expected_output,
    actual_output,
    keys = c("STUDYID", "USUBJID", "ASTDT")
  )
})

## Test 14: start_date < ref_start_date and end_date < ref_end_date for Period 01 ----
test_that("derive_var_ontrtfl Test 14: start_date < ref_start_date and end_date < ref_end_date for Period 01", { # nolint
  input <- tibble::tribble(
    ~STUDYID, ~USUBJID, ~ASTDT, ~AP01SDT, ~AP01EDT, ~AENDT,
    "TEST01", "PAT01", ymd("2019-04-30"), ymd("2020-01-01"), ymd("2020-03-01"), ymd("2020-03-15")
  )

  expected_output <- tibble::tribble(
    ~STUDYID, ~USUBJID, ~ASTDT, ~AP01SDT, ~AP01EDT, ~AENDT, ~ONTR01FL,
    "TEST01", "PAT01", ymd("2019-04-30"), ymd("2020-01-01"),
    ymd("2020-03-01"), ymd("2020-03-15"), "Y",
  )

  actual_output <- derive_var_ontrtfl(
    input,
    new_var = ONTR01FL,
    start_date = ASTDT,
    end_date = AENDT,
    ref_start_date = AP01SDT,
    ref_end_date = AP01EDT,
    span_period = "Y"
  )

  expect_dfs_equal(
    expected_output,
    actual_output,
    keys = c("STUDYID", "USUBJID", "ASTDT")
  )
})
