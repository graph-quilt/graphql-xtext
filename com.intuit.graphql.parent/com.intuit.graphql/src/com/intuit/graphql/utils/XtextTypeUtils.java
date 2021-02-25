package com.intuit.graphql.utils;

import java.util.Objects;
import com.intuit.graphql.graphQL.InterfaceTypeDefinition;
import com.intuit.graphql.graphQL.ListType;
import com.intuit.graphql.graphQL.NamedType;
import com.intuit.graphql.graphQL.ObjectType;
import com.intuit.graphql.graphQL.PrimitiveType;
import com.intuit.graphql.graphQL.TypeDefinition;
import com.intuit.graphql.graphQL.UnionTypeDefinition;

public class XtextTypeUtils {

  public static boolean isNotWrapped(NamedType type) {
    return !isWrapped(type);
  }

  public static boolean isWrapped(NamedType type) {
    return isListType(type);
  }

  public static boolean isNonNull(NamedType type) {
    return type.isNonNull();
  }

  public static boolean isListType(NamedType type) {
    return type instanceof ListType;
  }

  public static NamedType unwrapOne(NamedType type) {
    if (isListType(type)) {
      return ((ListType) type).getType();
    }
    return type;
  }


  /**
   * Returns the innermost ObjectType or PrimitiveType
   */
  public static NamedType unwrapAll(NamedType type) {
    while (true) {
      if (isNotWrapped(type)) {
        return type;
      }
      type = unwrapOne(type);
    }
  }

  public static String typeName(NamedType type) {
    type = unwrapAll(type);
    if (type instanceof PrimitiveType) {
      return ((PrimitiveType) type).getType();
    }
    return ((ObjectType) type).getType().getName();
  }

  public static TypeDefinition getObjectType(NamedType type) {
    if (Objects.nonNull(type) && type instanceof ObjectType) {
      return ((ObjectType) type).getType();
    }
    return null;
  }

  public static boolean isInterfaceOrUnionType(NamedType type) {
    final TypeDefinition typeDefinition = getObjectType(type);
    if (Objects.nonNull(typeDefinition)) {
      return typeDefinition instanceof InterfaceTypeDefinition
          || typeDefinition instanceof UnionTypeDefinition;
    }
    return false;
  }

}
