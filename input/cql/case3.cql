library case3

using FHIR version '4.0.1'

include FHIRHelpers version '4.0.1'

codesystem "SNOMED": 'http://snomed.info/sct'
codesystem "EventStatus": 'http://hl7.org/fhir/event-status'
codesystem "FinancialStatus": 'http://hl7.org/fhir/fm-status'
codesystem "CoverageClass": 'http://terminology.hl7.org/CodeSystem/coverage-class'

code "Transplantation": '77465005' from "SNOMED"
code "Completed": 'completed' from "EventStatus"
code "Active": 'active' from "FinancialStatus"
code "ClassType": 'class' from "CoverageClass"
code "SubClassType": 'subclass' from "CoverageClass"

define "Prior transplant":
  [Procedure: "Transplantation"] P
    where P.status = 'completed'

define "Medicare Covered Transplant":
  [Procedure: "Transplantation"] P
    with "ClaimFromPartA" Cl
      such that Cl.procedure.where ( procedure.reference = P.id ).exists ( )
    where P.status = 'completed'

define "ClaimFromPartA":
  [Claim] Cl
    with [Coverage] Co
      such that Co.payor.where ( reference = 'Medicare' ).exists ( )
        and Co.class.where ( type = "ClassType"
          and value.value = 'Part A' ).exists ( )
        and Co.status = 'active'
        and Cl.insurance.where ( coverage.reference = Co.id ).exists ( )

define "PartBCoversImmunoTherapy":
  [Coverage] Co
    where Co.payor.where ( reference = 'Medicare' ).exists ( )
      and Co.class.where ( type = "ClassType"
        and value.value = 'Part B' ).exists ( )
      and Co.status = 'active'

// TODO need to have MedicationRequest and compare its date with 36 months after transplant
define "PartB_ESRD_CoversImmunoTherapy":
  [Coverage] Co
    with "Medicare Covered Transplant" T
      such that T.performed 36 months before end Co.period
    where Co.payor.where ( reference = 'Medicare' ).exists ( )
      and Co.class.where ( type = "SubClassType"
        and value.value = 'Part B - ESRD' ).exists ( )
      and Co.status = 'active'