From: Jan Kara <jack@suse.cz>
Subject: Re: [RFC][PATCH] Re: [BUG] ext4: cannot unfreeze a filesystem due
 to a deadlock
Date: Wed, 30 Mar 2011 16:12:05 +0200
Message-ID: <20110330141205.GC22349@quack.suse.cz>
References: <20110207205325.FB6A.61FB500B@jp.fujitsu.com>
 <20110215160630.GH17313@quack.suse.cz>
 <20110215170352.GE4255@thunk.org>
 <20110215172954.GK17313@quack.suse.cz>
 <20110216081746.54d146d1.toshi.okajima@jp.fujitsu.com>
 <20110216145627.GB5592@quack.suse.cz>
 <4D5C9B1B.2050304@jp.fujitsu.com>
 <20110217104552.GD4947@quack.suse.cz>
 <20110328170628.ffe314fb.toshi.okajima@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Ted Ts'o <tytso@mit.edu>,
	Masayoshi MIZUMA <m.mizuma@jp.fujitsu.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:33283 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754807Ab1C3OMJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 30 Mar 2011 10:12:09 -0400
Content-Disposition: inline
In-Reply-To: <20110328170628.ffe314fb.toshi.okajima@jp.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hello,

On Mon 28-03-11 17:06:28, Toshiyuki Okajima wrote:
> On Thu, 17 Feb 2011 11:45:52 +0100
> Jan Kara <jack@suse.cz> wrote:
> > On Thu 17-02-11 12:50:51, Toshiyuki Okajima wrote:
> > > (2011/02/16 23:56), Jan Kara wrote:
> > > >On Wed 16-02-11 08:17:46, Toshiyuki Okajima wrote:
> > > >>On Tue, 15 Feb 2011 18:29:54 +0100
> > > >>Jan Kara<jack@suse.cz>  wrote:
> > > >>>On Tue 15-02-11 12:03:52, Ted Ts'o wrote:
> > > >>>>On Tue, Feb 15, 2011 at 05:06:30PM +0100, Jan Kara wrote:
> > > >>>>>Thanks for detailed analysis. Indeed this is a bug. Whenever we do IO
> > > >>>>>under s_umount semaphore, we are prone to deadlock like the one you
> > > >>>>>describe above.
> > > >>>>
> > > >>>>One of the fundamental problems here is that the freeze and thaw
> > > >>>>routines are using down_write(&sb->s_umount) for two purposes.  The
> > > >>>>first is to prevent the resume/thaw from racing with a umount (which
> > > >>>>it could do just as well by taking a read lock), but the second is to
> > > >>>>prevent the resume/thaw code from racing with itself.  That's the core
> > > >>>>fundamental problem here.
> > > >>>>
> > > >>>>So I think we can solve this by introduce a new mutex, s_freeze, and
> > > >>>>having the the resume/thaw first take the s_freeze mutex and then
> > > >>>>second take a read lock on the s_umount.
> > > >>>   Sadly this does not quite work because even down_read(&sb->s_umount)
> > > >>>in thaw_super() can block if there is another process that tries to acquire
> > > >>>s_umount for writing - a situation like:
> > > >>>   TASK 1 (e.g. flusher)		TASK 2	(e.g. remount)		TASK 3 (unfreeze)
> > > >>>down_read(&sb->s_umount)
> > > >>>   block on s_frozen
> > > >>>				down_write(&sb->s_umount)
> > > >>>				  -blocked
> > > >>>								down_read(&sb->s_umount)
> > > >>>								  -blocked
> > > >>>behind the write access...
> > > >>>
> > > >>>The only working solution I see is to check for frozen filesystem before
> > > >>>taking s_umount semaphore which seems rather ugly (but might be bearable if
> > > >>>we did so in some well described wrapper).
> > > >>I created the patch that you imagine yesterday.
> > > >>
> > > >>I got a reproducer from Mizuma-san yesterday, and then I executed it on the kernel
> > > >>without a fixed patch. After an hour, I confirmed that this deadlock happened.
> > > >>
> > > >>However, on the kernel with a fixed patch, this deadlock doesn't still happen
> > > >>after 12 hours passed.
> > > >>
> > > >>The patch for linux-2.6.38-rc4 is as follows:
> > > >>---
> > > >>  fs/fs-writeback.c |    2 +-
> > > >>  1 files changed, 1 insertions(+), 1 deletions(-)
> > > >>
> > > >>diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> > > >>index 59c6e49..1c9a05e 100644
> > > >>--- a/fs/fs-writeback.c
> > > >>+++ b/fs/fs-writeback.c
> > > >>@@ -456,7 +456,7 @@ static bool pin_sb_for_writeback(struct super_block *sb)
> > > >>         spin_unlock(&sb_lock);
> > > >>
> > > >>         if (down_read_trylock(&sb->s_umount)) {
> > > >>-               if (sb->s_root)
> > > >>+               if (sb->s_frozen == SB_UNFROZEN&&  sb->s_root)
> > > >>                         return true;
> > > >>                 up_read(&sb->s_umount);
> > > 
> > > >   So this is something along the lines I thought but it actually won't work
> > > >for example if sync(1) is run while the filesystem is frozen (that takes
> > > >s_umount semaphore in a different place). And generally, I'm not convinced
> > > >there are not other places that try to do IO while holding s_umount
> > > >semaphore...
> > > OK. I understand.
> > > 
> > > This code only fixes the case for the following path:
> > > writeback_inodes_wb
> > > -> ext4_da_writepages
> > >    -> ext4_journal_start_sb
> > >       -> vfs_check_frozen
> > > But, the code doesn't fix the other cases.
> > > 
> > > We must modify the local filesystem part in order to fix all cases...?
> >   Yes, possibly. But most importantly we should first find clear locking
> > rules for frozen filesystem that avoid deadlocks like the one above. And
> > the freezing / unfreezing code might become subtle for that reason, that's
> > fine, but it would be really good to avoid any complicated things for the
> > code in the rest of the VFS / filesystems.
> I have deeply continued to examined the root cause of this problem, then 
> I found it.
> 
> It is that we can write a memory which is mmaped to a file. Then the memory 
> becomes "DIRTY" so then the flusher thread (ex. wb_do_writeback) tries to
> "writeback" the memory. 
> 
> Therefore, the root cause of this hangup is not only ext4 component (with
> delayed allocation feature) but also writeback mechanism for mmap. If you 
> use the other filesystem, you can write something to the filesystem though 
> you have freezed the filesystem.
  Well, you can write something only in the caches, not to the on disk
image. So it's not a problem as such.

> A sample problem is attached on this mail.  Try to execute it then you can 
> confirm that we can write some data to your filesystem while freezing the 
> filesystem.
> (If you change FS variable in go.sh from ext3 to ext4 and you execute
> "fsfreeze -u mnt" manually on other prompt, you can also confirm this deadlock.)
> 
> I think the best approach to fix this problem is to let users not to write
> memory which is mapped to a certain file while the filesystem is freezing. 
> However, it is very difficult to control users not to write memory which has 
> been already mapped to the file.
  It is actually possible. In case of ext4, you could add a check (+ wait)
in ext4_page_mkwrite() whether the filesystem is frozen or in the process
of being frozen and if so, wait for it to get unfrozen. The only tough
problem here might be the locking as ext4_page_mkwrite() is called with
mmap_sem held and I'm not sure we can take s_umount with mmap_sem held.
But you'd have to fix all filesystems (and all paths possibly creating
dirty data) in this way.
 
> Therefore, I think there is only actual method that we stop writeback thread 
> to resolve the mmap problem. Also, by this fix, the original problem 
> (ext4 delayed write vs unfreeze) can be solved.
  Hmm, I had a look at the code again and think we could fix the issue
cleanly (i.e. all possible users of s_umount) as follows: The lock
ordering will be
  s_umount -> "fs frozen"
and there will be a new mutex s_freeze_mutex protecting changes of
s_frozen.

freeze_bdev() already observes this lock ordering, it will only take
s_freeze_mutex for the changes of s_frozen values. The only other code
that is relevant for the lock ordering is thaw_super() (the freezing
process is not expected to reenter kernel for the frozen filesystem).
In thaw_super() we could take s_freeze_mutex, do all the thawing work,
set s_frozen, release s_freeze_mutex and put superblock reference.

So something like the patch below - it seems to work for me, can you test
it please?

>From 0939f4c2fd5d69d7d1bf7ece9a641bb561e9d0dd Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Wed, 30 Mar 2011 15:21:44 +0200
Subject: [PATCH] vfs: Fix deadlocks on frozen filesystem

When a filesystem is frozen and the flusher thread decides to do writeback
for the frozen filesystem (e.g. because pages were marked dirty by mmaped
write) we deadlock because we take s_umount semaphore and then try to write
dirty pages which blocks. In this situation there is no way to unfreeze
the filesystem because thawing code requires s_umount semaphore.

Fix the problem removing the need to take s_umount from thawing code. Instead
we introduce new s_freeze_mutex to provide necessary exclusion.

Reported-by: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/super.c         |   40 ++++++++++++++++++++++++++++++++++------
 include/linux/fs.h |    1 +
 2 files changed, 35 insertions(+), 6 deletions(-)

diff --git a/fs/super.c b/fs/super.c
index e848649..4f74718 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -77,6 +77,7 @@ static struct super_block *alloc_super(struct file_system_type *type)
 		INIT_LIST_HEAD(&s->s_dentry_lru);
 		init_rwsem(&s->s_umount);
 		mutex_init(&s->s_lock);
+		mutex_init(&s->s_freeze_mutex);
 		lockdep_set_class(&s->s_umount, &type->s_umount_key);
 		/*
 		 * The locking rules for s_lock are up to the
@@ -971,6 +972,24 @@ out:
  * Syncs the super to make sure the filesystem is consistent and calls the fs's
  * freeze_fs.  Subsequent calls to this without first thawing the fs will return
  * -EBUSY.
+ *
+ * Locking of freeze / thaw is tricky (if not messy). Freezing is protected by
+ * exclusively taking s_umount to avoid races with mount / remount / umount and
+ * also provide exclusion of concurrent freeze calls. Then we have
+ * s_freeze_mutex which protects changes to s_frozen and the call ->freeze_fs()
+ * against races with thawing code.
+ *
+ * Thawing code must not take s_umount before the filesystem is unfrozen
+ * because that would cause deadlocks (e.g. background flushing takes s_umount
+ * and then does writeback which blocks on a frozen filesystem). So we take
+ * only s_freeze_mutex, which provides us exclusion against concurrent
+ * freezing, and hold it until the thawing is finished. We are protected
+ * against superblock going away by holding an active sb reference and against
+ * remounting by the fact that the sb is frozen.
+ *
+ * Notes: s_freeze_mutex cannot be merged with bd_fsfreeze_mutex because we
+ * can freeze block devices without filesystems and also freeze filesystems
+ * not backed by block devices.
  */
 int freeze_super(struct super_block *sb)
 {
@@ -978,7 +997,9 @@ int freeze_super(struct super_block *sb)
 
 	atomic_inc(&sb->s_active);
 	down_write(&sb->s_umount);
-	if (sb->s_frozen) {
+	mutex_lock(&sb->s_freeze_mutex);
+	if (sb->s_frozen != SB_UNFROZEN) {
+		mutex_unlock(&sb->s_freeze_mutex);
 		deactivate_locked_super(sb);
 		return -EBUSY;
 	}
@@ -986,15 +1007,18 @@ int freeze_super(struct super_block *sb)
 	if (sb->s_flags & MS_RDONLY) {
 		sb->s_frozen = SB_FREEZE_TRANS;
 		smp_wmb();
+		mutex_unlock(&sb->s_freeze_mutex);
 		up_write(&sb->s_umount);
 		return 0;
 	}
 
 	sb->s_frozen = SB_FREEZE_WRITE;
+	mutex_unlock(&sb->s_freeze_mutex);
 	smp_wmb();
 
 	sync_filesystem(sb);
 
+	mutex_lock(&sb->s_freeze_mutex);
 	sb->s_frozen = SB_FREEZE_TRANS;
 	smp_wmb();
 
@@ -1005,10 +1029,12 @@ int freeze_super(struct super_block *sb)
 			printk(KERN_ERR
 				"VFS:Filesystem freeze failed\n");
 			sb->s_frozen = SB_UNFROZEN;
+			mutex_unlock(&sb->s_freeze_mutex);
 			deactivate_locked_super(sb);
 			return ret;
 		}
 	}
+	mutex_unlock(&sb->s_freeze_mutex);
 	up_write(&sb->s_umount);
 	return 0;
 }
@@ -1019,14 +1045,15 @@ EXPORT_SYMBOL(freeze_super);
  * @sb: the super to thaw
  *
  * Unlocks the filesystem and marks it writeable again after freeze_super().
+ * See freeze_super() for locking comments.
  */
 int thaw_super(struct super_block *sb)
 {
 	int error;
 
-	down_write(&sb->s_umount);
-	if (sb->s_frozen == SB_UNFROZEN) {
-		up_write(&sb->s_umount);
+	mutex_lock(&sb->s_freeze_mutex);
+	if (sb->s_frozen != SB_FREEZE_TRANS) {
+		mutex_unlock(&sb->s_freeze_mutex);
 		return -EINVAL;
 	}
 
@@ -1039,7 +1066,7 @@ int thaw_super(struct super_block *sb)
 			printk(KERN_ERR
 				"VFS:Filesystem thaw failed\n");
 			sb->s_frozen = SB_FREEZE_TRANS;
-			up_write(&sb->s_umount);
+			mutex_unlock(&sb->s_freeze_mutex);
 			return error;
 		}
 	}
@@ -1048,7 +1075,8 @@ out:
 	sb->s_frozen = SB_UNFROZEN;
 	smp_wmb();
 	wake_up(&sb->s_wait_unfrozen);
-	deactivate_locked_super(sb);
+	mutex_unlock(&sb->s_freeze_mutex);
+	deactivate_super(sb);
 
 	return 0;
 }
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 7061a85..230892d 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1382,6 +1382,7 @@ struct super_block {
 	struct dentry		*s_root;
 	struct rw_semaphore	s_umount;
 	struct mutex		s_lock;
+	struct mutex		s_freeze_mutex;
 	int			s_count;
 	atomic_t		s_active;
 #ifdef CONFIG_SECURITY
-- 
1.7.1

