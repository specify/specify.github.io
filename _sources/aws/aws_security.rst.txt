AWS Security
#######################

TODO:
========

Security best practices, including:
* role overview
* how to determine smallest workable permissions for manual/console and automated processes
* best way to include authentication in scripts and automated processes (secrets vs
  manually configuring things)
* how to handle names of less secret information in order to retrieve authentication
  and access resources, so how best to deal with account numbers, usernames,
  role names, secret names, domain names, bucket names, etc


References
==================

https://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html

From Travis Berkley:
------------

Another tool we have available is the Well-Architected Review.  This is a set of
design principles that you can use to design and review applications.  It is divided
into several “pillars.”  One such pillar focuses on security.
https://docs.aws.amazon.com/wellarchitected/latest/security-pillar/welcome.html
It doesn’t give proscriptive answers.  Rather, it discusses how you should think about
various facets of the security posture of the application.  For example, there are
sections on least privilege access, reducing permissions, storing and using secrets,
and many others.  This would also be a great reference to use.


