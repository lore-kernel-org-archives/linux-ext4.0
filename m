From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [Ext4 punch hole 1/5] Ext4 Punch Hole Support: Convert Blocks to Uninit Exts
Date: Mon, 28 Feb 2011 23:42:48 -0700
Message-ID: <02A57041-5FC1-419D-89D2-47D541616DD4@dilger.ca>
References: <4D6C6318.2010105@linux.vnet.ibm.com>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-ext4@vger.kernel.org
To: Allison Henderson <achender@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:25723 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754346Ab1CAGmu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 1 Mar 2011 01:42:50 -0500
In-Reply-To: <4D6C6318.2010105@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-02-28, at 8:08 PM, Allison Henderson wrote:
> This first patch adds a function to convert a range of blocks
> to an uninitialized extent.  This function will
> be used to first convert the blocks to extents before
> punching them out.

This was proposed as a separate function for FALLOCATE by Dave Chinner (based on XFS_IOC_ZERO_RANGE), so this is useful as a standalone function.

> +/*
> + * ext4_split_extents() Splits a given extent at the block "split"
> + * @handle: The journal handle
> + * @inode: The file inode
> + * @split: The block where the extent will be split
> + * @path: The path to the extent
> + * @flags: flags used to insert the new extent
> + */
> +static int ext4_split_extents(handle_t *handle,
> +					struct inode *inode,
> +					ext4_lblk_t split,
> +					struct ext4_ext_path *path,
> +					int flags)

Isn't this already done when converting an uninitialized extent into a regular extent when it is being written to?  Hmm, ext4_ext_convert_to_initialized() is splitting the extent, but it is doing that "by hand".  It might make sense to convert ext4_ext_convert_to_initialized() to use this routine, but this depends on whether it makes the code simpler or not.

> +	/* if the block is not actually in the extent, go to out */
> +	if(split > ee_block+ee_len || split < ee_block)
> +		goto out;

Is this actually needed?

> +	ext_debug("The new block is %llu, the orig block is: %llu\n", newblock, origblock);  

(style) please wrap lines at 80 columns.  This patch should be run through checkpatch.pl, which should catch issues like this.
 
> +	if(EXT_LAST_EXTENT(eh) >=  EXT_MAX_EXTENT(eh)){
> +
> +	/* otherwise just scoot all ther other extents down  */
> +	else{
> +		for(i_ex = EXT_LAST_EXTENT(eh); i_ex > ex1; i_ex-- ){
> +			memcpy(i_ex+1, i_ex, sizeof(struct ext4_extent));
> +		}
> +		memcpy(ex1+1, ex2, sizeof(struct ext4_extent));

(style) the whitespace in several other places is also not following the Linux coding style


Cheers, Andreas





