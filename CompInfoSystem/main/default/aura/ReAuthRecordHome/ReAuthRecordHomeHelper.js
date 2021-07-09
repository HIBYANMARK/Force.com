({
    checkAuth: function(component) {
        var recordId = component.get("v.recordId");
        var password = component.get("v.password");
        var fieldName = component.get("v.fieldName");
        var esigType = component.get("v.esigType");
        var comments = component.get("v.comments");
        
        // Create the action
        var doAction = true;
        var action = component.get("c.checkCredentials"); // method on the ReAuthController
        if (recordId != null) {
            action.setParams({
                "recordId": recordId,
                "password": password,
                "fieldName": fieldName,
                "esigType": esigType,
                "comments": comments
            });
        } else {
            action.setParams({
                "password": password
            });
        }
        
        if (doAction) {
            // Add callback behavior for when response is received
            action.setCallback(this, function(response) {
                var state = response.getState();
                console.log('ReAuthHelper > checkAuth - response state: ' + state)
                
                if (state === "SUCCESS") {
                    var reAuthResponse = response.getReturnValue();
                    console.log('ReAuthHelper > checkAuth - reAuthResponse: ' 
                                + JSON.stringify(reAuthResponse));
                    
                    if (reAuthResponse.authPassed) {
                        component.set("v.authPassed", true);
                        component.set("v.errorMessage", '');
                    } else {
                        component.set("v.authPassed", false);
                        component.set("v.errorMessage", reAuthResponse.errorMessage);
                    }
                } else {
                    console.log("ReAuthHelper > checkAuth - failed with state: " 
                                + state);
                    console.log(response.getError());
                    component.set("v.authPassed", false);
                    component.set("v.authError", "Error calling auth service: " 
                                  + state);
                }
            });
            
            $A.enqueueAction(action);
        } // end doAction
    } // end checkAuth
})