From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 1/4] ext4: fix potential use after free during resize V2
Date: Tue,  2 Dec 2014 15:00:51 +0400
Message-ID: <1417518054-21733-1-git-send-email-dmonakhov@openvz.org>
Cc: tytso@mit.edu, Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:31053 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751666AbaLBLBH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 2 Dec 2014 06:01:07 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We need some sort of synchronization while updating ->s_group_desc
because there are a lot of users which can access old ->s_group_desc
array after it was released.

changes from V1:
  - use RCU instead seqcount

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/balloc.c |   12 ++++++++----
 fs/ext4/resize.c |    6 ++++--
 2 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index 83a6f49..2d0a0de 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -282,6 +282,7 @@ struct ext4_group_desc * ext4_get_group_desc(struct super_block *sb,
 	unsigned int offset;
 	ext4_group_t ngroups = ext4_get_groups_count(sb);
 	struct ext4_group_desc *desc;
+	struct buffer_head *gd_bh;
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 
 	if (block_group >= ngroups) {
@@ -293,7 +294,10 @@ struct ext4_group_desc * ext4_get_group_desc(struct super_block *sb,
 
 	group_desc = block_group >> EXT4_DESC_PER_BLOCK_BITS(sb);
 	offset = block_group & (EXT4_DESC_PER_BLOCK(sb) - 1);
-	if (!sbi->s_group_desc[group_desc]) {
+	rcu_read_lock();
+	gd_bh = *rcu_dereference(sbi->s_group_desc) + group_desc;
+	rcu_read_unlock();
+	if (!gd_bh) {
 		ext4_error(sb, "Group descriptor not loaded - "
 			   "block_group = %u, group_desc = %u, desc = %u",
 			   block_group, group_desc, offset);
@@ -301,10 +305,10 @@ struct ext4_group_desc * ext4_get_group_desc(struct super_block *sb,
 	}
 
 	desc = (struct ext4_group_desc *)(
-		(__u8 *)sbi->s_group_desc[group_desc]->b_data +
-		offset * EXT4_DESC_SIZE(sb));
+		(__u8 *)gd_bh->b_data + offset * EXT4_DESC_SIZE(sb));
 	if (bh)
-		*bh = sbi->s_group_desc[group_desc];
+		*bh = gd_bh;
+
 	return desc;
 }
 
diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index bf76f40..08c2256 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -854,8 +854,9 @@ static int add_new_gdb(handle_t *handle, struct inode *inode,
 	memcpy(n_group_desc, o_group_desc,
 	       EXT4_SB(sb)->s_gdb_count * sizeof(struct buffer_head *));
 	n_group_desc[gdb_num] = gdb_bh;
-	EXT4_SB(sb)->s_group_desc = n_group_desc;
 	EXT4_SB(sb)->s_gdb_count++;
+	rcu_assign_pointer(EXT4_SB(sb)->s_group_desc, n_group_desc);
+	synchronize_rcu();
 	kvfree(o_group_desc);
 
 	le16_add_cpu(&es->s_reserved_gdt_blocks, -1);
@@ -907,8 +908,9 @@ static int add_new_gdb_meta_bg(struct super_block *sb,
 	memcpy(n_group_desc, o_group_desc,
 	       EXT4_SB(sb)->s_gdb_count * sizeof(struct buffer_head *));
 	n_group_desc[gdb_num] = gdb_bh;
-	EXT4_SB(sb)->s_group_desc = n_group_desc;
 	EXT4_SB(sb)->s_gdb_count++;
+	rcu_assign_pointer(EXT4_SB(sb)->s_group_desc, n_group_desc);
+	synchronize_rcu();
 	kvfree(o_group_desc);
 	BUFFER_TRACE(gdb_bh, "get_write_access");
 	err = ext4_journal_get_write_access(handle, gdb_bh);
-- 
1.7.1

