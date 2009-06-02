From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH,STABLE 2.6.29 09/18] ext4: Add auto_da_alloc mount option
Date: Tue,  2 Jun 2009 08:07:50 -0400
Message-ID: <1243944479-20574-9-git-send-email-tytso@mit.edu>
References: <1243944479-20574-1-git-send-email-tytso@mit.edu>
 <1243944479-20574-2-git-send-email-tytso@mit.edu>
 <1243944479-20574-3-git-send-email-tytso@mit.edu>
 <1243944479-20574-4-git-send-email-tytso@mit.edu>
 <1243944479-20574-5-git-send-email-tytso@mit.edu>
 <1243944479-20574-6-git-send-email-tytso@mit.edu>
 <1243944479-20574-7-git-send-email-tytso@mit.edu>
 <1243944479-20574-8-git-send-email-tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>
To: stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:33531 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751503AbZFBMIK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 2 Jun 2009 08:08:10 -0400
In-Reply-To: <1243944479-20574-8-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Add a mount option which allows the user to disable automatic
allocation of blocks whose allocation by delayed allocation when the
file was originally truncated or when the file is renamed over an
existing file.  This feature is intended to save users from the
effects of naive application writers, but it reduces the effectiveness
of the delayed allocation code.  This mount option disables this
safety feature, which may be desirable for prodcutions systems where
the risk of unclean shutdowns or unexpected system crashes is low.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
(cherry picked from commit afd4672dc7610b7feef5190168aa917cc2e417e4)
---
 fs/ext4/ext4.h  |    2 +-
 fs/ext4/inode.c |    2 +-
 fs/ext4/namei.c |    3 ++-
 fs/ext4/super.c |   25 +++++++++++++------------
 4 files changed, 17 insertions(+), 15 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 83f685d..a2bd86e 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -557,7 +557,7 @@ do {									       \
 #define EXT4_MOUNT_NO_UID32		0x02000  /* Disable 32-bit UIDs */
 #define EXT4_MOUNT_XATTR_USER		0x04000	/* Extended user attributes */
 #define EXT4_MOUNT_POSIX_ACL		0x08000	/* POSIX Access Control Lists */
-#define EXT4_MOUNT_RESERVATION		0x10000	/* Preallocation */
+#define EXT4_MOUNT_NO_AUTO_DA_ALLOC	0x10000	/* No auto delalloc mapping */
 #define EXT4_MOUNT_BARRIER		0x20000 /* Use block barriers */
 #define EXT4_MOUNT_NOBH			0x40000 /* No bufferheads */
 #define EXT4_MOUNT_QUOTA		0x80000 /* Some quota option set */
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 3dafa6b..8ff6762 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3887,7 +3887,7 @@ void ext4_truncate(struct inode *inode)
 	if (!ext4_can_truncate(inode))
 		return;
 
-	if (inode->i_size == 0)
+	if (inode->i_size == 0 && !test_opt(inode->i_sb, NO_AUTO_DA_ALLOC))
 		ei->i_state |= EXT4_STATE_DA_ALLOC_CLOSE;
 
 	if (EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL) {
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 63568ec..8977e60 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2457,7 +2457,8 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
 		ext4_mark_inode_dirty(handle, new_inode);
 		if (!new_inode->i_nlink)
 			ext4_orphan_add(handle, new_inode);
-		force_da_alloc = 1;
+		if (!test_opt(new_dir->i_sb, NO_AUTO_DA_ALLOC))
+			force_da_alloc = 1;
 	}
 	retval = 0;
 
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 39d1993..1ad3c20 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -803,8 +803,6 @@ static int ext4_show_options(struct seq_file *seq, struct vfsmount *vfs)
 	if (!test_opt(sb, POSIX_ACL) && (def_mount_opts & EXT4_DEFM_ACL))
 		seq_puts(seq, ",noacl");
 #endif
-	if (!test_opt(sb, RESERVATION))
-		seq_puts(seq, ",noreservation");
 	if (sbi->s_commit_interval != JBD2_DEFAULT_MAX_COMMIT_AGE*HZ) {
 		seq_printf(seq, ",commit=%u",
 			   (unsigned) (sbi->s_commit_interval / HZ));
@@ -855,6 +853,9 @@ static int ext4_show_options(struct seq_file *seq, struct vfsmount *vfs)
 	if (test_opt(sb, DATA_ERR_ABORT))
 		seq_puts(seq, ",data_err=abort");
 
+	if (test_opt(sb, NO_AUTO_DA_ALLOC))
+		seq_puts(seq, ",auto_da_alloc=0");
+
 	ext4_show_quota_options(seq, sb);
 	return 0;
 }
@@ -1002,7 +1003,7 @@ enum {
 	Opt_resgid, Opt_resuid, Opt_sb, Opt_err_cont, Opt_err_panic, Opt_err_ro,
 	Opt_nouid32, Opt_debug, Opt_oldalloc, Opt_orlov,
 	Opt_user_xattr, Opt_nouser_xattr, Opt_acl, Opt_noacl,
-	Opt_reservation, Opt_noreservation, Opt_noload, Opt_nobh, Opt_bh,
+	Opt_auto_da_alloc, Opt_noload, Opt_nobh, Opt_bh,
 	Opt_commit, Opt_min_batch_time, Opt_max_batch_time,
 	Opt_journal_update, Opt_journal_dev,
 	Opt_journal_checksum, Opt_journal_async_commit,
@@ -1037,8 +1038,6 @@ static const match_table_t tokens = {
 	{Opt_nouser_xattr, "nouser_xattr"},
 	{Opt_acl, "acl"},
 	{Opt_noacl, "noacl"},
-	{Opt_reservation, "reservation"},
-	{Opt_noreservation, "noreservation"},
 	{Opt_noload, "noload"},
 	{Opt_nobh, "nobh"},
 	{Opt_bh, "bh"},
@@ -1073,6 +1072,7 @@ static const match_table_t tokens = {
 	{Opt_nodelalloc, "nodelalloc"},
 	{Opt_inode_readahead_blks, "inode_readahead_blks=%u"},
 	{Opt_journal_ioprio, "journal_ioprio=%u"},
+	{Opt_auto_da_alloc, "auto_da_alloc=%u"},
 	{Opt_err, NULL},
 };
 
@@ -1205,12 +1205,6 @@ static int parse_options(char *options, struct super_block *sb,
 			       "not supported\n");
 			break;
 #endif
-		case Opt_reservation:
-			set_opt(sbi->s_mount_opt, RESERVATION);
-			break;
-		case Opt_noreservation:
-			clear_opt(sbi->s_mount_opt, RESERVATION);
-			break;
 		case Opt_journal_update:
 			/* @@@ FIXME */
 			/* Eventually we will want to be able to create
@@ -1471,6 +1465,14 @@ set_qf_format:
 			*journal_ioprio = IOPRIO_PRIO_VALUE(IOPRIO_CLASS_BE,
 							    option);
 			break;
+		case Opt_auto_da_alloc:
+			if (match_int(&args[0], &option))
+				return 0;
+			if (option)
+				clear_opt(sbi->s_mount_opt, NO_AUTO_DA_ALLOC);
+			else
+				set_opt(sbi->s_mount_opt,NO_AUTO_DA_ALLOC);
+			break;
 		default:
 			printk(KERN_ERR
 			       "EXT4-fs: Unrecognized mount option \"%s\" "
@@ -2099,7 +2101,6 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	sbi->s_min_batch_time = EXT4_DEF_MIN_BATCH_TIME;
 	sbi->s_max_batch_time = EXT4_DEF_MAX_BATCH_TIME;
 
-	set_opt(sbi->s_mount_opt, RESERVATION);
 	set_opt(sbi->s_mount_opt, BARRIER);
 
 	/*
-- 
1.6.3.1.1.g75fc.dirty

