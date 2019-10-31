@isTest
public with sharing class opportunityAndWebOrderActionTriggerTests {
    @isTest static void createFewOpportunityDeleteFewWebOrderTest() {
        List<Opportunity> newOpportunityList = new List<Opportunity>();

        for(Integer opportunityCount = 0; opportunityCount < 3; opportunityCount++) {
        newOpportunityList.Add(new Opportunity(Name = 'deleteFewOpportunityTest' + opportunityCount, 
                                                CloseDate = System.today(), 
                                                StageName = 'Prospecting'));
        }

        Test.startTest();
        Database.insert(newOpportunityList, false);
        Set<Id> opportunityIdSet = new Map<Id, Opportunity>(newOpportunityList).keySet();
        List<WebOrder__c> webOrdersList = [SELECT Id, Name FROM WebOrder__c WHERE OpportunityId__c IN :opportunityIdSet];
        List<Database.DeleteResult> deleteResultList = Database.delete(webOrdersList, false);

        List<Opportunity> opportunitiesList = [SELECT Id, Name FROM Opportunity WHERE Id IN :opportunityIdSet];
        List<WebOrder__c> deletedWebOrdersList = [SELECT Id, Name FROM WebOrder__c WHERE OpportunityId__c IN :opportunityIdSet];
        Test.stopTest();

        for(Database.DeleteResult result : deleteResultList) {
            System.assert(result.isSuccess());
        }
        System.assertEquals(0, opportunitiesList.size());
        System.assertEquals(0, deletedWebOrdersList.size());
    }

    @isTest static void createOpportunityDeleteWebOrderTest() {
        Opportunity newOpportunity = new Opportunity(Name = 'deleteOpportunityTest', 
                                                        CloseDate = System.today(), 
                                                        StageName = 'Prospecting');

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
        List<WebOrder__c> newWebOrderList = new List<WebOrder__c>();

        for(Integer webOrderCount = 0; webOrderCount < 3; webOrderCount++) {
        newWebOrderList.Add(new WebOrder__c(Name = 'createFewWebOrderDeleteFewOpportunityTest' + webOrderCount, 
                                                CloseDate__c = System.today(), 
                                                StageName__c = 'Prospecting'));
        }

        Test.startTest();
        Database.insert(newWebOrderList, false);
        Set<Id> webOrderIdSet = new Map<Id, WebOrder__c>(newWebOrderList).keySet();
        List<Opportunity> opportunityList = [SELECT Id, Name FROM Opportunity WHERE WebOrderId__c IN :webOrderIdSet];
        List<Database.DeleteResult> deleteResultList = Database.delete(opportunityList, false);

        List<Opportunity> opportunitiesList = [SELECT Id, Name FROM Opportunity WHERE WebOrderId__c IN :webOrderIdSet];
        List<WebOrder__c> deletedWebOrdersList = [SELECT Id, Name FROM WebOrder__c WHERE Id IN :webOrderIdSet];
        Test.stopTest();

        for(Database.DeleteResult result : deleteResultList) {
            System.assert(result.isSuccess());
        }
        System.assertEquals(0, opportunitiesList.size());
        System.assertEquals(0, deletedWebOrdersList.size());
    }

    @isTest static void createWebOrderDeleteOpportunityTest() {
        WebOrder__c newWebOrder = new WebOrder__c(Name = 'createWebOrderDeleteOpportunityTest', 
                                                        CloseDate__c = System.today(), 
                                                        StageName__c = 'Prospecting');

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
