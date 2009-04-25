From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] ext4: Fallback to vmalloc if kmalloc can't allocate s_flex_groups array
Date: Fri, 24 Apr 2009 23:00:59 -0400
Message-ID: <1240628459-25582-1-git-send-email-tytso@mit.edu>
References: <532480950904052345m48bc5df5wcdc4c5e32778130c@mail.gmail.com>
Cc: Curt Wohlgemuth <curtw@google.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>
To: Michael Rubin <mrubin@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:54821 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750884AbZDYDBE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 24 Apr 2009 23:01:04 -0400
In-Reply-To: <532480950904052345m48bc5df5wcdc4c5e32778130c@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

For very large filesystems, the s_flex_groups array can get quite big.
For example, a 16TB filesystem will have 8192 flex groups by default,
so the array is 96k, which is marginal for kmalloc().  On the other
hand, a 160GB filesystem will have 80 flex groups, so the array will
be 960 bytes.  So we try to allocate the array first using kmalloc(),
and if that fails, we'll try to use vmalloc() instead.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/super.c |   15 ++++++++++++---
 1 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 2958f4e..0682fe0 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1620,6 +1620,7 @@ static int ext4_fill_flex_info(struct super_block *sb)
 	ext4_group_t flex_group_count;
 	ext4_group_t flex_group;
 	int groups_per_flex = 0;
+	size_t size;
 	int i;
 
 	if (!sbi->s_es->s_log_groups_per_flex) {
@@ -1634,8 +1635,13 @@ static int ext4_fill_flex_info(struct super_block *sb)
 	flex_group_count = ((sbi->s_groups_count + groups_per_flex - 1) +
 			((le16_to_cpu(sbi->s_es->s_reserved_gdt_blocks) + 1) <<
 			      EXT4_DESC_PER_BLOCK_BITS(sb))) / groups_per_flex;
-	sbi->s_flex_groups = kzalloc(flex_group_count *
-				     sizeof(struct flex_groups), GFP_KERNEL);
+	size = flex_group_count * sizeof(struct flex_groups);
+	sbi->s_flex_groups = kzalloc(size, GFP_KERNEL);
+	if (sbi->s_flex_groups == NULL) {
+		sbi->s_flex_groups = vmalloc(size);
+		if (sbi->s_flex_groups)
+			memset(sbi->s_flex_groups, 0, size);
+	}
 	if (sbi->s_flex_groups == NULL) {
 		printk(KERN_ERR "EXT4-fs: not enough memory for "
 				"%u flex groups\n", flex_group_count);
@@ -2849,7 +2855,10 @@ failed_mount3:
 failed_mount2:
 	for (i = 0; i < db_count; i++)
 		brelse(sbi->s_group_desc[i]);
-	kfree(sbi->s_group_desc);
+	if (is_vmalloc_addr(sbi->s_group_desc))
+		vfree(sbi->s_group_desc);
+	else
+		kfree(sbi->s_group_desc);
 failed_mount:
 	if (sbi->s_proc) {
 		remove_proc_entry(sb->s_id, ext4_proc_root);
-- 
1.5.6.3

