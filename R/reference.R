#' Saddle Fit Reference Thresholds
#'
#' Returns published threshold values for equine saddle pressure
#' assessment based on peer-reviewed studies.
#'
#' @param source Character. Reference source: `"vonpeinen2010"` (default),
#'   `"monkemoller2005"`, or `"werner2002"`.
#'
#' @return A [tibble::tibble] with columns `region`, `parameter`,
#'   `threshold`, `unit`, `interpretation`, `source`.
#' @export
#' @examples
#' pr_ref_saddle()
pr_ref_saddle <- function(source = c("vonpeinen2010",
                                      "monkemoller2005",
                                      "werner2002")) {
  source <- match.arg(source)

  if (source == "vonpeinen2010") {
    return(tibble::tibble(
      region = rep(c("cranial", "middle", "caudal"), 2),
      parameter = rep(c("mpp", "mvp"), each = 3),
      threshold = c(34.5, 30.3, 31.0, 13.2, 11.4, 10.0),
      unit = "kPa",
      interpretation = rep(
        c("Threshold above which back pain has been associated in walk/trot."),
        6
      ),
      source = "von Peinen et al. (2010) Equine Vet J Suppl."
    ))
  }
  if (source == "monkemoller2005") {
    return(tibble::tibble(
      region = c("cranial", "middle", "caudal"),
      parameter = "mvp",
      threshold = c(11.0, 9.0, 10.0),
      unit = "kPa",
      interpretation =
        "Reference MVP values in dressage horses at working trot.",
      source = "Moenkemoeller et al. (2005) Pferdeheilkunde."
    ))
  }
  tibble::tibble(
    region = c("cranial", "middle", "caudal"),
    parameter = "mpp",
    threshold = c(35, 30, 30),
    unit = "kPa",
    interpretation =
      "Indicative MPP ranges from the original saddle-pressure methodology study.",
    source = "Werner et al. (2002) J Vet Med A."
  )
}

#' Diabetic Foot Pressure Thresholds
#'
#' Clinical thresholds for plantar-pressure risk assessment in patients
#' with diabetic neuropathy.
#'
#' @return A [tibble::tibble] with threshold values and sources.
#' @export
#' @examples
#' pr_ref_diabetic_foot()
pr_ref_diabetic_foot <- function() {
  tibble::tibble(
    region = c("any plantar", "any plantar", "forefoot", "heel"),
    parameter = c("mpp", "pti_mean", "mpp", "mpp"),
    threshold = c(200, 70, 400, 250),
    unit = c("kPa", "kPa*s", "kPa", "kPa"),
    interpretation = c(
      "Elevated ulceration risk (Armstrong et al. 1998).",
      "Pressure-time integral associated with ulcer risk.",
      "High-risk forefoot peak pressure (Veves et al. 1992).",
      "Heel threshold reported in mixed-etiology neuropathy."
    ),
    source = c(
      "Armstrong DG et al. (1998) J Am Podiatr Med Assoc.",
      "Caselli A et al. (2002) Diabetes Care.",
      "Veves A et al. (1992) Diabetologia.",
      "Frykberg RG et al. (1998) Diabetes Care."
    )
  )
}

#' Wheelchair Seating Pressure Thresholds
#'
#' @return A [tibble::tibble] with threshold values and sources.
#' @export
#' @examples
#' pr_ref_wheelchair()
pr_ref_wheelchair <- function() {
  tibble::tibble(
    region = c("ischial", "ischial", "any"),
    parameter = c("mpp", "mean_pressure", "mpp"),
    threshold = c(60, 32, 200),
    unit = c("mmHg", "mmHg", "mmHg"),
    interpretation = c(
      "Elevated ischial peak pressure (cushion evaluation benchmark).",
      "Capillary closing pressure (Landis 1930).",
      "Very high focal pressure associated with tissue injury risk."
    ),
    source = c(
      "Sprigle & Sonenblum (2011) J Rehabil Res Dev.",
      "Landis EM (1930) Heart.",
      "Stinson MD et al. (2003) J Rehabil Res Dev."
    )
  )
}
