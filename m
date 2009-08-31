From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH, RFC] vm: Add an tuning knob for vm.max_writeback_pages
Date: Sun, 30 Aug 2009 23:08:15 -0400
Message-ID: <20090831030815.GD20822@mit.edu>
References: <1251600858-21294-1-git-send-email-tytso@mit.edu> <20090830165229.GA5189@infradead.org> <20090830181731.GA20822@mit.edu> <20090830222710.GA9938@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-mm@kvack.org,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org, chris.mason@oracle.com,
	jens.axboe@oracle.com
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:38354 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754305AbZHaDIR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 30 Aug 2009 23:08:17 -0400
Content-Disposition: inline
In-Reply-To: <20090830222710.GA9938@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Aug 30, 2009 at 06:27:10PM -0400, Christoph Hellwig wrote:
> I'm don't think tuning it on a per-filesystem basis is a good idea,
> we had to resort to this for 2.6.30 as a quick hack, and we will ged
> rid of it again in 2.6.31 one way or another.  I personally think we
> should fight this cancer of per-filesystem hacks in the writeback code
> as much as we can.  Right now people keep adding tuning hacks for
> specific workloads there, and at least all the modern filesystems (ext4,
> btrfs and XFS) have very similar requirements to the writeback code,
> that is give the filesystem as much as possible to write at the same
> time to do intelligent decisions based on that.  The VM writeback code
> fails horribly at that right now.

Yep; and Jens' patch doesn't change that.  It is still sending writes
out to the filesystem a piddling 1024 pages at a time.

> My stance is to wait for this until about -rc2 at which points Jens'
> code is hopefully in and we can start doing all the fine-tuning,
> including lots of benchmarking.

Well, I've ported my patch so it applies on top of Jens' per-bdi
patch.  It seems to be clearly needed; Jens, would you agree to add it
to your per-bdi patch series?  We can choose a different default if
you like, but making MAX_WRITEBACK_PAGES tunable seems to be clearly
necessary.

By the way, while I was testing my patch on top of v13 of the per-bdi
patches, I found something *very* curious.  I did a test where ran the
following commands on a freshly mkfs'ed ext4 filesystem:

	dd if=/dev/zero of=test1 bs=1024k count=128
	dd if=/dev/zero of=test2 bs=1024k count=128
	sync

I traced the calls to ext4_da_writepages() using ftrace, and found this:

      flush-8:16-1829  [001]    23.416351: ext4_da_writepages: dev sdb ino 12 nr_t_write 32759 pages_skipped 0 range_start 0 range_end 0 nonblocking 0 for_kupdate 0 for_reclaim 0 for_writepages 1 range_cyclic 1
      flush-8:16-1829  [000]    25.939354: ext4_da_writepages: dev sdb ino 12 nr_t_write 32768 pages_skipped 0 range_start 0 range_end 0 nonblocking 0 for_kupdate 0 for_reclaim 0 for_writepages 1 range_cyclic 1
      flush-8:16-1829  [000]    25.939486: ext4_da_writepages: dev sdb ino 13 nr_t_write 32759 pages_skipped 0 range_start 134180864 range_end 9223372036854775807 nonblocking 0 for_kupdate 0 for_reclaim 0 for_writepages 1 range_cyclic 1
      flush-8:16-1829  [000]    27.055687: ext4_da_writepages: dev sdb ino 12 nr_t_write 32768 pages_skipped 0 range_start 0 range_end 0 nonblocking 0 for_kupdate 0 for_reclaim 0 for_writepages 1 range_cyclic 1
      flush-8:16-1829  [000]    27.055691: ext4_da_writepages: dev sdb ino 13 nr_t_write 32768 pages_skipped 0 range_start 0 range_end 0 nonblocking 0 for_kupdate 0 for_reclaim 0 for_writepages 1 range_cyclic 1
      flush-8:16-1829  [000]    27.878708: ext4_da_writepages: dev sdb ino 13 nr_t_write 32768 pages_skipped 0 range_start 0 range_end 0 nonblocking 0 for_kupdate 0 for_reclaim 0 for_writepages 1 range_cyclic 1

The *first* time the per-bdi code called writepages on the second file
(test2, inode #13), range_start was 134180864 (which, curiously
enough, is 4096*32759, which was the value of nr_to_write passed to
ext4_da_writepages).  Given that the inode only had 32768 pages, the
fact that apparently *some* codepath called ext4_da_writepages
starting at logical block 32759, with nr_to_write set to 32759, seems
very curious indeed.  That doesn't seem right at all.  It's late, so I
won't try to trace it down now; plus which it's your code so I figure
you can probably figure it out faster....

     	     	       	    	    	       	  - Ted

>From 763fb19b3d14d73e71f5d88bd3b5f56869536ae5 Mon Sep 17 00:00:00 2001
From: Theodore Ts'o <tytso@mit.edu>
Date: Sun, 30 Aug 2009 23:06:24 -0400
Subject: [PATCH] vm: Add an tuning knob for vm.max_writeback_pages

Originally, MAX_WRITEBACK_PAGES was hard-coded to 1024 because of a
concern of not holding I_SYNC for too long.  (At least, that was the
comment previously.)  This doesn't make sense now because the only
time we wait for I_SYNC is if we are calling sync or fsync, and in
that case we need to write out all of the data anyway.  Previously
there may have been other code paths that waited on I_SYNC, but not
any more.

According to Christoph, the current writeback size is way too small,
and XFS had a hack that bumped out nr_to_write to four times the value
sent by the VM to be able to saturate medium-sized RAID arrays.  This
value was also problematic for ext4 as well, as it caused large files
to be come interleaved on disk by in 8 megabyte chunks (we bumped up
the nr_to_write by a factor of two).

So, in this patch, we make the MAX_WRITEBACK_PAGES a tunable, and
change the default to be 32768 blocks.

http://bugzilla.kernel.org/show_bug.cgi?id=13930

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
This patch is designed to be applied  on top of the per-bdi v13 patchset

 fs/fs-writeback.c         |   15 +++------------
 include/linux/writeback.h |    1 +
 kernel/sysctl.c           |    8 ++++++++
 mm/page-writeback.c       |    6 ++++++
 4 files changed, 18 insertions(+), 12 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index dfb4767..7e66de7 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -264,15 +264,6 @@ void bdi_start_writeback(struct backing_dev_info *bdi, struct super_block *sb,
 	}
 }
 
-/*
- * The maximum number of pages to writeout in a single bdi flush/kupdate
- * operation.  We do this so we don't hold I_SYNC against an inode for
- * enormous amounts of time, which would block a userspace task which has
- * been forced to throttle against that inode.  Also, the code reevaluates
- * the dirty each time it has written this many pages.
- */
-#define MAX_WRITEBACK_PAGES     1024
-
 static inline bool over_bground_thresh(void)
 {
 	unsigned long background_thresh, dirty_thresh;
@@ -325,11 +316,11 @@ static long wb_writeback(struct bdi_writeback *wb, long nr_pages,
 
 		wbc.more_io = 0;
 		wbc.encountered_congestion = 0;
-		wbc.nr_to_write = MAX_WRITEBACK_PAGES;
+		wbc.nr_to_write = max_writeback_pages;
 		wbc.pages_skipped = 0;
 		generic_sync_wb_inodes(wb, sb, &wbc);
-		nr_pages -= MAX_WRITEBACK_PAGES - wbc.nr_to_write;
-		wrote += MAX_WRITEBACK_PAGES - wbc.nr_to_write;
+		nr_pages -= max_writeback_pages - wbc.nr_to_write;
+		wrote += max_writeback_pages - wbc.nr_to_write;
 		/*
 		 * If we ran out of stuff to write, bail unless more_io got set
 		 */
diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index e070b91..a27fc00 100644
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -100,6 +100,7 @@ extern int vm_dirty_ratio;
 extern unsigned long vm_dirty_bytes;
 extern unsigned int dirty_writeback_interval;
 extern unsigned int dirty_expire_interval;
+extern unsigned int max_writeback_pages;
 extern int vm_highmem_is_dirtyable;
 extern int block_dump;
 extern int laptop_mode;
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 58be760..06d1c4c 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1104,6 +1104,14 @@ static struct ctl_table vm_table[] = {
 		.proc_handler	= &proc_dointvec,
 	},
 	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "max_writeback_pages",
+		.data		= &max_writeback_pages,
+		.maxlen		= sizeof(max_writeback_pages),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
+	{
 		.ctl_name	= VM_NR_PDFLUSH_THREADS,
 		.procname	= "nr_pdflush_threads",
 		.data		= &nr_pdflush_threads,
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index a727af9..46fe54f 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -55,6 +55,12 @@ static inline long sync_writeback_pages(void)
 /* The following parameters are exported via /proc/sys/vm */
 
 /*
+ * The maximum number of pages to write out in a single bdflush/kupdate
+ * operation.
+ */
+unsigned int max_writeback_pages = 32768;
+
+/*
  * Start background writeback (via pdflush) at this percentage
  */
 int dirty_background_ratio = 10;
-- 
1.6.3.2.1.gb9f7d.dirty

