From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [RFC v4] ext4: Coordinate fsync requests
Date: Wed, 18 Aug 2010 19:14:41 -0700
Message-ID: <20100819021441.GM2109@tux1.beaverton.ibm.com>
References: <1272934667.2544.3.camel@mingming-laptop> <4BE02C45.6010608@redhat.com> <1273002566.3755.10.camel@mingming-laptop> <20100629205102.GM15515@tux1.beaverton.ibm.com> <20100805164008.GH2901@thunk.org> <20100805164504.GI2901@thunk.org> <20100806070424.GD2109@tux1.beaverton.ibm.com> <20100809195324.GG2109@tux1.beaverton.ibm.com> <4D5AEB7F-32E2-481A-A6C8-7E7E0BD3CE98@dilger.ca> <20100809233805.GH2109@tux1.beaverton.ibm.com>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Ted Ts'o" <tytso@mit.edu>, Mingming Cao <cmm@us.ibm.com>,
	Ric Wheeler <rwheeler@redhat.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Keith Mannthey <kmannth@us.ibm.com>,
	Mingming Cao <mcao@us.ibm.com>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e37.co.us.ibm.com ([32.97.110.158]:52637 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970Ab0HSCOt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 18 Aug 2010 22:14:49 -0400
Content-Disposition: inline
In-Reply-To: <20100809233805.GH2109@tux1.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch attempts to coordinate barrier requests being sent in by fsync.
Instead of each fsync call initiating its own barrier, there's now a flag to
indicate if (0) no barriers are ongoing, (1) we're delaying a short time to
collect other fsync threads, or (2) we're actually in-progress on a barrier.

So, if someone calls ext4_sync_file and no barriers are in progress, the flag
shifts from 0->1 and the thread delays for a short time to see if there are
any other threads that are close behind in ext4_sync_file.  After that wait,
the state transitions to 2 and the barrier is issued.  Once that's done, the
state goes back to 0 and a completion is signalled.

Those close-behind threads see the flag is already 1, and go to sleep until the
completion is signalled.  Instead of issuing a barrier themselves, they simply
wait for that first thread to do it for them.

In an earlier version of this patch, the "short time" was 500ms, adjustable by
a module parameter.  Now, it's a mount option, and the mount option has three
values: x = 0, which gets you the old behavior; x = -1, which uses the average
commit time for the delay period; and x > 0, which sets the delay time to
min(x, average commit time).

So I gave this patchset some wider testing in my lab, and came up with the
following spreadsheet:
https://spreadsheets.google.com/ccc?key=0AtDnBlSkyNjodDZ4OEdSZC01X2haVi1ncmpGOXpfNkE&hl=en&authkey=CMznqcgH

These results do not reflect Tejun/Christoph's latest barrier/flush semantic
changes because ... I haven't figured out the correct sequence of 2.6.35+,
tejun's patchset, and hch's patchset.  With Tejun's original set of patches,
the performance actually decreased a little bit, so I haven't bothered to
upload those results while I try to put together a new tree.

The comma-separated numbers in the leftmost column indicates which options were
in effect during the run.  From left to right, they are (1) whether or not
directio is enabled; (2) the max_fsync_delay parameter (-1 is automatic
tuning, 0 is the behavior prior to my patch, and 500 is the v3 patch);
(3) whether or not Jan Kara's barrier generation counter is disabled; and (4)
whether or not my old dirty flag patch is disabled.  The old system behaviors
are in the *,0,1,1 rows, and the everything-on behavior should be in the
*,-1,0,0 rows.

>From these results, it seems like a reasonable conclusion that enabling Jan
Kara's barrier generation counter patch (*,*,0,*) does increase the tps count.
It also would appear that enabling the barrier coordination patch with the
automatic barrier delay tuning (*,-1,*,*) also seems to be increasing tps while
reducing barrier counts.  It's not so clear that my old dirty flag patch
(*,*,*,0) is doing much anymore.

The *,na,na,na rows reflect what happens if I turn barriers off entirely, so I
can compare the new numbers with the nobarrier behavior.

elm3c44_sas is a 36-spindle SAS storage array (RAID0).
elm3c44_ssd is 4 Intel SSDs tied together in a RAID0 via md.
elm3c65_sata is a single SATA disk.
elm3c71_sas is a 8-spindle SAS storage array (RAID0).
elm3c71_scsi is a 14-spindle SCSI storage array (RAID0).
elm3c75_ide is a single IDE laptop disk.

The storage array have battery-backed WC.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 fs/ext4/ext4.h  |    7 +++++++
 fs/ext4/fsync.c |   55 +++++++++++++++++++++++++++++++++++++++++++++++++++----
 fs/ext4/super.c |   21 ++++++++++++++++++++-
 3 files changed, 78 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 19a4de5..9e8dcc7 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1143,6 +1143,13 @@ struct ext4_sb_info {
 
 	/* workqueue for dio unwritten */
 	struct workqueue_struct *dio_unwritten_wq;
+
+	/* fsync coordination */
+	spinlock_t barrier_flag_lock;
+	int in_barrier;
+	struct completion barrier_completion;
+	u64 avg_barrier_time;
+	int max_fsync_delay;
 };
 
 static inline struct ext4_sb_info *EXT4_SB(struct super_block *sb)
diff --git a/fs/ext4/fsync.c b/fs/ext4/fsync.c
index 592adf2..e164ccd 100644
--- a/fs/ext4/fsync.c
+++ b/fs/ext4/fsync.c
@@ -75,9 +75,12 @@ int ext4_sync_file(struct file *file, int datasync)
 {
 	struct inode *inode = file->f_mapping->host;
 	struct ext4_inode_info *ei = EXT4_I(inode);
-	journal_t *journal = EXT4_SB(inode->i_sb)->s_journal;
+	struct ext4_sb_info *sb = EXT4_SB(inode->i_sb);
+	journal_t *journal = sb->s_journal;
 	int ret;
 	tid_t commit_tid;
+	ktime_t before, expires;
+	u64 duration;
 
 	J_ASSERT(ext4_journal_current_handle() == NULL);
 
@@ -130,8 +133,52 @@ int ext4_sync_file(struct file *file, int datasync)
 			blkdev_issue_flush(inode->i_sb->s_bdev, GFP_KERNEL,
 					NULL, BLKDEV_IFL_WAIT);
 		ret = jbd2_log_wait_commit(journal, commit_tid);
-	} else if (journal->j_flags & JBD2_BARRIER)
-		blkdev_issue_flush(inode->i_sb->s_bdev, GFP_KERNEL, NULL,
-			BLKDEV_IFL_WAIT);
+	} else if (journal->j_flags & JBD2_BARRIER) {
+		if (!sb->max_fsync_delay) {
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
+			if (sb->max_fsync_delay > 0 && (sb->max_fsync_delay * 1000) < sb->avg_barrier_time)
+				expires = ktime_add_ns(ktime_get(), sb->max_fsync_delay * 1000);
+			else
+				expires = ktime_add_ns(ktime_get(), sb->avg_barrier_time);
+			set_current_state(TASK_UNINTERRUPTIBLE);
+			schedule_hrtimeout(&expires, HRTIMER_MODE_ABS);
+
+			spin_lock(&sb->barrier_flag_lock);
+			sb->in_barrier = 2;
+			spin_unlock(&sb->barrier_flag_lock);
+
+			before = ktime_get();
+			blkdev_issue_flush(inode->i_sb->s_bdev, GFP_KERNEL, NULL, BLKDEV_IFL_WAIT);
+			duration = ktime_to_ns(ktime_sub(ktime_get(), before));
+			if (likely(sb->avg_barrier_time))
+				sb->avg_barrier_time = (duration + sb->avg_barrier_time * 15) / 16;
+			else
+				sb->avg_barrier_time = duration;
+
+			complete_all(&sb->barrier_completion);
+
+			spin_lock(&sb->barrier_flag_lock);
+			sb->in_barrier = 0;
+			spin_unlock(&sb->barrier_flag_lock);
+		}
+	}
+fast_out:
 	return ret;
 }
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 4e8983a..8d04e43 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -953,6 +953,7 @@ static int ext4_show_options(struct seq_file *seq, struct vfsmount *vfs)
 	if (!test_opt(sb, DELALLOC))
 		seq_puts(seq, ",nodelalloc");
 
+	seq_printf(seq, ",max_fsync_delay=%d", sbi->max_fsync_delay);
 
 	if (sbi->s_stripe)
 		seq_printf(seq, ",stripe=%lu", sbi->s_stripe);
@@ -1160,7 +1161,7 @@ enum {
 	Opt_block_validity, Opt_noblock_validity,
 	Opt_inode_readahead_blks, Opt_journal_ioprio,
 	Opt_dioread_nolock, Opt_dioread_lock,
-	Opt_discard, Opt_nodiscard,
+	Opt_discard, Opt_nodiscard, Opt_max_fsync_delay,
 };
 
 static const match_table_t tokens = {
@@ -1231,6 +1232,7 @@ static const match_table_t tokens = {
 	{Opt_dioread_lock, "dioread_lock"},
 	{Opt_discard, "discard"},
 	{Opt_nodiscard, "nodiscard"},
+	{Opt_max_fsync_delay, "max_fsync_delay=%d"},
 	{Opt_err, NULL},
 };
 
@@ -1699,6 +1701,16 @@ set_qf_format:
 		case Opt_dioread_lock:
 			clear_opt(sbi->s_mount_opt, DIOREAD_NOLOCK);
 			break;
+		case Opt_max_fsync_delay:
+			if (args[0].from) {
+				if (match_int(&args[0], &option))
+					return 0;
+			} else
+				return 0;
+
+			sbi->max_fsync_delay = option;
+			ext4_msg(sb, KERN_INFO, "Maximum fsync delay %d\n", option);
+			break;
 		default:
 			ext4_msg(sb, KERN_ERR,
 			       "Unrecognized mount option \"%s\" "
@@ -2562,6 +2574,8 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	if (!IS_EXT3_SB(sb))
 		set_opt(sbi->s_mount_opt, DELALLOC);
 
+	EXT4_SB(sb)->max_fsync_delay = -1;
+
 	if (!parse_options((char *) data, sb, &journal_devnum,
 			   &journal_ioprio, NULL, 0))
 		goto failed_mount;
@@ -3045,6 +3059,11 @@ no_journal:
 	ext4_msg(sb, KERN_INFO, "mounted filesystem with%s. "
 		"Opts: %s", descr, orig_data);
 
+	EXT4_SB(sb)->in_barrier = 0;
+	EXT4_SB(sb)->avg_barrier_time = 0;
+	spin_lock_init(&EXT4_SB(sb)->barrier_flag_lock);
+	init_completion(&EXT4_SB(sb)->barrier_completion);
+
 	lock_kernel();
 	kfree(orig_data);
 	return 0;
