#!/bin/bash
set -e
set -o pipefail

export LC_NUMERIC="en_US.UTF-8"

# Generate code coverage report
# Yeah, there is no function support yet: https://github.com/flutter/flutter/issues/108313
rm -rf coverage
flutter test --coverage
lcov --ignore-errors unused --remove coverage/lcov.info '*_generated.*' '*.freezed.dart' '*.g.dart' '*.gen.dart' '*.reflectable.dart' '*.module.dart' 'lib/l10n/*' -o coverage/filtered_lcov.info
genhtml coverage/filtered_lcov.info -o coverage/html

# Generage coverage badge
summary_output=$(lcov --summary coverage/filtered_lcov.info)

# Extract lines percentage using grep, awk, and sed
lines_percent=$(echo "$summary_output" | grep -o 'lines[^)]*' | awk -F ':' '{print $NF}' | sed 's/[^0-9.]//g')

rounded_percentage=$(printf "%.1f" $lines_percent)

if (( $(echo "$rounded_percentage >= 90" | bc -l) )); then
    color="#4CAF50"  # Green color for coverage >= 90%
elif (( $(echo "$rounded_percentage >= 80" | bc -l) )); then
    color="#FFC107"  # Orange color for coverage >= 80%
else
    color="#F44336"  # Red color for coverage < 80%
fi

echo $color

sed -e "s/?color?/$color/g" -e "s/?percent?/$rounded_percentage/g" images/coverage_badge_template.svg > coverage/coverage_badge.svg
