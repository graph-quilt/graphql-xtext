package com.intuit.graphql.tests

import com.google.inject.Inject
import com.intuit.graphql.graphQL.Document
import com.intuit.graphql.graphQL.GraphQLPackage
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.util.ParseHelper
import org.eclipse.xtext.testing.validation.ValidationTestHelper
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.^extension.ExtendWith
import org.eclipse.xtext.testing.extensions.InjectionExtension

@InjectWith(GraphQLInjectorProvider)
@ExtendWith(InjectionExtension)
class UniontTypeValidationTest {

	@Inject
	ParseHelper<Document> parseHelper
	
	@Inject 
	ValidationTestHelper validationTestHelper

	@Test
	def void testUnionWithInterfaceMemberError() throws Exception{
		
		val document = '''
			type  Foo1 {
				foo1: String
			}
			
			type  Foo2 {
				foo2: String
			}
			
			interface  InterfaceFoo {
				foo2: String
			}
						
			union FooUnion = Foo1 | Foo2 | InterfaceFoo
		'''

		val result = parseHelper.parse(document)
		validationTestHelper.assertError(result, GraphQLPackage.Literals.UNION_TYPE_DEFINITION, null,
			"Offending member type in union 'InterfaceFoo'")
	}
	
	@Test
	def void testUnionWithScalareMemberError() {
		
		val document = '''
			type  Foo1 {
				foo1: String
			}
			
			type  Foo2 {
				foo2: String
			}
			
			interface  InterfaceFoo {
				foo2: String
			}
						
			union FooUnion = String | Int
		'''
		
		val result = parseHelper.parse(document)
		validationTestHelper.assertError(result,GraphQLPackage.Literals.UNION_TYPE_DEFINITION, null,
			"Offending member type in union 'String'")
	}
}