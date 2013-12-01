'use strict'

describe 'Directive: rate', () ->

  # load the directive's module
  beforeEach module 'tapwalkdevApp'

  scope = {}

  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()

  it 'should make hidden element visible', inject ($compile) ->
    element = angular.element '<rate></rate>'
    element = $compile(element) scope
    expect(element.text()).toBe 'this is the rate directive'
