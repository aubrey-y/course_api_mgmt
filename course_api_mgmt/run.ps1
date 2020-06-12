using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

# Write to the Azure Functions log stream.
Write-Host "PowerShell HTTP trigger function processed a request."

$userEmail = $Request.body.UserEmail
$userFirstName = $Request.body.FirstName
$userLastName = $Request.body.LastName
$userPassword = ConvertTo-SecureString -String $Request.body.Password -AsPlainText -Force
$userNote = $Request.body.Note

# Interact with query parameters or the body of the request.
if (-not $userEmail -or -not $userFirstName -or -not $userLastName -or -not $userPassword) {
    $status = [HttpStatusCode]::BadRequest
    $body="Invalid request body."
}
else {
    $status = [HttpStatusCode]::Ok

    $subscriptionId = $env:AZURE_SUBSCRIPTION_ID

    # Api Management service specific details
    $apimServiceName = $env:AZURE_API_MGMT_NAME
    $resourceGroupName = $env:AZURE_API_MGMT_RSRC_GRP

    # User specific details
    $userState = "Active"

    # Subscription Name details
    $subscriptionName = $userEmail
    $subscriptionState = "Active"

    $User = $env:AZURE_SVC_APPLICATION_ID
    $PWord = ConvertTo-SecureString -String $env:AZURE_SVC_CLIENT_SECRET -AsPlainText -Force
    $tenant = $env:AZURE_TENANT_ID
    $Credential = New-Object -TypeName "System.Management.Automation.PSCredential" -ArgumentList $User,$PWord
    Connect-AzAccount -Credential $Credential -Tenant $tenant -ServicePrincipal

    Select-AzSubscription -SubscriptionId $subscriptionId

    # Get the api management context
    $context = New-AzApiManagementContext -ResourceGroupName $resourceGroupName -ServiceName $apimServiceName

    # create a new user in api management
    $user = New-AzApiManagementUser -Context $context -FirstName $userFirstName -LastName $userLastName `
        -Password $userPassword -State $userState -Note $userNote -Email $userEmail

    # get the details of the 'Starter' product in api management, which is created by default
    # $product = Get-AzApiManagementProduct -Context $context -Title 'Starter' | Select-Object -First 1

    $product = Get-AzApiManagementProduct -Context $context -Title 'Starter'
    
    $product = $product | Select-Object -First 1

    # generate a subscription key for the user to call apis which are part of the 'Starter' product
    $body = New-AzApiManagementSubscription -Context $context -UserId $user.UserId `
        -ProductId $product.ProductId -Name $subscriptionName -State $subscriptionState
}

# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    StatusCode = $status
    Body = $body
})
