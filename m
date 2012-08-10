From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] ext4: add max_dir_size_kb mount option
Date: Fri, 10 Aug 2012 15:23:58 -0400
Message-ID: <1344626638-31548-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:44039 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751832Ab2HJTYB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 10 Aug 2012 15:24:01 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Very large directories can cause significant performance problems,
especially if jobs are running in memory-tight environment (whether it
is VM's with a small amount of memory or small memory cgroups).

So it is useful, in cloud server/data center environments, to be able
to set a filesystem-wide cap on the maximum size of a directory, to
ensure that directories never get larger than a sane size.  We do this
via a new mount option, max_dir_size_kb.  If there is an attempt to
grow the directory larger than max_dir_size_kb, the system call will
return ENOSPC instead.

Google-Bug-Id: 6863013

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/ext4.h  | 1 +
 fs/ext4/namei.c | 6 ++++++
 fs/ext4/super.c | 7 +++++++
 3 files changed, 14 insertions(+)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index c3411d4..7c0841e 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1243,6 +1243,7 @@ struct ext4_sb_info {
 	unsigned int s_mb_order2_reqs;
 	unsigned int s_mb_group_prealloc;
 	unsigned int s_max_writeback_mb_bump;
+	unsigned int s_max_dir_size_kb;
 	/* where last allocation was done - for stream allocation */
 	unsigned long s_mb_last_group;
 	unsigned long s_mb_last_start;
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 2a42cc0..bdde668 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -55,6 +55,12 @@ static struct buffer_head *ext4_append(handle_t *handle,
 {
 	struct buffer_head *bh;
 
+	if (unlikely((inode->i_size >> 10) >=
+		     EXT4_SB(inode->i_sb)->s_max_dir_size_kb)) {
+		*err = -ENOSPC;
+		return NULL;
+	}
+
 	*block = inode->i_size >> inode->i_sb->s_blocksize_bits;
 
 	bh = ext4_bread(handle, inode, *block, 1, err);
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 56bcaec..5896dcb 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1230,6 +1230,7 @@ enum {
 	Opt_inode_readahead_blks, Opt_journal_ioprio,
 	Opt_dioread_nolock, Opt_dioread_lock,
 	Opt_discard, Opt_nodiscard, Opt_init_itable, Opt_noinit_itable,
+	Opt_max_dir_size_kb,
 };
 
 static const match_table_t tokens = {
@@ -1303,6 +1304,7 @@ static const match_table_t tokens = {
 	{Opt_init_itable, "init_itable=%u"},
 	{Opt_init_itable, "init_itable"},
 	{Opt_noinit_itable, "noinit_itable"},
+	{Opt_max_dir_size_kb, "max_dir_size_kb=%u"},
 	{Opt_removed, "check=none"},	/* mount option from ext2/3 */
 	{Opt_removed, "nocheck"},	/* mount option from ext2/3 */
 	{Opt_removed, "reservation"},	/* mount option from ext2/3 */
@@ -1483,6 +1485,7 @@ static const struct mount_opts {
 	{Opt_jqfmt_vfsold, QFMT_VFS_OLD, MOPT_QFMT},
 	{Opt_jqfmt_vfsv0, QFMT_VFS_V0, MOPT_QFMT},
 	{Opt_jqfmt_vfsv1, QFMT_VFS_V1, MOPT_QFMT},
+	{Opt_max_dir_size_kb, 0, MOPT_GTE0},
 	{Opt_err, 0, 0}
 };
 
@@ -1598,6 +1601,8 @@ static int handle_mount_opt(struct super_block *sb, char *opt, int token,
 			if (!args->from)
 				arg = EXT4_DEF_LI_WAIT_MULT;
 			sbi->s_li_wait_mult = arg;
+		} else if (token == Opt_max_dir_size_kb) {
+			sbi->s_max_dir_size_kb = arg;
 		} else if (token == Opt_stripe) {
 			sbi->s_stripe = arg;
 		} else if (m->flags & MOPT_DATAJ) {
@@ -1829,6 +1834,8 @@ static int _ext4_show_options(struct seq_file *seq, struct super_block *sb,
 	if (nodefs || (test_opt(sb, INIT_INODE_TABLE) &&
 		       (sbi->s_li_wait_mult != EXT4_DEF_LI_WAIT_MULT)))
 		SEQ_OPTS_PRINT("init_itable=%u", sbi->s_li_wait_mult);
+	if (nodefs || sbi->s_max_dir_size_kb)
+		SEQ_OPTS_PRINT("max_dir_size_kb=%u", sbi->s_max_dir_size_kb);
 
 	ext4_show_quota_options(seq, sb);
 	return 0;
-- 
1.7.12.rc0.22.gcdd159b

