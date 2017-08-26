From: Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH] misc: quiet llvm build warnings
Date: Fri, 25 Aug 2017 23:14:41 -0600
Message-ID: <1503724481-84704-1-git-send-email-adilger@dilger.ca>
Cc: linux-ext4@vger.kernel.org, Andreas Dilger <adilger@dilger.ca>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out-so.shaw.ca ([64.59.136.138]:49516 "EHLO
        smtp-out-so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750736AbdHZFOo (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 26 Aug 2017 01:14:44 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Quiet some relatively harmless build warnings:

mkquota.c:527:15: warning: format specifies type 'long' but the
	argument has type 'qsize_t' (aka 'long long') [-Wformat]
		dq->dq_id, dq->dq_dqb.dqb_curspace,
			   ^~~~~~~~~~~~~~~~~~~~~~~

tune2fs.c:928:18: warning: '&&' within '||' [-Wlogical-op-parentheses]
	if (pass == 1 && (inode->i_flags & EXT4_EA_INODE_FL) ||
	    ~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ~~
tune2fs.c:928:18: place parentheses around '&&' to silence warning

Signed-off-by: Andreas Dilger <adilger@dilger.ca>
---
 lib/support/mkquota.c | 2 +-
 misc/tune2fs.c        | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/lib/support/mkquota.c b/lib/support/mkquota.c
index 11a878e..4251e46 100644
--- a/lib/support/mkquota.c
+++ b/lib/support/mkquota.c
@@ -523,7 +523,7 @@ static int scan_dquots_callback(struct dquot *dquot, void *cb_data)
 	    dq->dq_dqb.dqb_curinodes != dquot->dq_dqb.dqb_curinodes) {
 		scan_data->usage_is_inconsistent = 1;
 		fprintf(stderr, "[QUOTA WARNING] Usage inconsistent for ID %u:"
-			"actual (%ld, %ld) != expected (%ld, %ld)\n",
+			"actual (%lld, %lld) != expected (%lld, %lld)\n",
 			dq->dq_id, dq->dq_dqb.dqb_curspace,
 			dq->dq_dqb.dqb_curinodes,
 			dquot->dq_dqb.dqb_curspace,
diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index 9b53dc2..c7c1d6d 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -925,8 +925,8 @@ static void rewrite_inodes(ext2_filsys fs)
 			if (!ino)
 				break;
 
-			if (pass == 1 && (inode->i_flags & EXT4_EA_INODE_FL) ||
-			    pass == 2 && !(inode->i_flags & EXT4_EA_INODE_FL))
+			if ((pass == 1 && (inode->i_flags & EXT4_EA_INODE_FL))||
+			    (pass == 2 && !(inode->i_flags & EXT4_EA_INODE_FL)))
 				rewrite_one_inode(&ctx, ino, inode);
 		} while (ino);
 
-- 
1.8.0
