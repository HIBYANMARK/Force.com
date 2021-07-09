trigger TriggerFlow on Inventory__c (after update)
{
    for(Inventory__c inv : Trigger.New)
    {
        String flowName = 'Inventory_Change_Request_Updates';
        Map<String, Object> inputs = new Map<String, Object>();
        inputs.put('recordId', inv.Id);
        inputs.put('currentStatus', inv.Approval_Status__c);
        
        Flow.Interview flow = Flow.Interview.createInterview(flowName, inputs);
        flow.start();
    }
}