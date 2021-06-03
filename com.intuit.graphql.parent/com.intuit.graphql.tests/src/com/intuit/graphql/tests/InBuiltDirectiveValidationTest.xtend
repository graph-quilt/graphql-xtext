package com.intuit.graphql.tests

import com.google.inject.Inject
import com.intuit.graphql.graphQL.Document
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.util.ParseHelper
import org.eclipse.xtext.testing.validation.ValidationTestHelper
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.^extension.ExtendWith
import org.eclipse.xtext.testing.extensions.InjectionExtension

@InjectWith(GraphQLInjectorProvider)
@ExtendWith(InjectionExtension)
class InBuiltDirectiveValidationTest {

	@Inject
	ParseHelper<Document> parseHelper
	
	@Inject 
	ValidationTestHelper validationTestHelper
	
	@Test
	def void deprecatedDirectiveDefined() throws Exception{
		
		val document = '''
			type  Foo1 {
				foo1: String  @deprecated(reason : "reason `in markdown syntax`")
			}
			
			directive @deprecated(reason: String = "No longer supported") on FIELD_DEFINITION | ENUM_VALUE
			
		'''

		val result = parseHelper.parse(document)
		validationTestHelper.validate(result)	}
	
	@Test
	def void deprecatedDirectiveNotDefined() throws Exception{
		
		val document = '''
			type  Foo1 {
				foo1: String  @deprecated(reason : "reason `in markdown syntax`")
			}
		'''

		val result = parseHelper.parse(document)
		validationTestHelper.validate(result)

	}
	
	@Test
	def void deprecatedDirectiveDefinedTwice() {
		
		val document = '''
			type  Foo1 {
				foo1: String @deprecated(reason : "reason `in markdown syntax`")
			}
		
						
			directive @deprecated(reason: String = "No longer supported") on FIELD_DEFINITION | ENUM_VALUE
			directive @deprecated(reason: String = "No longer supported") on FIELD_DEFINITION | ENUM_VALUE
		'''
		
		parseHelper.parse(document)
		
	}
}