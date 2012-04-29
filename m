From: "Theodore Ts'o" <tytso@mit.edu>
Subject: Update of e2fsprogs pu branch and ext4 dev branch
Date: Sun, 29 Apr 2012 17:16:47 -0400
Message-ID: <E1SObU7-0004xb-KU@tytso-glaptop.cam.corp.google.com>
Cc: "Darrick J. Wong" <djwong@us.ibm.com>,
	Zheng Liu <gnehzuil.liu@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:32873 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752784Ab2D2VQu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 29 Apr 2012 17:16:50 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


I have updated the pu ("proposed updates") branch of e2fsprogs to
include the metadata checksum and inline data patches rebased against
the lastest changes in the e2fsprogs repository.  Note that these
patches have not been fully reviewed yet, and are still subject to
change!  In particular, the metadata checksum patches still have the
issue with the jbd2 checksuming code breaking 64-bit block numbers, and
inline data branches are causing a regression test failure.  I've
integrated them into the pu branch to make it easier for me to review
and test these changes, and so that other developers can see what is
going on.

I also had to make some changes to the last inline data patch so that it
would apply given the changes which the metadata checksum patch series
had made to e2fsck/pass2.c.  I am not sure I did all off those changes
correctly, and I'd invite Darrick and Zheng to take a look at them to
make sure I didn't really screw something up.

As I've mentioned, the regression tests mostly pass, but critically
missing from both patch series are any kind of regression tests.  I
would really appreciate it if you would consider creating some of
those.  We may find some interesting bugs as part of the test creation
and validation process.

The pu branch is a **rewinding** branch; that is to say, I will be
periodically rebasing the patches on the pu branch to take into account
movement in the e2fsprogs master branch.  If you want to make any
changes to the patches at this point, please fork the following patch
queue on github, make the changes, and then (a) send the updated patch
to the mailing list, and (b) push it to github and ask me to pull it
from your tree.  That will save me a lot of time.  The github repo is
at:

	git://github.com/tytso/e2fsprogs-cksum-patch-queue.git
 
and the github page can be found at:

	https://github.com/tytso/e2fsprogs-cksum-patch-queue

I have been using the "guilt" package to manipulate the patch tree, but
you can also you quilt for the same purpose.


I have also added the first half of the metadata checksum patches to the
ext4 development tree.  Again, I've not fully finished reviewing the
patches, but they pass the regression test in the standard ext4 modes.
I haven't had a chance to enable metadata checksuming yet, and the jbd2
patches clearly need some revision (which is why they aren't in the ext4
patch queue yet).

The ext4 patch queue is also on github:

	git://github.com/tytso/ext4-patch-queue.git
	https://github.com/tytso/ext4-patch-queue/commits/master

The same comment applies for updating the patches that are on the
ext4-patch-queue.  Please start with the version of the patches in this
git tree, since I have had to make some changes so they would apply
cleanly against the latest kernel release.

There is a comment in the series file which indicates the commit ID of
e2fsprogs/ext4 the patchsets are currently based upon.  When I rebase
the patches to take into account newer commits, I will update the commit
ID in the series file.

						- Ted

