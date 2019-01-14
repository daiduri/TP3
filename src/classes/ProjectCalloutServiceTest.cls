@isTest
private class ProjectCalloutServiceTest {
    @testSetup 
    static void setup() {
        Opportunity opp = new opportunity();
        Opp.Name = 'Test 1';
        Opp.StageName = 'Submitted Project'; //Submitted Project
        Opp.CloseDate = Date.today();
        Opp.Amount = 500;
        insert opp;
        
        Opportunity opp2 = new opportunity();
        Opp2.Name = 'Test 2';
        Opp2.StageName = 'Resubmit Project';
        Opp2.CloseDate = Date.today();
        Opp2.Amount = 500;
        insert opp2;
        
      	//create the Custom Settings
        ServiceTokens__c servToken = new ServiceTokens__c();
        servToken.Name = 'ProjectServiceToken';
        servToken.Token__c = 'LSkdjflosijdsidofosdfjosokljs';
        insert servToken;        
        
    }
    
    @isTest static void testPostCallout() {
        Opportunity op = [Select Id, Name FROM Opportunity WHERE Name = 'Test 1' Limit 1];
        List<Id> oppList = new List<Id>();
        oppList.add(op.id);
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new ProjectCalloutServiceMock()); 
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
        ProjectCalloutService.postOpportunityToPMS(oppList); // AnimalsCallouts.makePostCallout();
        
        Opportunity opp = [Select Stagename FROM Opportunity WHERE Name = 'Test 1' Limit 1];
        System.assertEquals('Submitted Project', opp.StageName);
        //System.assertEquals(200, response.getStatusCode());
    }
    
    @isTest static void testPostCalloutFail() {
        Opportunity op = [Select Id FROM Opportunity WHERE Name = 'Test 2' Limit 1];
        List<Id> oppList = new List<Id>();
        oppList.add(op.id);
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new ProjectCalloutServiceMockFailure()); 
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
        Test.startTest();
        ProjectCalloutService.postOpportunityToPMS(oppList); // AnimalsCallouts.makePostCallout();
        Test.stopTest();
        
        Opportunity opp = [Select Stagename FROM Opportunity WHERE Name = 'Test 2' Limit 1];
        system.debug('Fail Test debug:' +opp.StageName);
        System.assertEquals('Resubmit Project', opp.StageName);
        //System.assertEquals(200, response.getStatusCode());
    }
}