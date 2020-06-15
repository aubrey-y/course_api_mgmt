
.                     |.
:--------------------:|:--------------------:
![GTCC](docs/gt.png)  |![GCP](docs/azure.png)


# course_api_mgmt

Azure Cloud Function to create API Management Users for [gatech-api](https://github.com/aubrey-y/gatech-api).

[![Build Status](https://travis-ci.org/aubrey-y/course_api_mgmt.svg?branch=master)](https://travis-ci.org/aubrey-y/course_api_mgmt)
![GitHub top language](https://img.shields.io/github/languages/top/aubrey-y/course_api_mgmt)

## Setup

For local development, you will need to:

1. Install the latest version of [VSCode](https://code.visualstudio.com/docs/setup/setup-overview).

2. Install [Powershell 7.0.2](https://github.com/PowerShell/PowerShell).

3. Acquire and set all environment variables required to run locally in `local.settings.json`. (This will involve
provisioning an API Management Instance and creating an Azure Service Principal)

4. Navigate to the file `run.ps1` and run through VSCode.

5. Send POST requests to [localhost:7071/api/course_api_mgmt](http://localhost:7071/api/course_api_mgmt) with the
following payload structure

```json
{
	"userEmail": "exampleemail@gmail.com",
	"firstName": "Test",
	"lastName": "User",
	"password": "123",
	"note": ""
}
```
