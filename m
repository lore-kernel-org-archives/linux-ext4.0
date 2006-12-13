From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [RFC][Patch 1/1] Persistent preallocation in ext4
Date: Tue, 12 Dec 2006 16:20:38 -0800
Message-ID: <1165969238.3771.34.camel@dyn9047017103.beaverton.ibm.com>
References: <20061205134338.GA1894@amitarora.in.ibm.com>
	 <20061206055822.GA6182@amitarora.in.ibm.com>
	 <1165886895.3939.18.camel@dyn9047017103.beaverton.ibm.com>
	 <20061212062302.GA8280@amitarora.in.ibm.com>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, suparna@in.ibm.com, suzuki@in.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:49800 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964795AbWLMAUo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 12 Dec 2006 19:20:44 -0500
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e34.co.us.ibm.com (8.13.8/8.12.11) with ESMTP id kBD0Khqa006870
	for <linux-ext4@vger.kernel.org>; Tue, 12 Dec 2006 19:20:43 -0500
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by westrelay02.boulder.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id kBD0Kg1R499266
	for <linux-ext4@vger.kernel.org>; Tue, 12 Dec 2006 17:20:42 -0700
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id kBD0Kgdj011376
	for <linux-ext4@vger.kernel.org>; Tue, 12 Dec 2006 17:20:42 -0700
To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
In-Reply-To: <20061212062302.GA8280@amitarora.in.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 2006-12-12 at 11:53 +0530, Amit K. Arora wrote:
> Hi Mingming,
> 
Hi Amit,

> On Mon, Dec 11, 2006 at 05:28:15PM -0800, Mingming Cao wrote:
> > On Wed, 2006-12-06 at 11:28 +0530, Amit K. Arora wrote:
> >
> > > @@ -1142,13 +1155,22 @@
> > >  	/* try to insert block into found extent and return */
> > >  	if (ex && ext4_can_extents_be_merged(inode, ex, newext)) {
> > >  		ext_debug("append %d block to %d:%d (from %llu)\n",
> > > -				le16_to_cpu(newext->ee_len),
> > > +				ext4_ext_get_actual_len(newext),
> > >  				le32_to_cpu(ex->ee_block),
> > > -				le16_to_cpu(ex->ee_len), ext_pblock(ex));
> > > +				ext4_ext_get_actual_len(ex), ext_pblock(ex));
> > >  		if ((err = ext4_ext_get_access(handle, inode, path + depth)))
> > >  			return err;
> > > -		ex->ee_len = cpu_to_le16(le16_to_cpu(ex->ee_len)
> > > -					 + le16_to_cpu(newext->ee_len));
> > > +
> > > +		/* ext4_can_extents_be_merged should have checked that either
> > > +		 * both extents are uninitialized, or both aren't. Thus we
> > > +		 * need to check any of them here.
> > > +		 */
> > > +		if (ext4_ext_is_uninitialized(ex))
> > > +			uninitialized = 1;
> > > +		ex->ee_len = cpu_to_le16(ext4_ext_get_actual_len(ex)
> > > +					 + ext4_ext_get_actual_len(newext));
> 
> Above line will "remove" the uninitialized bit from "ex", if it was set.
> We call ext4_ext_get_actual_len() to get the "actual" lengths of the two
> extents, which removes this MSB in ee_len (MSB in ee_len is used to mark
> an extent uninitialized). Now, we do this because if lengths of two
> uninitialized extents will be added as it is (i.e. without masking out
> the MSB in the length), it will result in removing the MSB in ee_len.
> For example, 0x8002 + 0x8003 => 0x10005 => 0x5 (since ee_len is 16 bit).
> 
> That is why just before this line, we save the "state" of this extent,
> whether it was uninitialized or not. And, we restore this "state" below.

Ah...you are right:)

More comments below...

> Index: linux-2.6.19/fs/ext4/ioctl.c
> ===================================================================
> --- linux-2.6.19.orig/fs/ext4/ioctl.c	2006-12-06 10:18:12.000000000 +0530
> +++ linux-2.6.19/fs/ext4/ioctl.c	2006-12-06 10:18:15.000000000 +0530
> @@ -248,6 +248,47 @@
>  		return err;
>  	}
> 
> +	case EXT4_IOC_PREALLOCATE: {
> +		struct ext4_falloc_input input;
> +		handle_t *handle;
> +		ext4_fsblk_t block, max_blocks;
> +		int ret = 0;
> +		struct buffer_head map_bh;
> +		unsigned int blkbits = inode->i_blkbits;
> +
> +		if (IS_RDONLY(inode))
> +                        return -EROFS;
> +
> +		if (copy_from_user(&input,
> +			(struct ext4_falloc_input __user *) arg, sizeof(input)))
> +                        return -EFAULT;
> +
> +		if (input.len == 0)
> +			return -EINVAL;
> +
> +		if (!(EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL))
> +			return -ENOTTY;
> 

Supporting preallocation for extent based files seems fairly
straightforward.  I agree we should look at this first.  After get this
done, it probably worth re-consider whether to support preallocation for
non-extent based files on ext4. I could imagine user upgrade from ext3
to ext4, and expecting to use preallocation on those existing files....

> +
> +		block = EXT4_BLOCK_ALIGN(input.offset, blkbits) >> blkbits;
> +		max_blocks = EXT4_BLOCK_ALIGN(input.len, blkbits) >> blkbits;
> +		handle=ext4_journal_start(inode,
> +				EXT4_DATA_TRANS_BLOCKS(inode->i_sb)+max_blocks);
> +		if (IS_ERR(handle))
> +			return PTR_ERR(handle);
> +		while(ret>=0 && ret<max_blocks)
> +		{
> +			block = block + ret;
> +			max_blocks = max_blocks - ret;
> +	  		ret = ext4_ext_get_blocks(handle, inode, block,
> +					max_blocks, &map_bh,
> +					EXT4_CREATE_UNINITIALIZED_EXT, 1);

Since the interface takes offset and number of blocks to allocate, I
assuming we are going to handle holes in preallocation, thus, we cannot
not mark the extend_size flag to 1 when calling ext4_ext_get_blocks.

I think we should update i_size and i_disksize after preallocation. Oh,
to protect parallel updating i_size, we have to take i_mutex down.

> +		}
> +		ext4_mark_inode_dirty(handle, inode);
> +		ext4_journal_stop(handle);
> +

Error code returned by ext4_journal_stop() is being ignored here, is
this right?
Well, there are other places in ext34/ioctl.c which ignore the return
returned by ext4_journal_stop(), maybe should fix this in a separate
patch.

> +		return ret>0?0:ret;
> +	}
> 
> 
Oh, what if we failed to allocate the full amount of blocks? i.e, the
ext4_ext_get_blocks() returns -ENOSPC error and exit the loop early. Are
we going to return error, or try something like 

if (ret == -ENOSPC && ext3_should_retry_alloc(inode->i_sb, &retries))
	goto retry

I wonder it might be useful to return the actual number of blocks
preallocated back to the application.


Mingming
