# Support Staff Expectations & Best Practices

Welcome to the Specify Support Team\! Your role is vital to our community's success. This guide outlines our approach to providing timely, effective, and friendly support to all Specify users.

## Guiding Principles

* **Empathy First:** Users contact us when they are stuck, confused, or frustrated. Our first job is to listen, acknowledge their problem, and assure them we're here to help.  
* **Be a Guide:** Our goal isn't just to solve the immediate problem, but to empower our users. Whenever possible, guide them to the answer by linking to documentation, forum posts, or other resources. This helps them learn and become more self-sufficient.  
* **Know Our Resources:** The best answers often already exist, and if it doesn’t it should be added here and linked to.   
  Before diving deep into a problem, always check our primary knowledge sources:  
  * **Community Forum:** [https://discourse.specifysoftware.org/](https://discourse.specifysoftware.org/)  
  * **Documentation:** [https://discourse.specifysoftware.org/docs](https://discourse.specifysoftware.org/docs)  
  * **“Get Help” User Issues:** [https://discourse.specifysoftware.org/c/get-help/78](https://discourse.specifysoftware.org/c/get-help/78)  
  * **GitHub Issues:** [https://github.com/specify/specify7/issues](https://github.com/specify/specify7/issues)  
  * **Technical (Internal) Documentation:** [https://specify.github.io/](https://specify.github.io/)  
  * **Previous Emails (in support@specifysoftware.org):** [https://mail.google.com/mail/u/0/\#all](https://mail.google.com/mail/u/0/#all) 

---

## Message Etiquette

* **Be Professional and Personable:** Maintain a considerate and professional tone, but don't be afraid to be friendly. We want users to feel like they're talking to a helpful colleague.  
* **Acknowledge Quickly:** If you anticipate taking more than 30 minutes to provide a full response, send a brief reply to let the user know you've received their message and are looking into it. This manages expectations and shows we're responsive.  
* **Test, Don't Guess:** Before proposing a solution (like a query, a data mapping, or a series of steps), test it yourself on a demo or development instance. This ensures your advice is accurate and solves the problem on the first try.  
* **Speak the User's Language:** Avoid using internal database field names. Instead, use the schema captions the user has configured in their views. For example, do not refer to a field as “`stationFieldNumber`” when you could instead refer to it as the caption they have configured, for example “Field Number”.  
* **Avoid "Inside Baseball":** Do not use technical jargon with external users. Be considerate of their experience.  
* **Link Generously:** Include links to resources whenever you can. If you mention the Workbench, link to the documentation section on it. If you reference a known issue, link directly to the GitHub issue. This makes it easy for the user to get more context.

---

## Standard Troubleshooting Workflow

Following a consistent process ensures we gather all necessary information and solve issues efficiently.

1. **Understand the Goal:** First, make sure you understand what the user is *trying to achieve*. Sometimes the stated problem isn't the root cause. You can rephrase their goal back to them to confirm: *"It sounds like you're trying to bulk-update storage locations for a set of preparations. Is that correct?"*  
     
2. **Gather Essential Information:** We cannot effectively troubleshoot without context. If the user hasn't provided it, politely ask for the following:  
     
   * **Specify 7 Version:** The exact version number (e.g.,`v 7.11.0.2`), found in the ["About Specify 7" dialog](https://discourse.specifysoftware.org/t/user-tools-menu/536#p-810-about-specify-7-19). A guess is not specific enough.  
   * **System Information:** If there was no crash, ask them to follow these instructions to download their System Information: [Download Specify 7 System Information](https://www.google.com/search?q=https://discourse.specifysoftware.org/t/download-specify-7-system-information/1614).  
   * **Screenshots or Videos:** A picture is worth a thousand words. A short screen recording is even better.  
   * **Crash Report:** If the application crashed, ask them to click "Download Error Message" and attach the resulting file.  
   * **Steps to Reproduce:** Ask for a clear, step-by-step list of actions that led to the issue.

   

3. **Reproduce the Issue:** Using the information provided, try to replicate the problem on a test instance. If you can't reproduce it, the user's environment or data is likely a key factor.

   If the issue is hyperspecific to a particular database (migration error, strange behavior on certain records, error with a specific record set or WorkBench upload plan), you can refer them to our guide on how to [Send a Backup to Specify](https://discourse.specifysoftware.org/t/send-a-backup-to-specify/767). Once you receive a database, make sure to comply with any and all requests regarding confidentiality and handling.

	Crash reports can be visualized & analyzed using the [Crash Report Visualizer](https://sp7demofish.specifycloud.org/specify/developer/crash-report-visualizer) built-in to every Specify 7 instance.

4. **Consult Our Resources:** Search the **Speciforum** and **GitHub Issues** to see if this problem has been reported and solved before. Often, another user has faced the same challenge.  
     
5. **Formulate and Send the Solution:** Provide clear, step-by-step instructions. Use Markdown formatting like backticks for `code` or navigation paths (`Data > Records > Collection Object`), and use numbered lists for sequences of actions. If the answer seems like it will be applicable to others in the future, please create a new topic on the Speciforum in the appropriate documentation category and link to it in your message.  
     
6. **Follow Up:** After providing a solution, check back in to ensure it resolved their issue.

---

## Handling Common Request Types

* **"How do I...?" Questions:** These are great opportunities to educate. The best first step is to find the relevant section in our documentation at [https://discourse.specifysoftware.org/docs](https://discourse.specifysoftware.org/docs) and link the user to it. If the documentation is unclear or missing, answer their question directly and make a note to suggest an improvement to our docs.  
* **"I think I found a bug":** Follow the troubleshooting workflow to reproduce and confirm the behavior. If it's a known bug, link them to the GitHub issue so they can track its progress. If it's a new bug, please use the bug report template to gather all the necessary details. Once written up, share a link to this issue with the user and thank them for reporting it.  
* **"I have an idea for a new feature":** The best place for these discussions to start is on the Speciforum ([https://discourse.specifysoftware.org/c/new-features/37](https://discourse.specifysoftware.org/c/new-features/37)). This allows the community to weigh in. If the idea is well-received and clearly defined, we can formalize it using the feature request template for GitHub.

---

## When to Escalate or Ask for Help

You are not expected to know everything\! Please ask for help whenever you are unsure. Escalate an issue if:

* You cannot reproduce a reported bug after a couple of tries.  
* The issue involves server configuration, Docker, or other infrastructure outside the Specify application itself.  
* The user is asking for help with sensitive information like passwords.  
* The user seems frustrated or is having difficulty communicating the problem.  
* The request is about billing, hosting plans, or other consortium services. These should be directed to the main [specifysoftware.org](https://specifysoftware.org) website.

---

## Requesting Developer Assistance

When an issue is a confirmed bug, a complex data update, or a feature request that requires code changes, it needs to be escalated for development. Once you have exhausted other troubleshooting options and confirmed the need for developer intervention, please follow this process:

1.  **Consolidate Your Findings:** Gather all the information you've collected into a single summary. This must include the original user report, a link to the bug/feature ticket, steps to reproduce, screenshots, crash reports, and any relevant details from your investigation.
2.  **Assess the Impact:** Prepare a brief analysis of the issue's severity. Your summary should answer:
    * **User Perspective:** How critical is this for their workflow? Is it a minor annoyance or does it block them completely? Is there a workaround?
    * **SCC Perspective:** Does this issue affect a single user, an entire institution, or all users?
3.  **Escalate for Tasking:** Send the complete summary and support materials to the Technical Support Manager (Grant). He will review the materials, create a formal task in our project management system (Asana), and assign it to the IT Support developer for development and resolution.
4.  **Communicate with the User:** Once the task has been prioritized, relay the expected timeline for a resolution back to the user. Keep them informed of any significant progress or changes.