AWS Security
#######################

TODO:
========


Root user
------------------

* https://docs.aws.amazon.com/wellarchitected/latest/security-pillar/sec_securely_operate_aws_account.html
* MFA should be enabled on it
* only used for functions that require it
* Disable programmatic access
* Disallow creating of access keys for root account



References
==================

https://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html

From Travis Berkley:
------------------------

Another tool we have available is the Well-Architected Review.  This is a set of
design principles that you can use to design and review applications.  It is divided
into several “pillars.”  One such pillar focuses on security.
https://docs.aws.amazon.com/wellarchitected/latest/security-pillar/welcome.html
It doesn’t give proscriptive answers.  Rather, it discusses how you should think about
various facets of the security posture of the application.  For example, there are
sections on least privilege access, reducing permissions, storing and using secrets,
and many others.  This would also be a great reference to use.


