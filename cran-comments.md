## R CMD check results

0 errors | 0 warnings | 1 note

* This is a new release.

* Possibly misspelled words in DESCRIPTION: "Geocoding"/"geocoding".
  This is a false positive: "geocoding" is the correct English technical
  term for the service this package wraps.

## Test environments

* Local: Windows 11, R 4.4.2
* win-builder: R Under development (unstable) (R-devel)

## Notes

* This package is a wrapper for the Argentine government's 'georef' API.
  Tests and examples that require network access to the API are skipped on
  CRAN via skip_on_cran() to avoid failures due to rate limiting or the
  service being unavailable.
