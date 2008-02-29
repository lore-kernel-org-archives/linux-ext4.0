From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [RFC][PATCH] ext4: Convert uninitialized extent to initialized
	extent in case of file system full
Date: Fri, 29 Feb 2008 16:39:24 +0530
Message-ID: <20080229110924.GA16757@skywalker>
References: <1204221911-9753-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1204221911-9753-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1204221911-9753-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1204240440.3609.26.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:60426 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752562AbYB2LKp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 29 Feb 2008 06:10:45 -0500
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp01.au.ibm.com (8.13.1/8.13.1) with ESMTP id m1TBBO3R031828
	for <linux-ext4@vger.kernel.org>; Fri, 29 Feb 2008 22:11:24 +1100
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m1TBAbkS2855040
	for <linux-ext4@vger.kernel.org>; Fri, 29 Feb 2008 22:10:37 +1100
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m1TBAb2W026268
	for <linux-ext4@vger.kernel.org>; Fri, 29 Feb 2008 22:10:37 +1100
Content-Disposition: inline
In-Reply-To: <1204240440.3609.26.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Feb 28, 2008 at 03:14:00PM -0800, Mingming Cao wrote:
> On Thu, 2008-02-28 at 23:35 +0530, Aneesh Kumar K.V wrote:
> > A write to prealloc area cause the split of unititalized extent into a initialized
> > and uninitialized extent. If we don't have space to add new extent information instead
> > of returning error convert the existing uninitialized extent to initialized one. We
> > need to zero out the blocks corresponding to the extent to prevent wrong data reaching
> > userspace.
> > 
> > +

....

> 
> The complexity added to the code to handle the corner case seems not
> worth the effort. 
> 
> One simple solution is submit bio directly to zero out the blocks on
> disk, and wait for that to finish before clear the uninitialized bit. On
> a 4K block size case, the max size of an uninitialized extents is 128MB,
> and since the blocks are all contigous on disk, a single IO could done
> the job, the latency should not be a too big issue. After all when a
> filesystem is full, it's already performs slowly.

This is the change that i have now. Yet to run the full test on that.
But seems to be working for simple tests.

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index d315cc1..26396e2 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2136,6 +2136,55 @@ void ext4_ext_release(struct super_block *sb)
 #endif
 }
 
+static void bi_complete(struct bio *bio, int error)
+{
+	complete((struct completion*)bio->bi_private);
+}
+
+/* FIXME!! we need to try to merge to left or right after zerout  */
+static int ext4_ext_zeroout(struct inode *inode, struct ext4_extent *ex)
+{
+	int ret = -EIO;
+	struct bio *bio;
+	int blkbits, blocksize;
+	ext4_fsblk_t ee_pblock;
+	unsigned int ee_len, i;
+	struct completion event;
+
+
+	blkbits   = inode->i_blkbits;
+	blocksize = inode->i_sb->s_blocksize;
+	ee_len    = ext4_ext_get_actual_len(ex);
+	ee_pblock = ext_pblock(ex);
+
+	bio = bio_alloc(GFP_NOIO, ee_len);
+	if (!bio)
+		return -ENOMEM;
+
+	bio->bi_sector = ee_pblock << (blkbits >> 9);
+	bio->bi_bdev   = inode->i_sb->s_bdev;
+
+	for (i = 0; i < ee_len; i++) {
+		ret = bio_add_page(bio, ZERO_PAGE(0), blocksize, 0);
+		if (ret != blocksize) {
+			ret = -EIO;
+			goto err_out;
+		}
+	}
+
+	init_completion(&event);
+	bio->bi_private = &event;
+	bio->bi_end_io = bi_complete;
+	submit_bio(WRITE, bio);
+	wait_for_completion(&event);
+
+	if (test_bit(BIO_UPTODATE, &bio->bi_flags))
+		ret = 0;
+err_out:
+	bio_put(bio);
+	return ret;
+}
+
 /*
  * This function is called by ext4_ext_get_blocks() if someone tries to write
  * to an uninitialized extent. It may result in splitting the uninitialized
@@ -2202,14 +2251,19 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
 		ex3->ee_len = cpu_to_le16(allocated - max_blocks);
 		ext4_ext_mark_uninitialized(ex3);
 		err = ext4_ext_insert_extent(handle, inode, path, ex3);
-		if (err) {
+		if (err == -ENOSPC) {
+			err =  ext4_ext_zeroout(inode, &orig_ex);
+			if (err)
+				goto fix_extent_len;
+			/* update the extent length and mark as initialized */
 			ex->ee_block = orig_ex.ee_block;
 			ex->ee_len   = orig_ex.ee_len;
 			ext4_ext_store_pblock(ex, ext_pblock(&orig_ex));
-			ext4_ext_mark_uninitialized(ex);
 			ext4_ext_dirty(handle, inode, path + depth);
-			goto out;
-		}
+			return le16_to_cpu(ex->ee_len);
+
+		} else if (err)
+			goto fix_extent_len;
 		/*
 		 * The depth, and hence eh & ex might change
 		 * as part of the insert above.
@@ -2295,15 +2349,28 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
 	goto out;
 insert:
 	err = ext4_ext_insert_extent(handle, inode, path, &newex);
-	if (err) {
+	if (err == -ENOSPC) {
+		err =  ext4_ext_zeroout(inode, &orig_ex);
+		if (err)
+			goto fix_extent_len;
+		/* update the extent length and mark as initialized */
 		ex->ee_block = orig_ex.ee_block;
 		ex->ee_len   = orig_ex.ee_len;
 		ext4_ext_store_pblock(ex, ext_pblock(&orig_ex));
-		ext4_ext_mark_uninitialized(ex);
 		ext4_ext_dirty(handle, inode, path + depth);
-	}
+		return le16_to_cpu(ex->ee_len);
+	} else if (err)
+		goto fix_extent_len;
 out:
 	return err ? err : allocated;
+
+fix_extent_len:
+	ex->ee_block = orig_ex.ee_block;
+	ex->ee_len   = orig_ex.ee_len;
+	ext4_ext_store_pblock(ex, ext_pblock(&orig_ex));
+	ext4_ext_mark_uninitialized(ex);
+	ext4_ext_dirty(handle, inode, path + depth);
+	return err;
 }
 
 /*


I am not invalidating the inode mapping after zeroing out the block. I
guess that is the right thing to do considering that pages already
mapped in via read or mmap would contain same value (zero).

> 
> >  /*
> >   * This function is called by ext4_ext_get_blocks() if someone tries to write
> >   * to an uninitialized extent. It may result in splitting the uninitialized
> > @@ -2202,14 +2333,20 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
> >  		ex3->ee_len = cpu_to_le16(allocated - max_blocks);
> >  		ext4_ext_mark_uninitialized(ex3);
> > +	} else if (err)

......


> > +		goto fix_extent_len;
> >  out:
> >  	return err ? err : allocated;
> > +
> > +fix_extent_len:
> > +	ex->ee_block = orig_ex.ee_block;
> > +	ex->ee_len   = orig_ex.ee_len;
> > +	ext4_ext_store_pblock(ex, ext_pblock(&orig_ex));
> > +	ext4_ext_mark_uninitialized(ex);
> > +	ext4_ext_dirty(handle, inode, path + depth);
> > +	return err;
> >  }
> > 
> It would be nice to detect if fs is full or almost full before convert
> the uninitialized extents. If the total number of free blocks left are
> not enough for the split(plan for the worse case, 3 extents adds), just
> go ahead to do the zero out the one single chunk ahead, in stead of
> possible zeroing out two chucks later on the error path. I feel it's
> much cleaner that way.
> 

We don't zero out two chunks. The uninit extent can possibly get split
into three extent.
[ 1st uninit] [ 2 init ] [ 3rd uninit]


Now first we attempt to insert 3. And if we fail due to ENOSPC we
zero out the full extent [1 2 3]. Now if we are successful in inserting 3 then
we attempt to insert 2. If we fail, we zero out [1 2]. That should also
reduce the number blocks that we are zeroing out. For example if we have
uninit extent len of 32767 blocks and we try to write the third block within
the extent and failed in the second step above we will zero out only 3
blocks. If we want to zero out the full extent that would imply zero out
32767 blocks.

-aneesh


