package com.intuit.graphql.tests

import com.google.inject.Inject
import com.intuit.graphql.graphQL.Document
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.util.ParseHelper
import org.eclipse.xtext.testing.validation.ValidationTestHelper
import org.junit.jupiter.api.Test
import org.eclipse.xtext.testing.extensions.InjectionExtension
import org.junit.jupiter.api.Assertions
import com.intuit.graphql.graphQL.TypeSystem
import org.junit.jupiter.api.^extension.ExtendWith
import com.intuit.graphql.graphQL.GraphQLPackage
import com.intuit.graphql.graphQL.ScalarTypeDefinition
import com.intuit.graphql.graphQL.ObjectTypeDefinition
import com.intuit.graphql.graphQL.ObjectTypeExtensionDefinition

@InjectWith(GraphQLInjectorProvider)
@ExtendWith(InjectionExtension)
class DirectiveValidationTest {

	@Inject
	ParseHelper<Document> parseHelper
	
	@Inject 
	ValidationTestHelper validationTestHelper
	
	@Test
	def void testInBuiltDirectiveCanBeDefined() throws Exception{
		
		val document = '''
			type  Foo1 {
				foo1: String  @deprecated(reason : "reason `in markdown syntax`")
			}
			
			directive @deprecated(reason: String = "No longer supported") on FIELD_DEFINITION | ENUM_VALUE
			
		'''

		val parsed = parseHelper.parse(document)
		val errors = validationTestHelper.validate(parsed)
		Assertions.assertTrue(errors.isEmpty, '''Unexpected errors: «errors.join(", ")»''')	
	}
	
	@Test
	def void testInBuilDirectiveCanBeUsedWithoutDefinition() throws Exception{
		
		val document = '''
			type  Foo1 {
				foo1: String  @deprecated(reason : "reason `in markdown syntax`")
			}
		'''

		val parsed = parseHelper.parse(document)
		val errors = validationTestHelper.validate(parsed)
		Assertions.assertTrue(errors.isEmpty, '''Unexpected errors: «errors.join(", ")»''')

	}
	
	@Test
	def void testAnyDirectiveCannotBeDefinedTwice() {
		
		val document = '''
			type  Foo1 {
				foo1: String @customDir(reason : "reason `in markdown syntax`")
			}
						
			directive @customDir(reason: String = "No longer supported") on FIELD_DEFINITION | ENUM_VALUE
			directive @customDir(reason: String = "No longer supported") on FIELD_DEFINITION | ENUM_VALUE
		'''
		
		val parsed = parseHelper.parse(document)
		validationTestHelper.assertError(parsed, GraphQLPackage.Literals.DIRECTIVE_DEFINITION, null,
			"Duplicate directives in schema: customDir")
	}
	
	@Test
	def void testNumberOfInBuiltDirectives() {
		
		val document = '''
			type  Foo1 {
				foo1: String @deprecated(reason : "reason `in markdown syntax`")
			}
		'''
		
		val parsed = parseHelper.parse(document)
		val errors = validationTestHelper.validate(parsed)
		Assertions.assertTrue(errors.isEmpty, '''Unexpected errors: «errors.join(", ")»''')
		
		val count = (parsed as TypeSystem).typeSystemDefinition
		 	.map[ type | type.directive]
		 	.filterNull
		    .size
		 	
		Assertions.assertEquals(4 , count)	
		
	}
	
	@Test
	def void testUrlOfSpecifiedByDirective() {
		
		val document = '''
			type  Foo1 {
				foo: MyScalar
			}
			scalar MyScalar @specifiedBy(url: "myUrl.example")
		'''
		
		val parsed = parseHelper.parse(document)
		val errors = validationTestHelper.validate(parsed)
		Assertions.assertTrue(errors.isEmpty, '''Unexpected errors: «errors.join(", ")»''')
		
		val directives = (parsed as TypeSystem).typeSystemDefinition
		 	.map[ type | type.type]
		 	.filterNull
		 	.filter(ScalarTypeDefinition)
		 	.filter[s | s.name == 'MyScalar']
		 	.flatMap[s | s.directives]
		 	.toMap([d | d.definition.name], [d | d])
		    
		 	
		Assertions.assertEquals(1 , directives.size)
		
		val specifiedBy = directives.get('specifiedBy')	
		Assertions.assertEquals('myUrl.example', specifiedBy.arguments.get(0).valueWithVariable.stringValue)
		Assertions.assertFalse(specifiedBy.definition.isRepeatable)
	}
	
	@Test
	def void testRepeatableDirective() {
		
		val document = '''
			directive @delegateField(name: String!) repeatable on OBJECT | INTERFACE
			type Book @delegateField(name: "pageCount") @delegateField(name: "author") {
			  id: ID!
			}
			extend type Book @delegateField(name: "index")	
		'''
		
		val parsed = parseHelper.parse(document)
		val errors = validationTestHelper.validate(parsed)
		Assertions.assertTrue(errors.isEmpty, '''Unexpected errors: «errors.join(", ")»''')
		
		val directives = (parsed as TypeSystem).typeSystemDefinition
		 	.map[ type | type.type]
		 	.filterNull
		 	.filter(ObjectTypeDefinition)
		 	.filter[s | s.name == 'Book']
		 	.flatMap[s | s.directives]
		 	.toList
		    		 	
		Assertions.assertEquals(2 , directives.size)
		directives.forEach[ d | Assertions.assertTrue(d.definition.isRepeatable)]
		
		
			val extDirectives = (parsed as TypeSystem).typeSystemDefinition
		 	.map[ type | type.typeExtension]
		 	.filterNull
		 	.filter(ObjectTypeExtensionDefinition)
		 	.filter[s | s.name == 'Book']
		 	.flatMap[s | s.directives]
		 	.toList
		    		 	
		Assertions.assertEquals(1 , extDirectives.size)
		extDirectives.forEach[ d | Assertions.assertTrue(d.definition.isRepeatable)]
	}	
	
}