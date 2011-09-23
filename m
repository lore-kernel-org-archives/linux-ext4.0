From: H Hartley Sweeten <hartleys@visionengravers.com>
Subject: [PATCH] ext3/balloc.c: local functions should be static
Date: Fri, 23 Sep 2011 13:55:52 -0700
Message-ID: <201109231355.52431.hartleys@visionengravers.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <linux-ext4@vger.kernel.org>, <jack@suse.cz>,
	<akpm@linux-foundation.org>, <adilger.kernel@dilger.ca>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail131.messagelabs.com ([216.82.242.99]:7219 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752326Ab1IWU41 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 23 Sep 2011 16:56:27 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This quites the sparse noise:

warning: symbol 'ext3_trim_all_free' was not declared. Should it be static?

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>

---

diff --git a/fs/ext3/balloc.c b/fs/ext3/balloc.c
index 6386d76..8e62ec5 100644
--- a/fs/ext3/balloc.c
+++ b/fs/ext3/balloc.c
@@ -1924,9 +1924,10 @@ unsigned long ext3_bg_num_gdb(struct super_block *sb, int group)
  * reaches any used block. Then issue a TRIM command on this extent and free
  * the extent in the block bitmap. This is done until whole group is scanned.
  */
-ext3_grpblk_t ext3_trim_all_free(struct super_block *sb, unsigned int group,
-				ext3_grpblk_t start, ext3_grpblk_t max,
-				ext3_grpblk_t minblocks)
+static ext3_grpblk_t ext3_trim_all_free(struct super_block *sb,
+					unsigned int group,
+					ext3_grpblk_t start, ext3_grpblk_t max,
+					ext3_grpblk_t minblocks)
 {
 	handle_t *handle;
 	ext3_grpblk_t next, free_blocks, bit, freed, count = 0;
