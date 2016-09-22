From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: optimize ext4 direct I/O locking for reading
Date: Thu, 22 Sep 2016 14:31:43 +0200
Message-ID: <20160922123143.GO2834@quack2.suse.cz>
References: <20160921052744.5223-1-tytso@mit.edu>
 <20160921132609.GA30232@infradead.org>
 <20160921143748.xswkovbjrtcgs3bq@thunk.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="6c2NcOVqGQ03X4Wi"
Cc: Christoph Hellwig <hch@infradead.org>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160921143748.xswkovbjrtcgs3bq@thunk.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--6c2NcOVqGQ03X4Wi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed 21-09-16 10:37:48, Ted Tso wrote:
> On Wed, Sep 21, 2016 at 06:26:09AM -0700, Christoph Hellwig wrote:
> > Is there any chance you could look into simplifying the locking instead
> > of making it even more complicated?  Since Al replaced i_mutex with
> > i_rwsem you can now easily take that in shared mode.  E.g. if you'd
> > move to a direct I/O model closer to XFS, ocfs2 and NFS where you always
> > take i_rwsem in shared mode you'll get the scalibility of the
> > dioread_nolock case while no having to do these crazy dances, and you
> > can also massively simplify the codebase.  Similarly you can demote it
> > from exclusive to shared after allocating blocks in the write path,
> > and you'll end up with something way easier to understand.
> 
> Unfortunately, in order to do this we need to extend the
> dioread_nolock handling for sub-page block sizes.  (This is where we
> insert the allocated blocks into the extent maps marked uninitialized,
> and only converting the extent from uninitialized to initialized ---
> which today only works when the page size == block size.)
> 
> This is on my todo list, but half of the problem is the mess caused by
> needing to iterate over the circularly linked buffer heads when there
> are multiple buffer heads covering the page.  I was originally
> assuming that it would be easier to fix this after doing the bh ->
> iomap conversion, but it's in a while before I looked into this
> particular change.  I can try to take a closer look again....
> 
> The main reason why I looked into this hack --- and I will be the
> first to agree it was a hack, is because I had a request to support
> the dioread_nolock scalability on a Little Endian PowerPC system which
> has 64k page sizes.
> 
> > Sorry for the rant, but I just had to dig into this code when looking
> > at converting ext4 to the new DAX path, and my eyes still bleed..
> 
> Yeah, I know, and I'm sorry.  There's quite a bit of technical debt
> there, which I do want to clean up.

So I think what Christoph meant in this case is something like attached
patch. That achieves more than your dirty hack in a much cleaner way.
Beware, the patch is only compile-tested.

Then there is the case of unlocked direct IO overwrites which we allow to
run without inode_lock in dioread_nolock mode as well and that is more
difficult to resolve (there lay the problems with blocksize < pagesize you
speak about).

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

--6c2NcOVqGQ03X4Wi
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-ext4-Allow-parallel-DIO-reads.patch"

>From 7de4ca30e0c897bbdd49eae0fdec5132744c105a Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Thu, 22 Sep 2016 14:20:15 +0200
Subject: [PATCH] ext4: Allow parallel DIO reads

We can easily support parallel direct IO reads. We only have to make
sure we cannot expose uninitialized data by reading allocated block to
which data was not written yet, or which was already truncated. That is
easily achieved by holding inode_lock in shared mode - that excludes all
writes, truncates, hole punches. We also have to guard against page
writeback allocating blocks for delay-allocated pages - that race is
handled by the fact that we writeback all the pages in the affected
range and the lock protects us from new pages being created there.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/inode.c | 40 ++++++++++++++++++----------------------
 1 file changed, 18 insertions(+), 22 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index c6ea25a190f8..0af52f012bfb 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3526,35 +3526,31 @@ out:
 
 static ssize_t ext4_direct_IO_read(struct kiocb *iocb, struct iov_iter *iter)
 {
-	int unlocked = 0;
-	struct inode *inode = iocb->ki_filp->f_mapping->host;
+	struct address_space *mapping = iocb->ki_filp->f_mapping;
+	struct inode *inode = mapping->host;
 	ssize_t ret;
 
-	if (ext4_should_dioread_nolock(inode)) {
-		/*
-		 * Nolock dioread optimization may be dynamically disabled
-		 * via ext4_inode_block_unlocked_dio(). Check inode's state
-		 * while holding extra i_dio_count ref.
-		 */
-		inode_dio_begin(inode);
-		smp_mb();
-		if (unlikely(ext4_test_inode_state(inode,
-						    EXT4_STATE_DIOREAD_LOCK)))
-			inode_dio_end(inode);
-		else
-			unlocked = 1;
-	}
+	/*
+	 * Shared inode_lock is enough for us - it protects against concurrent
+	 * writes & truncates and since we take care of writing back page cache,
+	 * we are protected against page writeback as well.
+	 */
+	inode_lock_shared(inode);
 	if (IS_DAX(inode)) {
-		ret = dax_do_io(iocb, inode, iter, ext4_dio_get_block,
-				NULL, unlocked ? 0 : DIO_LOCKING);
+		ret = dax_do_io(iocb, inode, iter, ext4_dio_get_block, NULL, 0);
 	} else {
+		size_t count = iov_iter_count(iter);
+
+		ret = filemap_write_and_wait_range(mapping, iocb->ki_pos,
+						   iocb->ki_pos + count);
+		if (ret)
+			goto out_unlock;
 		ret = __blockdev_direct_IO(iocb, inode, inode->i_sb->s_bdev,
 					   iter, ext4_dio_get_block,
-					   NULL, NULL,
-					   unlocked ? 0 : DIO_LOCKING);
+					   NULL, NULL, 0);
 	}
-	if (unlocked)
-		inode_dio_end(inode);
+out_unlock:
+	inode_unlock_shared(inode);
 	return ret;
 }
 
-- 
2.6.6


--6c2NcOVqGQ03X4Wi--
