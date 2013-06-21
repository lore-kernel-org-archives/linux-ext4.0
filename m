From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4 file replace guarantees
Date: Fri, 21 Jun 2013 10:33:47 -0400
Message-ID: <20130621143347.GF10730@thunk.org>
References: <1371764058.18527.140661246414097.671B4999@webmail.messagingengine.com>
 <20130621005937.GB10730@thunk.org>
 <1371818596.20553.140661246775057.0F7160F3@webmail.messagingengine.com>
 <20130621131521.GE10730@thunk.org>
 <1371822707.3188.140661246795017.2D10645B@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Ryan Lortie <desrt@desrt.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:60100 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161519Ab3FUOdx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 21 Jun 2013 10:33:53 -0400
Content-Disposition: inline
In-Reply-To: <1371822707.3188.140661246795017.2D10645B@webmail.messagingengine.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jun 21, 2013 at 09:51:47AM -0400, Ryan Lortie wrote:
> 
> > #2) If an existing file is removed via a rename, if there are any
> >     delayed allocation blocks in the new file, they will be flushed
> >     out.
> 
> Can you describe to me exactly what this means in terms of the syscall
> API?  Do I void these "delayed allocation blocks" guarantees by using
> fallocate() before-hand?

Based on how the implementation is currently implemented, any modified
blocks belonging to the inode will be staged out to disk --- Although
with out an explicit CACHE FLUSH command, which is ***extremely***
expensive.

Why are you using fallocate, by the way?  For small files, fallocate
is largely pointless.  All of the modern file systems which use
delayed allocation can do the right thing without fallocate(2).  It
won't hurt, but it won't help, either.

Fallocate is primarily useful for very large files, where the file
system has to start writing the data out to disk due to memory
pressure before the entire file has been written to the page cache.
And it sounds like multi-megabyte dconf files are a bit out of your
design scope.  :-)

> I have a legitimate desire to optimise for my second concern without
> sacrificing my first concern and I don't think that it's unreasonable
> for me to ask where the line is.  I don't really accept this "surf the
> boundaries" business about fuzzy APIs that "should do the right thing
> usually, but no guarantees if you get too close to the line".  I just
> want to know what I have to do in order to be safe.

The POSIX API is pretty clear: if you care about data being on disk,
you have to use fsync().

As file system designers, we're generally rather hesitant to make
guarantees beyond that, since most users are hypersensitive about
performance, and every single time we make additional guarantees
beyond what is specified by POSIX, it further constrains us, and it
may be that one of these guarantees is one you don't care about, but
will impact your performance.  Just as the cost of some guarantee you
*do* care about may impact the performance of some other application
which happens to be renaming files but who doesn't necessarily care
about making sure things are forced to disk atomically in that
particular instance.

> But it brings me to another interesting point: I don't want to sync the
> filesystem.  I really don't care when the data makes it to disk.  I
> don't want to waste battery and SSD life.  But I am forced to.  I only
> want one thing, which is what I said before: I want to know that either
> the old data will be there, or the new data.  The fact that I have to
> force the hard drive to wake up in order to get this is pretty
> unreasonable.
> 
> Why can't we get what we really need?
> 
> Honestly, what would be absolutely awesome is g_file_set_contents() in
> the kernel, with the "old or new" guarantee.  I have all of the data in
> a single buffer and I know the size of it in advance.  I just want you
> to get it onto the disk, at some point that is convenient to you, in
> such a way that I don't end up destroying the old data while still not
> having the new.

There are all sorts of rather tricky impliciations with this.  For
example, consider what happens if some disk editor does this with a
small text file.  OK, fine.  Future reads of this text file will get
the new contents, but if the system crashes, when the file read, they
will get the old value.  Now suppose other files are created based on
that text file.  For example, suppose the text file is a C source
file, and the compiler writes out an object file based on the source
file --- and then the system crashes.  What guarantees do we have to
give about the state of the object file after the crash?  What if the
object file contains the compiled version of the "new" source file,
but that source file hsa reverted to its original value.  Can you
imagine how badly make would get confused with such a thing?

Beyond the semantic difficulties of such an interface, while I can
technically think of ways that this might be workable for small files,
the problem with the file system API is that it's highly generalized,
and while you might promise than you'd only use it for files less than
64k, say, inevitably someone would try to use the exact same interface
with a multi-megabyte file.  And then complain when it didn't work,
didn't fulfill the guarantees, or OOM-killed their process, or trashed
their performance of their entire system....

By the way, if the old and new contents of the data you are replacing
is less than 4k, just open the file using O_DIRECT, and do a 4k
replacement write.  Keep the unused portion of the file padded out
with zeros, so you don't have to worry about the inode's i_size
update, and just do a 4k write.  *Boom*.  This is the fast, guaranteed
to work on all file systems, and will result in the least amount of
SSD wear.


By the way, I think I know why people have been seeing more instnaces
of data loss after a power failure.  There's been a bug that's been
introduced since the 3.0 kernel which disabled the writeback timer
under some circumstances.  This is the timer which forces inodes (for
all file systems; this was generic writeback bug) to be written back
after /sys/proc/vm/dirty_writeback_centisecs.  As a result, for files
that were written that did _not_ meet magic overwrite-via-rename
conditions and did not use fsync, they were more succeptible to data
loss after a crash.  The patch to fix this was discovered a three
weeks ago, and is attached below.

						- Ted

From: Jan Kara <jack@suse.cz>
To: Jens Axboe <axboe@kernel.dk>
Cc: Wu Fengguang <fengguang.wu@intel.com>,
	linux-fsdevel@vger.kernel.org,
	Bert De Jonghe <Bert.DeJonghe@amplidata.com>,
	Jan Kara <"jack@suse.cz>, stable"@vger.kernel.org#>
Subject: [PATCH] writeback: Fix periodic writeback after fs mount
Date: Thu, 30 May 2013 10:44:19 +0200
Message-Id: <1369903459-10295-1-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.8.1.4

Code in blkdev.c moves a device inode to default_backing_dev_info when
the last reference to the device is put and moves the device inode back
to its bdi when the first reference is acquired. This includes moving to
wb.b_dirty list if the device inode is dirty. The code however doesn't
setup timer to wake corresponding flusher thread and while wb.b_dirty
list is non-empty __mark_inode_dirty() will not set it up either. Thus
periodic writeback is effectively disabled until a sync(2) call which can
lead to unexpected data loss in case of crash or power failure.

Fix the problem by setting up a timer for periodic writeback in case we
add the first dirty inode to wb.b_dirty list in bdev_inode_switch_bdi().

Reported-by: Bert De Jonghe <Bert.DeJonghe@amplidata.com>
CC: stable@vger.kernel.org # >= 3.0
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/block_dev.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 2091db8..85f5c85 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -58,17 +58,24 @@ static void bdev_inode_switch_bdi(struct inode *inode,
 			struct backing_dev_info *dst)
 {
 	struct backing_dev_info *old = inode->i_data.backing_dev_info;
+	bool wakeup_bdi = false;
 
 	if (unlikely(dst == old))		/* deadlock avoidance */
 		return;
 	bdi_lock_two(&old->wb, &dst->wb);
 	spin_lock(&inode->i_lock);
 	inode->i_data.backing_dev_info = dst;
-	if (inode->i_state & I_DIRTY)
+	if (inode->i_state & I_DIRTY) {
+		if (bdi_cap_writeback_dirty(dst) && !wb_has_dirty_io(&dst->wb))
+			wakeup_bdi = true;
 		list_move(&inode->i_wb_list, &dst->wb.b_dirty);
+	}
 	spin_unlock(&inode->i_lock);
 	spin_unlock(&old->wb.list_lock);
 	spin_unlock(&dst->wb.list_lock);
+
+	if (wakeup_bdi)
+		bdi_wakeup_thread_delayed(dst);
 }
 
 /* Kill _all_ buffers and pagecache , dirty or not.. */
-- 
1.8.1.4

