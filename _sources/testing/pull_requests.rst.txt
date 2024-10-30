Pull Request Testing
########################

Developers
=======================

Follow instructions in the Github PR template for writing detailed testing instructions.

Testers:
=======================

* Copy and paste developer's instructions for testing into your testing comment.
* Check the passing tests
* Describe any failures in detail, with screenshots where helpful.

PRs tagged with label "Migration"
=======================

* Download the current database you’ll be working with.
* Upload a duplicate of this database with a new name format:
  oldDatabaseName_migration4847 (or similar, based on the migration number).
* Create a branch with this duplicate database.
* Run the tests on this branch.
* Once testing is complete, delete the duplicate database on which the migration was run.