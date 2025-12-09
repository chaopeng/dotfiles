#!/bin/bash

# to run: bash test_helpers.sh

source ~/.config/dotfiles/browsers-mac/bin/browsers/helpers.sh

# Test cases
function test_combine_with_delimiter() {
    echo "Test 1: replace with +"
    result="$(combine_with_delimiter "+" "apple" "orange" "banana with  spaces" "grape")"
    assert_equal "$result" "apple+orange+banana+with+spaces+grape"

    echo "Test 2: replace with %20"
    result="$(combine_with_delimiter "%20" "apple" "orange" "banana with  spaces" "grape")"
    assert_equal "$result" "apple%20orange%20banana%20with%20spaces%20grape"

    echo "Test 3: replace with / keyword in sed"
    result="$(combine_with_delimiter "/" "apple" "orange" "banana with  spaces" "grape")"
    assert_equal "$result" "apple/orange/banana/with/spaces/grape"

    echo "Test 4: replace with * keyword in grep"
    result="$(combine_with_delimiter "*" "apple" "orange" "banana with  spaces" "grape")"
    assert_equal "$result" "apple*orange*banana*with*spaces*grape"

    echo "Test 5: url encode"
    result="$(combine_with_delimiter "+" "(1+2)*3")"
    assert_equal "$result" "%281%2B2%29*3"
}

# Helper function for assertion
function assert_equal() {
    if [ "$1" != "$2" ]; then
        echo " Failed: Expected '$2', but got '$1'"
        exit 1
    fi
    echo " Passed"
}

# Run the tests
test_combine_with_delimiter
