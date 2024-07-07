##############################################################
# File: bulk-jira-sprint-creation.ps1
# Purpose: in Jira cloud create multiple sprints in one or many different projects
#
# Copyright (C) 2024 Andrew Newbury, andrew@exponentiallydigital.com
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <https://www.gnu.org/licenses/>.
#
###############################################################
#
# Version: 1.0.1, 2024-07-07 - public release for Jira Cloud (basic auth), added JSON raw debug display
# Version: 1.0.0a, 2024-07-05 - debugging disabled, only API returned strings
# Version: 1.0.0, 2024-07-05 - limited release, DC oauth, full debuging enabled
#
###############################################################
#
# Initial set up:
#
#   1. create an API token via https://id.atlassian.com/manage-profile/security/api-tokens
#       for detailed iinstructions see https://support.atlassian.com/atlassian-account/docs/manage-api-tokens-for-your-atlassian-account/
#   3. use the included script "create-token-prompted.ps1" to concatenate your atlassian email address with the token and base64 encode the result
#
# In the section "Make edits here" set the following:
#
#   1. set $DebugMode to "$true" to see copious debug output or "$false" to disable
#   2. set $accessToken to your encoded API token created in "initial set up" above
#   3. set $originBoardIds to your Jira project board IDs, you can find these in the URL for your board
#       or by navigating to https://my-org-name.atlassian.net/rest/agile/1.0/board to see all boards
#       eg "7" is the scrum board ID for the EXPD project-> https://my-org-name.atlassian.net/jira/software/c/projects/EXPD/boards/7
#       if you only have one project just put in one entry, you can have multiple entries here!
#   4. set $sprintNames to the prefix for your project names, ditto as above if only one project, you can have multiple entries here!
#   5. set $sprintIDPrefix to the Program Increment prefix which will be part of your sprint names
#   6. set $startDates to the start dates for your sprints, be careful not to change the date format, you can have multiple entries here!
#   7. set $endDates to match the end dates for your sprints, be careful not to change the date format, you can have multiple entries here!
#   8. set $jiraBaseUrl to your Jira instance, for Jira cloud this is typically https://my-org-name.atlassian.net"
#
# So what do the sprint names look like? "EXPD_PI01S1_06Jul-13Jul" then "EXPD_PI01S2_14Jul-20Jul" etc etc.
#
# I like having the project ID at the start, then an underscore to make the PI and sprint number stand out, then an underscore and the
# actual sprint dates as part of the name. Isn't that overkill? Not when you have several projects, doing this makes it very difficult
# to pick the wrong sprint in dialogue boxes.
#
# NB keep this powershell script somewhere *very* *safe* and *secure* as it contains an access token which can be used to do things in Jira under your user ID!
#
##############################################################
#
# Make edits here:
#
# Display debugging output as this script executes
$DebugMode = $true # Set to $true to enable, $false to disable
#
# Set API access token
$accessToken = "a-very-long-base64-encoded-string-of-letters-and-numbers"
#
# Parameters for Sprint creation
$originBoardIds = @("7", "3", "4")
$sprintNames = @("EXPD", "EXPD1", "EXPD2")
$sprintIDPrefix = "PI01S"
#
# Sprint dates and times
$startDates = @("2024-07-06T08:30", "2024-07-14T08:30")
$endDates = @("2024-07-13T17:30", "2024-07-20T17:30")
#
# Jira URL for your organisation
$jiraBaseUrl = "https://my-org-name.atlassian.net"
#
##############################################################
#
# don't change anything below here...

# Jira API endpoint
$apiEndpoint = "/rest/agile/latest/sprint/"

# Function to convert numeric month to three-character representation
function Convert-Month {
    param ([string]$numericMonth)
    switch ($numericMonth) {
        "01" { return "Jan" }
        "02" { return "Feb" }
        "03" { return "Mar" }
        "04" { return "Apr" }
        "05" { return "May" }
        "06" { return "Jun" }
        "07" { return "Jul" }
        "08" { return "Aug" }
        "09" { return "Sep" }
        "10" { return "Oct" }
        "11" { return "Nov" }
        "12" { return "Dec" }
    }
}

# Function to conditionally write debug messages
function Write-DebugMessage {
    param (
        [string]$message
    )
    if ($DebugMode) {
        Write-Host $message
    }
}

# Loop through each originBoardId
for ($i = 0; $i -lt $originBoardIds.Length; $i++) {
    $originBoardId = $originBoardIds[$i]
    $sprintName = $sprintNames[$i % $sprintNames.Length]  # Ensure the sprint name index is within bounds
    Write-DebugMessage "Sprint Name: $sprintName"

    # Loop through each set of parameters and create the sprint
    for ($j = 0; $j -lt $startDates.Length; $j++) {
        Write-DebugMessage "Origin Board ID: $originBoardId"
        $currentStartDate = $startDates[$j]
        Write-DebugMessage "Start Date: $currentStartDate"
        $currentEndDate = $endDates[$j]
        Write-DebugMessage "End Date: $currentEndDate"

        # Parse day and month from startDate and endDate
        $startDay = $currentStartDate.Substring(8, 2)
        Write-DebugMessage "Start Day: $startDay"
        $startMonth = Convert-Month $currentStartDate.Substring(5, 2)
        Write-DebugMessage "Start Month: $startMonth"
        $endDay = $currentEndDate.Substring(8, 2)
        Write-DebugMessage "End Day: $endDay"
        $endMonth = Convert-Month $currentEndDate.Substring(5, 2)
        Write-DebugMessage "End Month: $endMonth"

        # Construct sprint ID dynamically
        $sprintID = $j + 1
        Write-DebugMessage "Sprint ID: $sprintID"
        $sprintIDPart = "$sprintIDPrefix$sprintID"
        Write-DebugMessage "Sprint ID Part: $sprintIDPart"

        # Construct sprint name
        $sprintFullName = "${sprintName}_${sprintIDPart}_${startDay}${startMonth}-${endDay}${endMonth}"
        Write-DebugMessage "Sprint Full Name: $sprintFullName"
        
        # Construct the JSON data with proper escaping
        $jsonData = @{
            originBoardId = $originBoardId
            name = $sprintFullName
            startDate = $currentStartDate
            endDate = $currentEndDate
        } | ConvertTo-Json -Compress
        Write-DebugMessage "Raw JSON data: $jsonData"
        $jsonDataEscaped = $jsonData -replace '"', '\"'
        Write-DebugMessage "Escaped JSON data: $jsonDataEscaped"

        # Construct the curl command with proper single quotes
        if ($DebugMode) {
            $curlCommand = "curl.exe -v --request POST --url '$jiraBaseUrl$apiEndpoint' --header 'Authorization: Basic $accessToken' --header 'Accept: application/json' --header 'Content-Type: application/json' --data '$jsonDataEscaped'"            
        } else {
            $curlCommand = "curl.exe -s --request POST --url '$jiraBaseUrl$apiEndpoint' --header 'Authorization: Basic $accessToken' --header 'Accept: application/json' --header 'Content-Type: application/json' --data '$jsonDataEscaped'"
        }       

        # Display the command for debugging purposes
        Write-DebugMessage "Executing: $curlCommand"

        # Execute the curl command and capture the output
        $curlOutput = Invoke-Expression -Command $curlCommand
        Write-Host $curlOutput
    }
}

