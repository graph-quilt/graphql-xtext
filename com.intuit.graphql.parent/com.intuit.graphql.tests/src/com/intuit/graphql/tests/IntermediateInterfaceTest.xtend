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

@InjectWith(GraphQLInjectorProvider)
@ExtendWith(InjectionExtension)
class IntermediateInterfaceTest {

	@Inject
	ParseHelper<Document> parseHelper
	
	@Inject 
	ValidationTestHelper validationTestHelper
	
	@Test
	def void parseInterfaceImplementsInerfaceTest() throws Exception{
		
		val document = '''
            type Query {
               find(id: String!): Node
            }
            
            interface Node {
              id: ID!
            }
            interface Resource implements Node {
              id: ID!
              url: String
            }
		'''

		val parsed = parseHelper.parse(document)
		val errors = validationTestHelper.validate(parsed)
		Assertions.assertTrue(errors.isEmpty, '''Unexpected errors: «errors.join(", ")»''')	
	}
	
	@Test
	def void implementingInterfaceDoesNotHaveRequiredFields() throws Exception{
		
		val document = '''
            type Query {
               find(id: String!): Node
            }
            
            interface Node {
              id: ID!
            }
            interface Resource implements Node {
              url: String
            }
		'''

		val parsed = parseHelper.parse(document)
		val errors = validationTestHelper.validate(parsed) 
		//TODO: This test should fail after adding validations
		Assertions.assertTrue(errors.isEmpty, '''Unexpected errors: «errors.join(", ")»''')
	}
		
	@Test
	def void parseTransitivelyImplementedInterfacesDefinedInImplementingInterface() throws Exception{
		
		val document = '''
            type Query {
               find(id: String!): Node
            }
            
            interface Node {
              id: ID!
            }
            
            interface Resource implements Node {
              id: ID!
              url: String
            }
            interface Image implements Resource & Node {
              id: ID!
              url: String
              thumbnail: String
            }
		'''

		val parsed = parseHelper.parse(document)
		val errors = validationTestHelper.validate(parsed)
		Assertions.assertTrue(errors.isEmpty, '''Unexpected errors: «errors.join(", ")»''')	
	}
	
	@Test
	def void parseTransitivelyImplementedInterfacesDefinedInImplementingType() throws Exception{
		
		val document = '''
            type Query {
               find(id: String!): Node
            }
            
            interface Node {
              id: ID!
            }
            
            interface Resource implements Node {
              id: ID!
              url: String
            }
            type Image implements Resource & Node {
              id: ID!
              thumbnail: String
            }
		'''

		val parsed = parseHelper.parse(document)
		val errors = validationTestHelper.validate(parsed)
		Assertions.assertTrue(errors.isEmpty, '''Unexpected errors: «errors.join(", ")»''')	
	}	
	
	@Test
	def void parseFailsWhenAllTransitivelyImplementedInterfacesAreNotDefinedInImplementingInterface() throws Exception{
		
		val document = '''
            type Query {
               find(id: String!): Node
            }
            
            interface Node {
              id: ID!
            }
            
            interface Resource implements Node {
              id: ID!
              url: String
            }
            interface Image implements Resource & Node {
              id: ID!
              url: String
              thumbnail: String
            }
            
            interface LargeImage implements Image & Resource {
              id: ID!
              url: String
              thumbnail: String
              large: String
            }
		'''
		//TODO: This test should fail after adding validations
		val parsed = parseHelper.parse(document)
		val errors = validationTestHelper.validate(parsed)
		Assertions.assertTrue(errors.isEmpty, '''Unexpected errors: «errors.join(", ")»''')	
	}
	
	@Test
	def void parseFailsWhenAllTransitivelyImplementedInterfacesAreNotDefinedInImplementingType() throws Exception{
		
		val document = '''
            type Query {
               find(id: String!): Node
            }
            
            interface Node {
              id: ID!
            }
            
            interface Resource implements Node {
              id: ID!
              url: String
            }
            type Image implements Resource {
              id: ID!
              url: String
              thumbnail: String
            }
		'''
		//TODO: This test should fail after adding validations
		val parsed = parseHelper.parse(document)
		val errors = validationTestHelper.validate(parsed)
		Assertions.assertTrue(errors.isEmpty, '''Unexpected errors: «errors.join(", ")»''')	
	}	
	
	@Test
	def void parseFailsWhenInterfaceInImplementsItself() throws Exception{
		
		val document = '''
            type Query {
               find(id: String!): Node
            }
            
            interface Node implements Named & Node {
              id: ID!
              name: String
            }
            
            interface Named implements Node & Named {
              id: ID!
              name: String
            }
		'''
		//TODO: This test should fail after adding validations
		val parsed = parseHelper.parse(document)
		val errors = validationTestHelper.validate(parsed)
		Assertions.assertTrue(errors.isEmpty, '''Unexpected errors: «errors.join(", ")»''')	
	}	
	
	@Test
	def void parseInterfaceExtensionImplementsInterface() throws Exception{
		
		val document = '''
            type Query {
               find(id: String!): Node
            }
            
            interface Node {
              id: ID!
            }
            interface Resource {
              url: String
            }
            
            extend interface Resource implements Node {
                id: ID!
            }
		'''
		val parsed = parseHelper.parse(document)
		val errors = validationTestHelper.validate(parsed)
		Assertions.assertTrue(errors.isEmpty, '''Unexpected errors: «errors.join(", ")»''')	
	}	
	
	@Test
	def void parseFailsWhenInterfaceExtensionImplementsInterfaceButDoesNotDeclareRequiredFields() throws Exception{
		
		val document = '''
            type Query {
               find(id: String!): Node
            }
            
            interface Node {
              id: ID!
              extraField: String
            }
            interface Resource {
              url: String
            }
            
            extend interface Resource implements Node {
                id: ID!
            }
		'''
		//TODO: This test should fail after adding validations
		val parsed = parseHelper.parse(document)
		val errors = validationTestHelper.validate(parsed)
		Assertions.assertTrue(errors.isEmpty, '''Unexpected errors: «errors.join(", ")»''')	
	}	
	
	@Test
	def void parseFailsWhenAllTransitivelyImplementedInterfacesAreNotDefinedInImplementingInterfaceExtension() throws Exception{
		
		val document = '''
            type Query {
               find(id: String!): Node
            }
            
            interface Node {
              id: ID!
            }
            interface Resource implements Node {
              id: ID!
              url: String
            }
            
            interface Image {
                thumbnail: String!
            }
            
            extend interface Image implements Resource {
                id: ID!
                url: String
            }
		'''
		//TODO: This test should fail after adding validations
		val parsed = parseHelper.parse(document)
		val errors = validationTestHelper.validate(parsed)
		Assertions.assertTrue(errors.isEmpty, '''Unexpected errors: «errors.join(", ")»''')	
	}
	
	@Test
	def void parseFailsWhenAllTransitivelyImplementedInterfacesAreNotDefinedInImplementingTypeExtension() throws Exception{
		
		val document = '''
            type Query {
               find(id: String!): Node
            }
            
            interface Node {
              id: ID!
            }
            interface Resource implements Node {
              id: ID!
              url: String
            }
            
            type Image {
                thumbnail: String!
            }
            
            extend type Image implements Resource {
                id: ID!
                url: String
            }
		'''
		//TODO: This test should fail after adding validations
		val parsed = parseHelper.parse(document)
		val errors = validationTestHelper.validate(parsed)
		Assertions.assertTrue(errors.isEmpty, '''Unexpected errors: «errors.join(", ")»''')	
	}	
	
	@Test
	def void parseFailsWhenHierarchyResultsInCircularReference() throws Exception{
		
		val document = '''
            type Query {
               find(id: String!): Interface1
            }
            
            interface Interface1 implements Interface3 & Interface2 {
              field1: String
              field2: String
              field3: String
            }
            
            interface Interface2 implements Interface1 & Interface3 {
              field1: String
              field2: String
              field3: String
            }
            
            interface Interface3 implements Interface2 & Interface1 {
              field1: String
              field2: String
              field3: String
            }
		'''
		//TODO: This test should fail after adding validations
		val parsed = parseHelper.parse(document)
		val errors = validationTestHelper.validate(parsed)
		Assertions.assertTrue(errors.isEmpty, '''Unexpected errors: «errors.join(", ")»''')	
	}		
	
		
	@Test
	def void parseWhenFieldRequiredByExtensionImplementationIsDeclaredInOriginalInterfaceType() throws Exception{
		
		val document = '''
            type Query {
               find(id: String!): Interface1
            }
            
            interface Interface1 {
              field1: String
              field2: String
            }
            
            interface Interface2  {
              field2: String
            }
            
            extend interface Interface1 implements Interface2
		'''
		val parsed = parseHelper.parse(document)
		val errors = validationTestHelper.validate(parsed)
		Assertions.assertTrue(errors.isEmpty, '''Unexpected errors: «errors.join(", ")»''')	
	}
	
	@Test
	def void parseWhenFieldRequiredByExtensionImplementationIsDeclaredInOriginalType() throws Exception{
		
		val document = '''
            type Query {
               find(id: String!): Interface1
            }
            
            interface Interface1 {
              field1: String
              field2: String
            }
            
            interface Interface2  {
              field2: String
            }
            
            extend type Interface1 implements Interface2
            
            
            type Query {
               find(id: String!): Node
            }
            
            interface Node {
              id: ID!
            }
            interface Resource implements Node {
              id: ID!
              url: String
            }
            
            type Image {
                id: ID!
                url: String
                thumbnail: String!
            }
            
            extend type Image implements Resource & Node
		'''
		val parsed = parseHelper.parse(document)
		val errors = validationTestHelper.validate(parsed)
		Assertions.assertTrue(errors.isEmpty, '''Unexpected errors: «errors.join(", ")»''')	
	}	
	
	@Test
	def void parseFailsWhenInterfaceImplementsSameInterfaceMoreThanOnce() throws Exception{
		
		val document = '''
           type Query {
              find(id: String!): Type1
           }
           
           type Type1 implements Interface2 {
             field1: String
             field20: String
           }
           
           interface Interface2  {
             field20: String
             field21: String
           }
           
           extend type Type1 implements Interface2 {
             field21: String
           }
		'''
		//TODO: This test should fail after adding validations
		val parsed = parseHelper.parse(document)
		val errors = validationTestHelper.validate(parsed)
		Assertions.assertTrue(errors.isEmpty, '''Unexpected errors: «errors.join(", ")»''')	
	}		
}