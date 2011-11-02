From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 1/2] ext4: remove a the journal=update mount option
Date: Wed, 02 Nov 2011 11:33:36 -0500
Message-ID: <4EB170E0.7090701@redhat.com>
References: <4EB17085.9060107@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48588 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932709Ab1KBQdi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 2 Nov 2011 12:33:38 -0400
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pA2GXbsA028367
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Wed, 2 Nov 2011 12:33:38 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id pA2GXaFb028661
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 2 Nov 2011 12:33:37 -0400
In-Reply-To: <4EB17085.9060107@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The V2 journal format was introduced around ten years ago,
for ext3. It seems highly unlikely that anyone will need this
migration option for ext4.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 Documentation/filesystems/ext4.txt |    3 -
 fs/ext4/super.c                    |   26 ----------------
 fs/jbd2/journal.c                  |   57 -------------------------------------
 3 files changed, 1 insertion(+), 85 deletions(-)


diff --git a/Documentation/filesystems/ext4.txt b/Documentation/filesystems/ext4.txt
index 232a575..f19cecc 100644
--- a/Documentation/filesystems/ext4.txt
+++ b/Documentation/filesystems/ext4.txt
@@ -144,9 +144,6 @@ journal_async_commit	Commit block can be written to disk without waiting
 			mount the device. This will enable 'journal_checksum'
 			internally.
 
-journal=update		Update the ext4 file system's journal to the current
-			format.
-
 journal_dev=devnum	When the external journal device's major/minor numbers
 			have changed, this option allows the user to specify
 			the new journal location.  The journal device is
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 44d0c8d..6a5faac 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1306,8 +1306,7 @@ enum {
 	Opt_user_xattr, Opt_nouser_xattr, Opt_acl, Opt_noacl,
 	Opt_auto_da_alloc, Opt_noauto_da_alloc, Opt_noload, Opt_nobh, Opt_bh,
 	Opt_commit, Opt_min_batch_time, Opt_max_batch_time,
-	Opt_journal_update, Opt_journal_dev,
-	Opt_journal_checksum, Opt_journal_async_commit,
+	Opt_journal_dev, Opt_journal_checksum, Opt_journal_async_commit,
 	Opt_abort, Opt_data_journal, Opt_data_ordered, Opt_data_writeback,
 	Opt_data_err_abort, Opt_data_err_ignore,
 	Opt_usrjquota, Opt_grpjquota, Opt_offusrjquota, Opt_offgrpjquota,
@@ -1350,7 +1349,6 @@ static const match_table_t tokens = {
 	{Opt_commit, "commit=%u"},
 	{Opt_min_batch_time, "min_batch_time=%u"},
 	{Opt_max_batch_time, "max_batch_time=%u"},
-	{Opt_journal_update, "journal=update"},
 	{Opt_journal_dev, "journal_dev=%u"},
 	{Opt_journal_checksum, "journal_checksum"},
 	{Opt_journal_async_commit, "journal_async_commit"},
@@ -1598,19 +1596,6 @@ static int parse_options(char *options, struct super_block *sb,
 			ext4_msg(sb, KERN_ERR, "(no)acl options not supported");
 			break;
 #endif
-		case Opt_journal_update:
-			/* @@@ FIXME */
-			/* Eventually we will want to be able to create
-			   a journal file here.  For now, only allow the
-			   user to specify an existing inode to be the
-			   journal file. */
-			if (is_remount) {
-				ext4_msg(sb, KERN_ERR,
-					 "Cannot specify journal on remount");
-				return 0;
-			}
-			set_opt(sb, UPDATE_JOURNAL);
-			break;
 		case Opt_journal_dev:
 			if (is_remount) {
 				ext4_msg(sb, KERN_ERR,
@@ -4015,15 +4000,6 @@ static int ext4_load_journal(struct super_block *sb,
 	if (!(journal->j_flags & JBD2_BARRIER))
 		ext4_msg(sb, KERN_INFO, "barriers disabled");
 
-	if (!really_read_only && test_opt(sb, UPDATE_JOURNAL)) {
-		err = jbd2_journal_update_format(journal);
-		if (err)  {
-			ext4_msg(sb, KERN_ERR, "error updating journal");
-			jbd2_journal_destroy(journal);
-			return err;
-		}
-	}
-
 	if (!EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_RECOVER))
 		err = jbd2_journal_wipe(journal, !really_read_only);
 	if (!err) {
diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index f24df13..bed893f 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -71,7 +71,6 @@ EXPORT_SYMBOL(jbd2_journal_revoke);
 
 EXPORT_SYMBOL(jbd2_journal_init_dev);
 EXPORT_SYMBOL(jbd2_journal_init_inode);
-EXPORT_SYMBOL(jbd2_journal_update_format);
 EXPORT_SYMBOL(jbd2_journal_check_used_features);
 EXPORT_SYMBOL(jbd2_journal_check_available_features);
 EXPORT_SYMBOL(jbd2_journal_set_features);
@@ -96,7 +95,6 @@ EXPORT_SYMBOL(jbd2_journal_release_jbd_inode);
 EXPORT_SYMBOL(jbd2_journal_begin_ordered_truncate);
 EXPORT_SYMBOL(jbd2_inode_cache);
 
-static int journal_convert_superblock_v1(journal_t *, journal_superblock_t *);
 static void __journal_abort_soft (journal_t *journal, int errno);
 static int jbd2_journal_create_slab(size_t slab_size);
 
@@ -1542,61 +1540,6 @@ void jbd2_journal_clear_features(journal_t *journal, unsigned long compat,
 EXPORT_SYMBOL(jbd2_journal_clear_features);
 
 /**
- * int jbd2_journal_update_format () - Update on-disk journal structure.
- * @journal: Journal to act on.
- *
- * Given an initialised but unloaded journal struct, poke about in the
- * on-disk structure to update it to the most recent supported version.
- */
-int jbd2_journal_update_format (journal_t *journal)
-{
-	journal_superblock_t *sb;
-	int err;
-
-	err = journal_get_superblock(journal);
-	if (err)
-		return err;
-
-	sb = journal->j_superblock;
-
-	switch (be32_to_cpu(sb->s_header.h_blocktype)) {
-	case JBD2_SUPERBLOCK_V2:
-		return 0;
-	case JBD2_SUPERBLOCK_V1:
-		return journal_convert_superblock_v1(journal, sb);
-	default:
-		break;
-	}
-	return -EINVAL;
-}
-
-static int journal_convert_superblock_v1(journal_t *journal,
-					 journal_superblock_t *sb)
-{
-	int offset, blocksize;
-	struct buffer_head *bh;
-
-	printk(KERN_WARNING
-		"JBD: Converting superblock from version 1 to 2.\n");
-
-	/* Pre-initialise new fields to zero */
-	offset = ((char *) &(sb->s_feature_compat)) - ((char *) sb);
-	blocksize = be32_to_cpu(sb->s_blocksize);
-	memset(&sb->s_feature_compat, 0, blocksize-offset);
-
-	sb->s_nr_users = cpu_to_be32(1);
-	sb->s_header.h_blocktype = cpu_to_be32(JBD2_SUPERBLOCK_V2);
-	journal->j_format_version = 2;
-
-	bh = journal->j_sb_buffer;
-	BUFFER_TRACE(bh, "marking dirty");
-	mark_buffer_dirty(bh);
-	sync_dirty_buffer(bh);
-	return 0;
-}
-
