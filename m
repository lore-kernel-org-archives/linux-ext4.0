From: Theodore Tso <tytso@mit.edu>
Subject: Re: ext4 writepages is making tiny bios?
Date: Thu, 3 Sep 2009 20:15:45 -0400
Message-ID: <20090904001545.GA30759@mit.edu>
References: <20090901184450.GB7885@think> <20090901205744.GE6996@mit.edu> <20090901212740.GA9930@infradead.org> <20090903055201.GA7146@discord.disaster> <20090903164209.GA28384@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dave Chinner <david@fromorbit.com>,
	Chris Mason <chris.mason@oracle.com>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	xfs@oss.sgi.com, Jens Axboe <jens.axboe@oracle.com>
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:42906 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932475AbZIDAPz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 3 Sep 2009 20:15:55 -0400
Content-Disposition: inline
In-Reply-To: <20090903164209.GA28384@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 03, 2009 at 12:42:09PM -0400, Christoph Hellwig wrote:
> > Careful:
> > 
> > -	tloff = min(tlast, startpage->index + 64);
> > +	tloff = min(tlast, startpage->index + 8192);
> > 
> > That will cause 64k page machines to try to write back 512MB at a
> > time. This will re-introduce similar to the behaviour in sles9 where
> > writeback would only terminate at the end of an extent (because the
> > mapping end wasn't capped like above).
> 
> Pretty good point, any applies to all the different things we discussed
> recently.  Ted, should be maybe introduce a max_writeback_mb instead of
> the max_writeback_pages in the VM, too?

Good point.

Jens, maybe we should replace my patch with this one, which makes the
tunable in terms of megabytes instead of pages?

							- Ted

commit ed48d661394a6b22e9d376a7ad5327c2b9080a9c
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Tue Sep 1 13:19:06 2009 +0200

    vm: Add an tuning knob for vm.max_writeback_mb
    
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
    
    So, in this patch, we make the MAX_WRITEBACK_PAGES a tunable,
    max_writeback_mb, and set it to a default value of 128 megabytes.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=13930
    
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 38cb758..a9b230f 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -585,14 +585,7 @@ void generic_sync_bdi_inodes(struct writeback_control *wbc)
 	generic_sync_wb_inodes(&bdi->wb, wbc);
 }
 
-/*
- * The maximum number of pages to writeout in a single bdi flush/kupdate
- * operation.  We do this so we don't hold I_SYNC against an inode for
- * enormous amounts of time, which would block a userspace task which has
- * been forced to throttle against that inode.  Also, the code reevaluates
- * the dirty each time it has written this many pages.
- */
-#define MAX_WRITEBACK_PAGES     1024
+#define MAX_WRITEBACK_PAGES	(max_writeback_mb << (20 - PAGE_SHIFT))
 
 static inline bool over_bground_thresh(void)
 {
diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index 34c59f9..57cd3b5 100644
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -103,6 +103,7 @@ extern int vm_dirty_ratio;
 extern unsigned long vm_dirty_bytes;
 extern unsigned int dirty_writeback_interval;
 extern unsigned int dirty_expire_interval;
+extern unsigned int max_writeback_mb;
 extern int vm_highmem_is_dirtyable;
 extern int block_dump;
 extern int laptop_mode;
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 58be760..315fc30 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1104,6 +1104,14 @@ static struct ctl_table vm_table[] = {
 		.proc_handler	= &proc_dointvec,
 	},
 	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "max_writeback_mb",
+		.data		= &max_writeback_mb,
+		.maxlen		= sizeof(max_writeback_mb),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
+	{
 		.ctl_name	= VM_NR_PDFLUSH_THREADS,
 		.procname	= "nr_pdflush_threads",
 		.data		= &nr_pdflush_threads,
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 0fce7df..77decaa 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -55,6 +55,12 @@ static inline long sync_writeback_pages(void)
 /* The following parameters are exported via /proc/sys/vm */
 
 /*
+ * The maximum amount of memory (in megabytes) to write out in a
+ * single bdflush/kupdate operation.
+ */
+unsigned int max_writeback_mb = 128;
+
+/*
  * Start background writeback (via pdflush) at this percentage
  */
 int dirty_background_ratio = 10;
