From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 3/3] e2fsck: optimize CPU usage in check_{block,inode}_bitmaps()
Date: Sun, 11 Mar 2012 15:33:13 -0400
Message-ID: <1331494393-21577-3-git-send-email-tytso@mit.edu>
References: <20120311191836.GD1048@thunk.org>
 <1331494393-21577-1-git-send-email-tytso@mit.edu>
Cc: lczerner@redhat.com, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:36473 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751368Ab2CKTdP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 11 Mar 2012 15:33:15 -0400
In-Reply-To: <1331494393-21577-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The boolean expression (!skip_group || csum_flag) is always true,
since if csum_flag is FALSE, skip_group must also be FALSE.  Hence, we
can just remove the expression from the conditional altogether, thus
simplifying the code and making it easier to read/understand.

Also, in the case where the bit is set in the bitmap, there's no point
repeatedly setting first_free to be ext2fs_block_count(fs->super).

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 e2fsck/pass5.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/e2fsck/pass5.c b/e2fsck/pass5.c
index e25f080..c121d92 100644
--- a/e2fsck/pass5.c
+++ b/e2fsck/pass5.c
@@ -372,15 +372,14 @@ redo_counts:
 		ctx->options &= ~E2F_OPT_DISCARD;
 
 	do_counts:
-		if (!bitmap && (!skip_group || csum_flag)) {
+		if (!bitmap) {
 			group_free++;
 			free_blocks++;
 			if (first_free > i)
 				first_free = i;
-		} else {
-			if (i > first_free)
-				e2fsck_discard_blocks(ctx, first_free,
-						      (i - first_free));
+		} else if (i > first_free) {
+			e2fsck_discard_blocks(ctx, first_free,
+					      (i - first_free));
 			first_free = ext2fs_blocks_count(fs->super);
 		}
 		blocks ++;
@@ -627,7 +626,7 @@ do_counts:
 						      inodes - first_free);
 				first_free = fs->super->s_inodes_per_group + 1;
 			}
-		} else if (!skip_group || csum_flag) {
+		} else {
 			group_free++;
 			free_inodes++;
 			if (first_free > inodes)
-- 
1.7.9.107.g97f9a

