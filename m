From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [RFC v3] ext4: Combine barrier requests coming from fsync
Date: Mon, 9 Aug 2010 12:53:24 -0700
Message-ID: <20100809195324.GG2109@tux1.beaverton.ibm.com>
References: <20100429235102.GC15607@tux1.beaverton.ibm.com> <1272934667.2544.3.camel@mingming-laptop> <4BE02C45.6010608@redhat.com> <1273002566.3755.10.camel@mingming-laptop> <20100629205102.GM15515@tux1.beaverton.ibm.com> <20100805164008.GH2901@thunk.org> <20100805164504.GI2901@thunk.org> <20100806070424.GD2109@tux1.beaverton.ibm.com>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: "Ted Ts'o" <tytso@mit.edu>, Mingming Cao <cmm@us.ibm.com>,
	Ric Wheeler <rwheeler@redhat.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Ke
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e38.co.us.ibm.com ([32.97.110.159]:34595 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755269Ab0HITxa (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 9 Aug 2010 15:53:30 -0400
Content-Disposition: inline
In-Reply-To: <20100806070424.GD2109@tux1.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch attempts to coordinate barrier requests being sent in by fsync.
Instead of each fsync call initiating its own barrier, there's now a flag to
indicate if (0) no barriers are ongoing, (1) we're delaying a short time to
collect other fsync threads, or (2) we're actually in-progress on a barrier.

So, if someone calls ext4_sync_file and no barriers are in progress, the flag
shifts from 0->1 and the thread delays for 500us to see if there are any other
threads that are close behind in ext4_sync_file.  After that wait, the state
transitions to 2 and the barrier is issued.  Once that's done, the state goes
back to 0 and a completion is signalled.

Those close-behind threads see the flag is already 1, and go to sleep until the
completion is signalled.  Instead of issuing a barrier themselves, they simply
wait for that first thread to do it for them.

Without Jan's prior barrier generation patch, I can run my 5min fsync-happy
workload and see the barrier count drop from ~150000 to ~37000, and the
transaction rate increase from ~630 to ~680.

With Jan's patch, I see the barrier count drop from ~18000 to ~12000, and the
transaction rate jumps from ~720 to ~760 when using this patch.

There are some things to clean up -- the wait duration probably ought to be a
mount option and not a module parameter, but this is just a test patch.  I'm
also not sure that it won't totally eat the performance of a single thread that
calls fsync frequently, though ... that seems like sort of bad behavior.
If you set the delay time to 0 you get the old behavior.

I'm wondering at this point if this is useful?  Ted, is this the sort of fsync
coordination that you were looking for?

---

 fs/ext4/ext4.h  |    5 +++++
 fs/ext4/fsync.c |   47 +++++++++++++++++++++++++++++++++++++++++++----
 fs/ext4/super.c |    4 ++++
 3 files changed, 52 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 19a4de5..e51535a 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1143,6 +1143,11 @@ struct ext4_sb_info {
 
 	/* workqueue for dio unwritten */
 	struct workqueue_struct *dio_unwritten_wq;
+
+	/* fsync barrier reduction */
+	spinlock_t barrier_flag_lock;
+	int in_barrier;
+	struct completion barrier_completion;
 };
 
 static inline struct ext4_sb_info *EXT4_SB(struct super_block *sb)
diff --git a/fs/ext4/fsync.c b/fs/ext4/fsync.c
index 592adf2..c5afb45 100644
--- a/fs/ext4/fsync.c
+++ b/fs/ext4/fsync.c
@@ -57,6 +57,10 @@ static void ext4_sync_parent(struct inode *inode)
 	}
 }
 
+static int barrier_wait = 500;
+module_param(barrier_wait, int, 0644);
+MODULE_PARM_DESC(barrier_wait, "fsync barrier wait time (usec)");
+
 /*
  * akpm: A new design for ext4_sync_file().
  *
@@ -75,7 +79,8 @@ int ext4_sync_file(struct file *file, int datasync)
 {
 	struct inode *inode = file->f_mapping->host;
 	struct ext4_inode_info *ei = EXT4_I(inode);
-	journal_t *journal = EXT4_SB(inode->i_sb)->s_journal;
+	struct ext4_sb_info *sb = EXT4_SB(inode->i_sb);
+	journal_t *journal = sb->s_journal;
 	int ret;
 	tid_t commit_tid;
 
@@ -130,8 +135,42 @@ int ext4_sync_file(struct file *file, int datasync)
 			blkdev_issue_flush(inode->i_sb->s_bdev, GFP_KERNEL,
 					NULL, BLKDEV_IFL_WAIT);
 		ret = jbd2_log_wait_commit(journal, commit_tid);
-	} else if (journal->j_flags & JBD2_BARRIER)
-		blkdev_issue_flush(inode->i_sb->s_bdev, GFP_KERNEL, NULL,
-			BLKDEV_IFL_WAIT);
+	} else if (journal->j_flags & JBD2_BARRIER) {
+		if (!barrier_wait) {
+			blkdev_issue_flush(inode->i_sb->s_bdev, GFP_KERNEL, NULL,
+				BLKDEV_IFL_WAIT);
+			goto fast_out;
+		}
+again:
+		spin_lock(&sb->barrier_flag_lock);
+		if (sb->in_barrier == 2) {
+			spin_unlock(&sb->barrier_flag_lock);
+			ret = wait_for_completion_interruptible(&sb->barrier_completion);
+			goto again;
+		} else if (sb->in_barrier) {
+			spin_unlock(&sb->barrier_flag_lock);
+			ret = wait_for_completion_interruptible(&sb->barrier_completion);
+		} else {
+			sb->in_barrier = 1;
+			INIT_COMPLETION(sb->barrier_completion);
+			spin_unlock(&sb->barrier_flag_lock);
+
+			udelay(barrier_wait);
+
+			spin_lock(&sb->barrier_flag_lock);
+			sb->in_barrier = 2;
+			spin_unlock(&sb->barrier_flag_lock);
+
+			blkdev_issue_flush(inode->i_sb->s_bdev, GFP_KERNEL, NULL, BLKDEV_IFL_WAIT);
+			complete_all(&sb->barrier_completion);
+
+			spin_lock(&sb->barrier_flag_lock);
+			sb->in_barrier = 0;
+			spin_unlock(&sb->barrier_flag_lock);
+		}
+fast_out:
+		if (!ret)
+			ext4_clear_inode_state(inode, EXT4_STATE_DIRTY_DATA);
+	}
 	return ret;
 }
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 4e8983a..0dc96d2 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3045,6 +3045,10 @@ no_journal:
 	ext4_msg(sb, KERN_INFO, "mounted filesystem with%s. "
 		"Opts: %s", descr, orig_data);
 
+	EXT4_SB(sb)->in_barrier = 0;
+	spin_lock_init(&EXT4_SB(sb)->barrier_flag_lock);
+	init_completion(&EXT4_SB(sb)->barrier_completion);
+
 	lock_kernel();
 	kfree(orig_data);
 	return 0;
