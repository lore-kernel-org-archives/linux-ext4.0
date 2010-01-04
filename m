From: "Theodore Ts'o" <tytso@mit.edu>
Subject: [GIT PULL] ext4 fixes for v2.6.33
Date: Sun, 03 Jan 2010 20:21:59 -0500
Message-ID: <E1NRbdv-0006oG-Hg@closure.thunk.org>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:57900 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753172Ab0ADDKY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 3 Jan 2010 22:10:24 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Linus,

Please pull from:

        git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git for_linus

to grab a bug fix for v2.6.33.  This fixes a stupid typo and some
undesirable side effects of commit 0637c6f (which at least prevented
people from BUG'ing, but it would be great to get these fixes in before
-rc3).

Thanks!!

                                                        - Ted

Theodore Ts'o (2):
      ext4: Fix accounting of reserved metadata blocks
      ext4: Calculate metadata requirements more accurately

 fs/ext4/ext4.h         |    2 +
 fs/ext4/ext4_extents.h |    3 +-
 fs/ext4/extents.c      |   49 ++++++++++++++++++++++-----------
 fs/ext4/inode.c        |   70 +++++++++++++++++++++++++++--------------------
 fs/ext4/super.c        |    1 +
 5 files changed, 77 insertions(+), 48 deletions(-)
