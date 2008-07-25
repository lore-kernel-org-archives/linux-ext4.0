From: akpm@linux-foundation.org
Subject: [patch 071/277] ext3: don't read inode block if the buffer has a write error
Date: Fri, 25 Jul 2008 01:46:24 -0700
Message-ID: <200807250846.m6P8kORC001131@imap1.linux-foundation.org>
Cc: akpm@linux-foundation.org, hidehiro.kawai.ez@hitachi.com,
	jack@ucw.cz, linux-ext4@vger.kernel.org, nickpiggin@yahoo.com.au,
	satoshi.oshima.fk@hitachi.com, yumiko.sugita.yf@hitachi.com
To: torvalds@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43017 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752875AbYGYIrC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 25 Jul 2008 04:47:02 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>

A transient I/O error can corrupt inode data.  Here is the scenario:

(1) update inode_A at the block_B
(2) pdflush writes out new inode_A to the filesystem, but it results
    in write I/O error, at this point, BH_Uptodate flag of the buffer
    for block_B is cleared and BH_Write_EIO is set
(3) create new inode_C which located at block_B, and
    __ext3_get_inode_loc() tries to read on-disk block_B because the
    buffer is not uptodate
(4) if it can read on-disk block_B successfully, inode_A is
    overwritten by old data

This patch makes __ext3_get_inode_loc() not read the inode block if the
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
---

 fs/ext3/inode.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff -puN fs/ext3/inode.c~ext3-dont-read-inode-block-if-the-buffer-has-a-write-error fs/ext3/inode.c
--- a/fs/ext3/inode.c~ext3-dont-read-inode-block-if-the-buffer-has-a-write-error
+++ a/fs/ext3/inode.c
@@ -2521,6 +2521,16 @@ static int __ext3_get_inode_loc(struct i
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
_
