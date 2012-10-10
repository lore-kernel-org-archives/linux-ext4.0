From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] e2fsck: only consult inode_dir_map if needed in pass4
Date: Tue,  9 Oct 2012 22:55:55 -0400
Message-ID: <1349837755-22303-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:54730 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750931Ab2JJIQF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 10 Oct 2012 04:16:05 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In e2fsck_pass4(), we were consulting inode_dir_map using
ext2fs_test_inode_bitmap2() for every single inode in the file system.
However, there were many cases where we never needed the result of the
test --- most notably if the inode is not in use.

I was a bit surprised that GCC 4.7 with CFLAGS set to "-g -O2" wasn't
able to optimize this out for us, but here is the pass 4 timing for an
empty 3T file system before this patch:

Pass 4: Memory used: 672k/772k (422k/251k), time:  3.67/ 3.66/ 0.00

and afterwards, we see a 43% improvement:

Pass 4: Memory used: 672k/772k (422k/251k), time:  2.09/ 2.08/ 0.00

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 e2fsck/pass4.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/e2fsck/pass4.c b/e2fsck/pass4.c
index 1e63280..2d55180 100644
--- a/e2fsck/pass4.c
+++ b/e2fsck/pass4.c
@@ -123,7 +123,7 @@ void e2fsck_pass4(e2fsck_t ctx)
 
 	/* Protect loop from wrap-around if s_inodes_count maxed */
 	for (i=1; i <= fs->super->s_inodes_count && i > 0; i++) {
-		int isdir = ext2fs_test_inode_bitmap2(ctx->inode_dir_map, i);
+		int isdir;
 
 		if (ctx->flags & E2F_FLAG_SIGNAL_MASK)
 			goto errout;
@@ -157,6 +157,7 @@ void e2fsck_pass4(e2fsck_t ctx)
 			ext2fs_icount_fetch(ctx->inode_count, i,
 					    &link_counted);
 		}
+		isdir = ext2fs_test_inode_bitmap2(ctx->inode_dir_map, i);
 		if (isdir && (link_counted > EXT2_LINK_MAX))
 			link_counted = 1;
 		if (link_counted != link_count) {
-- 
1.7.12.rc0.22.gcdd159b

