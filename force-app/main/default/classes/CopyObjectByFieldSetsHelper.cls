public with sharing class CopyObjectByFieldSetsHelper {

    public static String FieldNameCustomPart = '__c';

    //region patch methods
    public static WebOrder__c patchWebOrder(
        Opportunity opportunity, 
        Set<String> fromFieldsList, 
        List<String> toFieldsList, 
        WebOrder__c webOrder
    ) {
        webOrder = webOrder != null ? webOrder : new WebOrder__c();

        for(String webOrderField: toFieldsList) {
            String ooprtunityField = getWebOrderFieldApi(webOrderField, fromFieldsList);

            if (ooprtunityField != null) {
                webOrder.put(webOrderField, opportunity.get(ooprtunityField));
            }
        }
        webOrder.OpportunityId__c = opportunity.Id;

        return webOrder;
    }

    public static Opportunity patchOpportunity(
        Opportunity opportunity, 
        Set<String> fromFieldsList, 
        List<String> toFieldsList, 
        WebOrder__c webOrder
    ) {
        opportunity = opportunity != null ? opportunity : new Opportunity();

        for(String opportunityField: toFieldsList) {
            String webOrderField = getOpportunityFieldApi(opportunityField, fromFieldsList);

            if (webOrderField != null) {
                opportunity.put(opportunityField, webOrder.get(webOrderField));
            }
        }
        opportunity.WebOrderId__c = webOrder.Id;

        return opportunity;
    }
    //endregion

    //region get fields collection methods
    public static List<String> getFieldSetFieldsPath(Schema.FieldSet fieldSet) {
        List<Schema.FieldSetMember> fieldMembers = fieldSet.getFields();

        List<String> fieldPathsList = new List<String>();
        for(Schema.FieldSetMember field: fieldMembers) {
            fieldPathsList.add(field.getFieldPath());
        }

        return fieldPathsList;
    }

    public static String getWebOrderFieldApi(String searchFieldName, Set<String> fieldNameCollection) {
        if (fieldNameCollection.contains(searchFieldName.toLowerCase())) { return searchFieldName; }

        String cutedFieldName = searchFieldName.removeEnd(FieldNameCustomPart);
        if (fieldNameCollection.contains(cutedFieldName.toLowerCase())) { return cutedFieldName; }

        return null;
    }

    public static String getOpportunityFieldApi(String searchFieldName, Set<String> fieldNameCollection) {
        if (fieldNameCollection.contains(searchFieldName.toLowerCase())) { return searchFieldName; }

        String fullFieldName = searchFieldName + FieldNameCustomPart;
        if (fieldNameCollection.contains(fullFieldName.toLowerCase())) { return fullFieldName; }

        return null;
    }
    //endregion

    //region get id colletion methods
    public static List<Id> getOpportunityIdList(List<WebOrder__c> webOrdersList) {
        List<Id> opportunityIdsList = new List<Id>();
        for(WebOrder__c webOrder: webOrdersList) {
            if (webOrder.OpportunityId__c == null) { continue; }

            opportunityIdsList.add(webOrder.OpportunityId__c);
        }

        return opportunityIdsList;
    }

    public static List<Id> getWebOrderIdList(List<opportunity> opportunityList) {
        List<Id> webOrderIdList = new List<Id>();
        for(Opportunity opportunity: opportunityList) {
            if (opportunity.WebOrderId__c == null) { continue; }

            webOrderIdList.add(opportunity.WebOrderId__c);
        }

        return webOrderIdList;
    }

    public static WebOrder__c getWebOrderByOpportunityId(Id opportunityId, List<WebOrder__c> webOrdersList) {
        for(WebOrder__c webOrder: webOrdersList) {
            if (webOrder.OpportunityId__c == opportunityId) {
                return webOrder;
            }
        }

        return null;
    }

    public static Opportunity getOpportunityByWebOrderId(Id webOrderId, List<Opportunity> opportunityList) {
        for(Opportunity opportunity : opportunityList) {
            if (opportunity.WebOrderId__c == webOrderId) {
                return opportunity;
            }
        }

        return null;
    }
    //endregion

    //region compare methods
    public static boolean compareOpportunityAndWebObjectFields(
        Opportunity opportunity, 
        Set<String> fromFieldsList, 
        List<String> toFieldsList, 
        WebOrder__c webOrder
    ) {
        for(String webOrderField : toFieldsList) {
            String ooprtunityField = getWebOrderFieldApi(webOrderField, fromFieldsList);

            if (opportunity.get(ooprtunityField) != webOrder.get(webOrderField)) {
                return false;
            }
        }

        return true;
    }

    public static boolean compareWebObjectAndOpportunityFields(
        Opportunity opportunity, 
        Set<String> fromFieldsList, 
        List<String> toFieldsList, 
        WebOrder__c webOrder
    ) {
        for(String ooprtunityField : toFieldsList) {
            String webOrderField = getOpportunityFieldApi(ooprtunityField, fromFieldsList);

            if (opportunity.get(ooprtunityField) != webOrder.get(webOrderField)) {
                return false;
            }
        }

        return true;
    }
    //endregion
    
}
