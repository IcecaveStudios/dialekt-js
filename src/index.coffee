module.exports =
  AST       : require './AST/index' 
  Evaluator : require './Evaluator/index'
  Exception : require './Exception/index'
  Parser    : require './Parser/index'
  Renderer  : require './Renderer/index'
  version   : require('../package.json').version
