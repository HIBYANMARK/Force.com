global with sharing class ReAuthController
{
    @AuraEnabled
    public static ReAuthResponse checkCredentials(String recordId, String password, String fieldName, String esigType, String comments)
    {
        ReAuthResponse reAuthResponse = new ReAuthResponse();
        String username = UserInfo.getUserName();

        // connected app
        String clientID = '3MVG9Nk1FpUrSQHe87hEdnp1QhWsAY31AxYACzCJtrq5FYqjVKJpWurIa3JZg_qeDj1tNjFP8P5n0J.UO57qx';
        String clientSecret = '130E9AFE5E46666F81DF4B7429367D6D7E1944C0DA78ECA0F51ABCF1E25F0F00';

        // user security token
        User currentUser = [SELECT securityToken__c
                            FROM User
                            WHERE Username = :username
                            LIMIT 1];
        String securityToken = currentUser.securityToken__c;

        if (securityToken != null)
        {
            Http http = new Http();
            HttpRequest request = new HttpRequest();

            // endpoint for Salesforce REST API to get access token
            String url = 'https://login.salesforce.com/services/oauth2/token?grant_type=password'
                    + '&client_id=' + clientID
                    + '&client_secret=' + clientSecret
                    + '&username=' + username
                    + '&password=' + password + securityToken;
            request.setEndpoint(url);
            request.setMethod('POST');

            // make the callout         
            String accessToken;
            try
            {
                HttpResponse response = http.send(request);
                String body = response.getBody();
 
                // get access token
                JSONParser parser = JSON.createParser(body);
                while (parser.nextToken() != null)
                {
                    if (parser.getCurrentToken() == JSONToken.FIELD_NAME)
                    {
                        String name = parser.getText();
                        parser.nextValue();
                        String value = parser.getText();
                        if (name == 'access_token') {
                            accessToken = value;
                        }
                        parser.nextToken();
                    }
                }

                if (accessToken != null)
                {
                    reAuthResponse.authPassed = true;
                    reAuthResponse.errorMessage = null;

                    if (recordId != null)
                    {
                        // create ESignature for the Case record
                        ESignature__c signature = new ESignature__c();
                        signature.put(fieldName, recordId);
                        signature.Signature_Type__c = esigType;
                        signature.Comments__c = comments;
                        insert signature;
                    }
                }
                else
                {
                    reAuthResponse.authPassed = false;
                    reAuthResponse.errorMessage = 'Incorrect Password or Security Token;' + body;
                }

            }
            catch (Exception e)
            {
                reAuthResponse.authPassed = false;
                reAuthResponse.errorMessage = e.getMessage();
            }
        }
        else
        {
            reAuthResponse.authPassed = false;
            reAuthResponse.errorMessage = 'No User Security Token';
        }

        return reAuthResponse;
    } // end checkCredentials

    public class ReAuthResponse
    {
        @AuraEnabled
        public Boolean authPassed;

        @AuraEnabled
        public String errorMessage;

    } // end ReAuthResponse
} // end ReAuthController