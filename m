From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [RFC][Patch 1/2] Persistent preallocation in ext4
Date: Wed, 27 Dec 2006 15:30:44 -0800
Message-ID: <1167262245.3792.20.camel@dyn9047017103.beaverton.ibm.com>
References: <20061205134338.GA1894@amitarora.in.ibm.com>
	 <20061206055822.GA6182@amitarora.in.ibm.com>
	 <20061215123528.GA24572@amitarora.in.ibm.com>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, suparna@in.ibm.com, suzuki@in.ibm.com,
	alex@clusterfs.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:60899 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753153AbWL0Xat (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 27 Dec 2006 18:30:49 -0500
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e33.co.us.ibm.com (8.13.8/8.12.11) with ESMTP id kBRNUl4n007891
	for <linux-ext4@vger.kernel.org>; Wed, 27 Dec 2006 18:30:47 -0500
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay04.boulder.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id kBRNUlxM551448
	for <linux-ext4@vger.kernel.org>; Wed, 27 Dec 2006 16:30:47 -0700
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id kBRNUkVe016088
	for <linux-ext4@vger.kernel.org>; Wed, 27 Dec 2006 16:30:46 -0700
To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
In-Reply-To: <20061215123528.GA24572@amitarora.in.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, 2006-12-15 at 18:05 +0530, Amit K. Arora wrote:
> This is the first patch in the set of two.
> 
> It implements the ioctl which will be used for persistent preallocation. It is a respun of the previous patch which was posted earlier, and includes following changes:
> * Takes care of review comments by Mingming
> * The declaration of extent related macros are now moved to ext4_fs_extent.h (from ext4_fs.h)
> * Updated the logic to calculate block and max_blocks in ext4/ioctl.c, which is used to call get_blocks.
> 
> It does _not_ take care of implementing persistent preallocation for non-extent based files. It is because of the following reasons:
> * It is being considered as a rare case
> * Users can/should convert their file(s) to extent format to use this feature
> * Moreover, posix_fallocate() can be used for this purpose, if the user does not want to convert the file(s) to the extent based format.
> 
> 
> Signed-off-by: Amit Arora (aarora@in.ibm.com)
> 
Hi Amit, 

looks good to me, a few comments :)
.....
> Index: linux-2.6.19.prealloc/fs/ext4/ioctl.c
> ===================================================================
> --- linux-2.6.19.prealloc.orig/fs/ext4/ioctl.c	2006-12-15 16:44:35.000000000 +0530
> +++ linux-2.6.19.prealloc/fs/ext4/ioctl.c	2006-12-15 17:47:00.000000000 +0530
> @@ -248,6 +248,65 @@
>  		return err;
>  	}
> 
> +	case EXT4_IOC_PREALLOCATE: {
> +		struct ext4_falloc_input input;
> +		handle_t *handle;
> +		ext4_fsblk_t block, max_blocks;
> +		int ret, ret2, nblocks = 0, retries = 0;
> +		struct buffer_head map_bh;
> +		unsigned int blkbits = inode->i_blkbits;
> +
> +		if (IS_RDONLY(inode))
> +			return -EROFS;
> +
> +		if (copy_from_user(&input,
> +			(struct ext4_falloc_input __user *) arg, sizeof(input)))
> +			return -EFAULT;
> +
> +		if (input.len == 0)
> +			return -EINVAL;
> +
> +		if (!(EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL))
> +			return -ENOTTY;
> +
> +		block = input.offset >> blkbits;
> +		max_blocks = (EXT4_BLOCK_ALIGN(input.len + input.offset,
> +						blkbits) >> blkbits) - block;
> +		handle=ext4_journal_start(inode,
> +				EXT4_DATA_TRANS_BLOCKS(inode->i_sb)+max_blocks);
> +		if (IS_ERR(handle))
> +			return PTR_ERR(handle);
> +retry:
> +		ret = 0;
> +		while(ret>=0 && ret<max_blocks)
> +		{
> +			block = block + ret;
> +			max_blocks = max_blocks - ret;
> +	  		ret = ext4_ext_get_blocks(handle, inode, block,
> +					max_blocks, &map_bh,
> +					EXT4_CREATE_UNINITIALIZED_EXT, 0);
> +			if(ret > 0 && test_bit(BH_New, &map_bh.b_state))
> +				nblocks = nblocks + ret;
> +		}


ext4_ext_get_blocks() returns 0 when it is mapping (non allocating) a
hole. In our case, we are doing allocating, so here it is not possible
to returns a 0 from ext4_ext_get_blocks(). I think we should quit the
loop and BUGON if ret == 0 here.

> +		if (ret == -ENOSPC && ext4_should_retry_alloc(inode->i_sb,
> +						&retries))
> +			goto retry;
> +
> +		if(nblocks) {
> +			mutex_lock(&inode->i_mutex);
> +			inode->i_size = inode->i_size + (nblocks >> blkbits);
> +			EXT4_I(inode)->i_disksize = inode->i_size;
> +			mutex_unlock(&inode->i_mutex);
> +		}

Hmm... We should not need to worry about the inode->i_size if we are
preallocating blocks for holes. 

And, Looking at other places calling ext4_*_get_blocks() in the kernel,
it seems not all of them protected by i_mutex lock. I think it probably
okay to not holding i_mutex during calling ext4_ext4_get_blocks(). 

> +
> +		ext4_mark_inode_dirty(handle, inode);
> +		ret2 = ext4_journal_stop(handle);
> +		if(ret > 0)
> +			ret = ret2;
> +
> +		return ret > 0 ? nblocks : ret;
> +	}
> +

Since the API takes the number of bytes to preallocate, at return time,
shall we convert the blocks to bytes to the user?

Here it returns the number of allocated blocks to the user.   Do we need
to worry about the case when dealing with a range with partial hole and
partial blocks already allocated? In that case nblocks(the new
preallocated blocks) will less than the maxblocks (the number of blocks
asked by application).  I am wondering what does other filesystem like
xfs do? Maybe we should do the same thing.

Thanks,
Mingming
