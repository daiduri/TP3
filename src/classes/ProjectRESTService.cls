@RestResource(urlMapping='/project/*')
global class ProjectRESTService {
    //Implement service logic here
    @HttpPost
    global static string postProjectData(String ProjectRef, String ProjectName,
                                         String OpportunityId, date StartDate,date EndDate,
                                         double Amount,string Status)
    {
        List<Project__c> projects = [SELECT Billable_Amount__c,End_Date__c,Id,Name,Opportunity__c,ProjectRef__c,Start_Date__c,Status__c 
                                     FROM Project__c WHERE ProjectRef__c = :ProjectRef];       
        project__C project = new project__C();
        if (projects.size() >0){
            project = projects[0];
        } 
        Savepoint sp = Database.setSavepoint();
        try{
            project.Billable_Amount__c = Amount;
            project.End_Date__c = EndDate;
            project.Name = ProjectName;
            if (!(projects.size() >0))project.Opportunity__c = OpportunityId;
            project.ProjectRef__c = ProjectRef;
            project.Start_Date__c = StartDate;
            project.Status__c = Status;
            upsert project;
            
            Opportunity opp = [SELECT Id, DeliveryInstallationStatus__c FROM Opportunity WHERE Id = :OpportunityId];
            opp.DeliveryInstallationStatus__c = 'In progress';
            update opp;
            return 'OK'; 
        }
        catch(exception ex){
            Database.rollback(sp);
            system.debug('Error : '+ ex.getMessage());
            return ex.getMessage();
        }	
        
        
        
    }
}