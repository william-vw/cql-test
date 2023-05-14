/*
Terminology

CodeSystems
ValueSets
Codes
Concepts
Comparison
Membership Testing

*//*
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

code "Primary immune deficiency disorder": '58606001' from "SNOMED"
code "Immunoglobulin desensitization therapy": '243196004' from "SNOMED"
code "Intravenous": '255560000' from "SNOMED"

context Patient

define "Has Primary immune deficiency disorder":
  [Condition: "Primary immune deficiency disorder"] C
    where C.active = true

define "IVIG Request":
  [MedicationRequest: medication = "Immunoglobulin desensitization therapy"] M
    where M.dosageInstruction.where ( "Intravenous" ~ route.coding.first ( ) ).count ( ) ) > 0