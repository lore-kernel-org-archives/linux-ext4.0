From: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Subject: Re: + ext3-abort-ext3-if-the-journal-has-aborted.patch added to -mm
    tree
Date: Wed, 30 Jul 2008 11:44:25 +0900
Message-ID: <488FD589.2040200@hitachi.com>
References: <200807290657.m6T6vmlk019831@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: mm-commits@vger.kernel.org, jack@suse.cz,
	linux-ext4@vger.kernel.org, sct@redhat.com, adilger@clusterfs.com,
	linux-kernel@vger.kernel.org, jbacik@redhat.com, cmm@us.ibm.com,
	tytso@mit.edu, snitzer@gmail.com, tglx@linutronix.de,
	yumiko.sugita.yf@hitachi.com, satoshi.oshima.fk@hitachi.com
To: akpm@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail7.hitachi.co.jp ([133.145.228.42]:36973 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757189AbYG3Con (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 29 Jul 2008 22:44:43 -0400
In-Reply-To: <200807290657.m6T6vmlk019831@imap1.linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Andrew,

akpm@linux-foundation.org wrote:

> The patch titled
>      ext3: abort ext3 if the journal has aborted
> has been added to the -mm tree.  Its filename is
>      ext3-abort-ext3-if-the-journal-has-aborted.patch

A problem was found in this patch:

http://lkml.org/lkml/2008/7/28/15
> 4. when checkpointing fails, notify this error to the ext3 layer so
>>   that ext3 don't clear the needs_recovery flag, otherwise the
>>   journaled contents are ignored and cleaned in the recovery phase
>
> Mike Snitzer noticed that ext3_mark_recovery_complete() doesn't
> check checkpointing failure and it clears needs_recovery flag 
> (thanks, Mike!).  I need an additional fix.
>
> I also found ext3_quota_on() forces checkpointing by journal_flush()
> but it doesn't check the error.  This will appear in 2.6.27-rc1,
> so I'll send the revised patch set for 2.6.27-rc1 (it may be
> a separate patch).

I attached the revised version below.  Could you replace the patch
titled `ext3: abort ext3 if the journal has aborted' with this
new one?  Please note that the patch's title also changed.


Subject: [PATCH 3/4] ext3: add checks for errors from jbd

If the journal has aborted due to a checkpointing failure, we
have to keep the contents of the journal space.  Otherwise, the
filesystem will lose uncheckpointed metadata completely and
become inconsistent.  To avoid this, we need to keep needs_recovery
flag if checkpoint has failed.

With this patch, ext3_put_super() detects a checkpointing failure
from the return value of journal_destroy(), then it invokes
ext3_abort() to make the filesystem read only and keep
needs_recovery flag.  Errors from journal_flush() are also handled
by this patch in some places.

Signed-off-by: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
---
 fs/ext3/ioctl.c |   12 ++++++++----
 fs/ext3/super.c |   23 +++++++++++++++++++----
 2 files changed, 27 insertions(+), 8 deletions(-)

Index: linux-2.6.27-rc1/fs/ext3/ioctl.c
===================================================================
--- linux-2.6.27-rc1.orig/fs/ext3/ioctl.c
+++ linux-2.6.27-rc1/fs/ext3/ioctl.c
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
Index: linux-2.6.27-rc1/fs/ext3/super.c
===================================================================
--- linux-2.6.27-rc1.orig/fs/ext3/super.c
+++ linux-2.6.27-rc1/fs/ext3/super.c
@@ -393,7 +393,8 @@ static void ext3_put_super (struct super
 	int i;
 
 	ext3_xattr_put_super(sb);
-	journal_destroy(sbi->s_journal);
+	if (journal_destroy(sbi->s_journal) < 0)
+		ext3_abort(sb, __func__, "Couldn't clean up the journal");
 	if (!(sb->s_flags & MS_RDONLY)) {
 		EXT3_CLEAR_INCOMPAT_FEATURE(sb, EXT3_FEATURE_INCOMPAT_RECOVER);
 		es->s_state = cpu_to_le16(sbi->s_mount_state);
@@ -2280,7 +2281,9 @@ static void ext3_mark_recovery_complete(
 	journal_t *journal = EXT3_SB(sb)->s_journal;
 
 	journal_lock_updates(journal);
-	journal_flush(journal);
+	if (journal_flush(journal) < 0)
+		goto out;
+
 	lock_super(sb);
 	if (EXT3_HAS_INCOMPAT_FEATURE(sb, EXT3_FEATURE_INCOMPAT_RECOVER) &&
 	    sb->s_flags & MS_RDONLY) {
@@ -2289,6 +2292,8 @@ static void ext3_mark_recovery_complete(
 		ext3_commit_super(sb, es, 1);
 	}
 	unlock_super(sb);
+
+out:
 	journal_unlock_updates(journal);
 }
 
@@ -2388,7 +2393,13 @@ static void ext3_write_super_lockfs(stru
 
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
@@ -2806,8 +2817,12 @@ static int ext3_quota_on(struct super_bl
 		 * otherwise be livelocked...
 		 */
 		journal_lock_updates(EXT3_SB(sb)->s_journal);
-		journal_flush(EXT3_SB(sb)->s_journal);
+		err = journal_flush(EXT3_SB(sb)->s_journal);
 		journal_unlock_updates(EXT3_SB(sb)->s_journal);
+		if (err) {
+			path_put(&nd.path);
+			return err;
+		}
 	}
 
 	path_put(&nd.path);




