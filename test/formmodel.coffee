assert = require "assert"

describe 'Test fromModel', ()->
  fm = require './../src/shared/formmodel/formmodel'
  describe '#Test geo coordinates', ()->
    o =
      "extension": [
        "extension": [
            "valueString": "59.831336"
            "url": "latitude"
          ,
            "valueString": "30.408996"
            "url": "longitude"
          ]
        "url": "http://zdrav.spb.ru"
      ,
        "extension": [
            "valueString": "59.831336"
            "url": "latitude"
          ,
            "valueString": "30.408996"
            "url": "longitude"
          ]
        "url": "http://other data"
      ]
    newo =
      "extension": [
        "extension": [
            "valueString": "60"
            "url": "latitude"
          ,
            "valueString": "30"
            "url": "longitude"
          ]
        "url": "http://zdrav.spb.ru"
      ]
    m =
      coordinates: ['','']
    res =
      coordinates: ['59.831336', '30.408996']
    change =
      coordinates: [ '60', '30']

    it '#Test geo FROM', ()->
      assert.deepEqual(fm.from(o, m), res)
    it '#Test geo TO', ()->
      assert.deepEqual(fm.to(o, change), newo)
    it '#Test geo TO from empty', ()->
      empty = {extension: []}
      rr = coordinates: ['','']
      cc = coordinates: ['30', '60']
      nnew = {
        "extension": [
          "extension": [
              "valueString": "30"
              "url": "latitude"
            ,
              "valueString": "60"
              "url": "longitude"
            ]
          "url": "http://zdrav.spb.ru"
        ]
      }
      assert.deepEqual(fm.to(empty, cc), nnew)
    
    it '#Test geo put empty geo', ()->
      empty = {extension: []}
      rr = coordinates: ['','']
      cc = coordinates: ['', '']
      nnew = {
        "extension": [
        ]
      }
      assert.deepEqual(fm.to(empty, cc), nnew)

  describe '#Test string and number first level fields', ()->
    o =
      name: 'Name before'
      numb: 5
      obj:
        foo: 'bar'
    m =
      name: ''
    res =
      name: 'Name before'
    change =
      name: 'Name after'
    newo =
      name: 'Name after'
      numb: 5
      obj:
        foo: 'bar'

    it '#Test From first level fields', ()->
      assert.deepEqual(fm.from(o, m), res)
    it '#Test TO first level fields', ()->
      assert.deepEqual(fm.to(o, change), newo)
  
  describe '#Test address field', ()->
    o =
      address: [ text: 'Address before']
      name: ''
      numb: 5
      obj:
        foo: 'bar'
    m =
      address: ''
      name: ''
    res =
      address: 'Address before'
      name: ''
    change =
      address: 'Address after'
      name: 'Name after'
    newo =
      address: [ text: 'Address after']
      name: 'Name after'
      numb: 5
      obj:
        foo: 'bar'

    it '#Test FROM address', ()->
      assert.deepEqual(fm.from(o, m), res)
    it '#Test TO address', ()->
      assert.deepEqual(fm.to(o, change), newo)
  
  describe '#Test OrgType', ()->
    o =
      type:
        "coding": [
            "display": "Гинекологические"
            "system": "medorgtype"
            "code": "10293"
          ,
            "display": "Анкология"
            "system": "OtherType"
            "code": "10277"
          ]
    m =
      medorgtype: {}
      medobjtype: {}
      opf: {}
      orglevel: {}
    res =
      medorgtype:
        code: '10293'
        system: 'medorgtype'
        display: "Гинекологические"
      medobjtype: {}
      opf: {}
      orglevel: {}
    change =
      medorgtype:
        code: '10999'
        system: 'medorgtype'
        display: "Хирургия"
      medobjtype: {}
      opf: {}
      orglevel: {}
    newo =
      type:
        "coding": [
            "display": "Хирургия"
            "system": "medorgtype"
            "code": "10999"
          ]

    it '#Test FROM OrgType', ()->
      assert.deepEqual(fm.from(o, m), res)
    it '#Test TO OrgType', ()->
      assert.deepEqual(fm.to(o, change), newo)
  
  describe '#Test Create object', ()->
    m = fm.org_form_model()
    o = fm.org_object()

    c = fm.org_form_model()
    c.name = 'New'
    c.id = 'id'
    c.oid = '1.2.643.5.1.13.3.25.78.104'
    c.fias = 'DCF9A4B1-8B4C-4235-84FD-E234FEA97559'
    c.coordinates = [60, 30]
    c.orglevel = { code: 0, display: '0', system: 'orglevel' }
    c.opf = { code: 14, display: 'dfdfdf', system: 'opf' }

    newo = fm.org_object()
    newo.name= 'New'
    newo.id= 'id'
    newo.type = {
      coding: [
                { code: 14, display: 'dfdfdf', system: 'opf' },
        { code: 0, display: '0', system: 'orglevel' }
      ]
    }
    newo.identifier= [
        {system: "oid", value: "1.2.643.5.1.13.3.25.78.104"},
        {system: "fias", value: "DCF9A4B1-8B4C-4235-84FD-E234FEA97559"}
    ]
    newo.extension= [
        extension: [{ valueString: 60, url: "latitude"},
                    {valueString: 30, url: "longitude"} ]
        url: "http://zdrav.spb.ru"
    ]

    it '#Test FROM Empty Organization object 1', ()->
      assert.deepEqual(fm.from(o, m), m)
    it '#Test TO Empty Organization from empty model', ()->
      assert.deepEqual(fm.to(o, m), o)
    it '#Test TO new Organization from model with data', ()->
      assert.deepEqual(fm.to(o, c), newo)

  describe '#Test delete data', ()->
    m = fm.org_form_model()
    o = fm.org_object()
    o.name= 'New'
    o.identifier= [
        {system: "fias", value: "DCF9A4B1-8B4C-4235-84FD-E234FEA97559"},
        {system: "inn", value: "35-84FD-E234FEA97559"},
        {system: "oid", value: "1.2.643.5.1.13.3.25.78.104"}]
    o.extension= [
        extension: [{ valueString: 60, url: "latitude"},
                    {valueString: 30, url: "longitude"} ]
        url: "http://zdrav.spb.ru"
      ,
        valueString: 'СПб ГКУЗ Центр восстановительного лечения "Детская психиатрия" имени С.С. Мнухина'
        url: "http://hl7.org/fhir/StructureDefinition/organization-alias"
    ]

    c = fm.org_form_model()
    c.name = ''
    c.shortname = ''
    c.oid = ''
    c.inn = 'inn'
    c.fias = ''
    c.coordinates = ["", ""]

    newo = fm.org_object()
    newo.name= ''
    newo.identifier= [{system: "inn", value: "inn"}]
    newo.extension= [ ]

    it '#Test delete oid fias coordinates', ()->
      assert.deepEqual(fm.to(o, c), newo)

