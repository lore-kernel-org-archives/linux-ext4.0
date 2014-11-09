From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 2/2] ext4: fix potential use after free issue while fsresize
Date: Sun,  9 Nov 2014 20:37:52 +0400
Message-ID: <1415551072-3949-2-git-send-email-dmonakhov@openvz.org>
References: <1415551072-3949-1-git-send-email-dmonakhov@openvz.org>
Cc: tytso@mit.edu, cmm@us.ibm.com,
	Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:8146 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751854AbaKIQjJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 9 Nov 2014 11:39:09 -0500
In-Reply-To: <1415551072-3949-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We need some sort of synchronization while updating ->s_group_desc because there
are a lot of users which can access old ->s_group_desc array after it was released.
It is reasonable to use lightweight seqcount_t here instead of RCU.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/balloc.c |   14 ++++++++++----
 fs/ext4/ext4.h   |    1 +
 fs/ext4/resize.c |    5 ++++-
 fs/ext4/super.c  |    1 +
 4 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index 83a6f49..4746907 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -280,8 +280,10 @@ struct ext4_group_desc * ext4_get_group_desc(struct super_block *sb,
 {
 	unsigned int group_desc;
 	unsigned int offset;
+	unsigned int seq;
 	ext4_group_t ngroups = ext4_get_groups_count(sb);
 	struct ext4_group_desc *desc;
+	struct buffer_head *gd_bh;
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 
 	if (block_group >= ngroups) {
@@ -293,7 +295,11 @@ struct ext4_group_desc * ext4_get_group_desc(struct super_block *sb,
 
 	group_desc = block_group >> EXT4_DESC_PER_BLOCK_BITS(sb);
 	offset = block_group & (EXT4_DESC_PER_BLOCK(sb) - 1);
-	if (!sbi->s_group_desc[group_desc]) {
+	do {
+		seq = read_seqcount_begin(&sbi->s_group_desc_seq);
+		gd_bh = sbi->s_group_desc[group_desc];
+	} while (unlikely(read_seqcount_retry(&sbi->s_group_desc_seq, seq)));
+	if (!gd_bh) {
 		ext4_error(sb, "Group descriptor not loaded - "
 			   "block_group = %u, group_desc = %u, desc = %u",
 			   block_group, group_desc, offset);
@@ -301,10 +307,10 @@ struct ext4_group_desc * ext4_get_group_desc(struct super_block *sb,
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
 
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index c55a1fa..2c039d2 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1199,6 +1199,7 @@ struct ext4_sb_info {
 	struct buffer_head * s_sbh;	/* Buffer containing the super block */
 	struct ext4_super_block *s_es;	/* Pointer to the super block in the buffer */
 	struct buffer_head **s_group_desc;
+	seqcount_t s_group_desc_seq;	/* protects s_group_desc updates */
 	unsigned int s_mount_opt;
 	unsigned int s_mount_opt2;
 	unsigned int s_mount_flags;
diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index ca45883..f9ec935 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -854,8 +854,10 @@ static int add_new_gdb(handle_t *handle, struct inode *inode,
 	memcpy(n_group_desc, o_group_desc,
 	       EXT4_SB(sb)->s_gdb_count * sizeof(struct buffer_head *));
 	n_group_desc[gdb_num] = gdb_bh;
+	write_seqcount_begin(&EXT4_SB(sb)->s_group_desc_seq);
 	EXT4_SB(sb)->s_group_desc = n_group_desc;
 	EXT4_SB(sb)->s_gdb_count++;
+	write_seqcount_end(&EXT4_SB(sb)->s_group_desc_seq);
 	ext4_kvfree(o_group_desc);
 
 	le16_add_cpu(&es->s_reserved_gdt_blocks, -1);
@@ -902,13 +904,14 @@ static int add_new_gdb_meta_bg(struct super_block *sb,
 			     gdb_num + 1);
 		return err;
 	}
-
 	o_group_desc = EXT4_SB(sb)->s_group_desc;
 	memcpy(n_group_desc, o_group_desc,
 	       EXT4_SB(sb)->s_gdb_count * sizeof(struct buffer_head *));
 	n_group_desc[gdb_num] = gdb_bh;
+	write_seqcount_begin(&EXT4_SB(sb)->s_group_desc_seq);
 	EXT4_SB(sb)->s_group_desc = n_group_desc;
 	EXT4_SB(sb)->s_gdb_count++;
+	write_seqcount_end(&EXT4_SB(sb)->s_group_desc_seq);
 	ext4_kvfree(o_group_desc);
 	BUFFER_TRACE(gdb_bh, "get_write_access");
 	err = ext4_journal_get_write_access(handle, gdb_bh);
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 2c9e686..08d50a1 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3872,6 +3872,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 			(EXT4_MAX_BLOCK_FILE_PHYS / EXT4_BLOCKS_PER_GROUP(sb)));
 	db_count = (sbi->s_groups_count + EXT4_DESC_PER_BLOCK(sb) - 1) /
 		   EXT4_DESC_PER_BLOCK(sb);
+	seqcount_init(&sbi->s_group_desc_seq);
 	sbi->s_group_desc = ext4_kvmalloc(db_count *
 					  sizeof(struct buffer_head *),
 					  GFP_KERNEL);
-- 
1.7.1

