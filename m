From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 1/2] e2fsck: always fix invalid extra field in timestamps if time_t is 32-bits
Date: Sun, 29 May 2016 01:08:11 -0400
Message-ID: <1464498492-1597-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:43708 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751051AbcE2FIT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 29 May 2016 01:08:19 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Systems with 32-bit time_t's can be used past 2038, so we should
always modify dates with extra_time=3.  (On systems with 64-bit
time_t's we will fix these dates before the year 2242.)

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 e2fsck/pass1.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 799158e..c924d31 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -512,7 +512,9 @@ static void check_inode_extra_space(e2fsck_t ctx, struct problem_context *pctx)
 	 * If the inode's extended atime (ctime, crtime, mtime) is stored in
 	 * the old, invalid format, repair it.
 	 */
-	if (sizeof(time_t) > 4 && ctx->now < EXT4_EXTRA_NEGATIVE_DATE_CUTOFF &&
+	if (((sizeof(time_t) <= 4) ||
+	     ((sizeof(time_t) > 4) &&
+	      ctx->now < EXT4_EXTRA_NEGATIVE_DATE_CUTOFF)) &&
 	    (CHECK_INODE_EXTRA_NEGATIVE_EPOCH(inode, atime) ||
 	     CHECK_INODE_EXTRA_NEGATIVE_EPOCH(inode, ctime) ||
 	     CHECK_INODE_EXTRA_NEGATIVE_EPOCH(inode, crtime) ||
-- 
2.5.0

