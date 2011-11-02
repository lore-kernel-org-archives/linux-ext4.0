From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 2/2 V2] ext4: remove the resize mount option
Date: Wed, 02 Nov 2011 11:36:58 -0500
Message-ID: <4EB171AA.2040006@redhat.com>
References: <4EB17085.9060107@redhat.com> <4EB1717B.1000202@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32255 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932731Ab1KBQhA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 2 Nov 2011 12:37:00 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pA2Gb00w026716
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Wed, 2 Nov 2011 12:37:00 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id pA2Gawhn031204
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 2 Nov 2011 12:36:59 -0400
In-Reply-To: <4EB1717B.1000202@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The resize mount option seems to be of limited value,
especially in the age of online resize2fs.  Nuke it.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
V2: get the subject right.

 Documentation/filesystems/ext4.txt |    5 -----
 fs/ext4/super.c                    |   29 ++++++-----------------------
 2 files changed, 6 insertions(+), 28 deletions(-)


diff --git a/Documentation/filesystems/ext4.txt b/Documentation/filesystems/ext4.txt
index f19cecc..4ea728a 100644
--- a/Documentation/filesystems/ext4.txt
+++ b/Documentation/filesystems/ext4.txt
@@ -362,11 +362,6 @@ nouid32			Disables 32-bit UIDs and GIDs.  This is for
 			interoperability  with  older kernels which only
 			store and expect 16-bit values.
 
-resize			Allows to resize filesystem to the end of the last
-			existing block group, further resize has to be done
-			with resize2fs either online, or offline. It can be
-			used only with conjunction with remount.
-
 block_validity		This options allows to enables/disables the in-kernel
 noblock_validity	facility for tracking filesystem metadata blocks
 			within internal data structures. This allows multi-
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 6a5faac..0f11e99 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1312,7 +1312,7 @@ enum {
 	Opt_usrjquota, Opt_grpjquota, Opt_offusrjquota, Opt_offgrpjquota,
 	Opt_jqfmt_vfsold, Opt_jqfmt_vfsv0, Opt_jqfmt_vfsv1, Opt_quota,
 	Opt_noquota, Opt_ignore, Opt_barrier, Opt_nobarrier, Opt_err,
-	Opt_resize, Opt_usrquota, Opt_grpquota, Opt_i_version,
+	Opt_usrquota, Opt_grpquota, Opt_i_version,
 	Opt_stripe, Opt_delalloc, Opt_nodelalloc, Opt_mblk_io_submit,
 	Opt_nomblk_io_submit, Opt_block_validity, Opt_noblock_validity,
 	Opt_inode_readahead_blks, Opt_journal_ioprio,
@@ -1374,7 +1374,6 @@ static const match_table_t tokens = {
 	{Opt_nobarrier, "nobarrier"},
 	{Opt_i_version, "i_version"},
 	{Opt_stripe, "stripe=%u"},
-	{Opt_resize, "resize"},
 	{Opt_delalloc, "delalloc"},
 	{Opt_nodelalloc, "nodelalloc"},
 	{Opt_mblk_io_submit, "mblk_io_submit"},
@@ -1484,7 +1483,7 @@ static int clear_qf_name(struct super_block *sb, int qtype)
 static int parse_options(char *options, struct super_block *sb,
 			 unsigned long *journal_devnum,
 			 unsigned int *journal_ioprio,
-			 ext4_fsblk_t *n_blocks_count, int is_remount)
+			 int is_remount)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	char *p;
@@ -1761,17 +1760,6 @@ set_qf_format:
 			break;
 		case Opt_ignore:
 			break;
-		case Opt_resize:
-			if (!is_remount) {
-				ext4_msg(sb, KERN_ERR,
-					"resize option only available "
-					"for remount");
-				return 0;
-			}
-			if (match_int(&args[0], &option) != 0)
-				return 0;
-			*n_blocks_count = option;
-			break;
 		case Opt_nobh:
 			ext4_msg(sb, KERN_WARNING,
 				 "Ignoring deprecated nobh option");
@@ -3200,13 +3188,13 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	sbi->s_li_wait_mult = EXT4_DEF_LI_WAIT_MULT;
 
 	if (!parse_options((char *) sbi->s_es->s_mount_opts, sb,
-			   &journal_devnum, &journal_ioprio, NULL, 0)) {
+			   &journal_devnum, &journal_ioprio, 0)) {
 		ext4_msg(sb, KERN_WARNING,
 			 "failed to parse options in superblock: %s",
 			 sbi->s_es->s_mount_opts);
 	}
 	if (!parse_options((char *) data, sb, &journal_devnum,
-			   &journal_ioprio, NULL, 0))
+			   &journal_ioprio, 0))
 		goto failed_mount;
 
 	sb->s_flags = (sb->s_flags & ~MS_POSIXACL) |
@@ -4285,7 +4273,6 @@ static int ext4_remount(struct super_block *sb, int *flags, char *data)
 {
 	struct ext4_super_block *es;
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
-	ext4_fsblk_t n_blocks_count = 0;
 	unsigned long old_sb_flags;
 	struct ext4_mount_options old_opts;
 	int enable_quota = 0;
@@ -4318,8 +4305,7 @@ static int ext4_remount(struct super_block *sb, int *flags, char *data)
 	/*
 	 * Allow the "check" option to be passed as a remount option.
 	 */
-	if (!parse_options(data, sb, NULL, &journal_ioprio,
-			   &n_blocks_count, 1)) {
+	if (!parse_options(data, sb, NULL, &journal_ioprio, 1)) {
 		err = -EINVAL;
 		goto restore_opts;
 	}
@@ -4337,8 +4323,7 @@ static int ext4_remount(struct super_block *sb, int *flags, char *data)
 		set_task_ioprio(sbi->s_journal->j_task, journal_ioprio);
 	}
 
-	if ((*flags & MS_RDONLY) != (sb->s_flags & MS_RDONLY) ||
-		n_blocks_count > ext4_blocks_count(es)) {
+	if ((*flags & MS_RDONLY) != (sb->s_flags & MS_RDONLY)) {
 		if (sbi->s_mount_flags & EXT4_MF_FS_ABORTED) {
 			err = -EROFS;
 			goto restore_opts;
@@ -4413,8 +4398,6 @@ static int ext4_remount(struct super_block *sb, int *flags, char *data)
 			if (sbi->s_journal)
 				ext4_clear_journal_err(sb, es);
 			sbi->s_mount_state = le16_to_cpu(es->s_state);
-			if ((err = ext4_group_extend(sb, es, n_blocks_count)))
-				goto restore_opts;
 			if (!ext4_setup_super(sb, es, 0))
 				sb->s_flags &= ~MS_RDONLY;
 			if (EXT4_HAS_INCOMPAT_FEATURE(sb,


