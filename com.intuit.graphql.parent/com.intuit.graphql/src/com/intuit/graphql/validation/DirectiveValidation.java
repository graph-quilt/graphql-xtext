package com.intuit.graphql.validation;

import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Objects;
import java.util.Set;

import org.eclipse.xtext.validation.Check;

import com.intuit.graphql.graphQL.Directive;
import com.intuit.graphql.graphQL.DirectiveDefinition;
import com.intuit.graphql.graphQL.InputValueDefinition;
import com.intuit.graphql.graphQL.TypeSystem

class DirectiveValidation extends BaseValidation {

	@Check
	public void checkDuplicateDirectiveDefinitions(TypeSystem typeSystem) {
		Set<String> directiveDefinitions  = new HashSet<>();
				
		typeSystem.getTypeSystemDefinition().stream().map(t->t.getDirective()).filter(Objects::nonNull).forEach(directiveDef->{
			if (!directiveDefinitions.add(directiveDef.getName())) {
				error("Duplicate directives in schema: " + directiveDef.getName(), directiveDef);
			}
		});
				
	}
	
	@Check
	public void validateDirectiveArguments(Directive directive) {
		DirectiveDefinition directiveDefinition = directive.getDefinition();
		Map<String, InputValueDefinition> argumentsInputValuesDefinitonMap = new HashMap<>();
		directiveDefinition.getArgumentsDefinition().getInputValueDefinition().stream().filter(Objects::nonNull)
				.forEach(inputValueDefinition -> {
					argumentsInputValuesDefinitonMap.put(inputValueDefinition.getName(), inputValueDefinition);
				});

		directive.getArguments().stream().forEach(argument -> {
			if (!argumentsInputValuesDefinitonMap.containsKey(argument.getName())) {
				error("Unknown Argument: "+argument.getName()+"inside directive : "+directiveDefinition.getName(), directive);
			}
		});
	}
}
