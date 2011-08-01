From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 1/5] ext4: introduce ext4_kvmalloc(), ext4_kzalloc(), and ext4_kvfree()
Date: Mon,  1 Aug 2011 09:13:14 -0400
Message-ID: <1312204398-12460-2-git-send-email-tytso@mit.edu>
References: <A8CDAA23-61C6-4823-ADB1-7D36CBAFC025@whamcloud.com>
 <1312204398-12460-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:40453 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751949Ab1HANN0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 1 Aug 2011 09:13:26 -0400
In-Reply-To: <1312204398-12460-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Introduce new helper functions which try kmalloc, and then fall back
to vmalloc if necessary, and use them for allocating and deallocating
s_flex_groups.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/ext4.h  |    3 +++
 fs/ext4/super.c |   54 ++++++++++++++++++++++++++++++++++++------------------
 2 files changed, 39 insertions(+), 18 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index ba2009b..db9fead 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1874,6 +1874,9 @@ extern int ext4_group_extend(struct super_block *sb,
 				ext4_fsblk_t n_blocks_count);
 
 /* super.c */
+extern void *ext4_kvmalloc(size_t size, gfp_t flags);
+extern void *ext4_kvzalloc(size_t size, gfp_t flags);
+extern void ext4_kvfree(void *ptr);
 extern void __ext4_error(struct super_block *, const char *, unsigned int,
 			 const char *, ...)
 	__attribute__ ((format (printf, 4, 5)));
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index cfe9f39..658f586 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -110,6 +110,35 @@ static struct file_system_type ext3_fs_type = {
 #define IS_EXT3_SB(sb) (0)
 #endif
 
+void *ext4_kvmalloc(size_t size, gfp_t flags)
+{
+	void *ret;
+
+	ret = kmalloc(size, flags);
+	if (!ret)
+		ret = __vmalloc(size, flags, PAGE_KERNEL);
+	return ret;
+}
+
+void *ext4_kvzalloc(size_t size, gfp_t flags)
+{
+	void *ret;
+
+	ret = kmalloc(size, flags);
+	if (!ret)
+		ret = __vmalloc(size, flags | __GFP_ZERO, PAGE_KERNEL);
+	return ret;
+}
+
+void ext4_kvfree(void *ptr)
+{
+	if (is_vmalloc_addr(ptr))
+		vfree(ptr);
+	else
+		kfree(ptr);
+
+}
+
 ext4_fsblk_t ext4_block_bitmap(struct super_block *sb,
 			       struct ext4_group_desc *bg)
 {
@@ -791,10 +820,7 @@ static void ext4_put_super(struct super_block *sb)
 	for (i = 0; i < sbi->s_gdb_count; i++)
 		brelse(sbi->s_group_desc[i]);
 	kfree(sbi->s_group_desc);
-	if (is_vmalloc_addr(sbi->s_flex_groups))
-		vfree(sbi->s_flex_groups);
-	else
-		kfree(sbi->s_flex_groups);
+	ext4_kvfree(sbi->s_flex_groups);
 	percpu_counter_destroy(&sbi->s_freeblocks_counter);
 	percpu_counter_destroy(&sbi->s_freeinodes_counter);
 	percpu_counter_destroy(&sbi->s_dirs_counter);
@@ -1977,15 +2003,11 @@ static int ext4_fill_flex_info(struct super_block *sb)
 			((le16_to_cpu(sbi->s_es->s_reserved_gdt_blocks) + 1) <<
 			      EXT4_DESC_PER_BLOCK_BITS(sb))) / groups_per_flex;
 	size = flex_group_count * sizeof(struct flex_groups);
-	sbi->s_flex_groups = kzalloc(size, GFP_KERNEL);
+	sbi->s_flex_groups = ext4_kvzalloc(size, GFP_KERNEL);
 	if (sbi->s_flex_groups == NULL) {
-		sbi->s_flex_groups = vzalloc(size);
-		if (sbi->s_flex_groups == NULL) {
-			ext4_msg(sb, KERN_ERR,
-				 "not enough memory for %u flex groups",
-				 flex_group_count);
-			goto failed;
-		}
+		ext4_msg(sb, KERN_ERR, "not enough memory for %u flex groups",
+			 flex_group_count);
+		goto failed;
 	}
 
 	for (i = 0; i < sbi->s_groups_count; i++) {
@@ -3750,12 +3772,8 @@ failed_mount_wq:
 	}
 failed_mount3:
 	del_timer(&sbi->s_err_report);
-	if (sbi->s_flex_groups) {
-		if (is_vmalloc_addr(sbi->s_flex_groups))
-			vfree(sbi->s_flex_groups);
-		else
-			kfree(sbi->s_flex_groups);
-	}
+	if (sbi->s_flex_groups)
+		ext4_kvfree(sbi->s_flex_groups);
 	percpu_counter_destroy(&sbi->s_freeblocks_counter);
 	percpu_counter_destroy(&sbi->s_freeinodes_counter);
 	percpu_counter_destroy(&sbi->s_dirs_counter);
-- 
1.7.4.1.22.gec8e1.dirty

