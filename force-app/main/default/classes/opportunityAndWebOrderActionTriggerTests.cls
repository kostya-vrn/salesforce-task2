@isTest
public with sharing class opportunityAndWebOrderActionTriggerTests {
    private static String StageNameProspecting = 'Prospecting';
    private static String UpdatePostfix = '_updated';

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
        List<Web_Order__c> webOrdersList = [SELECT Id, Name FROM Web_Order__c WHERE OpportunityId__c IN :opportunityIdSet];
        List<Database.DeleteResult> deleteResultList = Database.delete(webOrdersList, false);

        List<Opportunity> opportunitiesList = [SELECT Id, Name FROM Opportunity WHERE Id IN :opportunityIdSet];
        List<Web_Order__c> deletedWebOrdersList = [SELECT Id, Name FROM Web_Order__c WHERE OpportunityId__c IN :opportunityIdSet];
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
        List<Web_Order__c> webOrdersList = [SELECT Id, Name FROM Web_Order__c WHERE OpportunityId__c = :newOpportunity.Id];
        List<Database.DeleteResult> deleteResult = Database.delete(webOrdersList, false);

        List<Opportunity> opportunitiesList = [SELECT Id, Name FROM Opportunity WHERE Id = :newOpportunity.Id];
        List<Web_Order__c> deletedWebOrdersList = [SELECT Id, Name FROM Web_Order__c WHERE OpportunityId__c = :newOpportunity.Id];
        Test.stopTest();
        
        System.assertEquals(1, deleteResult.size());
        System.assert(deleteResult[0].isSuccess());
        System.assertEquals(0, opportunitiesList.size());
        System.assertEquals(0, deletedWebOrdersList.size());
    }

    @isTest static void createFewWebOrderDeleteFewOpportunityTest() {
        String webOrderName = 'createFewWebOrderDeleteFewOpportunityTest';

        List<Web_Order__c> newWebOrderList = new List<Web_Order__c>();
        for(Integer webOrderCount = 0; webOrderCount < 3; webOrderCount++) {
            newWebOrderList.Add(new Web_Order__c(
                Name = webOrderName + webOrderCount, 
                CloseDate__c = System.today(), 
                StageName__c = StageNameProspecting));
        }

        Test.startTest();
        Database.insert(newWebOrderList, false);
        Set<Id> webOrderIdSet = new Map<Id, Web_Order__c>(newWebOrderList).keySet();
        List<Opportunity> opportunityList = [SELECT Id, Name FROM Opportunity WHERE WebOrderId__c IN :webOrderIdSet];
        List<Database.DeleteResult> deleteResultList = Database.delete(opportunityList, false);

        List<Opportunity> opportunitiesList = [SELECT Id, Name FROM Opportunity WHERE WebOrderId__c IN :webOrderIdSet];
        List<Web_Order__c> deletedWebOrdersList = [SELECT Id, Name FROM Web_Order__c WHERE Id IN :webOrderIdSet];
        Test.stopTest();

        for(Database.DeleteResult result: deleteResultList) {
            System.assert(result.isSuccess());
        }
        System.assertEquals(0, opportunitiesList.size());
        System.assertEquals(0, deletedWebOrdersList.size());
    }

    @isTest static void createWebOrderDeleteOpportunityTest() {
        String webOrderName = 'createWebOrderDeleteOpportunityTest';
        Web_Order__c newWebOrder = new Web_Order__c(
            Name = webOrderName, 
            CloseDate__c = System.today(), 
            StageName__c = StageNameProspecting);

        Test.startTest();
        Database.insert(newWebOrder, false);
        List<Opportunity> opportunityList = [SELECT Id, Name FROM Opportunity WHERE WebOrderId__c = :newWebOrder.Id];
        List<Database.DeleteResult> deleteResult = Database.delete(opportunityList, false);

        List<Opportunity> opportunitiesList = [SELECT Id, Name FROM Opportunity WHERE WebOrderId__c = :newWebOrder.Id];
        List<Web_Order__c> deletedWebOrdersList = [SELECT Id, Name FROM Web_Order__c WHERE Id = :newWebOrder.Id];
        Test.stopTest();
        
        System.assertEquals(1, deleteResult.size());
        System.assert(deleteResult[0].isSuccess());
        System.assertEquals(0, opportunitiesList.size());
        System.assertEquals(0, deletedWebOrdersList.size());
    }

    @isTest static void createWebOrderUpdateWebOrderTest() {
        String webOrderName = 'createWebOrderUpdateWebOrderTest';
        Web_Order__c newWebOrder = new Web_Order__c(
            Name = webOrderName, 
            CloseDate__c = System.today(), 
            StageName__c = StageNameProspecting);

        Test.startTest();
        Database.insert(newWebOrder, false);
        newWebOrder.Name += UpdatePostfix;
        Database.SaveResult result = Database.update(newWebOrder, false);

        List<Opportunity> opportunitiesList = [SELECT Id, Name FROM Opportunity WHERE WebOrderId__c = :newWebOrder.Id];
        Set<Id> opportunityIds = (new Map<Id, opportunity>(opportunitiesList)).keySet();
        List<Web_Order__c> updatedWebOrdersList = [SELECT Id, Name FROM Web_Order__c WHERE Id = :newWebOrder.Id OR OpportunityId__c IN :opportunityIds];
        Test.stopTest();
        
        System.assert(result.isSuccess());
        System.assertEquals(1, opportunitiesList.size());
        System.assertEquals(1, updatedWebOrdersList.size());
    }

    @isTest static void createOpportunityUpdateWebOrderTest() {
        String opportunityName = 'createOpportunityUpdateWebOrderTest';
        Opportunity opportunity = new Opportunity(
            Name = opportunityName, 
            CloseDate = System.today(), 
            StageName = StageNameProspecting);

        Test.startTest();
        Database.insert(opportunity, false);
        List<Web_Order__c> updatedWebOrdersList = [SELECT Id, Name FROM Web_Order__c WHERE OpportunityId__c = :opportunity.Id];
        Web_Order__c updatedWebOrder = updatedWebOrdersList[0];
        updatedWebOrder.Name += UpdatePostfix;
        Database.SaveResult result = Database.update(updatedWebOrder, false);

        updatedWebOrdersList = [SELECT Id, Name FROM Web_Order__c WHERE OpportunityId__c = :opportunity.Id];
        Set<Id> webOrdersIds = (new Map<Id, Web_Order__c>(updatedWebOrdersList)).keySet();
        List<Opportunity> opportunitiesList = [SELECT Id, Name FROM Opportunity WHERE Id = :opportunity.Id OR WebOrderId__c IN :webOrdersIds];
        Test.stopTest();
        
        System.assert(result.isSuccess());
        System.assertEquals(1, opportunitiesList.size());
        System.assertEquals(1, updatedWebOrdersList.size());
    }
}
