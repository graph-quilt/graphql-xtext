package com.intuit.graphql.validation

import com.intuit.graphql.graphQL.DirectiveDefinition
import com.intuit.graphql.graphQL.TypeSystem
import java.util.HashSet
import org.eclipse.xtext.validation.Check

class DirectiveValidation extends BaseValidation {

	var directiveDefinitions = new HashSet()

	@Check
	def checkDuplicateDirectiveDefinitions(TypeSystem typeSystem) {
		directiveDefinitions = new HashSet()
		for (DirectiveDefinition directiveDefinition : typeSystem.typeSystemDefinition.filter[t|t.directive !== null].
			map[t|t.directive]) {
			if (!directiveDefinitions.add(directiveDefinition.name)) {
				error("Duplicate directives in schema: " + directiveDefinition.name, directiveDefinition)
			}
		}
	}
}
