package com.intuit.graphql.validation;

import static com.intuit.graphql.utils.XtextTypeUtils.typeName;

import java.util.Objects;

import org.eclipse.xtext.validation.Check;

import com.intuit.graphql.graphQL.InputObjectTypeDefinition;
import com.intuit.graphql.graphQL.InputValueDefinition;
import com.intuit.graphql.graphQL.NamedType;
import com.intuit.graphql.graphQL.ObjectType;

class InputValueValidation extends BaseValidation {
	
	@Check
	public void checkIfDefaultValuesConfirmsToNameTypes(InputValueDefinition inputValueDefinition) {
		if (Objects.isNull(inputValueDefinition.getDefaultValue())) {
			// since no default value exists
			return;
		}
		NamedType namedType = inputValueDefinition.getNamedType();
		if (!isInputObjectType(namedType)) {
			error("namedtype " + typeName(namedType) + " not confirms to inputObjectType.", inputValueDefinition);
		}
		
	}

	private boolean isInputObjectType(NamedType namedType) {
		return namedType instanceof ObjectType && ((ObjectType)namedType).getType() instanceof InputObjectTypeDefinition;
	}

}
