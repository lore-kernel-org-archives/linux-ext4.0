From: Joe Perches <joe@perches.com>
Subject: [PATCH 6/9] ext4: Remove redundant "EXT4-fs: " from uses of ext4_msg
Date: Thu, 15 Mar 2012 17:07:34 -0700
Message-ID: <d029f3995ba3c6f50a031671c40dfbcc764da4d2.1331856300.git.joe@perches.com>
References: <cover.1331856299.git.joe@perches.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1331856299.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

ext4_msg adds "EXT4-fs: " to the messsage output.
Remove the redundant bits from uses.

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/ext4/mballoc.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index c26b600..cd4d7c6 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2178,7 +2178,7 @@ int ext4_mb_add_groupinfo(struct super_block *sb, ext4_group_t group,
 			EXT4_DESC_PER_BLOCK_BITS(sb);
 		meta_group_info = kmalloc(metalen, GFP_KERNEL);
 		if (meta_group_info == NULL) {
-			ext4_msg(sb, KERN_ERR, "EXT4-fs: can't allocate mem "
+			ext4_msg(sb, KERN_ERR, "can't allocate mem "
 				 "for a buddy group");
 			goto exit_meta_group_info;
 		}
@@ -2192,7 +2192,7 @@ int ext4_mb_add_groupinfo(struct super_block *sb, ext4_group_t group,
 
 	meta_group_info[i] = kmem_cache_alloc(cachep, GFP_KERNEL);
 	if (meta_group_info[i] == NULL) {
-		ext4_msg(sb, KERN_ERR, "EXT4-fs: can't allocate buddy mem");
+		ext4_msg(sb, KERN_ERR, "can't allocate buddy mem");
 		goto exit_group_info;
 	}
 	memset(meta_group_info[i], 0, kmem_cache_size(cachep));
@@ -3864,11 +3864,11 @@ static void ext4_mb_show_ac(struct ext4_allocation_context *ac)
 	    (EXT4_SB(sb)->s_mount_flags & EXT4_MF_FS_ABORTED))
 		return;
 
-	ext4_msg(ac->ac_sb, KERN_ERR, "EXT4-fs: Can't allocate:"
+	ext4_msg(ac->ac_sb, KERN_ERR, "Can't allocate:"
 			" Allocation context details:");
-	ext4_msg(ac->ac_sb, KERN_ERR, "EXT4-fs: status %d flags %d",
+	ext4_msg(ac->ac_sb, KERN_ERR, "status %d flags %d",
 			ac->ac_status, ac->ac_flags);
-	ext4_msg(ac->ac_sb, KERN_ERR, "EXT4-fs: orig %lu/%lu/%lu@%lu, "
+	ext4_msg(ac->ac_sb, KERN_ERR, "orig %lu/%lu/%lu@%lu, "
 		 	"goal %lu/%lu/%lu@%lu, "
 			"best %lu/%lu/%lu@%lu cr %d",
 			(unsigned long)ac->ac_o_ex.fe_group,
@@ -3884,9 +3884,9 @@ static void ext4_mb_show_ac(struct ext4_allocation_context *ac)
 			(unsigned long)ac->ac_b_ex.fe_len,
 			(unsigned long)ac->ac_b_ex.fe_logical,
 			(int)ac->ac_criteria);
-	ext4_msg(ac->ac_sb, KERN_ERR, "EXT4-fs: %lu scanned, %d found",
+	ext4_msg(ac->ac_sb, KERN_ERR, "%lu scanned, %d found",
 		 ac->ac_ex_scanned, ac->ac_found);
-	ext4_msg(ac->ac_sb, KERN_ERR, "EXT4-fs: groups: ");
+	ext4_msg(ac->ac_sb, KERN_ERR, "groups: ");
 	ngroups = ext4_get_groups_count(sb);
 	for (i = 0; i < ngroups; i++) {
 		struct ext4_group_info *grp = ext4_get_group_info(sb, i);
-- 
1.7.8.111.gad25c.dirty
