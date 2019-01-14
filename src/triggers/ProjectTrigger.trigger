trigger ProjectTrigger on Project__c (after update) {
    //Project status is set to Billable. Call WS
    
    BillingCalloutService.callBillingService(Trigger.new, Trigger.newMap, Trigger.old, Trigger.oldMap);
    
}