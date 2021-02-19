package com.intuit.graphql.tests

import com.google.inject.Inject
import com.intuit.graphql.graphQL.Document
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.extensions.InjectionExtension
import org.eclipse.xtext.testing.util.ParseHelper
import org.eclipse.xtext.testing.validation.ValidationTestHelper
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.^extension.ExtendWith

@ExtendWith(InjectionExtension)
@InjectWith(GraphQLInjectorProvider)
class OperationTypeValidationTest {
	@Inject extension ParseHelper<Document>
	@Inject extension ValidationTestHelper

	@Test
	def void namedQueryOperationType() {
		'''
			query MyQuery {
			  consumer {
			    id
			  }
			}
		'''.parse.assertNoErrors
	}

	@Test
	def void queryOperationType() {
		'''
			query {
			  consumer {
			    id
			  }
			}
		'''.parse.assertNoErrors
	}

	@Test
	def void namedMutationOperationType() {
		'''
			mutation MyMutation {
			  likeStory(storyID: 12345) {
			    story {
			      likeCount
			    }
			  }
			}	
		'''.parse.assertNoErrors
	}

	@Test
	def void mutationOperationType() {
		'''
			mutation {
			  likeStory(storyID: 12345) {
			    story {
			      likeCount
			    }
			  }
			}	
		'''.parse.assertNoErrors
	}

	@Test
	def void selectionSets() {
		'''
			{
			  id
			  firstName
			  lastName
			}	
		'''.parse.assertNoErrors
	}

	@Test
	def void schemaDefinition() {
		'''
			schema {
			  query: MyQueryRootType
			  mutation: MyMutationRootType
			}
			
			type MyQueryRootType {
			  someField: String
			}
			
			type MyMutationRootType {
			  setSomeField(to: String): String
			}
		'''.parse.assertNoErrors
	}

	@Test
	def void defaultRootOperationTypes() {
		'''
			type Query {
			  someField: String
			}
			
			type Mutation {
			  setSomeField(to: String): String
			}
		'''.parse.assertNoErrors
	}

	@Test
	def void queryWithVariableDefinition() {
		'''
			query getZuckProfile($devicePicSize: Int) {
			  user(id: 4) {
			    id
			    name
			    profilePic(size: $devicePicSize)
			  }
			}
		'''.parse.assertNoErrors
	}

}
