## R CMD check results

0 errors | 0 warnings | 1 note

The note on both win-builder platforms is the standard new-submission note:

    * checking CRAN incoming feasibility ... NOTE
    Maintainer: 'Julián Echandi <jechandi.gobar@gmail.com>'

    New submission

    Possibly misspelled words in DESCRIPTION:
      Geocoding (2:43)
      geocoding (12:24)

This is a new release, so the "New submission" note is expected. "Geocoding"
is spelled correctly — it is the standard English term for the operation this
package performs.

The macOS builder check returned Status: OK, with no errors, warnings or notes.

The two remaining notes on our local machine are artefacts of the local
setup and are not expected on the CRAN check machines:

* "unable to verify current time" (no access to the time-stamping service).
* "Files 'README.md' or 'NEWS.md' cannot be checked without 'pandoc' being
  installed."

## Test environments

* Local: Windows 11, R 4.4.2 — 0 errors | 0 warnings | 2 notes (local artefacts,
  see above)
* win-builder, R-devel (R Under development, 2026-08-24 r90445 ucrt,
  x86_64-w64-mingw32, Windows Server 2022) — 0 errors | 0 warnings | 1 note
* win-builder, R-release (R 4.6.1, x86_64-w64-mingw32, Windows Server 2022)
  — 0 errors | 0 warnings | 1 note
* macOS builder (R 4.6.1 Patched, aarch64-apple-darwin23, macOS 26.6) —
  Status: OK (0 errors | 0 warnings | 0 notes)

## Notes

* This package is a wrapper for the Argentine government's 'georef' API
  (<https://apis.datos.gob.ar/georef>). It has no functionality that can be
  exercised without network access to that service.

* Tests that contact the API are skipped on CRAN via `skip_on_cran()` and,
  when run elsewhere, via `skip_if_not(curl::has_internet())`, so the check
  does not fail because of rate limiting or service downtime.

* Examples are wrapped in `\donttest{}` (not `\dontrun{}`): they are valid,
  runnable code that only requires an internet connection. Following the CRAN
  policy on packages that use Internet resources, the calls are wrapped in
  `try()` so that an outage or a rate limit of the upstream service cannot
  turn the check into an error. We observed real HTTP 502 responses from the
  API while preparing this submission, so this is not a hypothetical concern.

* No example writes to the user's home directory or to the working directory;
  the one example that saves a file uses `tempfile()` and removes it afterwards.

* The user-facing documentation (help pages) is written in Spanish, which is
  the language of the API being wrapped and of its intended user base. The
  DESCRIPTION file is in English. Please let us know if English help pages
  are required.
