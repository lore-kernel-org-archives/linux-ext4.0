From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH] ext4: Fix fallocate to update the file size in
	each transaction.
Date: Sat, 8 Mar 2008 21:41:27 +0530
Message-ID: <20080308161127.GA6992@skywalker>
References: <1204887200-9929-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <47D16302.9090506@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, tytso@mit.edu, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:55175 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016AbYCHQMa (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 8 Mar 2008 11:12:30 -0500
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp04.au.ibm.com (8.13.1/8.13.1) with ESMTP id m28GC3G1010066
	for <linux-ext4@vger.kernel.org>; Sun, 9 Mar 2008 03:12:03 +1100
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m28GG8Zu246048
	for <linux-ext4@vger.kernel.org>; Sun, 9 Mar 2008 03:16:09 +1100
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m28GCRYg006044
	for <linux-ext4@vger.kernel.org>; Sun, 9 Mar 2008 03:12:27 +1100
Content-Disposition: inline
In-Reply-To: <47D16302.9090506@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Mar 07, 2008 at 09:45:06AM -0600, Eric Sandeen wrote:
> Aneesh Kumar K.V wrote:
> > ext4_fallocate need to update file size in each transaction. Otherwise
> > ife we crash the file size won't be updated. We were also not marking
> > the inode dirty after updating file size before. 
> 
> This led to losing the size update when unmounted...
> 
> > Also when we try to
> > retry allocation due to ENOSPC make sure we reset the variable ret so
> > that we actually do a retry.
> 
> That's a few alsos.  Should this be more than one patch when committed?
> 
> -Eric
> 
> > Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> > ---
> >  fs/ext4/extents.c |   78 +++++++++++++++++++++--------------------------------
> >  1 files changed, 31 insertions(+), 47 deletions(-)
> > 
> > diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> > index dcdf92a..09dd3c5 100644
> > --- a/fs/ext4/extents.c
> > +++ b/fs/ext4/extents.c
> > @@ -2783,6 +2783,26 @@ int ext4_ext_writepage_trans_blocks(struct inode *inode, int num)
> >  	return needed;
> >  }
> >  
> > +static void ext4_falloc_update_inode(struct inode *inode,
> > +					int mode, loff_t new_size)
> > +{
> > +	struct timespec now;
> > +
> > +	now = current_fs_time(inode->i_sb);
> > +	if (!timespec_equal(&inode->i_ctime, &now))
> > +		inode->i_ctime = now;
> 
> This used to depend on blocks actually being allocated; it looks like it
> doesn't anymore?

I am still not clear about the requirement here. The earlier code
check for greater than current file size, which was confusing because we
could very well convert a hole to a prealloc area. How about updating
i_ctime if the buffer head is new ?.


> 
> > +	/*
> > +	 * Update only when preallocation was requested beyond
> > +	 * the file size.
> > +	 */
> > +	if (!(mode & FALLOC_FL_KEEP_SIZE) &&
> >  			break;

.....

> >  		}
> > -		if (ret > 0) {
> > -			/* check wrap through sign-bit/zero here */
> > -			if ((block + ret) < 0 || (block + ret) < block) {
> > -				ret = -EIO;
> > -				ext4_mark_inode_dirty(handle, inode);
> > -				ret2 = ext4_journal_stop(handle);
> > -				break;
> > -			}
> > -			if (buffer_new(&map_bh) && ((block + ret) >
> > -			    (EXT4_BLOCK_ALIGN(i_size_read(inode), blkbits)
> > -			    >> blkbits)))
> > -					nblocks = nblocks + ret;
> > -		}
> > +		if ((block + ret) >= (EXT4_BLOCK_ALIGN(offset + len,
> > +						blkbits) >> blkbits))
> > +			new_size = offset + len;
> > +		else
> > +			new_size = (block + ret) << blkbits;
> 
> Since we called ext4_get_blocks_wrap with max_blocks, will we really end
> up with more blocks allocated than we asked for?  And do we no longer
> need the wrap checks?  (I'd expect that to be tested higher up with the
> original offset+len requested, no?)

ext4_get_blocks_wrap had confusing returns. Mingming actually fixed it
in the previous patch. We can actually return more bytes than requested
if we are calling ext4_get_blocks_wrap in read mode for an falloc area.
Well that is not really the case here. But having in >=  is ok. 


The wrap check there was not needed. The needed wrap check is to make sure
whether we are crossing the allowed max file size. That is done in
sys_fallocate.



> 
> > -		/* Update ctime if new blocks get allocated */
> > -		if (nblocks) {
> > -			struct timespec now;
> > -
> > -			now = current_fs_time(inode->i_sb);

...

-aneesh
