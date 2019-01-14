public class ProjectCalloutService {
    //Complete the implementation for business and callout logic
    @InvocableMethod
    public static void postOpportunityToPMS(list<Id> oppId){
        Opportunity Op = [select id, Name, account.name,closedate, amount from opportunity where Id = :oppId[0] limit 1];
        string OJ = '{';
        OJ = OJ + '"opportunityId": "'+ (Op.Id);
        OJ = OJ + '", "opportunityName": "'+ (Op.Name);
        OJ = OJ + '", "accountName": "'+(Op.Account.Name);
        OJ = OJ + '", "closeDate":"'+(DateTime.newInstance(Op.closedate.year(),Op.closedate.month(),Op.closedate.day()).format('yyyy-MM-dd'));
        OJ = OJ + '", "amount":'+(Op.amount);
        OJ = OJ + '}';
        system.debug(OJ);  
        
        QueueablePMSCall updateJob = new QueueablePMSCall(OJ,Op.Id);
        // enqueue the job for processing
        ID jobID = System.enqueueJob(updateJob);
        system.debug('Enqued Job :' + jobID);
        
    }
    
    @future(callout=true)
    public static void RestCall (string sBody, Id oppId){
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        
        String serviceToken = ServiceTokens__c.getValues('ProjectServiceToken').Token__c;
        
        req.setMethod('POST');
        req.setEndpoint('callout:ProjectService');
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('token',serviceToken);
        req.setBody(sBody);
        
        
        HTTPResponse res = http.send(req);
        
        opportunity op  = new opportunity(Id = oppId);
        if (res.getstatuscode()==201){
            op.StageName = 'Submitted Project';
            system.debug('Success:'+ res.getstatuscode() );
        }else{
            op.StageName = 'Resubmit Project';
            system.debug('Failure :'+ res.getstatuscode() + '. Status :' + res.getstatus());
        }
        update op;
        
    }
    
    public class QueueablePMSCall implements Queueable, Database.AllowsCallouts {
        private string sBody;
        private Id oppId;
        public  QueueablePMSCall (string OJ,Id OpId){
            this.sBody = OJ;
            this.oppId = OpId;
        }
        
        public void execute(QueueableContext context) {
            RestCall(sBody,oppId);
        }
    }
    
}