
test_that("Plotting issues expected errors", {

  ## simulate basic epicurve
  dat <- c(0, 2, 2, 3, 3, 5, 5, 5, 6, 6, 6, 6)
  i <- incidence::incidence(dat)
  p <- plot(i)

  ## example with a function for SI
  expect_error(add_projections(p, "toto"),
               "`x` must be a 'projections' object but is a `character`",
               fixed = TRUE)
})




test_that("Test against reference results", {

  ## simulate basic epicurve
  dat <- c(0, 2, 2, 3, 3, 5, 5, 5, 6, 6, 6, 6)
  i <- incidence::incidence(dat)


  ## example with a function for SI
  si <- distcrete::distcrete("gamma", interval = 1L,
                             shape = 1.5,
                             scale = 2, w = 0)

  set.seed(1)
  pred_1 <- project(i, runif(100, 0.8, 1.9), si, n_days = 30)
  plot_1 <- plot(pred_1)

  vdiffr::expect_doppelganger(
    "basic-example-plot",
    plot_1
  )

  ## using simulated ebola data

  si <- distcrete::distcrete(
    "gamma",
    interval = 1L,
    shape = 2.4,
    scale = 4.7,
    w = 0.5)

  i <- incidence::incidence(outbreaks::ebola_sim$linelist$date_of_onset)

  ## add projections after the first 100 days, over 60 days
  set.seed(1)
  proj <- project(x = i[1:100], R = 1.4, si = si, n_days = 60)

  ## plotting projections
  plot_2 <- plot(proj)
  vdiffr::expect_doppelganger(
    "evd-proj",
    plot_2
  )

  plot_3 <- plot(proj, boxplots = TRUE, outliers = FALSE)
  vdiffr::expect_doppelganger(
    "evd-proj-box-no-outliers",
    plot_3
  )

  plot_4 <- plot(proj, ribbon = FALSE)
  vdiffr::expect_doppelganger(
    "evd-proj-no-ribbon",
    plot_4
  )

  plot_5 <- plot(proj, boxplots = FALSE, linetype = 2, linesize = 3)
  vdiffr::expect_doppelganger(
    "evd-proj-no-box-custom-lines",
    plot_5
  )

  plot_6 <- plot(proj, boxplots = TRUE, boxplots_color = "red")
  vdiffr::expect_doppelganger(
    "evd-proj-red-box",
    plot_6
  )

  plot_7 <- plot(proj, quantiles = FALSE, ribbon = FALSE, boxplots = TRUE)
  vdiffr::expect_doppelganger(
    "evd-proj-box-only",
    plot_7
  )

  plot_8 <- plot(proj, quantiles = FALSE)
  vdiffr::expect_doppelganger(
    "evd-proj-ribbon-only",
    plot_8
  )

  plot_9 <- plot(proj, ribbon_color = "red", quantiles = FALSE)
  vdiffr::expect_doppelganger(
    "evd-proj-red-ribbon",
    plot_9
  )

  plot_10 <- plot(
    proj,
    ribbon_color = "red",
    ribbon_alpha = 1,
    quantiles = FALSE,
    ribbon_quantiles = c(.4, .6)
  )
  vdiffr::expect_doppelganger(
    "evd-proj-full-red-ribbon-narrow-range",
    plot_10
  )


  ## adding projections to incidence::incidence plot
  plot_11 <- plot(i) %>% add_projections(proj)
  vdiffr::expect_doppelganger(
    "evd-proj-with-incidence-incidence",
    plot_11
  )

  plot_12 <- plot(i) %>% add_projections(proj, boxplots = TRUE)
  vdiffr::expect_doppelganger(
    "evd-proj-with-incidence-incidence-no-box",
    plot_12
  )

  plot_13 <-
    plot(i) %>%
    add_projections(proj, quantiles = FALSE, ribbon = FALSE, boxplots = TRUE)
  vdiffr::expect_doppelganger(
    "evd-proj-with-incidence-incidence-box-only",
    plot_13
  )


  ## same, custom colors and quantiles
  quantiles <- c(.001, .01, 0.05, .1, .2, .3, .4, .5)
  pal <- colorRampPalette(c("#b3c6ff", "#00e64d", "#cc0066"))
  plot_14 <- plot(i[1:200]) %>%
    add_projections(proj, quantiles, palette = pal) +
    ggplot2::scale_x_date(date_labels = "%b %Y")
  vdiffr::expect_doppelganger(
    "evd-proj-with-incidence-incidence-and-custom",
    plot_14
  )

})
