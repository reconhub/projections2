
## This function will take an existing 'incidence' plot object ('p') and add
## lines from an 'projections' object ('x'), as returned by projections::project

#' @export
#' @rdname plot.projections
#' @param p A previous incidence plot to which projections should be added.
add_projections <- function(p, x, quantiles = c(0.01, 0.05, 0.1, 0.5),
                            ribbon = TRUE, boxplots = FALSE,
                            palette = quantile_pal,
                            quantiles_alpha = 1,
                            linetype = 1, linesize = 0.5,
                            ribbon_quantiles = NULL,
                            ribbon_color = NULL, ribbon_alpha = 0.3,
                            boxplots_color = "#47476b",
                            boxplots_fill = "grey",
                            boxplots_alpha = 0.8,
                            outliers = TRUE) {

  if (!inherits(x, "projections")) {
    msg <- sprintf(
      "`x` must be a 'projections' object but is a `%s`",
      paste(class(x), collapse = ", "))
    stop(msg)
  }

  ## Strategy: we start off the provided plot, which may well be empty
  ## (i.e. output of ggplot2::ggplot()), and add layers depending on what the
  ## user wants. Currently available layers include:

  ## - quantiles
  ## - boxplots
  ## - ribbon

  out <- p
  dates <- get_dates(x)

  if (!is.null(quantiles) && !isFALSE(quantiles) && !all(is.na(quantiles))) {
    quantiles <- sort(unique(c(quantiles, 1 - quantiles)))
    quantiles <- quantiles[quantiles >= 0 & quantiles <= 1]
  }


  ## This is the part handling the ribbon

  if (isTRUE(ribbon)) {
    ## find the ymin and ymax for ribbon
    if (is.null(ribbon_quantiles)) {
      if (is.null(quantiles) || isFALSE(quantiles) || all(is.na(quantiles))) {
        ribbon_quantiles <- c(0, 1)
      } else {
        ribbon_quantiles <- range(quantiles)
      }
    }
    stats <- t(apply(x, 1, stats::quantile, ribbon_quantiles))
    df <- cbind.data.frame(dates, stats)
    names(df) <- c("dates", "ymin", "ymax")

    ## find colors; use the quantile's by default
    if (is.null(ribbon_color)) {
      ribbon_color <- color_quantiles(ribbon_quantiles, palette)[1]
    }
    ribbon_color <- transp(ribbon_color, ribbon_alpha)

    out <- out +
      ggplot2::geom_ribbon(
        data = df,
        ggplot2::aes(x = .data[["dates"]],
                     ymin = .data[["ymin"]],
                     ymax = .data[["ymax"]]),
        fill = ribbon_color)
  }


  ## This is the part handling the boxplots

  if (isTRUE(boxplots)) {
    df <- as.data.frame(x, long = TRUE)
    out <- suppressMessages(
      out +
        ggplot2::geom_boxplot(
          data = df,
          ggplot2::aes(x = .data[["date"]],
                       y = .data[["incidence"]],
                       group = .data[["date"]]),
          color = transp(boxplots_color, boxplots_alpha),
          fill = transp(boxplots_fill, boxplots_alpha),
          outlier.size = 0.5,
          outlier.color = ifelse(outliers, boxplots_color, "transparent")
        )
      )
  }


  ## This is the part handling the quantile lines

  if (isFALSE(quantiles)) {
    quantiles <- NULL
  }
  if (!is.null(quantiles)) {
    stats <- t(apply(x, 1, stats::quantile, quantiles))
    quantiles <- rep(colnames(stats), each = nrow(stats))
    quantiles <- factor(quantiles, levels = unique(quantiles))
    df <- cbind.data.frame(dates = rep(dates, ncol(stats)),
                           quantile = quantiles,
                           value = as.vector(stats),
                           stringsAsFactors = FALSE)

    colors <- color_quantiles(df$quantile, palette)
    colors <- transp(colors, quantiles_alpha)

    out <- suppressMessages(
      out +
        ggplot2::geom_line(
          data = df,
          ggplot2::aes(x = .data[["dates"]],
                       y = .data[["value"]],
                       color = .data[["quantile"]]),
          linetype = linetype,
          linewidth = linesize
        ) +
        ggplot2::scale_color_manual(values = colors)
    )
  }

  ## We need to update the x scale, depending on the type of the dates
  if (inherits(dates, c("Date", "POSIXct"))) {
    out <- out + ggplot2::scale_x_date()
  } else {
    out <- out + ggplot2::scale_x_continuous()
  }
  
  out
}

