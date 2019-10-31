@isTest
public with sharing class opportunityAndWebOrderActionTriggerTests {
    private static String StageNameProspecting = 'Prospecting';

    @isTest static void createFewOpportunityDeleteFewWebOrderTest() {
        String opportunityName = 'createFewOpportunityDeleteFewWebOrderTest';

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
        List<WebOrder__c> webOrdersList = [SELECT Id, Name FROM WebOrder__c WHERE OpportunityId__c IN :opportunityIdSet];
        List<Database.DeleteResult> deleteResultList = Database.delete(webOrdersList, false);

        List<Opportunity> opportunitiesList = [SELECT Id, Name FROM Opportunity WHERE Id IN :opportunityIdSet];
        List<WebOrder__c> deletedWebOrdersList = [SELECT Id, Name FROM WebOrder__c WHERE OpportunityId__c IN :opportunityIdSet];
        Test.stopTest();

        for(Database.DeleteResult result: deleteResultList) {
            System.assert(result.isSuccess());
        }
        System.assertEquals(0, opportunitiesList.size());
        System.assertEquals(0, deletedWebOrdersList.size());
    }

    @isTest static void createOpportunityDeleteWebOrderTest() {
        String opportunityName = 'createOpportunityDeleteWebOrderTest';

        Opportunity newOpportunity = new Opportunity(
            Name = opportunityName, 
            CloseDate = System.today(), 
            StageName = StageNameProspecting);

        Test.startTest();
        Database.insert(newOpportunity, false);
        List<WebOrder__c> webOrdersList = [SELECT Id, Name FROM WebOrder__c WHERE OpportunityId__c = :newOpportunity.Id];
        List<Database.DeleteResult> deleteResult = Database.delete(webOrdersList, false);

        List<Opportunity> opportunitiesList = [SELECT Id, Name FROM Opportunity WHERE Id = :newOpportunity.Id];
        List<WebOrder__c> deletedWebOrdersList = [SELECT Id, Name FROM WebOrder__c WHERE OpportunityId__c = :newOpportunity.Id];
        Test.stopTest();
        
        System.assertEquals(1, deleteResult.size());
        System.assert(deleteResult[0].isSuccess());
        System.assertEquals(0, opportunitiesList.size());
        System.assertEquals(0, deletedWebOrdersList.size());
    }

    @isTest static void createFewWebOrderDeleteFewOpportunityTest() {
        String webOrderName = 'createFewWebOrderDeleteFewOpportunityTest';

        List<WebOrder__c> newWebOrderList = new List<WebOrder__c>();
        for(Integer webOrderCount = 0; webOrderCount < 3; webOrderCount++) {
            newWebOrderList.Add(new WebOrder__c(
                Name = webOrderName + webOrderCount, 
                CloseDate__c = System.today(), 
                StageName__c = StageNameProspecting));
        }

        Test.startTest();
        Database.insert(newWebOrderList, false);
        Set<Id> webOrderIdSet = new Map<Id, WebOrder__c>(newWebOrderList).keySet();
        List<Opportunity> opportunityList = [SELECT Id, Name FROM Opportunity WHERE WebOrderId__c IN :webOrderIdSet];
        List<Database.DeleteResult> deleteResultList = Database.delete(opportunityList, false);

        List<Opportunity> opportunitiesList = [SELECT Id, Name FROM Opportunity WHERE WebOrderId__c IN :webOrderIdSet];
        List<WebOrder__c> deletedWebOrdersList = [SELECT Id, Name FROM WebOrder__c WHERE Id IN :webOrderIdSet];
        Test.stopTest();

        for(Database.DeleteResult result: deleteResultList) {
            System.assert(result.isSuccess());
        }
        System.assertEquals(0, opportunitiesList.size());
        System.assertEquals(0, deletedWebOrdersList.size());
    }

    @isTest static void createWebOrderDeleteOpportunityTest() {
        String webOrderName = 'createWebOrderDeleteOpportunityTest';
        WebOrder__c newWebOrder = new WebOrder__c(
            Name = webOrderName, 
            CloseDate__c = System.today(), 
            StageName__c = StageNameProspecting);

        Test.startTest();
        Database.insert(newWebOrder, false);
        List<Opportunity> opportunityList = [SELECT Id, Name FROM Opportunity WHERE WebOrderId__c = :newWebOrder.Id];
        List<Database.DeleteResult> deleteResult = Database.delete(opportunityList, false);

        List<Opportunity> opportunitiesList = [SELECT Id, Name FROM Opportunity WHERE WebOrderId__c = :newWebOrder.Id];
        List<WebOrder__c> deletedWebOrdersList = [SELECT Id, Name FROM WebOrder__c WHERE Id = :newWebOrder.Id];
        Test.stopTest();
        
        System.assertEquals(1, deleteResult.size());
        System.assert(deleteResult[0].isSuccess());
        System.assertEquals(0, opportunitiesList.size());
        System.assertEquals(0, deletedWebOrdersList.size());
    }
}
