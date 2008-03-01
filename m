From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [RFC][PATCH] ext4: Convert uninitialized extent to initialized
	extent in case of file system full
Date: Sat, 1 Mar 2008 23:00:59 +0530
Message-ID: <20080301173059.GA6833@skywalker>
References: <1204221911-9753-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1204221911-9753-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1204221911-9753-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1204240440.3609.26.camel@localhost.localdomain> <20080229110924.GA16757@skywalker> <20080229192142.GJ2997@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Mingming Cao <cmm@us.ibm.com>, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:44494 "EHLO
	e28esmtp03.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755087AbYCARbG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 1 Mar 2008 12:31:06 -0500
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by e28esmtp03.in.ibm.com (8.13.1/8.13.1) with ESMTP id m21HV3vV029760
	for <linux-ext4@vger.kernel.org>; Sat, 1 Mar 2008 23:01:03 +0530
Received: from d28av04.in.ibm.com (d28av04.in.ibm.com [9.184.220.66])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m21HV0Vr942284
	for <linux-ext4@vger.kernel.org>; Sat, 1 Mar 2008 23:01:03 +0530
Received: from d28av04.in.ibm.com (loopback [127.0.0.1])
	by d28av04.in.ibm.com (8.13.1/8.13.3) with ESMTP id m21HV0bt028148
	for <linux-ext4@vger.kernel.org>; Sat, 1 Mar 2008 17:31:00 GMT
Content-Disposition: inline
In-Reply-To: <20080229192142.GJ2997@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Feb 29, 2008 at 11:21:42AM -0800, Andreas Dilger wrote:
> On Feb 29, 2008  16:39 +0530, Aneesh Kumar K.V wrote:
> > > One simple solution is submit bio directly to zero out the blocks on
> > > disk, and wait for that to finish before clear the uninitialized bit. On
> > > a 4K block size case, the max size of an uninitialized extents is 128MB,
> > > and since the blocks are all contigous on disk, a single IO could done
> > > the job, the latency should not be a too big issue. After all when a
> > > filesystem is full, it's already performs slowly.
> > 
> > This is the change that i have now. Yet to run the full test on that.
> > But seems to be working for simple tests.
> > 
> > diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> > index d315cc1..26396e2 100644
> > --- a/fs/ext4/extents.c
> > +++ b/fs/ext4/extents.c
> > @@ -2136,6 +2136,55 @@ void ext4_ext_release(struct super_block *sb)
> >  #endif
> >  }
> >  
> > +static void bi_complete(struct bio *bio, int error)
> > +{
> > +	complete((struct completion*)bio->bi_private);
> > +}
> 
> Note that the completion event can be called multiple times if there are
> block device errors...  Our similar completion code in Lustre is like:
> 
> static int dio_complete_routine(struct bio *bio, unsigned int done, int error)
> {
> 
>         /* CAVEAT EMPTOR: possibly in IRQ context  */
>         if (bio->bi_size)                       /* Not complete */
>                 return 1;
> 
> 	bio->bi_private->data.error = error;
> 
> 	return 0;
> }


I looked at the latest kernel and with the latest kernel it will be called only
once. We could be having an error. But even for error we would like to be
woken up and later i test for BIO_UPTODATE and if it is not uptodate returns -EIO.

The commit below changed the bio_endio

  6712ecf8f648118c3363c142196418f89a510b90
  5bb23a688b2de23d7765a1dd439d89c038378978
  9cc54d40b8ca01fcefc9151044b6996565061d90



> 
> 
> > +/* FIXME!! we need to try to merge to left or right after zerout  */
> > +static int ext4_ext_zeroout(struct inode *inode, struct ext4_extent *ex)
> > +{
> > +	bio = bio_alloc(GFP_NOIO, ee_len);
> > +	if (!bio)
> > +		return -ENOMEM;
> 
> I don't think it will be possible to allocate a bio large enough for a
> maximum-sized unwritten extent.  BIO_MAX_PAGES is only 256 (1MB on x86),
> but an unwritten extent can be up to 128MB.
> 
> > +	bio->bi_bdev   = inode->i_sb->s_bdev;
> > +
> > +	for (i = 0; i < ee_len; i++) {
> > +		ret = bio_add_page(bio, ZERO_PAGE(0), blocksize, 0);
> > +		if (ret != blocksize) {
> > +			ret = -EIO;
> > +			goto err_out;
> 
> This shouldn't be considered an error.  Rather, it just means that the
> bio is full or is crossing some storage boundary so it should be submitted
> and a new bio created and the zeroing continues.

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
+	sector_t ee_pblock;
+	unsigned int ee_len, len, done;
+	struct completion event;
+
+
+	blkbits   = inode->i_blkbits;
+	blocksize = inode->i_sb->s_blocksize;
+	ee_len    = ext4_ext_get_actual_len(ex);
+	ee_pblock = ext_pblock(ex);
+
+	/* convert ee_pblock in 512 byte sector */
+	ee_pblock = ee_pblock << (blkbits >> 9);
+
+
+	while (ee_len > 0 ) {
+
+		if (ee_len > BIO_MAX_PAGES)
+			len = BIO_MAX_PAGES;
+		else
+			len = ee_len;
+
+		bio = bio_alloc(GFP_NOIO, len);
+		if (!bio)
+			return -ENOMEM;
+		bio->bi_sector = ee_pblock;
+		bio->bi_bdev   = inode->i_sb->s_bdev;
+
+		done = 0;
+		while(done < len) {
+			ret = bio_add_page(bio, ZERO_PAGE(0), blocksize, 0);
+			if (ret != blocksize) {
+				/* We can't add any more page because of
+				 * hardware limitation. Start a new bio
+				 */
+				break;
+			}
+			done++;
+		}
+
+		init_completion(&event);
+		bio->bi_private = &event;
+		bio->bi_end_io = bi_complete;
+		submit_bio(WRITE, bio);
+		wait_for_completion(&event);
+
+		if (test_bit(BIO_UPTODATE, &bio->bi_flags))
+			ret = 0;
+		else {
+			ret = -EIO;
+			break;
+		}
+		bio_put(bio);
+		ee_len    -= done;
+		ee_pblock += done  << (blkbits - 9);
+	}
+	return ret;
+}
+

> 
> Please move most of this function into a generic helper that can be used
> elsewhere.  It might even go into the VFS like:
> 
> int bio_zero_blocks(struct block_device *bdev, sector_t start, sector_t len,
> 		    bio_end_io_t completion);
> 
> and then have ext4_ext_zeroout() call that routine after decoding the extent.
> The error case is only when the bio completion routine is called and the
> saved "data.error" value is returned.


Converting it to an API like above doesn't help much. How about 

int bio_zero_blocks(struct block_device *bdev, sector_t start, unsigned
long bytes);

Here it implies that we would like to wait for zero out to finish.

Since we don't have another user now i didn't add the helper. But that
should be easy.

> 
> > > It would be nice to detect if fs is full or almost full before convert
> > > the uninitialized extents. If the total number of free blocks left are
> > > not enough for the split(plan for the worse case, 3 extents adds), just
> > > go ahead to do the zero out the one single chunk ahead, in stead of
> > > possible zeroing out two chucks later on the error path. I feel it's
> > > much cleaner that way.
> > 
> > We don't zero out two chunks. The uninit extent can possibly get split
> > into three extent.
> > [ 1st uninit] [ 2 init ] [ 3rd uninit]
> > 
> > 
> > Now first we attempt to insert 3. And if we fail due to ENOSPC we
> > zero out the full extent [1 2 3]. Now if we are successful in inserting 3 then
> > we attempt to insert 2. If we fail, we zero out [1 2]. That should also
> > reduce the number blocks that we are zeroing out. For example if we have
> > uninit extent len of 32767 blocks and we try to write the third block within
> > the extent and failed in the second step above we will zero out only 3
> > blocks. If we want to zero out the full extent that would imply zero out
> > 32767 blocks.
> 
> A related optimization is to determine the size of the remaining split
> extents.  I propose that if either of the remaining extents are < 7
> blocks long (or whatever, possibly 15 blocks to get a nice 64kB write) we
> should just zero out those blocks and create a single initialized extent.
> This would avoid the "write every alternate block" problem that could
> grow the number of extents dramatically.

Why 64KB ?. Also while inserting the extent we try to merge with left or
right so the problem may not be that bad. But I agree with you it
would be nice to zero out if the split extent have very small size.

-aneesh
