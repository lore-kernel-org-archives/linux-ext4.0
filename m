From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 12/54] e2fsck: clear i_block[] when there are too many bad
 mappings on a special inode
Date: Mon, 26 Jan 2015 23:36:50 -0800
Message-ID: <20150127073650.13308.34112.stgit@birch.djwong.org>
References: <20150127073533.13308.44994.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:33451 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949AbbA0Hgy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 27 Jan 2015 02:36:54 -0500
In-Reply-To: <20150127073533.13308.44994.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If we decide to clear a special inode because of bad mappings, we need
to zero the i_block array.  The clearing routine depends on setting
i_links_count to zero to keep us from re-checking the block maps,
but that field isn't checked for special inodes.  Therefore, if we
haven't erased the mappings, check_blocks will restart fsck and fsck
will try to check the blocks again, leading to an infinite loop.

(This seems easy to trigger if the bootloader inode extent map is
corrupted.)

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 e2fsck/pass1.c |   10 ++++++++++
 1 file changed, 10 insertions(+)


diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 14877d7..faafa7c 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -2285,6 +2285,16 @@ void e2fsck_clear_inode(e2fsck_t ctx, ext2_ino_t ino,
 	ext2fs_icount_store(ctx->inode_link_info, ino, 0);
 	inode->i_dtime = ctx->now;
 
+	/*
+	 * If a special inode has such rotten block mappings that we
+	 * want to clear the whole inode, be sure to actually zap
+	 * the block maps because i_links_count isn't checked for
+	 * special inodes, and we'll end up right back here the next
+	 * time we run fsck.
+	 */
+	if (ino < EXT2_FIRST_INODE(ctx->fs->super))
+		memset(inode->i_block, 0, sizeof(inode->i_block));
+
 	ext2fs_unmark_inode_bitmap2(ctx->inode_dir_map, ino);
 	ext2fs_unmark_inode_bitmap2(ctx->inode_used_map, ino);
 	if (ctx->inode_reg_map)

