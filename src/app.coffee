require('file?name=/index.html!jade-env-html!./index.jade')

require('ng-cache?!jade-env-html!./404.jade')
require('ng-cache?!jade-env-html!./_index.jade')
require('./app.less')
require('angular-ui-codemirror')

fpath = require('../fhirpath.js/build/bundle.js')
# console.log(fpath)

app = angular.module('app', [
  'ngCookies'
  'ngRoute'
  'ngAnimate'
  'ui.codemirror'
  # 'firebase'
])

app.run ($rootScope, $window) ->
  console.log('run')

app.config ($routeProvider) ->
  rp = $routeProvider
  rp.when '/',
    name: 'index'
    templateUrl: '_index.jade'
    controller: 'IndexCtrl'
    reloadOnSearch: false
  rp.otherwise templateUrl: '404.jade'


app.controller 'IndexCtrl', ($scope) ->
  $scope.path = 'Patient.name.given |  Patient.name.given'
  $scope.resource = '{"resourceType": "Patient", "name": [{"given": ["John"]}]}'
  $scope.update = ()->
    try
      console.log($scope.path)
      result = fpath(JSON.parse($scope.resource),$scope.path)
      $scope.result = JSON.stringify(result[1], null, "  ")
      $scope.errors = []
    catch e
      if e.errors
        $scope.errors = e.errors
        console.log("ERROR", e.errors)
      else
        $scope.error = e.toString()
        # throw e
  $scope.update()

  console.log('here')
  codemirrorExtraKeys = window.CodeMirror.normalizeKeyMap
    "Ctrl-Space": () ->
      $scope.$apply('doMapping()')

    Tab: (cm) ->
      cm.replaceSelection("  ")

  $scope.codemirrorConfig =
    lineWrapping: false
    lineNumbers: true
    mode: 'javascript'
    extraKeys: codemirrorExtraKeys,
    viewportMargin: Infinity
