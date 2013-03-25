util = require 'util'
pegjs_utils = require 'pegjs/lib/utils'
coffeeScript = require 'coffee-script'


compileCoffeeScript = (text, ast) ->
  try
    coffeeScript.compile text,
      bare: true
  catch error
    throw new SyntaxError(
      """
      In: "#{text}"
      was the following error: #{error.message}
      AST node:
      #{util.inspect ast, {depth:3, colors:true}}
      """
    )


indent = (text) ->
  text.replace(/^(.+)$/gm, '    $1')


generateInitializer = (ast) ->
  ast.initializer ?=
    type: "initializer"
    code: ""

  coffeeInitializer =
    """
    peg$coffee$scope = (
      ->
    #{indent(ast.initializer.code)}
        return this
    ).call({})
    """
  ast.initializer.code = compileCoffeeScript(coffeeInitializer, ast)


generateCode = (ast) ->
  return this unless ast.code

  coffeeCode =
    """
    return (
      ->
    #{indent(ast.code)}
    ).apply(peg$coffee$scope)
    """
  ast.code = compileCoffeeScript(coffeeCode, ast)


nop = ->


replaceInSubnodes = (property) ->
  (ast) ->
    pegjs_utils.each ast[property], generate

replaceInExpression = (ast) ->
  generate(ast.expression)


generate = pegjs_utils.buildNodeVisitor
  grammar: (ast) ->
    generateInitializer ast
    replaceInSubnodes("rules")(ast)
  choice: replaceInSubnodes("alternatives")
  sequence: replaceInSubnodes("elements")
  action: generateCode
  rule: replaceInExpression
  named: replaceInExpression
  labeled: replaceInExpression
  text: replaceInExpression
  simple_and: replaceInExpression
  simple_not: replaceInExpression
  semantic_and: nop
  semantic_not: nop
  optional: replaceInExpression
  zero_or_more: replaceInExpression
  one_or_more: replaceInExpression
  rule_ref: nop
  literal: nop
  class: nop
  any: nop


coffeeCompilerPass = (ast, options) ->
  generate ast, options

module.exports.use = (config) ->
  config.passes['transform'].unshift coffeeCompilerPass

