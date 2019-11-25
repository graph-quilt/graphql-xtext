package com.intuit.graphql.validation

import org.eclipse.xtext.validation.AbstractDeclarativeValidator
import javax.inject.Inject
import org.eclipse.xtext.validation.EValidatorRegistrar
import org.eclipse.emf.ecore.EStructuralFeature
import org.eclipse.emf.ecore.EObject

class BaseValidation extends AbstractDeclarativeValidator {
	
	@Inject
	override register(EValidatorRegistrar registrar) {
		// nothing to do
	}
	def error(String message, EObject object) {
		var EStructuralFeature feature = object.eClass.getEStructuralFeature("name")
		error(message, object, feature)
	}
	def warning(String message, EObject object) {
		var EStructuralFeature feature = object.eClass.getEStructuralFeature("name")
		warning(message, object, feature)
	}
}