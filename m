From: "Theodore Ts'o" <tytso@mit.edu>
Subject: E2fsprogs git tree
Date: Mon, 09 Jul 2007 11:02:30 -0400
Message-ID: <E1I7ukw-0001ht-T0@candygram.thunk.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:56643 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750788AbXGIPCe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 9 Jul 2007 11:02:34 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

People may have noticed that e2fsprogs 1.40 and roughly a week later
e2fsprogs 1.40.1 have been released, while there hasn't been any
activity at http://thunk.org/hg/e2fsprogs.  That's because right after
e2fsprogs 1.40, I have moved the e2fsprogs development activity over to
git.  The public repositories can be found here:

	http://www.kernel.org/pub/scm/fs/ext2/e2fsprogs.git
	git://git.kernel.org/pub/scm/fs/ext2/e2fsprogs.git

and here:

	git://repo.or.cz/e2fsprogs.git
	http://repo.or.cz/r/e2fsprogs.git

There are currently two branches, "maint" and "master".  Bug-fixes will
go on the maint branch, obvious development updates will go on the
"master" branch.  If something requires a longer cooking phase, I will
create "topic" branches and "next" and "pu" branches much like how Junio
manages the git development tree.  (The difference between "next" and
"pu" --- proposed updates --- is "maint", "master", and "next" are
guaranteed never to rewind or go "back in time", where as the "pu"
branch will get rewound and is meant for more aggressive experiments.)

People who send me patches that can be more easily merged into the
"maint" or "master" will receive a hundred blessings --- and said
patches will get merged much more quickly.  :-)

Patches that don't introduce changes to the ABI will also get accepted
much more quickly; new interfaces need to be considered very carefully,
and existing interfaces NEVER get broken without a major version number
bump of the shared library in question, and that is something we will do
only very cautiously.

							- Ted
