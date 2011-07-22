From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH V2] e2fsck: fix error in computing blocks of the ending group
Date: Thu, 21 Jul 2011 23:18:57 -0500
Message-ID: <4E28FA31.7090405@redhat.com>
References: <1311090411-13766-1-git-send-email-xiaoqiangnk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32063 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751387Ab1GVETD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 22 Jul 2011 00:19:03 -0400
In-Reply-To: <1311090411-13766-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Yongqiang Yang <xiaoqiangnk@gmail.com>

If the blocks of a filesystem is a multiple of blocks_per_group,
blocks of the ending group is computed wrongly.  Use the
new ext2fs_group_blocks_count() helper instead.

Eric Sandeen: Converted to use new blocks per group helper

Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---

diff --git a/e2fsck/pass5.c b/e2fsck/pass5.c
index f9d746c..2a28c7a 100644
--- a/e2fsck/pass5.c
+++ b/e2fsck/pass5.c
@@ -225,9 +225,8 @@ redo_counts:
 				count = 0;
 				cmp_block = fs->super->s_clusters_per_group;
 				if (group == (int)fs->group_desc_count - 1)
-					cmp_block =
-						EXT2FS_NUM_B2C(fs,
-		ext2fs_blocks_count(fs->super) % fs->super->s_blocks_per_group);
+					cmp_block = EXT2FS_NUM_B2C(fs,
+						    ext2fs_group_blocks_count(fs, group));
 			}
 
 			bitmap = 0;
