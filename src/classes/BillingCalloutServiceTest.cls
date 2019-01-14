@isTest
private class BillingCalloutServiceTest {
    @testSetup static void setupProject(){
        Opportunity oppo = new Opportunity();
        oppo.Name = 'TestOpp';
        oppo.CloseDate = Date.today();
        oppo.StageName = 'Prospecting';
        insert oppo;
        
        
        Project__c proj = new Project__c();
        proj.Name = 'TestProj';
        proj.Billable_Amount__c = 1000.00;       
        proj.ProjectRef__c = 'TestRef';
        proj.Status__c = 'Running';
        proj.Opportunity__c = oppo.Id;
        insert proj;
        
        ServiceCredentials__c servCred = new ServiceCredentials__c();
        servCred.Name = 'BillingServiceCredential';
        servCred.Username__c = 'user1';
        servCred.Password__c = 'pass1';
        insert servCred;
        
    }
    @isTest static void testCalloutSuccess(){
        Project__c pro = [Select Billable_Amount__c,ProjectRef__c,Status__C from Project__c where ProjectRef__c = 'TestRef' limit 1 ];
        Test.setMock(WebServiceMock.class, new BillingCalloutServiceMock());
        Test.startTest();
        BillingCalloutService.CallBilling(pro.Billable_Amount__c,pro.ProjectRef__c);
        Test.stopTest();
        System.assertEquals('Running', pro.Status__C);
        
    }
    
    @isTest static void testCalloutFailure(){
        Project__c pro = [Select Billable_Amount__c,ProjectRef__c,Status__C from Project__c where ProjectRef__c = 'TestRef' limit 1 ];
        Test.setMock(WebServiceMock.class, new BillingCalloutServiceMockFailure());
        Test.startTest();
        BillingCalloutService.CallBilling(pro.Billable_Amount__c,pro.ProjectRef__c);
        Test.stopTest();
        System.assertNotEquals('Billed', pro.Status__C);
    }
    
}