From: Benjamin LaHaise <bcrl@kvack.org>
Subject: [PATCH] ext4: add noorlov parameter to avoid spreading of directory inodes
Date: Tue, 1 Oct 2013 12:08:17 -0400
Message-ID: <20131001160817.GA2295@kvack.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kanga.kvack.org ([205.233.56.17]:44715 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750704Ab3JAQIR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 1 Oct 2013 12:08:17 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

While investigating a performance regression during migration of the
Solace product from an older kernel running ext3 to a 3.x kernel running
ext4, the change in allocation policies between ext3 and ext4 were found
to have caused a 10-50% decrease (depending on the test) in I/O
throughput.  In order to extract more parallelism from the filesystem,
this particular use-case has 100 subdirectories off of the root
directory of an ext4 filesystem in which files are created in a
round-robin fashion.  The subdirectories are used in order to increase
the number of metadata operations that can occur in parallel.  With the
older setup on ext3, files were created sequentially, while using ext4
resulted in the files being spread out across block groups.

To avoid this change in allocation policies, introduce the noorlov mount
parameter to ext4.  This parameter changes allocation policy such that new
subdirectories in the filesystem are allocated in the same block group
as the parent subdirectory.  With the subdirectories in the same block
group, the allocation policy once again results in files being laid out
sequentially on disk, restoring performance.

Signed-off-by: Benjamin LaHaise <ben.lahaise@solacesystems.com>
Signed-off-by: Benjamin LaHaise <bcrl@kvack.org>

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index af815ea..3894ab0 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -985,6 +985,8 @@ struct ext4_inode_info {
 #define EXT4_MOUNT2_STD_GROUP_SIZE	0x00000002 /* We have standard group
 						      size of blocksize * 8
 						      blocks */
+#define EXT4_MOUNT2_NO_ORLOV		0x00000004 /* Disable orlov for inode
+						      allocation */
 
 #define clear_opt(sb, opt)		EXT4_SB(sb)->s_mount_opt &= \
 						~EXT4_MOUNT_##opt
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 137193f..2b1b4ee 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -745,7 +745,7 @@ struct inode *__ext4_new_inode(handle_t *handle, struct inode *dir,
 		goto got_group;
 	}
 
-	if (S_ISDIR(mode))
+	if (!test_opt2(sb, NO_ORLOV) && S_ISDIR(mode))
 		ret2 = find_group_orlov(sb, dir, &group, mode, qstr);
 	else
 		ret2 = find_group_other(sb, dir, &group, mode);
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 2c2e6cb..d0bdcd7 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1143,7 +1143,7 @@ enum {
 	Opt_inode_readahead_blks, Opt_journal_ioprio,
 	Opt_dioread_nolock, Opt_dioread_lock,
 	Opt_discard, Opt_nodiscard, Opt_init_itable, Opt_noinit_itable,
-	Opt_max_dir_size_kb,
+	Opt_max_dir_size_kb, Opt_noorlov,
 };
 
 static const match_table_t tokens = {
@@ -1163,6 +1163,7 @@ static const match_table_t tokens = {
 	{Opt_debug, "debug"},
 	{Opt_removed, "oldalloc"},
 	{Opt_removed, "orlov"},
+	{Opt_noorlov, "noorlov"},
 	{Opt_user_xattr, "user_xattr"},
 	{Opt_nouser_xattr, "nouser_xattr"},
 	{Opt_acl, "acl"},
@@ -1341,6 +1342,7 @@ static const struct mount_opts {
 	int	token;
 	int	mount_opt;
 	int	flags;
+	int	mount_opt2;
 } ext4_mount_opts[] = {
 	{Opt_minix_df, EXT4_MOUNT_MINIX_DF, MOPT_SET},
 	{Opt_bsd_df, EXT4_MOUNT_MINIX_DF, MOPT_CLEAR},
@@ -1417,6 +1419,7 @@ static const struct mount_opts {
 	{Opt_jqfmt_vfsv0, QFMT_VFS_V0, MOPT_QFMT},
 	{Opt_jqfmt_vfsv1, QFMT_VFS_V1, MOPT_QFMT},
 	{Opt_max_dir_size_kb, 0, MOPT_GTE0},
+	{Opt_noorlov, 0, MOPT_SET, EXT4_MOUNT2_NO_ORLOV},
 	{Opt_err, 0, 0}
 };
 
@@ -1601,6 +1604,7 @@ static int handle_mount_opt(struct super_block *sb, char *opt, int token,
 		} else {
 			clear_opt(sb, DATA_FLAGS);
 			sbi->s_mount_opt |= m->mount_opt;
+			sbi->s_mount_opt2 |= m->mount_opt2;
 		}
 #ifdef CONFIG_QUOTA
 	} else if (m->flags & MOPT_QFMT) {
@@ -1630,10 +1634,13 @@ static int handle_mount_opt(struct super_block *sb, char *opt, int token,
 			WARN_ON(1);
 			return -1;
 		}
-		if (arg != 0)
+		if (arg != 0) {
 			sbi->s_mount_opt |= m->mount_opt;
-		else
+			sbi->s_mount_opt2 |= m->mount_opt2;
+		} else {
 			sbi->s_mount_opt &= ~m->mount_opt;
+			sbi->s_mount_opt2 &= ~m->mount_opt2;
+		}
 	}
 	return 1;
 }
@@ -1777,11 +1784,15 @@ static int _ext4_show_options(struct seq_file *seq, struct super_block *sb,
 		if (((m->flags & (MOPT_SET|MOPT_CLEAR)) == 0) ||
 		    (m->flags & MOPT_CLEAR_ERR))
 			continue;
-		if (!(m->mount_opt & (sbi->s_mount_opt ^ def_mount_opt)))
+		if (!(m->mount_opt & (sbi->s_mount_opt ^ def_mount_opt)) &&
+		    !(m->mount_opt2 & sbi->s_mount_opt2))
 			continue; /* skip if same as the default */
-		if ((want_set &&
-		     (sbi->s_mount_opt & m->mount_opt) != m->mount_opt) ||
-		    (!want_set && (sbi->s_mount_opt & m->mount_opt)))
+		if (want_set &&
+		    (((sbi->s_mount_opt & m->mount_opt) != m->mount_opt) ||
+		     ((sbi->s_mount_opt2 & m->mount_opt2) != m->mount_opt2)))
+			continue; /* select Opt_noFoo vs Opt_Foo */
+		if (!want_set && ((sbi->s_mount_opt & m->mount_opt) ||
+				  (sbi->s_mount_opt2 & m->mount_opt2)))
 			continue; /* select Opt_noFoo vs Opt_Foo */
 		SEQ_OPTS_PRINT("%s", token2str(m->token));
 	}
