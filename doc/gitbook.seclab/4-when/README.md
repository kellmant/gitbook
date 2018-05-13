# When Do We Start?

When does this happen? When does it stop? When is it too late?
Gitbook of actions/results returned for each phase.

Project starts the 28th of May 2018

---

{% uml %}
@startuml
Project starts the 7th of may 2018
saturday are closed
sunday are closed
[Assess] lasts 5 days and is colored in Orange
-- Chapter 1 --
[Build] lasts 5 days and is colored in LightPink/FireBrick
-- Chapter 2 --
[Development] lasts 10 days and is colored in LightBlue
-- Chapter 3 --
[Acceptance] lasts 10 days and is colored in Yellow
-- Chapter 4 --
[Production] lasts 5 days and is colored in GreenYellow
-- Epilogue --
[Assess] -> [Build]
[Build] -> [Development]
[Development] -> [Acceptance]
[Acceptance] -> [Production]
@enduml
{% enduml %}

---

**Assess** - Onsite interview for collection of technology platforms as they align to overall goals. Define overall variable templates in the form of JSON for customer acceptance. Once completed, the story takes us through the phases.

### Chapters

1. **Build** - Staging of proof of concept code, focus is on the operational model with little concern to optimization or security. Demonstrate a flow or process points for data transformation. Acceptance of concepts before development work begins.

1. **Development** - Generation of production ready code with a focus on scalability and security authorization. Optimization of the PoC designs in higher level language, with support and deployment process. Incorporate monitoring tools and processes as early as possible in the development of your application. Monitoring is about more than just production performance: You must be aware of the health of the application at all stages of development. By monitoring earlier in the process you will gain valuable insight into the application before it goes to production, making it easier to correlate and compare how the application behaved in test environments and in production. Test result expectations are defined and must meet automated requirements of testing to move to UAT.

1. **Acceptance Testing** - Limited rollout for user testing after confirmation of automated test suites. Confirm customer targets can be validated in real world usage. Measure to determine which features in your application are most valuable and which are at least valuable. Many features and functions are never used. They're expensive to maintain and make innovation more difficult, effectively slowing down your team.

1. **Production** - Deployment of services for production consumption. Measurement of response and continues sample testing of results.


**Epiloge** - Everything is an experiment of sorts. Assessing the outcome and impact is a critical discipline that IT must embrace in its journey to implement DevOps. The process must be automatic, continuous, and comprehensive. Without continuous assessment in your DevOps toolkit, you run the risk of flying blind and missing huge opportunities that are easily within your grasp. As a consequence, the final chapter should include a return to the assessment of the service, and the application of changes at an increasing rate of deployment. This increase should match the velocity of change within the overall organization.
