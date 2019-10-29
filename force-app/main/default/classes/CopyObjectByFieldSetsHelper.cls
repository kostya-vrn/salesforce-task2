public with sharing class CopyObjectByFieldSetsHelper {
    
    public static WebOrder__c generateWebOrder(Opportunity opportunity, List<Schema.FieldSetMember> fromFieldList, List<Schema.FieldSetMember> toFieldsList) {
        WebOrder__c newWebOrder = new WebOrder__c();
        for(Integer fieldNumber = 0; fieldNumber < Math.min(fromFieldList.size(), toFieldsList.size()); fieldNumber++) {
            Schema.FieldSetMember opportunityField = fromFieldList[fieldNumber];
            Schema.FieldSetMember webOrderField = toFieldsList[fieldNumber];

            if (opportunity.getSobjectType().getDescribe().fields.getMap().keySet().contains(opportunityField.getFieldPath().toLowerCase())) {
                newWebOrder.put(webOrderField.getFieldPath(), opportunity.get(opportunityField.getFieldPath()));
            }
        }

        return newWebOrder;
    }

    public static boolean hasSObjectField(String fieldName, SObject so){
                return so.getSobjectType().getDescribe().fields.getMap().keySet().contains(fieldName.toLowerCase());
    }
}
