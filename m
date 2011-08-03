From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Subject: Re: [PATCH] ext3: fix message in ext3_remount for rw-remount case
Date: Wed, 3 Aug 2011 22:25:48 +0900
Message-ID: <20110803222548.7c1ee229.toshi.okajima@jp.fujitsu.com>
References: <20110801135451.cb73c981.toshi.okajima@jp.fujitsu.com>
	<20110801084526.GB6522@quack.suse.cz>
	<4E3675D6.3010201@jp.fujitsu.com>
	<20110801095731.GI6522@quack.suse.cz>
	<4E37BFEA.7020601@jp.fujitsu.com>
	<4E38B57B.4050304@jp.fujitsu.com>
	<20110803095754.GA5047@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: akpm@linux-foundation.org, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:53750 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755764Ab1HCN1d (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 3 Aug 2011 09:27:33 -0400
Received: from m1.gw.fujitsu.co.jp (unknown [10.0.50.71])
	by fgwmail5.fujitsu.co.jp (Postfix) with ESMTP id 364AC3EE0BD
	for <linux-ext4@vger.kernel.org>; Wed,  3 Aug 2011 22:27:31 +0900 (JST)
Received: from smail (m1 [127.0.0.1])
	by outgoing.m1.gw.fujitsu.co.jp (Postfix) with ESMTP id 1923845DE5B
	for <linux-ext4@vger.kernel.org>; Wed,  3 Aug 2011 22:27:31 +0900 (JST)
Received: from s1.gw.fujitsu.co.jp (s1.gw.fujitsu.co.jp [10.0.50.91])
	by m1.gw.fujitsu.co.jp (Postfix) with ESMTP id 01DF045DE56
	for <linux-ext4@vger.kernel.org>; Wed,  3 Aug 2011 22:27:31 +0900 (JST)
Received: from s1.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s1.gw.fujitsu.co.jp (Postfix) with ESMTP id E93491DB8052
	for <linux-ext4@vger.kernel.org>; Wed,  3 Aug 2011 22:27:30 +0900 (JST)
Received: from ml13.s.css.fujitsu.com (ml13.s.css.fujitsu.com [10.240.81.133])
	by s1.gw.fujitsu.co.jp (Postfix) with ESMTP id 9CE401DB804F
	for <linux-ext4@vger.kernel.org>; Wed,  3 Aug 2011 22:27:30 +0900 (JST)
In-Reply-To: <20110803095754.GA5047@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi.

On Wed, 3 Aug 2011 11:57:54 +0200
Jan Kara <jack@suse.cz> wrote:
>   Hello,
> 
> On Wed 03-08-11 11:42:03, Toshiyuki Okajima wrote:
> > >(2011/08/01 18:57), Jan Kara wrote:
> > >>On Mon 01-08-11 18:45:58, Toshiyuki Okajima wrote:
> > >>>(2011/08/01 17:45), Jan Kara wrote:
> > >>>>On Mon 01-08-11 13:54:51, Toshiyuki Okajima wrote:
> > >>>>>If there are some inodes in orphan list while a filesystem is being
> > >>>>>read-only mounted, we should recommend that pepole umount and then
> > >>>>>mount it when they try to remount with read-write. But the current
> > >>>>>message/comment recommends that they umount and then remount it.
> > <SNIP>
> > >>>>the most... BTW, I guess you didn't really see this message in practice, did
> > >>>>you?
> > >>>No.
> > >>>I have seen this message in practice while quotacheck command was repeatedly
> > >>>executed per an hour.
> > >>Interesting. Are you able to reproduce this? Quotacheck does remount
> > >>read-only + remount read-write but you cannot really remount the filesystem
> > >>read-only when it has orphan inodes and so you should not see those when
> > >>you remount read-write again. Possibly there's race between remounting and
> > >>unlinking...
> > >Yes. I can reproduce it. However, it is not frequently reproduced
> > >by using the original procedure (qutacheck per an hour). So, I made a
> > >reproducer.
> > To tell the truth, I think the race creates the message:
> > -----------------------------------------------------------------------
> >  EXT3-fs: <dev>: couldn't remount RDWR because of
> >  　　　 　unprocessed orphan inode list.  Please umount/remount instead.
> > -----------------------------------------------------------------------
> > which hides a serious problem.
>   I've inquired about this at linux-fsdevel (I think you were in CC unless
> I forgot). It's a race in VFS remount code as you properly analyzed below.
> People are working on fixing it but it's not trivial. Filesystem is really
> a wrong place to fix such problem. If there is a trivial fix for ext3 to
> workaround the issue, I can take it but I'm not willing to push anything
> complex - effort should better be spent working on a generic fix.
I also think read-only remount race in VFS layer should be fixed.
However, I think this race depends on ext3/ext4 filesystem 
implementation. (Orphan inode list)
So, we should modify ext3/ext4(jbd/jbd2) to fix it.

> 
> 								Honza
> 
> > By using my reproducer, I found that it can show another message that
> > is not the above mentioned message:
> > -----------------------------------------------------------------------
> > EXT3-fs error (device <dev>) in start_transaction: Readonly filesystem	
> > -----------------------------------------------------------------------
> > After I examined the code path which message could display, I found
> > it can display if the following steps are satisfied:
<SNIP>
> > I will try to fix this problem not to do with fs-error.
> > Please comment about the fix if I have created one.
I created a sample patch to fix above EXT3-fs error. But it is tricky, 
I think. :-)

Signed-off-by: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
---
 fs/ext3/inode.c         |   27 ++++++++++++++++++++++-----
 fs/ext3/super.c         |   15 ++++++++++++++-
 fs/jbd/transaction.c    |    1 +
 include/linux/ext3_fs.h |    3 +++
 include/linux/jbd.h     |    2 ++
 5 files changed, 42 insertions(+), 6 deletions(-)

diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index 04da6ac..abfa500 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -201,6 +201,7 @@ void ext3_evict_inode (struct inode *inode)
 	struct ext3_block_alloc_info *rsv;
 	handle_t *handle;
 	int want_delete = 0;
+	int err = 0;
 
 	trace_ext3_evict_inode(inode);
 	if (!inode->i_nlink && !is_bad_inode(inode)) {
@@ -246,6 +247,7 @@ void ext3_evict_inode (struct inode *inode)
 
 	handle = start_transaction(inode);
 	if (IS_ERR(handle)) {
+skip_trans:
 		/*
 		 * If we're going to skip the normal cleanup, we still need to
 		 * make sure that the in-core orphan linked list is properly
@@ -258,8 +260,13 @@ void ext3_evict_inode (struct inode *inode)
 	if (IS_SYNC(inode))
 		handle->h_sync = 1;
 	inode->i_size = 0;
-	if (inode->i_blocks)
-		ext3_truncate(inode);
+	if (inode->i_blocks) {
+		err = __ext3_truncate(inode);
+		if (err == -EROFS) {
+			ext3_journal_stop(handle);
+			goto skip_trans;
+		}
+	}
 	/*
 	 * Kill off the orphan record created when the inode lost the last
 	 * link.  Note that ext3_orphan_del() has to be able to cope with the
@@ -2511,7 +2518,7 @@ int ext3_can_truncate(struct inode *inode)
  * that's fine - as long as they are linked from the inode, the post-crash
  * ext3_truncate() run will find them and release them.
  */
-void ext3_truncate(struct inode *inode)
+int __ext3_truncate(struct inode *inode)
 {
 	handle_t *handle;
 	struct ext3_inode_info *ei = EXT3_I(inode);
@@ -2524,6 +2531,7 @@ void ext3_truncate(struct inode *inode)
 	int n;
 	long last_block;
 	unsigned blocksize = inode->i_sb->s_blocksize;
+	int err = 0;
 
 	trace_ext3_truncate_enter(inode);
 
@@ -2534,8 +2542,11 @@ void ext3_truncate(struct inode *inode)
 		ext3_set_inode_state(inode, EXT3_STATE_FLUSH_ON_CLOSE);
 
 	handle = start_transaction(inode);
-	if (IS_ERR(handle))
+	if (IS_ERR(handle)) {
+		if (PTR_ERR(handle) == -EROFS)
+			err = -EROFS;
 		goto out_notrans;
+	}
 
 	last_block = (inode->i_size + blocksize-1)
 					>> EXT3_BLOCK_SIZE_BITS(inode->i_sb);
@@ -2654,7 +2665,7 @@ out_stop:
 
 	ext3_journal_stop(handle);
 	trace_ext3_truncate_exit(inode);
-	return;
+	return 0;
 out_notrans:
 	/*
 	 * Delete the inode from orphan list so that it doesn't stay there
@@ -2663,6 +2674,12 @@ out_notrans:
 	if (inode->i_nlink)
 		ext3_orphan_del(NULL, inode);
 	trace_ext3_truncate_exit(inode);
+	return err;
+}
+
+void ext3_truncate(struct inode *inode)
+{
+	__ext3_truncate(inode);
 }
 
 static ext3_fsblk_t ext3_get_inode_block(struct super_block *sb,
diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index 7beb69a..22ffb04 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -270,6 +270,10 @@ void __ext3_std_error (struct super_block * sb, const char * function,
 	if (errno == -EROFS && journal_current_handle() == NULL &&
 	    (sb->s_flags & MS_RDONLY))
 		return;
+	smp_rmb();
+	if ((sb->s_flags & MS_RDONLY) && errno == -EROFS &&
+		(EXT3_SB(sb)->s_mount_state & EXT3_ROMOUNT))
+		return;
 
 	errstr = ext3_decode_error(sb, errno, nbuf);
 	ext3_msg(sb, KERN_CRIT, "error in %s: %s", function, errstr);
@@ -2642,7 +2646,12 @@ static int ext3_remount (struct super_block * sb, int * flags, char * data)
 			 * First of all, the unconditional stuff we have to do
 			 * to disable replay of the journal when we next remount
 			 */
+			spin_lock(&sbi->s_journal->j_state_lock);
+			sbi->s_journal->j_flags |= JFS_ROMOUNT;
+			spin_unlock(&sbi->s_journal->j_state_lock);
+			sbi->s_mount_state |= EXT3_ROMOUNT;
 			sb->s_flags |= MS_RDONLY;
+			smp_wmb();
 
 			/*
 			 * OK, test if we are remounting a valid rw partition
@@ -2651,7 +2660,8 @@ static int ext3_remount (struct super_block * sb, int * flags, char * data)
 			 */
 			if (!(es->s_state & cpu_to_le16(EXT3_VALID_FS)) &&
 			    (sbi->s_mount_state & EXT3_VALID_FS))
-				es->s_state = cpu_to_le16(sbi->s_mount_state);
+				es->s_state = 
+				cpu_to_le16(sbi->s_mount_state & ~EXT3_ROMOUNT);
 
 			ext3_mark_recovery_complete(sb, es);
 		} else {
@@ -2686,6 +2696,9 @@ static int ext3_remount (struct super_block * sb, int * flags, char * data)
 			 * been changed by e2fsck since we originally mounted
 			 * the partition.)
 			 */
+			spin_lock(&sbi->s_journal->j_state_lock);
+			sbi->s_journal->j_flags &= ~JFS_ROMOUNT;
+			spin_unlock(&sbi->s_journal->j_state_lock);
 			ext3_clear_journal_err(sb, es);
 			sbi->s_mount_state = le16_to_cpu(es->s_state);
 			if ((err = ext3_group_extend(sb, es, n_blocks_count)))
diff --git a/fs/jbd/transaction.c b/fs/jbd/transaction.c
index 7e59c6e..26139a3 100644
--- a/fs/jbd/transaction.c
+++ b/fs/jbd/transaction.c
@@ -118,6 +118,7 @@ repeat:
 	spin_lock(&journal->j_state_lock);
 repeat_locked:
 	if (is_journal_aborted(journal) ||
+	    journal->j_flags & JFS_ROMOUNT ||
 	    (journal->j_errno != 0 && !(journal->j_flags & JFS_ACK_ERR))) {
 		spin_unlock(&journal->j_state_lock);
 		ret = -EROFS;
diff --git a/include/linux/ext3_fs.h b/include/linux/ext3_fs.h
index 67a803a..f02ed52 100644
--- a/include/linux/ext3_fs.h
+++ b/include/linux/ext3_fs.h
@@ -369,6 +369,8 @@ struct ext3_inode {
 #define	EXT3_VALID_FS			0x0001	/* Unmounted cleanly */
 #define	EXT3_ERROR_FS			0x0002	/* Errors detected */
 #define	EXT3_ORPHAN_FS			0x0004	/* Orphans being recovered */
+#define EXT3_ROMOUNT			0x0008	/* FS is ro-mounted
+						 * (Internal use only) */
 
 /*
  * Misc. filesystem flags
@@ -912,6 +914,7 @@ extern void ext3_dirty_inode(struct inode *, int);
 extern int ext3_change_inode_journal_flag(struct inode *, int);
 extern int ext3_get_inode_loc(struct inode *, struct ext3_iloc *);
 extern int ext3_can_truncate(struct inode *inode);
+extern int __ext3_truncate(struct inode *inode);
 extern void ext3_truncate(struct inode *inode);
 extern void ext3_set_inode_flags(struct inode *);
 extern void ext3_get_inode_flags(struct ext3_inode_info *);
diff --git a/include/linux/jbd.h b/include/linux/jbd.h
index e6a5e34..eae4b62 100644
--- a/include/linux/jbd.h
+++ b/include/linux/jbd.h
@@ -831,6 +831,8 @@ struct journal_s
 #define JFS_ABORT_ON_SYNCDATA_ERR	0x040  /* Abort the journal on file
 						* data write error in ordered
 						* mode */
+#define JFS_ROMOUNT	0x080	/* Prevent new transaction creating
+				 * while ro-mounting. */
 
 /*
  * Function declarations for the journaling transaction and buffer
-- 
1.5.5.6
