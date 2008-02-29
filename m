From: Andreas Dilger <adilger@sun.com>
Subject: Re: [RFC][PATCH] ext4: Convert uninitialized extent to initialized
	extent in case of file system full
Date: Fri, 29 Feb 2008 11:21:42 -0800
Message-ID: <20080229192142.GJ2997@webber.adilger.int>
References: <1204221911-9753-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1204221911-9753-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1204221911-9753-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1204240440.3609.26.camel@localhost.localdomain>
 <20080229110924.GA16757@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: Mingming Cao <cmm@us.ibm.com>, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:37832 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761379AbYB2TV6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 29 Feb 2008 14:21:58 -0500
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m1TJLtMj021529
	for <linux-ext4@vger.kernel.org>; Fri, 29 Feb 2008 11:21:56 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0JX000G01LRMGG00@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Fri, 29 Feb 2008 11:21:55 -0800 (PST)
In-reply-to: <20080229110924.GA16757@skywalker>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Feb 29, 2008  16:39 +0530, Aneesh Kumar K.V wrote:
> > One simple solution is submit bio directly to zero out the blocks on
> > disk, and wait for that to finish before clear the uninitialized bit. On
> > a 4K block size case, the max size of an uninitialized extents is 128MB,
> > and since the blocks are all contigous on disk, a single IO could done
> > the job, the latency should not be a too big issue. After all when a
> > filesystem is full, it's already performs slowly.
> 
> This is the change that i have now. Yet to run the full test on that.
> But seems to be working for simple tests.
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index d315cc1..26396e2 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -2136,6 +2136,55 @@ void ext4_ext_release(struct super_block *sb)
>  #endif
>  }
>  
> +static void bi_complete(struct bio *bio, int error)
> +{
> +	complete((struct completion*)bio->bi_private);
> +}

Note that the completion event can be called multiple times if there are
block device errors...  Our similar completion code in Lustre is like:

static int dio_complete_routine(struct bio *bio, unsigned int done, int error)
{

        /* CAVEAT EMPTOR: possibly in IRQ context  */
        if (bio->bi_size)                       /* Not complete */
                return 1;

	bio->bi_private->data.error = error;

	return 0;
}


> +/* FIXME!! we need to try to merge to left or right after zerout  */
> +static int ext4_ext_zeroout(struct inode *inode, struct ext4_extent *ex)
> +{
> +	bio = bio_alloc(GFP_NOIO, ee_len);
> +	if (!bio)
> +		return -ENOMEM;

I don't think it will be possible to allocate a bio large enough for a
maximum-sized unwritten extent.  BIO_MAX_PAGES is only 256 (1MB on x86),
but an unwritten extent can be up to 128MB.

> +	bio->bi_bdev   = inode->i_sb->s_bdev;
> +
> +	for (i = 0; i < ee_len; i++) {
> +		ret = bio_add_page(bio, ZERO_PAGE(0), blocksize, 0);
> +		if (ret != blocksize) {
> +			ret = -EIO;
> +			goto err_out;

This shouldn't be considered an error.  Rather, it just means that the
bio is full or is crossing some storage boundary so it should be submitted
and a new bio created and the zeroing continues.

Please move most of this function into a generic helper that can be used
elsewhere.  It might even go into the VFS like:

int bio_zero_blocks(struct block_device *bdev, sector_t start, sector_t len,
		    bio_end_io_t completion);

and then have ext4_ext_zeroout() call that routine after decoding the extent.
The error case is only when the bio completion routine is called and the
saved "data.error" value is returned.

> > It would be nice to detect if fs is full or almost full before convert
> > the uninitialized extents. If the total number of free blocks left are
> > not enough for the split(plan for the worse case, 3 extents adds), just
> > go ahead to do the zero out the one single chunk ahead, in stead of
> > possible zeroing out two chucks later on the error path. I feel it's
> > much cleaner that way.
> 
> We don't zero out two chunks. The uninit extent can possibly get split
> into three extent.
> [ 1st uninit] [ 2 init ] [ 3rd uninit]
> 
> 
> Now first we attempt to insert 3. And if we fail due to ENOSPC we
> zero out the full extent [1 2 3]. Now if we are successful in inserting 3 then
> we attempt to insert 2. If we fail, we zero out [1 2]. That should also
> reduce the number blocks that we are zeroing out. For example if we have
> uninit extent len of 32767 blocks and we try to write the third block within
> the extent and failed in the second step above we will zero out only 3
> blocks. If we want to zero out the full extent that would imply zero out
> 32767 blocks.

A related optimization is to determine the size of the remaining split
extents.  I propose that if either of the remaining extents are < 7
blocks long (or whatever, possibly 15 blocks to get a nice 64kB write) we
should just zero out those blocks and create a single initialized extent.
This would avoid the "write every alternate block" problem that could
grow the number of extents dramatically.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

