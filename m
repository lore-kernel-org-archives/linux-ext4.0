From: Fengguang Wu <wfg@mail.ustc.edu.cn>
Subject: [PATCH] writeback: speed up writeback of big dirty files
Date: Thu, 17 Jan 2008 13:28:18 +0800
Message-ID: <E1JFNIY-0007R4-VO__17720.0265498415$1200559446$gmane$org@localhost.localdomain>
References: <230154.6549.qm@web32604.mail.mud.yahoo.com> <170fa0d20801160827p73ae28d0u702120a4f9f48936@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Mike Snitzer <snitzer@gmail.com>,
	Martin Knoblauch <spamtrap@knobisoft.de>,
	Peter Zijlstra <peterz@infradead.org>, jplatte@naasa.net,
	Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756407AbYAQIn0@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <170fa0d20801160827p73ae28d0u702120a4f9f48936@mail.gmail.com>
Message-Id: <E1JFNIY-0007R4-VO@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

> On Jan 16, 2008 9:15 AM, Martin Knoblauch <spamtrap@knobisoft.de> wrote:
> Fengguang's latest writeback patch applies cleanly, builds, boots on 2.6.24-rc8.

Linus, if possible, I'd suggest this patch be merged for 2.6.24.

It's a safer version of the reverted patch. It was tested on
ext2/ext3/jfs/xfs/reiserfs and won't 100% iowait even without the
other bug fixing patches.

Fengguang
---

writeback: speed up writeback of big dirty files

After making dirty a 100M file, the normal behavior is to
start the writeback for all data after 30s delays. But
sometimes the following happens instead:

	- after 30s:    ~4M
	- after 5s:     ~4M
	- after 5s:     all remaining 92M

Some analyze shows that the internal io dispatch queues goes like this:

		s_io            s_more_io
		-------------------------
	1)	100M,1K         0
	2)	1K              96M
	3)	0               96M
1) initial state with a 100M file and a 1K file
2) 4M written, nr_to_write <= 0, so write more
3) 1K written, nr_to_write > 0, no more writes(BUG)
nr_to_write > 0 in (3) fools the upper layer to think that data have all been
written out. The big dirty file is actually still sitting in s_more_io. We
cannot simply splice s_more_io back to s_io as soon as s_io becomes empty, and
let the loop in generic_sync_sb_inodes() continue: this may starve newly
expired inodes in s_dirty.  It is also not an option to draw inodes from both
s_more_io and s_dirty, an let the loop go on: this might lead to live locks,
and might also starve other superblocks in sync time(well kupdate may still
starve some superblocks, that's another bug).
We have to return when a full scan of s_io completes. So nr_to_write > 0 does
not necessarily mean that "all data are written". This patch introduces a flag
writeback_control.more_io to indicate that more io should be done. With it the
big dirty file no longer has to wait for the next kupdate invocation 5s later.

In sync_sb_inodes() we only set more_io on super_blocks we actually visited.
This aviods the interaction between two pdflush deamons.

Also in __sync_single_inode() we don't blindly keep requeuing the io if the
filesystem cannot progress. Failing to do so may lead to 100% iowait.

Tested-by: Mike Snitzer <snitzer@gmail.com>
Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---
 fs/fs-writeback.c         |   18 ++++++++++++++++--
 include/linux/writeback.h |    1 +
 mm/page-writeback.c       |    9 ++++++---
 3 files changed, 23 insertions(+), 5 deletions(-)

--- linux.orig/fs/fs-writeback.c
+++ linux/fs/fs-writeback.c
@@ -284,7 +284,17 @@ __sync_single_inode(struct inode *inode,
 				 * soon as the queue becomes uncongested.
 				 */
 				inode->i_state |= I_DIRTY_PAGES;
-				requeue_io(inode);
+				if (wbc->nr_to_write <= 0) {
+					/*
+					 * slice used up: queue for next turn
+					 */
+					requeue_io(inode);
+				} else {
+					/*
+					 * somehow blocked: retry later
+					 */
+					redirty_tail(inode);
+				}
 			} else {
 				/*
 				 * Otherwise fully redirty the inode so that
@@ -479,8 +489,12 @@ sync_sb_inodes(struct super_block *sb, s
 		iput(inode);
 		cond_resched();
 		spin_lock(&inode_lock);
-		if (wbc->nr_to_write <= 0)
+		if (wbc->nr_to_write <= 0) {
+			wbc->more_io = 1;
 			break;
+		}
+		if (!list_empty(&sb->s_more_io))
+			wbc->more_io = 1;
 	}
 	return;		/* Leave any unwritten inodes on s_io */
 }
--- linux.orig/include/linux/writeback.h
+++ linux/include/linux/writeback.h
@@ -62,6 +62,7 @@ struct writeback_control {
 	unsigned for_reclaim:1;		/* Invoked from the page allocator */
 	unsigned for_writepages:1;	/* This is a writepages() call */
 	unsigned range_cyclic:1;	/* range_start is cyclic */
+	unsigned more_io:1;		/* more io to be dispatched */
 };
 
 /*
--- linux.orig/mm/page-writeback.c
+++ linux/mm/page-writeback.c
@@ -558,6 +558,7 @@ static void background_writeout(unsigned
 			global_page_state(NR_UNSTABLE_NFS) < background_thresh
 				&& min_pages <= 0)
 			break;
+		wbc.more_io = 0;
 		wbc.encountered_congestion = 0;
 		wbc.nr_to_write = MAX_WRITEBACK_PAGES;
 		wbc.pages_skipped = 0;
@@ -565,8 +566,9 @@ static void background_writeout(unsigned
 		min_pages -= MAX_WRITEBACK_PAGES - wbc.nr_to_write;
 		if (wbc.nr_to_write > 0 || wbc.pages_skipped > 0) {
 			/* Wrote less than expected */
-			congestion_wait(WRITE, HZ/10);
-			if (!wbc.encountered_congestion)
+			if (wbc.encountered_congestion || wbc.more_io)
+				congestion_wait(WRITE, HZ/10);
+			else
 				break;
 		}
 	}
@@ -631,11 +633,12 @@ static void wb_kupdate(unsigned long arg
 			global_page_state(NR_UNSTABLE_NFS) +
 			(inodes_stat.nr_inodes - inodes_stat.nr_unused);
 	while (nr_to_write > 0) {
+		wbc.more_io = 0;
 		wbc.encountered_congestion = 0;
 		wbc.nr_to_write = MAX_WRITEBACK_PAGES;
 		writeback_inodes(&wbc);
 		if (wbc.nr_to_write > 0) {
-			if (wbc.encountered_congestion)
+			if (wbc.encountered_congestion || wbc.more_io)
 				congestion_wait(WRITE, HZ/10);
 			else
 				break;	/* All the old data is written */

