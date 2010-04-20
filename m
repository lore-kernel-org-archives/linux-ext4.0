From: "Theodore Ts'o" <tytso@mit.edu>
Subject: [GIT PULL] ext4 fixes
Date: Tue, 20 Apr 2010 17:39:28 -0400
Message-ID: <E1O4LAG-0003NN-0A@closure.thunk.org>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:40114 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750714Ab0DTVjd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 20 Apr 2010 17:39:33 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Linus,

I have some fixes for some data corruption bugs that should really get
pulled into the 2.6.34 kernel, so I'd appreciate it if you could pull
from:

        git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git for_linus

Thanks,

						- Ted

 fs/ext4/extents.c |    1 +
 fs/ext4/inode.c   |    3 ++-
 fs/ext4/mballoc.c |   21 +++++++++++----------
 3 files changed, 14 insertions(+), 11 deletions(-)

Curt Wohlgemuth (2):
      ext4: Fix possible lost inode write in no journal mode
      ext4: Fix buffer head leaks after calls to ext4_get_inode_loc()

Theodore Ts'o (1):
      ext4: Issue the discard operation *before* releasing the blocks to be reused



