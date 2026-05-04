## R CMD check results

0 errors | 0 warnings | 1 note

The remaining note is environmental:

* checking for future file timestamps ... NOTE
    unable to verify current time

This occurs because the build environment cannot reach
`worldtimeapi.org`; all file timestamps are in the past on the build
machine's clock. This is not an issue with the package itself.

## Test environments

* Local: Windows 11, R 4.5.2
* GitHub Actions: ubuntu-latest (release, devel, oldrel-1),
  macos-latest (release), windows-latest (release)

## This is a new submission.

`pressR` provides tools for parsing, analyzing, and visualizing
pressure distribution data from capacitive sensor systems. It ships
with predefined layouts for several clinical and research
applications, plus a Shiny application for interactive exploration.
