## bulk Jira Cloud sprint creation

A Windows PowerShell script that enables creating multiple Jira Cloud sprints in one or many different projects!

Why would you want to do this? It's time consuming and error prone manually creating sprints as a Release Train Engineer, Agile Delivery Coach, or Scrum Master. Using this script you can create a virtually unlimited number of configurable sprints with a consistent naming standard in minutes.

Full set up instructions are included in the script file. An accompanying PowerShell script is included "create-encoded-token.ps1" to enable creation of the API security token needed to authorise sprint creation.

This script allows you to do the following:
- create a single sprint
- create multiple sprints
- create single or multiple sprints in multiple Jira projects
- create these sprints with a standardised naming format
- create these sprints with a standardised date format
- create these sprints with standardised start and end times
- return the SprintID for all sprints created, useful in JQL queries

Enjoy!
