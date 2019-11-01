@isTest
public with sharing class webOrderActionTriggerTests {
    private static String UpdatePostfix = '_updated';
    private static String StageNameProspecting = 'Prospecting';

    @isTest static void createOneWebOrderTest() {
        String webOrderName = 'createOneWebOrderTest';

        Web_Order__c newWebOrder = new Web_Order__c(
            Name = webOrderName, 
            CloseDate__c = System.today(), 
            StageName__c = StageNameProspecting);

        Test.startTest();
        Database.SaveResult result = Database.insert(newWebOrder, false);
        List<Opportunity> createdOpportunitysList = [SELECT Id, Name, CloseDate, StageName FROM Opportunity WHERE WebOrderId__c = :newWebOrder.Id];
        Test.stopTest();        

        System.assert(result.isSuccess());
        System.assertEquals(1, createdOpportunitysList.size());

        Opportunity createdOpportunity = createdOpportunitysList[0];
        System.assertEquals(newWebOrder.Name, createdOpportunity.Name);
        System.assertEquals(newWebOrder.CloseDate__c, createdOpportunity.CloseDate);
        System.assertEquals(newWebOrder.StageName__c, createdOpportunity.StageName);
    }

    @isTest static void createFewWebOrderTest() {
        String webOrderName = 'createFewWebOrderTest';

        List<Web_Order__c> newWebOrderList = new List<Web_Order__c>();
        for(Integer webOrderCount = 0; webOrderCount < 3; webOrderCount++) {
            newWebOrderList.Add(new Web_Order__c(
                Name = webOrderName + webOrderCount, 
                CloseDate__c = System.today(), 
                StageName__c = StageNameProspecting));
        }

        Test.startTest();
        List<Database.SaveResult> resultList = Database.insert(newWebOrderList, false);
        Set<Id> webOrderIdSet = new Map<Id, Web_Order__c>(newWebOrderList).keySet();
        List<Opportunity> createdOpportunityList = [SELECT Id, Name, CloseDate, StageName, WebOrderId__c FROM Opportunity WHERE WebOrderId__c IN :webOrderIdSet];
        Test.stopTest();

        for(Database.SaveResult result: resultList) {
            System.assert(result.isSuccess());
        }
        System.assertEquals(3, createdOpportunityList.size());

        for(Opportunity opportunity: createdOpportunityList) {
            System.assert(newWebOrderList.contains(new Web_Order__c(
                Id = opportunity.WebOrderId__c, 
                Name = opportunity.Name,
                CloseDate__c = opportunity.CloseDate,
                StageName__c = opportunity.StageName)));
        }
    }

    @isTest static void deleteFewWebOrderTest() {
        String webOrderName = 'deleteFewWebOrderTest';

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
        List<Database.DeleteResult> deleteResultList = Database.delete(newWebOrderList, false);

        List<Web_Order__c> webOrdersList = [SELECT Id, Name FROM Web_Order__c WHERE Id IN :webOrderIdSet];
        List<Opportunity> opportunitiesList = [SELECT Id, Name FROM Opportunity WHERE WebOrderId__c IN :webOrderIdSet];
        Test.stopTest();

        for(Database.DeleteResult result: deleteResultList) {
            System.assert(result.isSuccess());
        }
        System.assertEquals(0, opportunitiesList.size());
        System.assertEquals(0, webOrdersList.size());
    }

    @isTest static void deleteWebOrderTest() {
        String webOrderName = 'deleteWebOrderTest';

        Web_Order__c newWebOrder = new Web_Order__c(
            Name = webOrderName, 
            CloseDate__c = System.today(), 
            StageName__c = StageNameProspecting);

        Test.startTest();
        Database.insert(newWebOrder, false);
        Database.DeleteResult deleteResult = Database.delete(newWebOrder, false);

        List<Web_Order__c> webOrdersList = [SELECT Id, Name FROM Web_Order__c WHERE Id = :newWebOrder.Id];
        List<opportunity> opportunitiesList = [SELECT Id, Name FROM Opportunity WHERE WebOrderId__c = :newWebOrder.Id];
        Test.stopTest();

        System.assert(deleteResult.isSuccess());
        System.assertEquals(0, opportunitiesList.size());
        System.assertEquals(0, webOrdersList.size());
    }

    @isTest static void updateOneWebOrderTest() {
        String webOrderName = 'updateOneWebOrderTest';

        Web_Order__c newWebOrder = new Web_Order__c(
            Name = webOrderName, 
            CloseDate__c = System.today(), 
            StageName__c = StageNameProspecting);

        Test.startTest();
        Database.insert(newWebOrder, false);

        newWebOrder.Name += UpdatePostfix;
        Database.SaveResult result = Database.update(newWebOrder, false);

        List<Web_Order__c> updatedWebOrderList = [SELECT Id, Name, CloseDate__c, StageName__c FROM Web_Order__c WHERE Id = :newWebOrder.Id];
        List<Opportunity> updatedOpportunityList = [SELECT Id, Name, CloseDate, StageName FROM Opportunity WHERE WebOrderId__c = :newWebOrder.Id];
        Test.stopTest();        

        System.assert(result.isSuccess());
        System.assertEquals(1, updatedOpportunityList.size());
        System.assertEquals(1, updatedWebOrderList.size());

        Opportunity updatedOpportunity = updatedOpportunityList[0];
        System.assertEquals(newWebOrder.Name, updatedOpportunity.Name);

        Web_Order__c updatedWebOrder = updatedWebOrderList[0];
        System.assertEquals(newWebOrder.Name, updatedWebOrder.Name);
    }

    @isTest static void updateFewWebOrderTest() {
        String webOrderName = 'updateFewWebOrderTest';

        List<Web_Order__c> newWebOrderList = new List<Web_Order__c>();
        for(Integer webOrderCount = 0; webOrderCount < 3; webOrderCount++) {
            newWebOrderList.Add(new Web_Order__c(
                Name = webOrderName + webOrderCount, 
                CloseDate__c = System.today(), 
                StageName__c = StageNameProspecting));
        }

        Test.startTest();
        Database.insert(newWebOrderList, false);
        for(Web_Order__c webOrder: newWebOrderList) {
            webOrder.Name += UpdatePostfix;
        }

        List<Database.SaveResult> resultList = Database.update(newWebOrderList, false);

        Set<Id> webOrderIdSet = new Map<Id, Web_Order__c>(newWebOrderList).keySet();
        List<Web_Order__c> updatedWebOrderList = [SELECT Id, Name, CloseDate__c, StageName__c FROM Web_Order__c WHERE Id IN :webOrderIdSet];
        List<Opportunity> updatedOpportunityList = [SELECT Id, Name, CloseDate, StageName, WebOrderId__c FROM Opportunity WHERE WebOrderId__c IN :webOrderIdSet];
        Test.stopTest();

        for(Database.SaveResult result: resultList) {
            System.assert(result.isSuccess());
        }
        System.assertEquals(3, updatedOpportunityList.size());
        System.assertEquals(3, updatedWebOrderList.size());

        for(Web_Order__c webOrder: updatedWebOrderList) {
            System.assert(newWebOrderList.contains(new Web_Order__c(
                Id = webOrder.Id, 
                Name = webOrder.Name,
                CloseDate__c = webOrder.CloseDate__c,
                StageName__c = webOrder.StageName__c)));
        }

        for(Opportunity opportunity: updatedOpportunityList) {
            System.assert(newWebOrderList.contains(new Web_Order__c(
                Id = opportunity.WebOrderId__c, 
                Name = opportunity.Name,
                CloseDate__c = opportunity.CloseDate,
                StageName__c = opportunity.StageName)));
        }
    }
}
