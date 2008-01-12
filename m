From: Indan Zupancic <indan@nul.nu>
Subject: [PATCH] Shrink ext3_inode_info by 8 bytes for !POSIX_ACL.
Date: Sat, 12 Jan 2008 21:35:42 +0100
Message-ID: <1200170142-1151-1-git-send-email-indan@nul.nu>
Cc: Indan Zupancic <indan@nul.nu>
To: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1762753AbYALUgB@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

i_file_acl and i_dir_acl aren't always needed.

With certain configs this makes 10 ext3_inode_cache objects fit in
one slab instead of the current 9, as the size shrinks from 416 to
408 bytes for 32 bit, !POSIX_ACL and !EXT3_FS_XATTR configs.

Signed-off-by: Indan Zupancic <indan@nul.nu>
---
 fs/ext3/ialloc.c          |    2 ++
 fs/ext3/inode.c           |   29 +++++++++++++++++++----------
 include/linux/ext3_fs_i.h |    2 ++
 3 files changed, 23 insertions(+), 10 deletions(-)

diff --git a/fs/ext3/ialloc.c b/fs/ext3/ialloc.c
index 1bc8cd8..01745bc 100644
--- a/fs/ext3/ialloc.c
+++ b/fs/ext3/ialloc.c
@@ -574,8 +574,10 @@ got:
 	ei->i_frag_no = 0;
 	ei->i_frag_size = 0;
 #endif
+#ifdef CONFIG_EXT3_FS_POSIX_ACL
 	ei->i_file_acl = 0;
 	ei->i_dir_acl = 0;
+#endif
 	ei->i_dtime = 0;
 	ei->i_block_alloc_info = NULL;
 	ei->i_block_group = group;
diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index 9b162cd..20a8aeb 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -46,9 +46,12 @@ static int ext3_writepage_trans_blocks(struct inode *inode);
  */
 static int ext3_inode_is_fast_symlink(struct inode *inode)
 {
-	int ea_blocks = EXT3_I(inode)->i_file_acl ?
-		(inode->i_sb->s_blocksize >> 9) : 0;
+	int ea_blocks = 0;
 
+#ifdef CONFIG_EXT3_FS_POSIX_ACL
+	if (EXT3_I(inode)->i_file_acl)
+		ea_blocks = inode->i_sb->s_blocksize >> 9;
+#endif
 	return (S_ISLNK(inode->i_mode) && inode->i_blocks - ea_blocks == 0);
 }
 
@@ -2717,13 +2720,16 @@ void ext3_read_inode(struct inode * inode)
 	ei->i_frag_no = raw_inode->i_frag;
 	ei->i_frag_size = raw_inode->i_fsize;
 #endif
-	ei->i_file_acl = le32_to_cpu(raw_inode->i_file_acl);
-	if (!S_ISREG(inode->i_mode)) {
-		ei->i_dir_acl = le32_to_cpu(raw_inode->i_dir_acl);
-	} else {
+	if (S_ISREG(inode->i_mode)) {
 		inode->i_size |=
 			((__u64)le32_to_cpu(raw_inode->i_size_high)) << 32;
 	}
+#ifdef CONFIG_EXT3_FS_POSIX_ACL
+	else {
+		ei->i_dir_acl = le32_to_cpu(raw_inode->i_dir_acl);
+	}
+	ei->i_file_acl = le32_to_cpu(raw_inode->i_file_acl);
+#endif
 	ei->i_disksize = inode->i_size;
 	inode->i_generation = le32_to_cpu(raw_inode->i_generation);
 	ei->i_block_group = iloc.block_group;
@@ -2854,10 +2860,7 @@ static int ext3_do_update_inode(handle_t *handle,
 	raw_inode->i_frag = ei->i_frag_no;
 	raw_inode->i_fsize = ei->i_frag_size;
 #endif
-	raw_inode->i_file_acl = cpu_to_le32(ei->i_file_acl);
-	if (!S_ISREG(inode->i_mode)) {
-		raw_inode->i_dir_acl = cpu_to_le32(ei->i_dir_acl);
-	} else {
+	if (S_ISREG(inode->i_mode)) {
 		raw_inode->i_size_high =
 			cpu_to_le32(ei->i_disksize >> 32);
 		if (ei->i_disksize > 0x7fffffffULL) {
@@ -2883,6 +2886,12 @@ static int ext3_do_update_inode(handle_t *handle,
 			}
 		}
 	}
+#ifdef CONFIG_EXT3_FS_POSIX_ACL
+	else {
+		raw_inode->i_dir_acl = cpu_to_le32(ei->i_dir_acl);
+	}
+	raw_inode->i_file_acl = cpu_to_le32(ei->i_file_acl);
+#endif
 	raw_inode->i_generation = cpu_to_le32(inode->i_generation);
 	if (S_ISCHR(inode->i_mode) || S_ISBLK(inode->i_mode)) {
 		if (old_valid_dev(inode->i_rdev)) {
diff --git a/include/linux/ext3_fs_i.h b/include/linux/ext3_fs_i.h
index 7894dd0..9e7f1b6 100644
--- a/include/linux/ext3_fs_i.h
+++ b/include/linux/ext3_fs_i.h
@@ -75,8 +75,10 @@ struct ext3_inode_info {
 	__u8	i_frag_no;
 	__u8	i_frag_size;
 #endif
+#ifdef CONFIG_EXT3_FS_POSIX_ACL
 	ext3_fsblk_t	i_file_acl;
 	__u32	i_dir_acl;
+#endif
 	__u32	i_dtime;
 
 	/*
-- 
1.5.3.7

