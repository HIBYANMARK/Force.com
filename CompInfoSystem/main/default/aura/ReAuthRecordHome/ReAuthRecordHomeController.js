({
    checkAuthApprove: function(component, event, helper) {
        console.log('ReAuthController > checkAuth');
        component.set("v.esigType", "Approve");
        helper.checkAuth(component);
    },
    
    checkAuthDecline: function(component, event, helper) {
        console.log('ReAuthController > checkAuth');
        component.set("v.esigType", "Decline");
        helper.checkAuth(component);
    }
    
})