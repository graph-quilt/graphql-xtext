package com.intuit.graphql.validation

import com.intuit.graphql.graphQL.TypeDefinition
import com.intuit.graphql.graphQL.TypeSystem
import java.util.HashSet
import org.eclipse.xtext.validation.Check

class ObjectTypeValidation extends BaseValidation {
	
	@Check
	def checkForDuplicateTypes(TypeSystem typeSystem){
		val names = new HashSet()
		for (TypeDefinition type : typeSystem.typeSystemDefinition.map[t|t.type]) {
			if (!names.add(type.name)) {
				error("Duplicate name in schema: "+type.name, type)
			}
		}
	} 
	
	
}
