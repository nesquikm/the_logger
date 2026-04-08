## 0.0.23

* Update CI actions (actions/checkout v4→v6, upload-pages-artifact v3→v4)
* Upgrade transitive dependencies

## 0.0.22

* Migrate from sqflite to drift for cross-platform SQLite support (iOS, Android, macOS, Windows, Linux, Web)
* Add web support via drift's WasmDatabase
* Log export (writeAllLogsToJson) is not supported on web — throws UnsupportedError
* No public API changes — drift is an internal implementation detail
* Add web assets (sqlite3.wasm, drift_worker.js) to example app

## 0.0.21

* Fix archive directory creation for file export

## 0.0.20

* Add real-time log streaming via broadcast stream
* Add proper logger disposal (fixes flaky tests from database locking)

## 0.0.19

* Update SDK constraints and dependencies
* Fix analyzer issues for very_good_analysis 10.2.0

## 0.0.18

* Update dependencies
* Update very_good_analysis
* Fix analyzer issues
* Add ability to share log file in example app
* Add ability to open log viewer in example app

## 0.0.17

* Add code coverage generation to the CI/CD pipeline
* Add code coverage badge to README.md

## 0.0.16

* Add JSON pretty print for console logging

## 0.0.15

* Add custom color scheme for console logging

## 0.0.14

* Use gzip instead of archive:bz2

## 0.0.13

* Add documentation about how to view logs

## 0.0.12

* Change console printer formatting
* Change console printer colors

## 0.0.11

* Add ability to mask sensitive data
* Add additional colors for console output

## 0.0.10

* Tiny example app fix

## 0.0.9

* Anoher attempt to fix image path in README.md

## 0.0.8

* Change image for README.md

## 0.0.7

* Add image for README.md

## 0.0.6

* Add additional docs

## 0.0.5

* Fix some documentation issues

## 0.0.4

* Example app version fix

## 0.0.3

* Documentation formatting

## 0.0.2

* Lowered the minimum sdk version to 3.2.5 (pub.dev requirement at this moment)

## 0.0.1

* Initial version
