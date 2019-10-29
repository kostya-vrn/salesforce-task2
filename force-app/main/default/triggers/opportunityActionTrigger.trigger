trigger opportunityActionTrigger on Opportunity (before insert, before delete, before update) {
    List<Schema.FieldSetMember> opportunityToWebOrderFields = Schema.SObjectType.Opportunity.fieldSets.getMap().get('Opportunity_Sync_To_Web_Order').getFields();
    List<Schema.FieldSetMember> webOrderToOpportunityFields = Schema.SObjectType.WebOrder__c.fieldSets.getMap().get('Opportunity_Sync_To_Web_Order').getFields();

    for(Opportunity opportunity : Trigger.New) {
        WebOrder__c newWebOrder = CopyObjectByFieldSetsHelper.generateWebOrder(opportunity, opportunityToWebOrderFields, webOrderToOpportunityFields);

        System.debug(newWebOrder);
    }
}

