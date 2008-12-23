From: Coly Li <coly.li@suse.de>
Subject: [FYI][PATCH] ext4: directory inode reservation, v5
Date: Tue, 23 Dec 2008 11:09:00 +0800
Message-ID: <4950564C.2010402@suse.de>
Reply-To: coly.li@suse.de
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ns2.suse.de ([195.135.220.15]:50875 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752853AbYLWDC3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 22 Dec 2008 22:02:29 -0500
Received: from Relay1.suse.de (mail2.suse.de [195.135.221.8])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx2.suse.de (Postfix) with ESMTP id 79EE04855D
	for <linux-ext4@vger.kernel.org>; Tue, 23 Dec 2008 04:02:28 +0100 (CET)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

sorry send out this patch too late. This patch was wrote against comments from Mingming, Jan.
On SSD or hard disk forced large cache, performance improvement is not so obvious by directory inode
reservation. Therefore, currently I will not pay more attention to improve this patch. But if anyone
has good idea, I do appreciate s/he to share with me :)

Thanks to everyone who reviews and comments on this patch :-)

Signed-off-by: Coly Li <coly.li@suse.de>
---
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 028e601..bdb5844 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -499,6 +499,78 @@ fallback:
 	return -1;
 }

+
+static int ext4_ino_from_ireserve(handle_t *handle, struct inode *dir,
+				int mode, ext4_group_t *group, unsigned long *ino)
+{
+	struct super_block *sb;
+	struct ext4_sb_info *sbi;
+	struct ext4_group_desc *gdp = NULL;
+	struct buffer_head *gdp_bh = NULL, *bitmap_bh = NULL;
+	ext4_group_t ires_group = *group;
+	unsigned long ires_ino;
+	int i, bit;
+
+	sb = dir->i_sb;
+	sbi = EXT4_SB(sb);
+
+	/* if the inode number is not for directory,
+	 * only try to allocate after directory's inode
+	 */
+	if (!S_ISDIR(mode)) {
+		*ino = dir->i_ino % EXT4_INODES_PER_GROUP(sb);
+		return 0;
+	}
+
+	/* reserve inodes for new directory */
+	for (i = 0; i < sbi->s_groups_count; i++) {
+		gdp = ext4_get_group_desc(sb, ires_group, &gdp_bh);
+		if (!gdp)
+			goto fail;
+		brelse(bitmap_bh);
+		bitmap_bh = read_inode_bitmap(sb, ires_group);
+		if (!bitmap_bh)
+			goto fail;
+
+		bit = 0;
+
+		while (bit < EXT4_INODES_PER_GROUP(sb)) {
+			if (!ext4_test_bit(bit, bitmap_bh->b_data)) {
+				BUFFER_TRACE(bitmap_bh, "get_write_access");
+				if (ext4_journal_get_write_access(
+				    handle, bitmap_bh) != 0)
+					goto fail;
+				if (!ext4_set_bit_atomic(sb_bgl_lock(sbi,
+				     ires_group), bit, bitmap_bh->b_data)) {
+					/* we won it */
+					BUFFER_TRACE(bitmap_bh,
+					"call ext4_journal_dirty_metadata");
+					if (ext4_journal_dirty_metadata(handle,
+					    bitmap_bh) != 0)
+						goto fail;
+					ires_ino = bit;
+					goto find;
+				}
+				/* we lost it */
+				jbd2_journal_release_buffer(handle, bitmap_bh);
+			}
+			bit += sbi->s_dir_ireserve_nr;
+		}
+		if (++ires_group == sbi->s_groups_count)
+			ires_group = 0;
+	}
+	goto fail;
+find:
+	brelse(bitmap_bh);
+	*group = ires_group;
+	*ino = ires_ino;
+	return 0;
+fail:
+	brelse(bitmap_bh);
+	return -ENOSPC;
+}
+
+
 static int find_group_other(struct super_block *sb, struct inode *parent,
 				ext4_group_t *group)
 {
@@ -616,6 +688,15 @@ got_group:
 	if (ret2 == -1)
 		goto out;

+	if (test_opt(sb, DIR_IRESERVE)) {
+		err = ext4_ino_from_ireserve(handle, dir,
+				mode, &group, &ino);
+		if ((!err) && S_ISDIR(mode)) {
+			gdp = ext4_get_group_desc(sb, group, &bh2);
+			if (gdp) goto got;
+		}
+	}
+
 	for (i = 0; i < sbi->s_groups_count; i++) {
 		err = -EIO;

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 34fdfad..05cbf8c 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -758,6 +758,10 @@ static int ext4_show_options(struct seq_file *seq, struct vfsmount *vfs)
 	else if (test_opt(sb, DATA_FLAGS) == EXT4_MOUNT_WRITEBACK_DATA)
 		seq_puts(seq, ",data=writeback");

+	if (test_opt(sb, DIR_IRESERVE))
+		seq_printf(seq, ",dir_ireserve=%u",
+			(unsigned)sbi->s_dir_ireserve_nr);
+
 	ext4_show_quota_options(seq, sb);
 	return 0;
 }
@@ -884,7 +888,7 @@ enum {
 	Opt_user_xattr, Opt_nouser_xattr, Opt_acl, Opt_noacl,
 	Opt_reservation, Opt_noreservation, Opt_noload, Opt_nobh, Opt_bh,
 	Opt_commit, Opt_journal_update, Opt_journal_inum, Opt_journal_dev,
-	Opt_journal_checksum, Opt_journal_async_commit,
+	Opt_journal_checksum, Opt_journal_async_commit, Opt_dir_ireserve,
 	Opt_abort, Opt_data_journal, Opt_data_ordered, Opt_data_writeback,
 	Opt_usrjquota, Opt_grpjquota, Opt_offusrjquota, Opt_offgrpjquota,
 	Opt_jqfmt_vfsold, Opt_jqfmt_vfsv0, Opt_quota, Opt_noquota,
@@ -927,6 +931,7 @@ static match_table_t tokens = {
 	{Opt_journal_dev, "journal_dev=%u"},
 	{Opt_journal_checksum, "journal_checksum"},
 	{Opt_journal_async_commit, "journal_async_commit"},
+	{Opt_dir_ireserve, "dir_ireserve=%u"},
 	{Opt_abort, "abort"},
 	{Opt_data_journal, "data=journal"},
 	{Opt_data_ordered, "data=ordered"},
@@ -1127,6 +1132,30 @@ static int parse_options (char *options, struct super_block *sb,
 			set_opt(sbi->s_mount_opt, JOURNAL_ASYNC_COMMIT);
 			set_opt(sbi->s_mount_opt, JOURNAL_CHECKSUM);
 			break;
+		case Opt_dir_ireserve:
+			if (match_int(&args[0], &option))
+				return 0;
+			if (option < DIR_IRESERVE_MIN_NR) {
+				printk(KERN_ERR
+					"EXT4-fs: Can not accept "
+					"dir_ireserve < %d\n",
+					DIR_IRESERVE_MIN_NR);
+				return 0;
+			}
+			if (option > DIR_IRESERVE_MAX_NR) {
+				printk(KERN_ERR
+					"EXT4-fs: Can not accept "
+					"dir_ireserve > %d\n",
+					DIR_IRESERVE_MAX_NR);
+				return 0;
+			}
+			set_opt(sbi->s_mount_opt, DIR_IRESERVE);
+			/* make dir_ireserve alligned to 8  */
+			sbi->s_dir_ireserve_nr = ((unsigned)option + 0x7)&(~0x7);
+			printk("EXT4-fs: dir inodes reservation enabled, "
+				"reserve %u inodes in directory.\n",
+				sbi->s_dir_ireserve_nr);
+			break;
 		case Opt_noload:
 			set_opt (sbi->s_mount_opt, NOLOAD);
 			break;
diff --git a/include/linux/ext4_fs.h b/include/linux/ext4_fs.h
index be1729c..c0b9203 100644
--- a/include/linux/ext4_fs.h
+++ b/include/linux/ext4_fs.h
@@ -111,6 +111,10 @@ struct ext4_allocation_request {
 /* First non-reserved inode for old ext4 filesystems */
 #define EXT4_GOOD_OLD_FIRST_INO	11

+/* min and max reserved inodes in directory */
+#define DIR_IRESERVE_MIN_NR	4
+#define DIR_IRESERVE_MAX_NR	1024
+
 /*
  * Maximal count of links to a file
  */
@@ -586,6 +590,7 @@ do {									       \
 #define EXT4_MOUNT_I_VERSION            0x2000000 /* i_version support */
 #define EXT4_MOUNT_MBALLOC		0x4000000 /* Buddy allocation support */
 #define EXT4_MOUNT_DELALLOC		0x8000000 /* Delalloc support */
+#define EXT4_MOUNT_DIR_IRESERVE		0x10000000 /* dir inode reservation */
 /* Compatibility, for having both ext2_fs.h and ext4_fs.h included at once */
 #ifndef _LINUX_EXT2_FS_H
 #define clear_opt(o, opt)		o &= ~EXT4_MOUNT_##opt
diff --git a/include/linux/ext4_fs_sb.h b/include/linux/ext4_fs_sb.h
index b419fa4..958ac49 100644
--- a/include/linux/ext4_fs_sb.h
+++ b/include/linux/ext4_fs_sb.h
@@ -143,6 +143,8 @@ struct ext4_sb_info {

 	/* locality groups */
 	struct ext4_locality_group *s_locality_groups;
+	/* number of inodes we reserve in a directory */
+	int s_dir_ireserve_nr;

 	unsigned int s_log_groups_per_flex;
 	struct flex_groups *s_flex_groups;
-- 
Coly Li
SuSE PRC Labs
