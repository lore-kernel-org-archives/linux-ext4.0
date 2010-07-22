From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 0/7] Revised set of patches for fuse-ext2
Date: Thu, 22 Jul 2010 10:03:11 -0400
Message-ID: <1279807398-13680-1-git-send-email-tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>
To: Renzo Davoli <renzo@cs.unibo.it>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:34072 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759438Ab0GVODW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 22 Jul 2010 10:03:22 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Renzo,

I didn't like how you implemented the truncate function, so I tried
implementing it myself.  I added a more generic ext2fs_punch() function
which is then used by ext2fs_file_size2().

Can you try out how well this works for you?

        	    	    	 - Ted

Renzo Davoli (1):
  libext2fs: Add new function ext2fs_file_get_inode()

Theodore Ts'o (6):
  tst_extents: Fix 64-bit bugs in do_goto_block()
  libext2fs: Fix ext2fs_iblk_{add,sub}_blocks() when the i_blocks_hi is
    non-zero
  libext2fs: Don't make a copy of the inode in ext2fs_extent_open2()
  libext2fs: Add new function ext2fs_punch()
  debugfs: Add new debugfs command punch (aka truncate)
  libext2fs: Add ext2fs_file_size_size2() and truncate the file if
    necessary

 debugfs/debug_cmds.ct  |    3 +
 debugfs/debugfs.8.in   |   12 ++
 debugfs/debugfs.c      |   31 +++++
 debugfs/debugfs.h      |    1 +
 lib/ext2fs/Makefile.in |   32 ++++-
 lib/ext2fs/ext2fs.h    |    8 ++
 lib/ext2fs/extent.c    |   27 ++---
 lib/ext2fs/fileio.c    |   28 +++--
 lib/ext2fs/i_block.c   |   17 ++--
 lib/ext2fs/punch.c     |  324 ++++++++++++++++++++++++++++++++++++++++++++++++
 10 files changed, 446 insertions(+), 37 deletions(-)
 create mode 100644 lib/ext2fs/punch.c

