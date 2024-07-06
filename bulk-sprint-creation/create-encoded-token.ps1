##############################################################
# File: create-encoded-token.ps1
# Purpose: create a base64 encoded token
#
# Copyright (C) 2024 Andrew Newbury
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
###############################################################Clear-Host
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
