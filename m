From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] ext4: don't read inode block if the buffer has a write error
Date: Sat, 26 Jul 2008 20:26:52 -0400
Message-ID: <1217118414-18636-2-git-send-email-tytso@mit.edu>
References: <1217118414-18636-1-git-send-email-tytso@mit.edu>
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
	sugita <yumiko.sugita.yf@hitachi.com>,
	Satoshi OSHIMA <satoshi.oshima.fk@hitachi.com>,
	Nick Piggin <nickpiggin@yahoo.com.au>, Jan Kara <jack@ucw.cz>,
	<linux-ext4@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:38622 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756323AbYG0A1F (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 26 Jul 2008 20:27:05 -0400
In-Reply-To: <1217118414-18636-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>

A transient I/O error can corrupt inode data.  Here is the scenario:

(1) update inode_A at the block_B
(2) pdflush writes out new inode_A to the filesystem, but it results
    in write I/O error, at this point, BH_Uptodate flag of the buffer
    for block_B is cleared and BH_Write_EIO is set
(3) create new inode_C which located at block_B, and
    __ext4_get_inode_loc() tries to read on-disk block_B because the
    buffer is not uptodate
(4) if it can read on-disk block_B successfully, inode_A is
    overwritten by old data

This patch makes __ext4_get_inode_loc() not read the inode block if the
buffer has BH_Write_EIO flag.  In this case, the buffer should have the
latest information, so setting the uptodate flag to the buffer (this
avoids WARN_ON_ONCE() in mark_buffer_dirty().)

According to this change, we would need to test BH_Write_EIO flag for the
error checking.  Currently nobody checks write I/O errors on metadata
buffers, but it will be done in other patches I'm working on.

Signed-off-by: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Cc: sugita <yumiko.sugita.yf@hitachi.com>
Cc: Satoshi OSHIMA <satoshi.oshima.fk@hitachi.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Jan Kara <jack@ucw.cz>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/inode.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 33f1ed4..5262589 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3610,6 +3610,16 @@ static int __ext4_get_inode_loc(struct inode *inode,
 	}
 	if (!buffer_uptodate(bh)) {
 		lock_buffer(bh);
+
+		/*
+		 * If the buffer has the write error flag, we have failed
+		 * to write out another inode in the same block.  In this
+		 * case, we don't have to read the block because we may
+		 * read the old inode data successfully.
+		 */
+		if (buffer_write_io_error(bh) && !buffer_uptodate(bh))
+			set_buffer_uptodate(bh);
+
 		if (buffer_uptodate(bh)) {
 			/* someone brought it uptodate while we waited */
 			unlock_buffer(bh);
-- 
1.5.6.1.205.ge2c7.dirty

