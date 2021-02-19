package com.intuit.graphql.validation;

import javax.inject.Inject;

import org.eclipse.emf.ecore.EObject;
import org.eclipse.emf.ecore.EStructuralFeature;
import org.eclipse.xtext.validation.AbstractDeclarativeValidator;
import org.eclipse.xtext.validation.EValidatorRegistrar;

class BaseValidation extends AbstractDeclarativeValidator {

	@Inject
	@Override
	public void register(EValidatorRegistrar registrar) {
		// nothing to do
	}

	protected void error(String message, EObject object) {
		EStructuralFeature feature = object.eClass().getEStructuralFeature("name");
		error(message, object, feature);
	}

	protected void warning(String message, EObject object) {
		EStructuralFeature feature = object.eClass().getEStructuralFeature("name");
		warning(message, object, feature);
	}
}
