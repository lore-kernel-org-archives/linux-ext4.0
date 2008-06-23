From: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Subject: [RFC][PATCH] ext3: don't read inode block if the buffer has a write
    error
Date: Mon, 23 Jun 2008 20:25:22 +0900
Message-ID: <485F8822.5030205@hitachi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	jack@suse.cz, sugita <yumiko.sugita.yf@hitachi.com>,
	Satoshi OSHIMA <satoshi.oshima.fk@hitachi.com>
To: akpm@linux-foundation.org, sct@redhat.com, adilger@sun.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail9.hitachi.co.jp ([133.145.228.44]:42487 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752837AbYFWLZb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 23 Jun 2008 07:25:31 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

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

This patch makes __ext3_get_inode_loc() not read the inode block if
the buffer has BH_Write_EIO flag.  In this case, the buffer should
have the latest information, so setting the uptodate flag to the
buffer (this avoids WARN_ON_ONCE() in mark_buffer_dirty().)

According to this change, we would need to test BH_Write_EIO flag for
the error checking.  Currently nobody checks write I/O errors on
metadata buffers, but it will be done in other patches I'm working on.

Signed-off-by: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
---
 fs/ext3/inode.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

Index: linux-2.6.26-rc5-mm3/fs/ext3/inode.c
===================================================================
--- linux-2.6.26-rc5-mm3.orig/fs/ext3/inode.c
+++ linux-2.6.26-rc5-mm3/fs/ext3/inode.c
@@ -2516,6 +2516,16 @@ static int __ext3_get_inode_loc(struct i
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



