From: Tomas Racek <tracek@redhat.com>
Subject: [PATCH] ext4: Automatic setting of {INODE,BLOCK}_UNINIT flags
Date: Thu, 25 Oct 2012 09:25:43 +0200
Message-ID: <1351149943-4827-1-git-send-email-tracek@redhat.com>
Cc: lczerner@redhat.com, Tomas Racek <tracek@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:5307 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757507Ab2JYHZz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 25 Oct 2012 03:25:55 -0400
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q9P7Ps2T020017
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Thu, 25 Oct 2012 03:25:55 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When last inode from bg is freed, set the INODE_UNINIT flag, similarly
when last block is freed, set BLOCK_UNINIT flag. This can speed up
subsequent fsck run.

Signed-off-by: Tomas Racek <tracek@redhat.com>
---
 fs/ext4/ialloc.c  | 4 ++++
 fs/ext4/mballoc.c | 4 ++++
 2 files changed, 8 insertions(+)

diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 4facdd2..6e4b982 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -289,6 +289,10 @@ void ext4_free_inode(handle_t *handle, struct inode *inode)
 
 	count = ext4_free_inodes_count(sb, gdp) + 1;
 	ext4_free_inodes_set(sb, gdp, count);
+
+	if (count == EXT4_INODES_PER_GROUP(sb))
+               gdp->bg_flags |= cpu_to_le16(EXT4_BG_INODE_UNINIT);
+
 	if (is_directory) {
 		count = ext4_used_dirs_count(sb, gdp) - 1;
 		ext4_used_dirs_set(sb, gdp, count);
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 526e553..28bce35 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4665,6 +4665,10 @@ do_more:
 
 	ret = ext4_free_group_clusters(sb, gdp) + count_clusters;
 	ext4_free_group_clusters_set(sb, gdp, ret);
+
+	if(ret == EXT4_BLOCKS_PER_GROUP(sb))
+		gdp->bg_flags |= cpu_to_le16(EXT4_BG_BLOCK_UNINIT);
+
 	ext4_block_bitmap_csum_set(sb, block_group, gdp, bitmap_bh);
 	ext4_group_desc_csum_set(sb, block_group, gdp);
 	ext4_unlock_group(sb, block_group);
-- 
1.7.11.7

