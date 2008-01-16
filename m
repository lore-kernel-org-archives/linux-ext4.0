From: Fengguang Wu <wfg@mail.ustc.edu.cn>
Subject: Re: regression: 100% io-wait with 2.6.24-rcX
Date: Wed, 16 Jan 2008 13:14:09 +0800
Message-ID: <400460464.27881@ustc.edu.cn>
References: <200801071151.11200.lists@naasa.net> <20080114035439.GA7330@mail.ustc.edu.cn> <400304530.01514@ustc.edu.cn> <200801141230.13694.jplatte@naasa.net> <1200310886.15103.1.camel@twins> <E1JEOmD-0001Ap-U7@localhost.localdomain> <20080115214212.GB32428@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Peter Zijlstra <peterz@infradead.org>, jplatte@naasa.net,
	linux-kernel@vger.kernel.org,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Snitzer <snitzer@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.ustc.edu.cn ([202.38.64.16]:39740 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751785AbYAPFOW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 16 Jan 2008 00:14:22 -0500
Content-Disposition: inline
In-Reply-To: <20080115214212.GB32428@elte.hu>
Message-Id: <E1JF0bJ-0000zU-FG@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jan 15, 2008 at 10:42:13PM +0100, Ingo Molnar wrote:
> 
> * Fengguang Wu <wfg@mail.ustc.edu.cn> wrote:
> 
> > On Mon, Jan 14, 2008 at 12:41:26PM +0100, Peter Zijlstra wrote:
> > > 
> > > On Mon, 2008-01-14 at 12:30 +0100, Joerg Platte wrote:
> > > > Am Montag, 14. Januar 2008 schrieb Fengguang Wu:
> > > > 
> > > > > Joerg, this patch fixed the bug for me :-)
> > > > 
> > > > Fengguang, congratulations, I can confirm that your patch fixed the bug! With 
> > > > previous kernels the bug showed up after each reboot. Now, when booting the 
> > > > patched kernel everything is fine and there is no longer any suspicious 
> > > > iowait!
> > > > 
> > > > Do you have an idea why this problem appeared in 2.6.24? Did somebody change 
> > > > the ext2 code or is it related to the changes in the scheduler?
> > > 
> > > It was Fengguang who changed the inode writeback code, and I guess the
> > > new and improved code was less able do deal with these funny corner
> > > cases. But he has been very good in tracking them down and solving them,
> > > kudos to him for that work!
> > 
> > Thank you.
> > 
> > In particular the bug is triggered by the patch named:
> >         "writeback: introduce writeback_control.more_io to indicate more io"
> > That patch means to speed up writeback, but unfortunately its
> > aggressiveness has disclosed bugs in reiserfs, jfs and now ext2.
> > 
> > Linus, given the number of bugs it triggered, I'd recommend revert 
> > this patch(git commit 2e6883bdf49abd0e7f0d9b6297fc3be7ebb2250b). Let's 
> > push it back to -mm tree for more testings?
> 
> i dont think a revert at this stage is a good idea and i'm not sure 
> pushing it back into -mm would really expose more of these bugs. And 
> these are real bugs in filesystems - bugs which we want to see fixed 
> anyway. You are also tracking down those bugs very fast.
> 
> [ perhaps, if it's possible technically (and if it is clean enough), you
>   might want to offer a runtime debug tunable that can be used to switch
>   off the new aspects of your code. That would speed up testing, in case
>   anyone suspects the new writeback code. ]

The patch is too aggressive in itself. We'd better not risk on it.
The iowait is only unpleasant not destructive. But it will hurt if
many users complaints. Comment says that "nfs_writepages() sometimes
bales out without doing anything."

However I have an improved and more safe patch now. It won't iowait
when nfs_writepages() bale out without increasing pages_skipped, or
even when some buggy filesystem forget to clear PAGECACHE_TAG_DIRTY.
(The magic lies in the first chunk below.)

Mike, you can use this one on 2.6.24.


---
 fs/fs-writeback.c         |   17 +++++++++++++++--
 include/linux/writeback.h |    1 +
 mm/page-writeback.c       |    9 ++++++---
 3 files changed, 22 insertions(+), 5 deletions(-)

--- linux.orig/fs/fs-writeback.c
+++ linux/fs/fs-writeback.c
@@ -284,7 +284,16 @@ __sync_single_inode(struct inode *inode,
 				 * soon as the queue becomes uncongested.
 				 */
 				inode->i_state |= I_DIRTY_PAGES;
-				requeue_io(inode);
+				if (wbc->nr_to_write <= 0)
+					/*
+					 * slice used up: queue for next turn
+					 */
+					requeue_io(inode);
+				else
+					/*
+					 * somehow blocked: retry later
+					 */
+					redirty_tail(inode);
 			} else {
 				/*
 				 * Otherwise fully redirty the inode so that
@@ -479,8 +488,12 @@ sync_sb_inodes(struct super_block *sb, s
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
