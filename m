From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 06/31] e2fsck: clear i_block[] when there are too many bad
 mappings on a special inode
Date: Sat, 20 Dec 2014 13:17:24 -0800
Message-ID: <20141220211724.25563.77107.stgit@birch.djwong.org>
References: <20141220211640.25563.80596.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:45086 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752426AbaLTVR3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 20 Dec 2014 16:17:29 -0500
In-Reply-To: <20141220211640.25563.80596.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If we decide to clear a special inode because of bad mappings, we need
to zero the i_block array.  The clearing routine depends on setting
i_links_count to zero to keep us from re-checking the block maps,
but that field isn't checked for special inodes.  Therefore, if we
haven't erased the mappings, check_blocks will restart fsck and fsck
will try to check the blocks again, leading to an infinite loop.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 e2fsck/pass1.c |    8 ++++++++
 1 file changed, 8 insertions(+)


diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 5f6e1dc..a861177 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -2862,6 +2862,14 @@ static void check_blocks(e2fsck_t ctx, struct problem_context *pctx,
 	}
 
 	if (pb.clear) {
+		/*
+		 * If a special inode has such rotten block mappings that we
+		 * want to clear the whole inode, be sure to actually zap
+		 * the block maps because i_links_count isn't checked for
+		 * special inodes, and we'll end up right back here.
+		 */
+		if (ino < EXT2_FIRST_INODE(fs->super))
+			memset(inode->i_block, 0, sizeof(inode->i_block));
 		e2fsck_clear_inode(ctx, ino, inode, E2F_FLAG_RESTART,
 				   "check_blocks");
 		return;

