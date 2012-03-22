From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] e2fsck: avoid unnecessary close/reopen for non-MMP filesystems
Date: Wed, 21 Mar 2012 23:21:16 -0400
Message-ID: <1332386476-25673-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger@whamcloud.com>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:35788 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751900Ab2CVDVU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 21 Mar 2012 23:21:20 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

For file systems that do not use MMP, there's no reason to close the
file system and then re-open the file system a second time, since
EXT2_FLAG_SKIP_MMP has no meaning for non-MMP file systems anyway.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: Andreas Dilger <adilger@whamcloud.com>
---
 e2fsck/unix.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/e2fsck/unix.c b/e2fsck/unix.c
index 59c52ff..d0b10d4 100644
--- a/e2fsck/unix.c
+++ b/e2fsck/unix.c
@@ -1398,12 +1398,10 @@ failure:
 	    (flags & EXT2_FLAG_SKIP_MMP)) {
 		if (e2fsck_check_mmp(fs, ctx))
 			fatal_error(ctx, 0);
-	}
 
-	 /*
-	  * Restart in order to reopen fs but this time start mmp.
-	  */
-	if (flags & EXT2_FLAG_SKIP_MMP) {
+		/*
+		 * Restart in order to reopen fs but this time start mmp.
+		 */
 		ext2fs_close(fs);
 		ctx->fs = NULL;
 		flags &= ~EXT2_FLAG_SKIP_MMP;
-- 
1.7.9.107.g97f9a

