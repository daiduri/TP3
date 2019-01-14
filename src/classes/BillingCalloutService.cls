public class BillingCalloutService {
    //Trigger.new, Trigger.newMap, Trigger.old, Trigger.oldMap
    public static void callBillingService(list<project__C> newlist,map<id,project__C> newmap,
                                                 list<project__C> oldlist,map<id,project__C> oldmap){
                                                     for(project__C proj:newlist){
                                                         if (proj.Status__c == 'Billable' && oldmap.get(proj.id).status__c != 'Billable'){
                                                             CallBilling(proj.Billable_Amount__c,proj.ProjectRef__c); 
                                                         }
                                                         
                                                     }
                                                 }
   
    
    @future(callout=true)
    public static void CallBilling(decimal billAmount,string projectid) {
        
        BillingServiceProxy.project project = new BillingServiceProxy.project();
        
        project.username = ServiceCredentials__c.getValues('BillingServiceCredential').Username__c;
        project.password = ServiceCredentials__c.getValues('BillingServiceCredential').Password__c;
        project.billAmount = billAmount;
        project.projectid = projectid;
        
        BillingServiceProxy.InvoicesPortSoap11 callBillingSvc = new BillingServiceProxy.InvoicesPortSoap11();
        string strReturn = callBillingSvc.billProject(project);
        system.debug('strReturn:'+strReturn);
        
        List<Project__c> proj;
        if (strReturn != null && strReturn.equalsIgnoreCase('OK')){
            project__C projUpdate = [SELECT Status__c FROM Project__c WHERE ProjectRef__c =: projectid limit 1];
            projUpdate.Status__c = 'Billed';
            update projUpdate;
        }

        
    }
}