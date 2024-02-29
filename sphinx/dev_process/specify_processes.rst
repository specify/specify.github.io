Specify Development Process
################################

Overview
**************
At Specify, we follow a structured process when creating a new product or feature to
ensure that we deliver high-quality solutions that meet user needs. Here's the step-by-
step process we follow:

1. Vision: We start by defining the vision for the new product or feature. This includes
understanding the problem we're trying to solve and the goals we want to achieve.

2. User Stories: Based on the vision, we create user stories that describe the specific
functionality from the user's perspective. This helps us stay focused on delivering value
to our users.

3. Detailed Requirements: Once we have the user stories, we break them down into
detailed requirements. This includes defining the data model, UI/UX design, and any
other technical specifications.

4. Priorities: We then prioritize the requirements based on factors such as user impact,
value, and technical complexity.

5. Estimates Time: After prioritizing, we estimate the time required to implement each
requirement. This process enables effective planning of the project timeline and
allocation of resources.

6. Issue Creation on GitHub: For each requirement, we create an issue on GitHub to
break it down into smaller tasks. This allows us to track progress and collaborate
effectively.

7. Project Creation on GitHub: Once all the issues are created, we create a project on
GitHub to assemble all the small issues related to the feature. This provides a
centralized view of the project and helps us manage it more efficiently.

8. Build: With the project plan in place, we start building the feature. This involves
writing code, designing interfaces, and implementing the required functionality.

9. Unit Testing: After the initial build, the feature is tested by at least three different
team members on a unit level. This ensures that each component works as expected
and meets the requirements.

10. Integration Testing: Once the feature is integrated into the larger system, we
perform testing on a global level to ensure that it works seamlessly with the existing
features. This global testing will have two phases: the first phase will be conducted by
the internal specification team, and the second phase will involve an open testing week
during which clients can test the new release version and provide feedback on their
findings.

11. Launch: Finally, once the feature has been thoroughly tested and meets our quality
standards, we launch it to our users. This includes deploying the feature to production
and communicating the new feature to users.

By following this process, we ensure that we deliver high-quality products and features
that meet user needs and align with our vision.

Detailed process for new feature requests
*********************************************

1. In the case a request comes from a client, a detailed requirement document will be
requested to be sent to the support team.

2. The support team will create a feature request on GitHub with a detailed
explanation of what is needed. They will rephrase the request from the client and
use Specify’s terms to describe the needs. They will consider anything that needs
to be added on top of what the client has requested or what should be removed
from the request. The feature request will have a second part: a clear checklist of all
items that need to be present in the feature. For example, the new feature will do X
when doing Y in the component Z. The new feature will do A when doing B in the
component C. This list needs to include all places and all actions that will be
comprised in the feature.

3. In the case the feature request comes from a client, the GitHub feature request link
will be sent to the client, and approval will be requested. In other cases, the link will
be posted to the specified engineering channel.

4. The GitHub feature request will be reviewed by the lead software developer. It will
be assigned to a release and to a developer to work on.

5. Once development has started ; The pull request created by the developer
responsible for the new feature will include a detailed checklist on how to test the
branch. This list should be in total compliance with the feature request checklist but
with added detailed explanations on how to proceed with the workflow. This list
might be updated in the case the developer brings modifications to their code.

6. The testing team, when testing the branch, needs to write a comment on the PR
confirming that each point on the checklist has passed. In the case some of the
items fail, the full checklist will have to be tested again and added with a check in a
new comment during the second testing phase. This is a process that will need to
be followed for each iteration of testing. Each pull request needs 3 approvals before
being merged.