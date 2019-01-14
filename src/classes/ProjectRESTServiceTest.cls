@isTest
private class ProjectRESTServiceTest {
    //Implement Apex REST service tests here
    @isTest static void testPost() {
        Id recordId = createTestRecord();
        // Set up a test request
        RestRequest request = new RestRequest();
        string strResponse = ProjectRESTService.postProjectData ( 'ProjectRef',  'ProjectName',
                                         recordId, System.Today(),System.Today(),
                                         100,'Running');

        // Verify results
        System.assertEquals('OK', strResponse);
        //System.assertEquals('Test record', thisCase.Subject);        
    }
    
        @isTest static void testPostFail() {
        Id recordId = createTestRecord();
        // Set up a test request
        RestRequest request = new RestRequest();
        string strResponse = ProjectRESTService.postProjectData ( Null,  Null,
                                         Null, Null,System.Today(),
                                         100,'Running');

        // Verify results
        //System.assertEquals('OK', strResponse);
        system.assertNotEquals('OK', strResponse);
        //System.assertEquals('Test record', thisCase.Subject);        
    }

    static Id createTestRecord() {
        // Create test record
        Opportunity caseTest = new opportunity(
            Name='Test Oppty',
            CloseDate = Date.today(),
            stagename='Prospecting'
        );
        insert caseTest;
        system.debug('caseTest:' + caseTest.Id);
        project__C project = new project__C();
        project.Name = 'ProjectName';
        project.Opportunity__c = caseTest.Id;
        project.ProjectRef__c = 'ProjectRef';
        insert project;
        return caseTest.Id;
    }
}