package com.intuit.graphql.validation;

import java.util.HashSet;
import java.util.Set;

import org.eclipse.xtext.validation.Check;

import com.intuit.graphql.graphQL.TypeDefinition;
import com.intuit.graphql.graphQL.TypeSystem;
import com.intuit.graphql.graphQL.TypeSystemDefinition;

class TypeSystemValidation extends BaseValidation {

	@Check
	public void checkForDuplicateTypes(TypeSystem typeSystem) {
		Set<String> names = new HashSet<>();

		for (TypeSystemDefinition tsd : typeSystem.getTypeSystemDefinition()) {
			TypeDefinition type = tsd.getType();
			if (!names.add(type.getName())) {
				error("Duplicate name in schema: " + type.getName(), type);
			}
		}
	}

}
