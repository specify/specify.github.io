Fix Exposed Secrets
############################


If a secret or password is inadvertently exposed through Github or some other site
on the web, not only must it be deleted as soon as possible, but the password must
be changed or the secret revoked.

Secrets
***************

You must understand the implications of revoking this secret by investigating where it
is used in your code and on any virtual or physical machines or processes.

* Create another secret and replace all instances of the old one with the new
* Make your secret unusable by revoking it
* Store the new secret safely. `GitGuardian best practices
  <https://blog.gitguardian.com/secrets-api-management/?utm_source=product&utm_medium=product&utm_campaign=white_knight_v2>`_



Github
-----------------

Making your repository private is not sufficient

* **Do not** commit on top of the current source code

* If the secret is in the last commit

  * Remove from file
  * Edit previous commit
  * Force push changes

.. code-block::

    git add <path to file with exposed secret>
    git commit --amend
    git push --all --force
    git push --tags --force

