# Who should be involved?

Who is the target audience? Who can contribute to an overall framework?

---

Surprise, you already have a DevOps team. It's all of you.

1. Employees
  * Development
  * Network
  * Security
  * Helpdesk
  * Compliance
  * Finance
  * Sales
  * Operations
1. Customers
  * Gold
  * Silver
1. Infrastructure
  * Platform Providers
  * Software Development
  * Devices
  * Data Center

---

## Trust No One, Verify Everything

  {% uml %}
  @startuml
  title Trust No One

  skinparam handwritten true
  skinparam sequence {
      ArrowColor black
      ActorBorderColor black
      LifeLineBorderColor Crimson
      LifeLineBackgroundColor #A9DCDF
      ParticipantBorderColor DeepSkyBlue
      ParticipantBackgroundColor black
      ParticipantFontName Impact
      ParticipantFontSize 17
      ParticipantFontColor white
      ActorBackgroundColor white
      ActorFontColor blue
      ActorFontSize 17
      ActorFontName Aapex
  }

  actor Request
  participant "Trust" as IDT
  participant "Directory" as AD
  participant "Certificate" as ORCA
  participant "Token" as RSA
  participant "Biometric" as BIO

  group Trusted
  Request -> IDT : <b> Trust Request </b>
  activate IDT

  group User Directory
  IDT -> AD : ldap://user@group, AD query
  AD -> IDT : exists today, trusted
  note left : Easy to integrate \n established roles
  end

  group Origin Root CA
  IDT -> ORCA : auth CN=User
  ORCA -> IDT : temporary or long term certificate, encrypted
  note left : Strong protection \ntls pinning
  end

  group Device Token
  IDT -> RSA : one time password
  RSA -> IDT : can be time limited, no password recall, layered authentication
  note left : No password exposed \ntwo factor
  end

  group Biometric Analysis
  IDT -> BIO : Something they are
  BIO -> IDT : unique to individual, strong additional factor complex to manage limited use
  note left : Strong marker \n2nd factor of identity
  end
  end

  deactivate IDT
  @enduml
  {% enduml %}

---

  {% uml %}
  @startuml
  title Verify Everything

  skinparam handwritten true
  skinparam sequence {
      ArrowColor black
      ActorBorderColor black
      LifeLineBorderColor Crimson
      LifeLineBackgroundColor #A9DCDF
      ParticipantBorderColor DeepSkyBlue
      ParticipantBackgroundColor black
      ParticipantFontName Impact
      ParticipantFontSize 17
      ParticipantFontColor white
      ActorBackgroundColor white
      ActorFontColor blue
      ActorFontSize 17
      ActorFontName Aapex
  }

  actor Request
  participant "Verify" as IDA
  participant "Social" as OAUTH
  participant "Device" as DEVICE
  participant "Applications" as APP
  participant "Learned" as ML

  activate IDA

  group Verified
  Request -> IDA : <b> Verify Request </b>
  activate IDA

  group OAuth Tokens
  IDA --> OAUTH : 3rd party API
  OAUTH -> IDA : oauth token
  note left : Social media activity\nonline presence
  end

  group Device Mobility
  IDA --> DEVICE : Contact number
  DEVICE -> IDA : unique arnid
  note left : Qualify hardware \ndevice ownership
  end

  group Shared Applications
  IDA -> APP : In app, REST, shared db
  APP -> IDA : custom tools, app signatures, activity
  note left : Leverage SaaS/PaaS\ninternal apps
  end

  group Machine Learning
  IDA --> ML : Learned Behavior over time
  ML --> IDA : validate identifiers over time, not valid without correlation,\n proactive and unique risk detection
  note left : ML training complex\ntransparent to user
  end
  end

  deactivate IDA
  @enduml
  {% enduml %}

---
