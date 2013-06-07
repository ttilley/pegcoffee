PEG = require 'pegjs'
pegcoffee = require '../src/pegcoffee'
path = require 'path'
fs = require 'fs'

parserFromFile = (filename) ->
  file = path.join __dirname, '..', 'examples', filename
  grammar = fs.readFileSync file, 'utf8'
  PEG.buildParser grammar, plugins: [pegcoffee]

describe 'example pegcoffee grammars', ->
  describe 'arithmetics.pegcoffee', ->
    beforeEach ->
      @parser = parserFromFile 'arithmetics.pegcoffee'
    it 'parses 2*(3+4)', ->
      @parser.parse('2*(3+4)').should.equal 14
    it 'parses 2*3+4', ->
      @parser.parse('2*3+4').should.equal 10

  describe 'json.pegcoffee', ->
    beforeEach ->
      @parser = parserFromFile 'json.pegcoffee'
    it 'parses null to the string "null"', ->
      @parser.parse('{"val": null}').should.eql val: 'null'
    it 'parses numbers', ->
      @parser.parse('{"val":1}').should.eql val: 1
      @parser.parse('{"val":1.2}').should.eql val: 1.2
    it 'parses strings', ->
      @parser.parse('{"val":""}').should.eql val: ''
      @parser.parse('{"val":"str"}').should.eql val: 'str'
    it 'parses boolean values', ->
      @parser.parse('{"val":true}').should.eql val: true
      @parser.parse('{"val":false}').should.eql val: false
    it 'parses arrays', ->
      @parser.parse('{"val":[]}').should.eql val: []
      @parser.parse('{"val":[1]}').should.eql val: [1]
      @parser.parse('{"val":[null, "str", 1.2]}').should.eql val: ['null', 'str', 1.2]
    it 'parses subobjects', ->
      @parser.parse('{"val":{"a":1}}').should.eql val: a: 1
