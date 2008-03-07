From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH] ext4: Fix fallocate to update the file size in
	each transaction.
Date: Fri, 7 Mar 2008 17:14:13 +0530
Message-ID: <20080307114413.GA10824@skywalker>
References: <1204887200-9929-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1204889457.3627.43.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:45784 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756017AbYCGLoU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 7 Mar 2008 06:44:20 -0500
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp02.au.ibm.com (8.13.1/8.13.1) with ESMTP id m27BiRXn012920
	for <linux-ext4@vger.kernel.org>; Fri, 7 Mar 2008 22:44:27 +1100
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m27BiGOI3981388
	for <linux-ext4@vger.kernel.org>; Fri, 7 Mar 2008 22:44:16 +1100
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m27BiLE4019151
	for <linux-ext4@vger.kernel.org>; Fri, 7 Mar 2008 22:44:21 +1100
Content-Disposition: inline
In-Reply-To: <1204889457.3627.43.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Mar 07, 2008 at 03:30:57AM -0800, Mingming Cao wrote:
> On Fri, 2008-03-07 at 16:23 +0530, Aneesh Kumar K.V wrote:
> > ext4_fallocate need to update file size in each transaction. Otherwise
> > ife we crash the file size won't be updated. We were also not marking
> > the inode dirty after updating file size before. Also when we try to
> > retry allocation due to ENOSPC make sure we reset the variable ret so
> > that we actually do a retry.
> > 
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
> > +	/*
> > +	 * Update only when preallocation was requested beyond
> > +	 * the file size.
> > +	 */
> > +	if (!(mode & FALLOC_FL_KEEP_SIZE) &&
> > +				new_size > i_size_read(inode)) {
> > +		i_size_write(inode, new_size);
> > +		EXT4_I(inode)->i_disksize = i_size_read(inode);
> 
> Just a minor thing, we could store new_size directly to i_disksize to
> avoid calling the i_size_read() instead.
> 

OK

> 
> > +	}
> > +
> > +}
> > +
> >  /*
> >   * preallocate space for a file. This implements ext4's fallocate inode
> >   * operation, which gets called from sys_fallocate system call.
> > @@ -2794,8 +2814,8 @@ long ext4_fallocate(struct inode *inode, int mode, loff_t offset, loff_t len)
> >  {
> >  	handle_t *handle;
> >  	ext4_lblk_t block;
> > +	loff_t new_size;
> >  	unsigned long max_blocks;
> > -	ext4_fsblk_t nblocks = 0;
> >  	int ret = 0;
> >  	int ret2 = 0;
> >  	int retries = 0;
> > @@ -2814,8 +2834,7 @@ long ext4_fallocate(struct inode *inode, int mode, loff_t offset, loff_t len)
> >  		return -ENODEV;
> > 
> >  	block = offset >> blkbits;
> > -	max_blocks = (EXT4_BLOCK_ALIGN(len + offset, blkbits) >> blkbits)
> > -			- block;
> > +	max_blocks = EXT4_BLOCK_ALIGN(len, blkbits) >> blkbits;
> > 
> 
> Not sure about this change... Other than this looks fine to me
> 

max_blocks actually represented the number of blocks that we are
requesting. The above change makes it simple.

-aneesh
