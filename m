From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 11/39] resize2fs: use old_fs to detect per-bg metadata
 blocks to free
Date: Sat, 25 Oct 2014 13:57:34 -0700
Message-ID: <20141025205734.532.8441.stgit@birch.djwong.org>
References: <20141025205623.532.12119.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:43887 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752775AbaJYU6H (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 25 Oct 2014 16:58:07 -0400
In-Reply-To: <20141025205623.532.12119.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When shrinking a filesystem, resize2fs wants to free per-bg metadata
blocks that are no longer needed.  This behavior is gated on whether
there's a superblock in the group as told by new_fs.  The check really
should be against old_fs, since we're effectively freeing blocks out
of old_fs in the transition to new_fs, but prior to sparse_super2 this
didn't matter since superblocks didn't move, so it didn't matter.

Under sparse_super2, however, there's a superblock in the last group,
so now we need to change the test to use old_fs as it should.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 resize/resize2fs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/resize/resize2fs.c b/resize/resize2fs.c
index 212fee2..a8a6850 100644
--- a/resize/resize2fs.c
+++ b/resize/resize2fs.c
@@ -1042,7 +1042,7 @@ static errcode_t blocks_to_move(ext2_resize_t rfs)
 		}
 
 		for (i = 0; i < max_groups; i++) {
-			if (!ext2fs_bg_has_super(fs, i)) {
+			if (!ext2fs_bg_has_super(old_fs, i)) {
 				group_blk += fs->super->s_blocks_per_group;
 				continue;
 			}

