From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Explanation of different branches in git tree
Date: Mon, 22 Oct 2007 21:15:15 +0530
Message-ID: <471CC58B.904@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Theodore Tso <tytso@mit.edu>,
	linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:34294 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990AbXJVPpV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 22 Oct 2007 11:45:21 -0400
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp05.au.ibm.com (8.13.1/8.13.1) with ESMTP id l9MFjIFK030492
	for <linux-ext4@vger.kernel.org>; Tue, 23 Oct 2007 01:45:18 +1000
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l9MFjI402412626
	for <linux-ext4@vger.kernel.org>; Tue, 23 Oct 2007 01:45:19 +1000
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l9MFjIx6022513
	for <linux-ext4@vger.kernel.org>; Tue, 23 Oct 2007 01:45:18 +1000
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

I gues Ted is following the same terminology. 

http://marc.info/?l=git&m=117965490313979&w=2

There are four branches in git.git repository that track the
source tree of git: "master", "maint", "next", and "pu".  I may
add more maintenance branches (e.g. "maint-1.5.1") if we have
huge backward incompatible feature updates in the future to keep
an older release alive; I may not, but the distributed nature of
git means any volunteer can run a stable-tree like that himself.

The "master" branch is meant to contain what are very well
tested and ready to be used in a production setting.  There
could occasionally be minor breakages or brown paper bag bugs
but they are not expected to be anything major.  Every now and
then, a "feature release" is cut from the tip of this branch and
they typically are named with three dotted decimal digits.  The
last such release was v1.5.2 done on May 20th this year.

Whenever a feature release is made, "maint" branch is forked off
from "master" at that point.  Obvious, safe and urgent fixes
after a feature release are applied to this branch and
maintenance releases are cut from it.  The maintenance releases
are named with four dotted decimal, named after the feature
release they are updates to; the last such release was v1.5.1.6.
New features never go to this branch.  This branch is also
merged into "master" to propagate the fixes forward.

A trivial and safe enhancement goes directly on top of "master".
A new development, either initiated by myself or more often by
somebody who found his or her own itch to scratch, does not
usually happen on "master", however.  Instead, a separate topic
branch is forked from the tip of "master", and it first is
tested in isolation; I may make minimum fixups at this point.
Usually there are a handful such topic branches that are running
ahead of "master" in git.git repository.  I do not publish the
tip of these branches in my public repository, however, partly
to keep the number of branches that downstream developers need
to worry about low, and primarily because I am lazy.

I judge the quality of topic branches, taking advices from the
mailing list discussions.  Some of them start out as "good idea
but obviously is broken in some areas (e.g. breaks the existing
testsuite)" and then with some more work (either by the original
contributor or help from other people on the list) becomes "more
or less done and can now be tested by wider audience".  Luckily,
most of them start out in the latter, better shape.

The "next" branch is to merge and test topic branches in the
latter category.  In general, the branch always contains the tip
of "master".  It might not be quite rock-solid production ready,
but is expected to work more or less without major breakage.  I
usually use "next" version of git for my own work, so it cannot
be _that_ broken to prevent me from pushing the changes out.
The "next" branch is where new and exciting things take place.

The above three branches, "master", "maint" and "next" are never
rewound, so you should be able to safely track them (this
automatically means the topics that have been merged into "next"
are not rebased, and you can find the tip of topic branches you
are interested in from the output of "git log next").

The "pu" (proposed updates) branch bundles all the remainder of
topic branches.  The "pu" branch, and topic branches that are
only in "pu", are subject to rebasing in general.

When a topic that was in "pu" proves to be in testable shape, it
graduates to "next".  I do this with:

        git checkout next
        git merge that-topic-branch

Sometimes, an idea that looked promising turns out to be not so
hot and the topic can be dropped from "pu" in such a case.

A topic that is in "next" is expected to be tweaked and fixed to
perfection before it is merged to "master" (that's why "master"
can be expected to stay very stable).  Similarly to the above I
do it with this:

        git checkout master
        git merge that-topic-branch
        git branch -d that-topic-branch

However, being in "next" is not a guarantee to appear in the
next release (being in "master" is such a guarantee, unless it
is later found seriously broken and reverted), or even in any
future release.  There even were cases that topics needed
reverting a few commits in them before graduating to "master",
or a topic that already was in "next" were entirely reverted
from "next" because fatal flaws were found in them later.
