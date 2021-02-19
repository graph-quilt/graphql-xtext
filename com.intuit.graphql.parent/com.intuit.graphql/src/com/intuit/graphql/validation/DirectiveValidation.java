package com.intuit.graphql.validation;

import java.util.HashSet;
import java.util.Objects;
import java.util.Set;

import org.eclipse.xtext.validation.Check;

import com.intuit.graphql.graphQL.TypeSystem;

class DirectiveValidation extends BaseValidation {

	@Check
	public void checkDuplicateDirectiveDefinitions(TypeSystem typeSystem) {
		Set<String> directiveDefinitions  = new HashSet();
				
		typeSystem.getTypeSystemDefinition().stream().map(t->t.getDirective()).filter(Objects::nonNull).forEach(directiveDef->{
			if (!directiveDefinitions.add(directiveDef.getName())) {
				error("Duplicate directives in schema: " + directiveDef.getName(), directiveDef);
			}
		});
				
	}
}
