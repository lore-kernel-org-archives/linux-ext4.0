From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: revert i_data_sum locking cleanups for
 dioread_nolock
Date: Thu, 18 Feb 2016 23:09:56 +0100
Message-ID: <20160218220956.GA24219@quack.suse.cz>
References: <20160212182506.GB1592@localhost.localdomain>
 <20160216050840.GA3426@thunk.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="tKW2IUtsqtDRztdT"
Cc: Eric Whitney <enwlinux@gmail.com>, linux-ext4@vger.kernel.org,
	jack@suse.cz
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43597 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423513AbcBRWJe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 18 Feb 2016 17:09:34 -0500
Content-Disposition: inline
In-Reply-To: <20160216050840.GA3426@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--tKW2IUtsqtDRztdT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue 16-02-16 00:08:40, Ted Tso wrote:
> On Fri, Feb 12, 2016 at 01:25:06PM -0500, Eric Whitney wrote:
> > Commit 2bcba4781fa3 ("ext4: get rid of EXT4_GET_BLOCKS_NO_LOCK flag")
> > can cause a kernel panic when xfstest generic/300 is run on a file
> > system mounted with dioread_nolock.  The panic is typically triggered
> > from check_irqs_on() (fs/buffer.c: 1272), and happens because
> > ext4_end_io_dio() is being called in an interrupt context rather than
> > from a workqueue for AIO.  This suggests that buffer_defer_completion
> > may not be set properly when creating an unwritten extent for async
> > direct I/O.
> > 
> > Revert the locking changes until this problem can be resolved.  Patch
> > applied to 4.5-rc3 and tested with a full xfstest-bld auto group run.
> > 
> > Signed-off-by: Eric Whitney <enwlinux@gmail.com>
> 
> Applied, thanks.
> 
> I was able to reliably reproduce the problem without this revert patch
> using a 32-bit x86 kvm-xfstests test appliance:
> 
>    ftp://ftp.kernel.org/pub/linux/kernel/people/tytso/kvm-xfstests/testing/root_fs.img.i386
> 
> Using the command: "kvm-xfstests -c dioread_nolock generic/300"
> 
> With this patch, the problem goes away, so reverting the patch is
> clearly the right thing for now.  There is something screwy going on,
> since the original commit shouldn't have made a difference, but let's
> revert it first, and figure it out when we have time to investigate
> more deeply.

OK, I had a look into this. So I'm not 100% what has happened but the
following looks likely: Current io_end handling can overwrite io_end
pointer in the inode in dioread_nolock mode (nothing prevents unlocked DIO
to overwrite pointer of locked DIO and then clear it out). I suspect that
the change in i_data_sem locking made this race more visible. Attached
patch should fix the issue (I don't see failures of generic/300 with it in
dioread_nolock mode). Can you consider this instead of a revert Eric sent?

I have also a more complete rewrite of io_end handling which makes the code
more comprehensible and avoids storing io_end pointer in the inode (thus
avoids similar pitfalls in future) but that is a 4.6 matter. I'll submit
the rewrite once xfstests runs complete.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

--tKW2IUtsqtDRztdT
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-ext4-Fix-crashes-in-dioread_nolock-mode.patch"

>From 09eae61bb0433f8424f606fde00db35dbd72615d Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Thu, 18 Feb 2016 22:50:07 +0100
Subject: [PATCH] ext4: Fix crashes in dioread_nolock mode

Competing overwrite DIO in dioread_nolock mode will just overwrite
pointer to io_end in the inode. This may result in data corruption or
extent conversion happening from IO completion interrupt because we
don't properly set buffer_defer_completion() when unlocked DIO races
with locked DIO to unwritten extent.

Since unlocked DIO doesn't need io_end for anything, just avoid
allocating it and corrupting pointer from inode for locked DIO.
A cleaner fix would be to avoid these games with io_end pointer from the
inode but that requires more intrusive changes so we leave that for
later.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/inode.c | 40 ++++++++++++++++++++--------------------
 1 file changed, 20 insertions(+), 20 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 83bc8bfb3bea..ee8ca1ff4023 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3253,29 +3253,29 @@ static ssize_t ext4_ext_direct_IO(struct kiocb *iocb, struct iov_iter *iter,
 	 * case, we allocate an io_end structure to hook to the iocb.
 	 */
 	iocb->private = NULL;
-	ext4_inode_aio_set(inode, NULL);
-	if (!is_sync_kiocb(iocb)) {
-		io_end = ext4_init_io_end(inode, GFP_NOFS);
-		if (!io_end) {
-			ret = -ENOMEM;
-			goto retake_lock;
-		}
-		/*
-		 * Grab reference for DIO. Will be dropped in ext4_end_io_dio()
-		 */
-		iocb->private = ext4_get_io_end(io_end);
-		/*
-		 * we save the io structure for current async direct
-		 * IO, so that later ext4_map_blocks() could flag the
-		 * io structure whether there is a unwritten extents
-		 * needs to be converted when IO is completed.
-		 */
-		ext4_inode_aio_set(inode, io_end);
-	}
-
 	if (overwrite) {
 		get_block_func = ext4_get_block_overwrite;
 	} else {
+		ext4_inode_aio_set(inode, NULL);
+		if (!is_sync_kiocb(iocb)) {
+			io_end = ext4_init_io_end(inode, GFP_NOFS);
+			if (!io_end) {
+				ret = -ENOMEM;
+				goto retake_lock;
+			}
+			/*
+			 * Grab reference for DIO. Will be dropped in
+			 * ext4_end_io_dio()
+			 */
+			iocb->private = ext4_get_io_end(io_end);
+			/*
+			 * we save the io structure for current async direct
+			 * IO, so that later ext4_map_blocks() could flag the
+			 * io structure whether there is a unwritten extents
+			 * needs to be converted when IO is completed.
+			 */
+			ext4_inode_aio_set(inode, io_end);
+		}
 		get_block_func = ext4_get_block_write;
 		dio_flags = DIO_LOCKING;
 	}
-- 
2.6.2


--tKW2IUtsqtDRztdT--
