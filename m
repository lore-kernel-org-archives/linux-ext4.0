From: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Subject: [PATCH 3/4] ext3: abort ext3 if the journal has aborted
Date: Thu, 24 Jul 2008 21:40:14 +0900
Message-ID: <4888782E.2050102@hitachi.com>
References: <488876D3.80004@hitachi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	jack@suse.cz, jbacik@redhat.com, cmm@us.ibm.com, tytso@mit.edu,
	snitzer@gmail.com, tglx@linutronix.de,
	yumiko.sugita.yf@hitachi.com, satoshi.oshima.fk@hitachi.com
To: akpm@linux-foundation.org, sct@redhat.com, adilger@clusterfs.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail9.hitachi.co.jp ([133.145.228.44]:49337 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757238AbYGXMk2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 24 Jul 2008 08:40:28 -0400
In-Reply-To: <488876D3.80004@hitachi.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If the journal has aborted due to a checkpointing failure, we
have to keep the contents of the journal space.  ext3_put_super()
detects the journal abort, then it invokes ext3_abort() to make
the filesystem read only and keep needs_recovery flag.

Signed-off-by: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Acked-by: Jan Kara <jack@suse.cz>
---
 fs/ext3/ioctl.c |   12 ++++++++----
 fs/ext3/super.c |   11 +++++++++--
 2 files changed, 17 insertions(+), 6 deletions(-)

Index: linux-2.6.26-rc8-mm1/fs/ext3/ioctl.c
===================================================================
--- linux-2.6.26-rc8-mm1.orig/fs/ext3/ioctl.c
+++ linux-2.6.26-rc8-mm1/fs/ext3/ioctl.c
@@ -239,7 +239,7 @@ setrsvsz_out:
 	case EXT3_IOC_GROUP_EXTEND: {
 		ext3_fsblk_t n_blocks_count;
 		struct super_block *sb = inode->i_sb;
-		int err;
+		int err, err2;
 
 		if (!capable(CAP_SYS_RESOURCE))
 			return -EPERM;
@@ -254,8 +254,10 @@ setrsvsz_out:
 		}
 		err = ext3_group_extend(sb, EXT3_SB(sb)->s_es, n_blocks_count);
 		journal_lock_updates(EXT3_SB(sb)->s_journal);
-		journal_flush(EXT3_SB(sb)->s_journal);
+		err2 = journal_flush(EXT3_SB(sb)->s_journal);
 		journal_unlock_updates(EXT3_SB(sb)->s_journal);
+		if (err == 0)
+			err = err2;
 group_extend_out:
 		mnt_drop_write(filp->f_path.mnt);
 		return err;
@@ -263,7 +265,7 @@ group_extend_out:
 	case EXT3_IOC_GROUP_ADD: {
 		struct ext3_new_group_data input;
 		struct super_block *sb = inode->i_sb;
-		int err;
+		int err, err2;
 
 		if (!capable(CAP_SYS_RESOURCE))
 			return -EPERM;
@@ -280,8 +282,10 @@ group_extend_out:
 
 		err = ext3_group_add(sb, &input);
 		journal_lock_updates(EXT3_SB(sb)->s_journal);
-		journal_flush(EXT3_SB(sb)->s_journal);
+		err2 = journal_flush(EXT3_SB(sb)->s_journal);
 		journal_unlock_updates(EXT3_SB(sb)->s_journal);
+		if (err == 0)
+			err = err2;
 group_add_out:
 		mnt_drop_write(filp->f_path.mnt);
 		return err;
Index: linux-2.6.26-rc8-mm1/fs/ext3/super.c
===================================================================
--- linux-2.6.26-rc8-mm1.orig/fs/ext3/super.c
+++ linux-2.6.26-rc8-mm1/fs/ext3/super.c
@@ -393,7 +393,8 @@ static void ext3_put_super (struct super
 	int i;
 
 	ext3_xattr_put_super(sb);
-	journal_destroy(sbi->s_journal);
+	if (journal_destroy(sbi->s_journal) < 0)
+		ext3_abort(sb, __func__, "Couldn't clean up the journal");
 	if (!(sb->s_flags & MS_RDONLY)) {
 		EXT3_CLEAR_INCOMPAT_FEATURE(sb, EXT3_FEATURE_INCOMPAT_RECOVER);
 		es->s_state = cpu_to_le16(sbi->s_mount_state);
@@ -2388,7 +2389,13 @@ static void ext3_write_super_lockfs(stru
 
 		/* Now we set up the journal barrier. */
 		journal_lock_updates(journal);
-		journal_flush(journal);
+
+		/*
+		 * We don't want to clear needs_recovery flag when we failed
+		 * to flush the journal.
+		 */
+		if (journal_flush(journal) < 0)
+			return;
 
 		/* Journal blocked and flushed, clear needs_recovery flag. */
 		EXT3_CLEAR_INCOMPAT_FEATURE(sb, EXT3_FEATURE_INCOMPAT_RECOVER);


