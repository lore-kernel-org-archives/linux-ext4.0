From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/3] ext4: Clear the unwritten buffer_head flag properly
Date: Fri, 8 May 2009 13:42:27 +0530
Message-ID: <20090508081227.GA19157@skywalker>
References: <1241692770-22547-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1241692770-22547-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <4A030011.7040901@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, tytso@mit.edu, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:38409 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752997AbZEHIN2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 8 May 2009 04:13:28 -0400
Received: from d23relay01.au.ibm.com (d23relay01.au.ibm.com [202.81.31.243])
	by e23smtp07.au.ibm.com (8.13.1/8.13.1) with ESMTP id n488DP3G009708
	for <linux-ext4@vger.kernel.org>; Fri, 8 May 2009 18:13:25 +1000
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
	by d23relay01.au.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n488DPvJ336224
	for <linux-ext4@vger.kernel.org>; Fri, 8 May 2009 18:13:25 +1000
Received: from d23av01.au.ibm.com (loopback [127.0.0.1])
	by d23av01.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n488DPoX018746
	for <linux-ext4@vger.kernel.org>; Fri, 8 May 2009 18:13:25 +1000
Content-Disposition: inline
In-Reply-To: <4A030011.7040901@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, May 07, 2009 at 10:36:49AM -0500, Eric Sandeen wrote:
> Aneesh Kumar K.V wrote:
> > ext4_get_blocks_wrap does a block lookup requesting to
> > allocate new blocks. A lookup of blocks in prealloc area
> > result in setting the unwritten flag in buffer_head. So
> > a write to an unwritten extent will cause the buffer_head
> > to have unwritten and mapped flag set. Clear hte unwritten
> > buffer_head flag before requesting to allocate blocks.
> > 
> > Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> > ---
> >  fs/ext4/inode.c |    7 +++++++
> >  1 files changed, 7 insertions(+), 0 deletions(-)
> > 
> > diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> > index c3cd00f..f6d7e9b 100644
> > --- a/fs/ext4/inode.c
> > +++ b/fs/ext4/inode.c
> > @@ -1149,6 +1149,7 @@ int ext4_get_blocks_wrap(handle_t *handle, struct inode *inode, sector_t block,
> >  	int retval;
> >  
> >  	clear_buffer_mapped(bh);
> > +	clear_buffer_unwritten(bh);
> >  
> >  	/*
> >  	 * Try to see if we can get  the block without requesting
> > @@ -1179,6 +1180,12 @@ int ext4_get_blocks_wrap(handle_t *handle, struct inode *inode, sector_t block,
> >  		return retval;
> >  
> >  	/*
> > +	 * The above get_blocks can cause the buffer to be
> > +	 * marked unwritten. So clear the same.
> > +	 */
> > +	clear_buffer_unwritten(bh);
> 
> hm, thinking out loud here.
> 
> ext4_ext_get_blocks() will only set unwritten if (!create) ... but then
> ext4_get_blocks_wrap() calls ext4_ext_get_blocks() !create as an
> argument no matter what, the first time, for an initial lookup.
> 
> But if ext4_get_blocks_wrap() was called with !create, then we return
> regardless, so ok - by the time you get to the above hunk, we -are- in
> create mode, we're planning to write it ... so I guess clearing the
> unwritten state makes sense here.
> 
> But is this too late, because it's after this?
> 
>         /*
>          * Returns if the blocks have already allocated
>          *
>          * Note that if blocks have been preallocated
>          * ext4_ext_get_block() returns th create = 0
>          * with buffer head unmapped.
>          */
>         if (retval > 0 && buffer_mapped(bh))
>                 return retval;
> 
> I guess not; ext4_ext_get_blocks() won't map the buffer if it's found to
> be preallocated/unwritten because it was called with !create.  If we're
> going on to write it, we want to clear unwritten.
> 
> So I guess this looks right, although I can't help but think that in
> general, the buffer_head state management is really getting to be a
> hard-to-follow mess...

To further clarify what i think was causing the I/O error.

1) We do a multi block delayed alloc to prealloc space. That would get
us multiple buffer_heads marked with BH_Unwritten. (say 10, 11, 12)
2) pdflush attempt to write some pages (say mapping block 10) which cause
a get_block call with create = 1. That would attempt to convert
uninitialized extent to initialized one. This can cause multiple blocks
to be marked initialized. ( say 10, 11 , 12)
3) We do an overwrite of block 11. That would mean we call
ext4_da_get_block_prep, which would again do a get_block for block 11
with create = 0. But remember we already have buffer_head marked with
BH_Unwritten flag. But the buffer was unmapped because it is unwritten
( We are fixing this mess in the patch for 2.6.31).
4) The get_block call will find the buffer mapped due to step b. And
mark the buffer_head mapped. There we go . We end up with buffer_head
mapped and unwritten
5) later in ext4_da_get_block_prep we check whether the buffer_head in marked
BH_Unwritten if so we set the block number to ~0. This is introduced by
[PATCH -V4 1/2] Fix sub-block zeroing for buffered writes into unwritten extents
6) So now we have a buffer_head that is mapped, unwritten, with
b_blocknr = ~0. That would result in the I/O error.

-aneesh


