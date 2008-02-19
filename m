From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH] ext4: When reading from fallocated blocks make sure we
	return zero.
Date: Mon, 18 Feb 2008 21:24:12 -0800
Message-ID: <1203398652.3612.7.camel@localhost.localdomain>
References: <1203099414-8815-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	 <1203104584.3598.4.camel@localhost.localdomain>
	 <20080216032334.GA6501@skywalker>
	 <1203380074.3629.35.camel@localhost.localdomain>
	 <20080219031914.GA7192@skywalker>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:44206 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750701AbYBSFYQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 19 Feb 2008 00:24:16 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e1.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m1J5OGQQ032511
	for <linux-ext4@vger.kernel.org>; Tue, 19 Feb 2008 00:24:16 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m1J5OG5a254956
	for <linux-ext4@vger.kernel.org>; Tue, 19 Feb 2008 00:24:16 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m1J5OFIt022546
	for <linux-ext4@vger.kernel.org>; Tue, 19 Feb 2008 00:24:15 -0500
In-Reply-To: <20080219031914.GA7192@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 2008-02-19 at 08:49 +0530, Aneesh Kumar K.V wrote:
> On Mon, Feb 18, 2008 at 04:14:34PM -0800, Mingming Cao wrote:
> > On Sat, 2008-02-16 at 08:53 +0530, Aneesh Kumar K.V wrote:
> > 
> > How about the following patch?
> > 
> > Regards,
> > Mingming
> > 
> > ext4: ext4_get_blocks_wrap fix for writing to preallocated
> > From: Mingming Cao <cmm@us.ibm.com>
> > 
> > This patch fixed a issue with wrting to a preallocated blocks.
> > A write hit a BUG_ON() in fs/buffer.c saying the buffer is not mapped.
> > 
> > On the write path, ext4_get_block_wrap() is called with create=1, but it
> > will pass create=0 down to the underlying ext4ext_get_blocks()
> > to do a look up first.  In the preallocation case, ext4_ext_get_blocks()
> > with create = 0, will return number of blocks pre-allocated and buffer
> > head unmapped. ext4_get_blocks_wrap() thinks it succeeds too early, without
> > checking if it needs again call ext4_ext_get_blocks with create = 1
> > which would do proper handling for writing to preallocated blocks:
> > split the extent to initialized and uninitialized one and
> > returns the mapped buffer head.
> > 
> > Treating preallocated blocks as holes equally(i.e. ignoring the number of blocks
> > pre-allocated and returns 0) when get_blocks() is called with create = 0 is not enough.
> > ext4_ext_get_blocks() needs to differentiate these two cases for delayed allocation
> > purpose, as for holes it need to do reservation and prepare for later
> > delayed allocation, but for pre-allocated blocks it needs skip that work.
> > 
> > It would makes things more clear if we have clear definition of what
> > get_blocks() return value means.
> > 
> > Similar to ext4_get_blocks_handle(),  the following 
> > * return > 0, # of blocks already allocated
> > *          if these are pre-allocated blocks and create = 0
> > *             buffer head is unmapped
> > *          otherwise blocks are mapped.
> > *
> > * return = 0, if plain look up failed (blocks have not been allocated)
> > *          buffer head is unmapped
> > *
> > * return < 0, error case.
> > 
> > The for the write path, at ext4_ext_get_blocks_wrap(), it could check the
> > buffer_mapped() status for preallocated extent before quit too early.
> > 
> > Signed-off-by: Mingming Cao <cmm@us.ibm.com>
> 
> Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.co>
> 
> 
> 
> I guess we also need to make sure the buffer head have the mapped bit
> set. Something like the patch below.
> 
Good point. I modified the patch with clear_buffer_mapped() added at the
begining of the wrapper function.

Mingming
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index bc7081f..69ccda9 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -2294,6 +2294,7 @@ int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
>  	struct ext4_allocation_request ar;
> 
>  	__clear_bit(BH_New, &bh_result->b_state);
> +	__clear_bit(BH_Mapped, &bh_result->b_state);
>  	ext_debug("blocks %u/%lu requested for inode %u\n",
>  			iblock, max_blocks, inode->i_ino);
> 
