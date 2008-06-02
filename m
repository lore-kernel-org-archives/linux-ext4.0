From: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Subject: [PATCH 5/5] ext3: abort ext3 if the journal has aborted
Date: Mon, 02 Jun 2008 19:48:41 +0900
Message-ID: <4843D009.9010200@hitachi.com>
References: <4843CE15.6080506@hitachi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	jack@suse.cz, jbacik@redhat.com, cmm@us.ibm.com, tytso@mit.edu,
	sugita <yumiko.sugita.yf@hitachi.com>,
	Satoshi OSHIMA <satoshi.oshima.fk@hitachi.com>
To: akpm@linux-foundation.org, sct@redhat.com, adilger@clusterfs.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail9.hitachi.co.jp ([133.145.228.44]:57802 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986AbYFBKsu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 2 Jun 2008 06:48:50 -0400
In-Reply-To: <4843CE15.6080506@hitachi.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Subject: [PATCH 5/5] ext3: abort ext3 if the journal has aborted

If the journal has aborted due to a checkpointing failure, we
have to keep the contents of the journal space.  ext3_put_super()
detects the journal abort, then it invokes ext3_abort() to make
the filesystem read only and keep needs_recovery flag.

Signed-off-by: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
---
 fs/ext3/ioctl.c |   12 ++++++------
 fs/ext3/super.c |   11 +++++++++--
 2 files changed, 15 insertions(+), 8 deletions(-)

Index: linux-2.6.26-rc4/fs/ext3/ioctl.c
===================================================================
--- linux-2.6.26-rc4.orig/fs/ext3/ioctl.c
+++ linux-2.6.26-rc4/fs/ext3/ioctl.c
@@ -239,7 +239,7 @@ setrsvsz_out:
 	case EXT3_IOC_GROUP_EXTEND: {
 		ext3_fsblk_t n_blocks_count;
 		struct super_block *sb = inode->i_sb;
-		int err;
+		int err, err2;
 
 		if (!capable(CAP_SYS_RESOURCE))
 			return -EPERM;
@@ -254,16 +254,16 @@ setrsvsz_out:
 		}
 		err = ext3_group_extend(sb, EXT3_SB(sb)->s_es, n_blocks_count);
 		journal_lock_updates(EXT3_SB(sb)->s_journal);
-		journal_flush(EXT3_SB(sb)->s_journal);
+		err2 = journal_flush(EXT3_SB(sb)->s_journal);
 		journal_unlock_updates(EXT3_SB(sb)->s_journal);
 group_extend_out:
 		mnt_drop_write(filp->f_path.mnt);
-		return err;
+		return (err) ? err : err2;
 	}
 	case EXT3_IOC_GROUP_ADD: {
 		struct ext3_new_group_data input;
 		struct super_block *sb = inode->i_sb;
-		int err;
+		int err, err2;
 
 		if (!capable(CAP_SYS_RESOURCE))
 			return -EPERM;
@@ -280,11 +280,11 @@ group_extend_out:
 
 		err = ext3_group_add(sb, &input);
 		journal_lock_updates(EXT3_SB(sb)->s_journal);
-		journal_flush(EXT3_SB(sb)->s_journal);
+		err2 = journal_flush(EXT3_SB(sb)->s_journal);
 		journal_unlock_updates(EXT3_SB(sb)->s_journal);
 group_add_out:
 		mnt_drop_write(filp->f_path.mnt);
-		return err;
+		return (err) ? err : err2;
 	}
 
 
Index: linux-2.6.26-rc4/fs/ext3/super.c
===================================================================
--- linux-2.6.26-rc4.orig/fs/ext3/super.c
+++ linux-2.6.26-rc4/fs/ext3/super.c
@@ -393,7 +393,8 @@ static void ext3_put_super (struct super
 	int i;
 
 	ext3_xattr_put_super(sb);
-	journal_destroy(sbi->s_journal);
+	if (journal_destroy(sbi->s_journal) < 0)
+		ext3_abort(sb, __func__, "Couldn't clean up the journal");
 	if (!(sb->s_flags & MS_RDONLY)) {
 		EXT3_CLEAR_INCOMPAT_FEATURE(sb, EXT3_FEATURE_INCOMPAT_RECOVER);
 		es->s_state = cpu_to_le16(sbi->s_mount_state);
@@ -2373,7 +2374,13 @@ static void ext3_write_super_lockfs(stru
 
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


