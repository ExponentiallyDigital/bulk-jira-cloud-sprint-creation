##############################################################
# File: create-encoded-token.ps1
# Purpose: create a base64 encoded token
#
###############################################################
# Prompt the user for their email address
$UserName = Read-Host "`nPlease enter your email address"

# Prompt the user for their API token
$APIToken = Read-Host "Please enter your API token    "

# Combine the username and API token in the format "username:api_token"
$Text = $UserName + ":" + $APIToken

# Display the concatenated string
#Write-Host "`nThe concatenated string is     : " $Text

# Encode the combined text to Base64
$Bytes = [System.Text.Encoding]::UTF8.GetBytes($Text)
$EncodedText = [Convert]::ToBase64String($Bytes)

# Output the encoded API token
Write-Host "`nYour encoded API token is      : " $EncodedText "`n"
