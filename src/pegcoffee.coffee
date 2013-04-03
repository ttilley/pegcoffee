###########################################
# pegcoffee                               #
# https://github.com/ttilley/pegcoffee    #
#                                         #
# Copyright (c) Apr 3, 2013 Travis Tilley #
# Licensed under the MIT license.         #
###########################################

CoffeeScript = require 'coffee-script'


STAGE = 'transform'
LOCATION = 'first'


indent = (text) ->
  text.replace(/^(.+)$/gm, '  $1')

coffeeCompile = (code, options={}) ->
  options.inline = true
  options.bare = true
  options.header = false
  indent "\n" + CoffeeScript.compile code, options

buildNodeVisitor = (visitorMap={}, scope=null) ->
  (node) ->
    visitor = visitorMap[node.type] or ->
    visitor.apply scope, arguments


module.exports = pass = (ast, options) ->

  transpileCode = (node) ->
    if node.type is 'initializer'
      wrapped = """
peg$coffee$scope = ( ->
#{node.code}
  @
).call({})
"""
    else
      wrapped = """
return ( ->
#{node.code}
).apply(peg$coffee$scope)
"""
    node.code = coffeeCompile wrapped
    node

  transpileInExpression = (node) ->
    transpile node.expression
    node

  transpileInSubnodes = (property) ->
    (node) ->
      transpile subnode for subnode in node[property]
      node

  transpile = buildNodeVisitor
    grammar:        transpileInSubnodes("rules")
    choice:         transpileInSubnodes("alternatives")
    sequence:       transpileInSubnodes("elements")
    action:         transpileCode
    rule:           transpileInExpression
    named:          transpileInExpression
    labeled:        transpileInExpression
    text:           transpileInExpression
    simple_and:     transpileInExpression
    simple_not:     transpileInExpression
    optional:       transpileInExpression
    zero_or_more:   transpileInExpression
    one_or_more:    transpileInExpression

  ast.initializer ?=
    type: "initializer"
    code: ""

  transpileCode ast.initializer
  transpile ast
  ast

module.exports.use = (config, options) ->
  stage = config.passes[STAGE]
  switch LOCATION
    when 'first' then stage.unshift pass
    when 'last'  then stage.push    pass

