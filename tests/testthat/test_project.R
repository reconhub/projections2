test_that(
  "project() issues the right error messages",
  {

    input <- "toto"
    class(input) <- c("character", "stuff")    
    msg <- "No `project\\(\\)` method for oject of the class: character, stuff"
    expect_error(project(input), msg)
    
    msg <- "No `project\\(\\)` method for oject of the class: NULL"
    expect_error(project(NULL), msg)

    i <- incidence::incidence(1:10, 3)
    expect_error(project(i),
                 "daily incidence needed, but interval is 3 days")

    i <- incidence::incidence(1:10, 1, group = letters[1:10])
    expect_error(project(i),
                 "cannot use multiple groups in incidence object")
    i <- incidence::incidence(seq(Sys.Date(), by = "month", length.out = 12), "month")
    expect_error(project(i),
                 "daily incidence needed, but interval is 30 days")

    i <- incidence::incidence(1)
    si <- distcrete::distcrete("gamma", interval = 5L,
                               shape = 1.5,
                               scale = 2, w = 0)

    expect_error(project(i, 1, si = si),
                 "interval used in si is not 1 day, but 5")
    expect_error(project(i, -1, si = si),
                 "R < 0 (value: -1.00)", fixed = TRUE)
    expect_error(project(i, Inf, si = si),
                 "R is not a finite value", fixed = TRUE)
    expect_error(project(i, "tamere", si = si),
                 "R is not numeric", fixed = TRUE)
    expect_error(project(i, R = list(1), si = si, time_change = 2),
                 "`R` must be a `list` of size 2 to match 1 time changes; found 1",
                 fixed = TRUE)
    expect_error(project(i, si = si, time_change = "pophip", R = 3),
                 "`time_change` must be `numeric`, but is a `character`",
                 fixed = TRUE)
    msg <- ifelse(R.version.string > "3.6.3",
                  "`R` must be a `vector` or a `list` if `time_change` provided; it is a `matrix, array`",
                  "`R` must be a `vector` or a `list` if `time_change` provided; it is a `matrix`")
    expect_error(project(i, si = si, time_change = 2, R = matrix(1.2)),
                 msg,
                 fixed = TRUE)


  }
)





test_that("Projections throw warning if si[1] = 0", {
  i <- incidence::incidence(as.Date('2020-01-23'))
  si <- c(0, 0.2, 0.5, 0.2, 0.1)
  R0 <- 2

  msg <- "si[1] is 0. Did you accidentally input the serial interval"

  expect_warning(project(x = i,
               si = si,
               R = R0,
               n_sim = 2,
               R_fix_within = TRUE,
               n_days = 1,
               model = "poisson"),
               msg, fixed = TRUE)
})


test_that("Projections can be performed for a single day", {
  i <- incidence::incidence(as.Date('2020-01-23'))
  si <- c(0.2, 0.5, 0.2, 0.1)
  R0 <- 2

  p <- project(x = i,
               si = si,
               R = R0,
               n_sim = 2,  # doesn't work with 1 in project function
               R_fix_within = TRUE,
               n_days = 1, # doing 2 days as project function currently not working with one day - will only use first day though
               model = "poisson"
  )

  expect_equal(get_dates(p), as.Date("2020-01-24"))
})





test_that("Projections can be performed for a single day and single simulation", {
  i <- incidence::incidence(as.Date('2020-01-23'))
  si <- c(0.2, 0.5, 0.2, 0.1)
  R0 <- 2

  p <- project(x = i,
               si = si,
               R = R0,
               n_sim = 1,  # doesn't work with 1 in project function
               R_fix_within = TRUE,
               n_days = 1, # doing 2 days as project function currently not working with one day - will only use first day though
               model = "poisson"
  )

  expect_equal(get_dates(p), as.Date("2020-01-24"))
  expect_identical(ncol(p), 1L)
})





test_that("Test that dates start when needed", {
  skip_on_cran()

  ## simulate basic epicurve
  dat <- c(0, 2, 2, 3, 3, 5, 5, 5, 6, 6, 6, 6)
  i <- incidence::incidence(dat)


  ## example with a function for SI
  si <- distcrete::distcrete("gamma", interval = 1L,
                             shape = 1.5,
                             scale = 2, w = 0)

  set.seed(1)
  pred_1 <- project(i, runif(100, 0.8, 1.9), si, n_days = 30)
  expect_equal(max(i$dates) + 1, min(get_dates(pred_1)))

})





test_that("Test R_fix_within", {

  ## The rationale of this test is to check that the variance of trajectories
  ## when fixing R within a given simulation is larger than when drawing
  ## systematically from the distribution. On the provided example, fixing R
  ## will lead to many more trajectories growing fast, and greater average
  ## incidence (> x10 for the last time steps).

  skip_on_cran()

  ## simulate basic epicurve
  dat <- c(0, 2, 2, 3, 3, 5, 5, 5, 6, 6, 6, 6)
  i <- incidence::incidence(dat)

  set.seed(1)
  x_base <- project(i,
                    si = c(1, 1 , 1, 1),
                    R = c(0.8, 1.2),
                    n_days = 50,
                    n_sim = 1000,
                    R_fix_within = FALSE)
  x_fixed <- project(i,
                     si = c(1, 1 , 1, 1),
                     R = c(0.8, 1.2),
                     n_days = 50,
                     n_sim = 1000,
                     R_fix_within = TRUE)
  expect_true(all(tail(rowSums(x_fixed) / rowSums(x_base), 5) > 10))

})





test_that("Re-estimation of instantaneous R gives expected results", {

  ## Check that when projecting with instantaneous_R = TRUE, and then
  ## reestimating R with EpiEstim::estimate_R,
  ## we recover the correct R over time

  ## Define R over time with two successive values:
  R <- c(rep(1.4, 25), rep(1.1, 25))

  ## Serial interval distribution
  si <- rep(0.25, 4)

  ## simulate basic epicurve
  dat <- rep(0, 10000) # start with high incidence --> good power to estimate R
  initial <- incidence::incidence(dat)

  set.seed(1)
  incid <- project(initial,
                   si = si,
                   R = R,
                   n_days = 50,
                   n_sim = 1,
                   time_change = seq_len(length(R) - 1) - 1,
                   instantaneous_R = TRUE)
  ## convert to vector and pre-apend initial cases
  incid <- as.numeric(rbind(initial$counts, as.matrix(incid)))

  ## reestimate R using EpiEstim
  windows <- seq(2, length(incid), 1)
  daily_R <- EpiEstim::estimate_R(incid = incid,
                                  method = "non_parametric_si",
                                  config = EpiEstim::make_config(list(si_distr = c(0, si),
                                                                      t_start = windows,
                                                                      t_end = windows,
                                                                      mean_prior = 1,
                                                                      std_prior = 1)))$R

  ## Expect we were able to reasonably accurately reestimate R
  ## excluding first time step as EpiEstim start estimation on 2nd time step
  expect_true(all(abs(daily_R$`Mean(R)`[-1] - R[-1]) < 0.05))
})





test_that(
  "Average projections are within expected bounds - Poisson model", {

    ## expectations: each time step incidence should be multiplied by 1.5 on
    ## average
    res <- project(1e4, R = 1.5, si = 1, n_sim = 100)
    expect_true(quantile(as.vector(res[1, ]), probs = 0.1) > 14000)
    expect_true(quantile(as.vector(res[1, ]), probs = 0.9) < 16000)

    for (t in 2:7) {
      expect_true(all(as.vector(res[t, ] / res[t-1, ]) > 1.4))
      expect_true(all(as.vector(res[t, ] / res[t-1, ]) < 1.6))
    }
  }
)





test_that(
  "Average projections are within expected bounds - NegBin model", {

    ## expectations: each time step incidence should be multiplied by 1.5 on
    ## average
    res <- project(10000, R = 1.5, si = 1, n_sim = 100, model = "negbin")
    expect_true(quantile(as.vector(res[1, ]), probs = 0.1) > 11000)
    expect_true(quantile(as.vector(res[1, ]), probs = 0.9) < 19000)

    for (t in 2:6) {
      expect_true(all(as.vector(res[t, ] / res[t-1, ]) > 1.2))
      expect_true(all(as.vector(res[t, ] / res[t-1, ]) < 1.8))
    }
  }
)




test_that(
  "project works with incidence2 inputs", {

    i <- incidence2::incidence(data.frame(t = c(0, 1, 1, 3, 3, 4)), "t", interval = 1)
    expect_no_error(res <- project(i, R = 1.123, si = 1))
    expect_identical(dim(res), c(7L, 100L))
    expect_equal(as.integer(get_dates(res)), 5:11)
    
  }
)





test_that(
  "Regrouping data for incidence2 objects", {

    linelist <- data.frame(
      onset = c(1, 3, 4, 4, 5, 5, 5, 6, 7, 7, 7),
      gender = rep(c("m", "f"), c(4, 7))      
    )
    i <- incidence2::incidence(linelist, "onset", group = "gender", interval = 1)
    msg <- "stratificaction in incidence2 object will be ignored"
    expect_warning(project(i, R = 12, si = 1), msg)
    expect_no_warning(project(i, R = 12, si = 1, quiet = TRUE))

  }
)
