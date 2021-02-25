package com.intuit.graphql.converter;

import org.eclipse.xtext.common.services.DefaultTerminalConverters;
import org.eclipse.xtext.conversion.IValueConverter;
import org.eclipse.xtext.conversion.ValueConverter;
import org.eclipse.xtext.conversion.ValueConverterException;
import org.eclipse.xtext.conversion.impl.STRINGValueConverter;
import org.eclipse.xtext.nodemodel.INode;

public class GraphQLValueConverter extends DefaultTerminalConverters {

  STRINGValueConverter converter = new STRINGValueConverter();

  @ValueConverter(rule = "StringValue")
  public IValueConverter<String> ElementBound() {
    return new IValueConverter<String>() {

      @Override
      public String toValue(String string, INode node) throws ValueConverterException {

        if (string != null && string.length() > 3) {
          if (string.charAt(2) == '\'') {
            string = string.replaceAll("^\'\'\'|\'\'\'$", "\'");
          }

          if (string.charAt(0) == string.charAt(2)) {
            string = string.replaceAll("^\"\"\"|\"\"\"$", "\"");
          }
        }

        return converter.toValue(string, node);
      }

      @Override
      public String toString(String value) throws ValueConverterException {
        return converter.toString(value);
      }
    };
  }
}