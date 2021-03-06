@isTest
public with sharing class opportunityActionTriggerTests {
    private static String StageNameProspecting = 'Prospecting';
    private static String UpdatePostfix = '_update';

    @isTest static void createOneOpportunityTest() {
        String opportunityName = 'createOneOpportunityTest';

        Opportunity newOpportunity = new Opportunity(
            Name = opportunityName, 
            CloseDate = System.today(), 
            StageName = StageNameProspecting);

        Test.startTest();
        Database.SaveResult result = Database.insert(newOpportunity, false);
        List<Web_Order__c> createdWebOrdersList = [SELECT Id, Name, CloseDate__c, StageName__c FROM Web_Order__c WHERE OpportunityId__c = :newOpportunity.Id];
        Test.stopTest();        

        System.assert(result.isSuccess());
        System.assertEquals(1, createdWebOrdersList.size());

        Web_Order__c createdWebOrder = createdWebOrdersList[0];
        System.assertEquals(newOpportunity.Name, createdWebOrder.Name);
        System.assertEquals(newOpportunity.CloseDate, createdWebOrder.CloseDate__c);
        System.assertEquals(newOpportunity.StageName, createdWebOrder.StageName__c);
    }

    @isTest static void createFewOpportunityTest() {
        String opportunityName = 'createFewOpportunityTest';

        List<Opportunity> newOpportunityList = new List<Opportunity>();
        for(Integer opportunityCount = 0; opportunityCount < 3; opportunityCount++) {
            newOpportunityList.Add(new Opportunity(
                Name = opportunityName + opportunityCount, 
                CloseDate = System.today(), 
                StageName = StageNameProspecting));
        }

        Test.startTest();
        List<Database.SaveResult> resultList = Database.insert(newOpportunityList, false);
        Set<Id> opportunityIdSet = new Map<Id, Opportunity>(newOpportunityList).keySet();
        List<Web_Order__c> createdWebOrdersList = [SELECT Id, Name, CloseDate__c, StageName__c, OpportunityId__c FROM Web_Order__c WHERE OpportunityId__c IN :opportunityIdSet];
        Test.stopTest();

        for(Database.SaveResult result: resultList) {
            System.assert(result.isSuccess());
        }
        System.assertEquals(3, createdWebOrdersList.size());

        for(Web_Order__c webOrder: createdWebOrdersList) {
            System.assert(newOpportunityList.contains(new Opportunity(
                Id = webOrder.OpportunityId__c, 
                Name = webOrder.Name,
                CloseDate = webOrder.CloseDate__c,
                StageName = webOrder.StageName__c)));
        }
    }

    @isTest static void deleteFewOpportunityTest() {
        String opportunityName = 'deleteFewOpportunityTest';

        List<Opportunity> newOpportunityList = new List<Opportunity>();
        for(Integer opportunityCount = 0; opportunityCount < 3; opportunityCount++) {
            newOpportunityList.Add(new Opportunity(
                Name = opportunityName + opportunityCount, 
                CloseDate = System.today(), 
                StageName = StageNameProspecting));
        }

        Test.startTest();
        Database.insert(newOpportunityList, false);
        Set<Id> opportunityIdSet = new Map<Id, Opportunity>(newOpportunityList).keySet();
        List<Database.DeleteResult> deleteResultList = Database.delete(newOpportunityList, false);
        List<Opportunity> opportunitiesList = [SELECT Id, Name FROM Opportunity WHERE Id IN :opportunityIdSet];
        List<Web_Order__c> webOrdersList = [SELECT Id, Name FROM Web_Order__c WHERE OpportunityId__c IN :opportunityIdSet];
        Test.stopTest();

        for(Database.DeleteResult result: deleteResultList) {
            System.assert(result.isSuccess());
        }
        System.assertEquals(0, opportunitiesList.size());
        System.assertEquals(0, webOrdersList.size());
    }

    @isTest static void deleteOpportunityTest() {
        String opportunityName = 'deleteOpportunityTest';

        Opportunity newOpportunity = new Opportunity(
            Name = opportunityName, 
            CloseDate = System.today(), 
            StageName = StageNameProspecting);

        Test.startTest();
        Database.insert(newOpportunity, false);
        Database.DeleteResult deleteResult = Database.delete(newOpportunity, false);

        List<Opportunity> opportunitiesList = [SELECT Id, Name FROM Opportunity WHERE Id = :newOpportunity.Id];
        List<Web_Order__c> webOrdersList = [SELECT Id, Name FROM Web_Order__c WHERE OpportunityId__c = :newOpportunity.Id];
        Test.stopTest();

        System.assert(deleteResult.isSuccess());
        System.assertEquals(0, opportunitiesList.size());
        System.assertEquals(0, webOrdersList.size());
    }

    @isTest static void updateOneOpportunityTest() {
        String opportunityName = 'updateOneOpportunityTest';

        Opportunity newOpportunity = new Opportunity(
            Name = opportunityName, 
            CloseDate = System.today(), 
            StageName = StageNameProspecting);

        Test.startTest();
        Database.insert(newOpportunity, false);

        newOpportunity.Name += UpdatePostfix;
        Database.SaveResult result = Database.update(newOpportunity, false);

        List<Opportunity> updatedOpportunityList = [SELECT Id, Name, CloseDate, StageName FROM Opportunity WHERE Id = :newOpportunity.Id];
        List<Web_Order__c> updatedWebOrderList = [SELECT Id, Name, CloseDate__c, StageName__c FROM Web_Order__c WHERE OpportunityId__c = :newOpportunity.Id];
        Test.stopTest();        

        System.assert(result.isSuccess());
        System.assertEquals(1, updatedOpportunityList.size());
        System.assertEquals(1, updatedWebOrderList.size());

        Opportunity updatedOpportunity = updatedOpportunityList[0];
        System.assertEquals(newOpportunity.Name, updatedOpportunity.Name);

        Web_Order__c updatedWebOrder = updatedWebOrderList[0];
        System.assertEquals(newOpportunity.Name, updatedWebOrder.Name);
    }

    @isTest static void updateFewOpportunityTest() {
        String opportunityName = 'updateFewOpportunityTest';

        List<Opportunity> newOpportunityList = new List<Opportunity>();
        for(Integer opportunityCount = 0; opportunityCount < 3; opportunityCount++) {
            newOpportunityList.Add(new Opportunity(
                Name = opportunityName + opportunityCount, 
                CloseDate = System.today(), 
                StageName = StageNameProspecting));
        }

        Test.startTest();
        Database.insert(newOpportunityList, false);
        for(Opportunity opportunity: newOpportunityList) {
            opportunity.Name += UpdatePostfix;
        }

        List<Database.SaveResult> resultList = Database.update(newOpportunityList, false);

        Set<Id> opportunityIdSet = new Map<Id, Opportunity>(newOpportunityList).keySet();
        List<Opportunity> updatedOpportunityList = [SELECT Id, Name, CloseDate, StageName FROM Opportunity WHERE Id IN :opportunityIdSet];
        List<Web_Order__c> updatedWebOrdersList = [SELECT Id, Name, CloseDate__c, StageName__c, OpportunityId__c FROM Web_Order__c WHERE OpportunityId__c IN :opportunityIdSet];
        Test.stopTest();

        for(Database.SaveResult result: resultList) {
            System.assert(result.isSuccess());
        }
        System.assertEquals(3, updatedOpportunityList.size());
        System.assertEquals(3, updatedWebOrdersList.size());

        for(Web_Order__c webOrder: updatedWebOrdersList) {
            System.assert(newOpportunityList.contains(new Opportunity(
                Id = webOrder.OpportunityId__c, 
                Name = webOrder.Name,
                CloseDate = webOrder.CloseDate__c,
                StageName = webOrder.StageName__c)));
        }

        for(Opportunity opportunity: updatedOpportunityList) {
            System.assert(newOpportunityList.contains(new Opportunity(
                Id = opportunity.Id, 
                Name = opportunity.Name,
                CloseDate = opportunity.CloseDate,
                StageName = opportunity.StageName)));
        }
    }
}
