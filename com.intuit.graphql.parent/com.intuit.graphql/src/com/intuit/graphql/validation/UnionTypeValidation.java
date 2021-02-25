package com.intuit.graphql.validation;

import com.intuit.graphql.graphQL.NamedType;
import com.intuit.graphql.graphQL.ObjectType;
import com.intuit.graphql.graphQL.ObjectTypeDefinition;
import com.intuit.graphql.graphQL.UnionTypeDefinition;
import java.util.Objects;

import org.eclipse.emf.common.util.EList;
import org.eclipse.xtext.validation.Check;

import static com.intuit.graphql.utils.XtextTypeUtils.typeName;

class UnionTypeValidation extends BaseValidation {

	@Check
	public void checkIfMembersAreObjectTypes(UnionTypeDefinition unionTypeDefinition) {
		if (Objects.isNull(unionTypeDefinition.getUnionMemberShip())) {
			return;
		// per specifications, UnionMemberType is optional
		}
		EList<NamedType> members = unionTypeDefinition.getUnionMemberShip().getUnionMembers().getNamedUnion();
		for (NamedType namedType : members) {
			if (!isGraphQLObjectType(namedType)) {
				error("Offending member type in union '" + typeName(namedType) + "'", unionTypeDefinition);
			}
		}
	}

	private boolean isGraphQLObjectType(NamedType namedType) {
		return namedType instanceof ObjectType && ((ObjectType)namedType).getType() instanceof ObjectTypeDefinition;
	}
}
