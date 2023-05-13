/*
Terminology

CodeSystems
ValueSets
Codes
Concepts
Comparison
Membership Testing

*/
library case1

using FHIR version '4.0.1'

include FHIRHelpers version '4.0.1'

codesystem "SNOMED": 'http://snomed.info/sct'

code "Postmenopausal osteoporosis": '102447009' from "SNOMED"
code "Osteoporotic fracture of bone": '443165006' from "SNOMED"
code "Product containing teriparatide": '398823001' from "SNOMED"
code "Inject": '740685003' from "SNOMED"

context Patient

define "Female Patient": Patient.gender = 'female'

define "Practitioner": 
  Patient.generalPractitioner[0]

define "Osteoporosis Condition":
  [Condition: "Postmenopausal osteoporosis"]

define "Fracture due to Osteoporosis":
  [Condition: "Osteoporotic fracture of bone"]

define "Teriparatide Request":
  [MedicationRequest: medication = "Product containing teriparatide"] M
    // where M.dosageInstruction[0].route.coding[0].code.value = '740685003'
    // where "Inject" ~ M.dosageInstruction[0].route.coding[0]
    // where "Inject" ~ M.dosageInstruction.single().route.coding.single()
    where M.dosageInstruction.where("Inject" ~ route.coding.first()).count() > 0
      and M.requester = "Practitioner"
      and M.performer = "Practitioner"