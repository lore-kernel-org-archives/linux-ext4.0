From: H Hartley Sweeten <hartleys@visionengravers.com>
Subject: [PATCH] ext4/fsync.c: functions should not be declared extern
Date: Fri, 23 Sep 2011 15:14:01 -0700
Message-ID: <201109231514.02174.hartleys@visionengravers.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <linux-ext4@vger.kernel.org>, <tytso@mit.edu>,
	<adilger.kernel@dilger.ca>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail131.messagelabs.com ([216.82.242.99]:38369 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752276Ab1IWWOT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 23 Sep 2011 18:14:19 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The function declaration in ext4.h is already marked extern.  The function
definition should not have the tag.

This quiets the sparse noise:

warning: function 'ext4_flush_completed_IO' with external linkage has definition

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>

---

diff --git a/fs/ext4/fsync.c b/fs/ext4/fsync.c
index 036f78f..c942924 100644
--- a/fs/ext4/fsync.c
+++ b/fs/ext4/fsync.c
@@ -75,7 +75,7 @@ static void dump_completed_IO(struct inode * inode)
  * to written.
  * The function return the number of pending IOs on success.
  */
-extern int ext4_flush_completed_IO(struct inode *inode)
+int ext4_flush_completed_IO(struct inode *inode)
 {
 	ext4_io_end_t *io;
 	struct ext4_inode_info *ei = EXT4_I(inode);
