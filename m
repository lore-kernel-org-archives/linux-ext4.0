From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: Re: [Ext4 punch hole 1/5] Ext4 Punch Hole Support: Convert Blocks
 to Uninit Exts
Date: Tue, 01 Mar 2011 13:47:22 -0700
Message-ID: <4D6D5B5A.4050108@linux.vnet.ibm.com>
References: <4D6C6318.2010105@linux.vnet.ibm.com> <02A57041-5FC1-419D-89D2-47D541616DD4@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:57484 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757361Ab1CAUrl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 1 Mar 2011 15:47:41 -0500
Received: from d01dlp02.pok.ibm.com (d01dlp02.pok.ibm.com [9.56.224.85])
	by e3.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p21KRSWr005820
	for <linux-ext4@vger.kernel.org>; Tue, 1 Mar 2011 15:27:28 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by d01dlp02.pok.ibm.com (Postfix) with ESMTP id 2B65B6E8036
	for <linux-ext4@vger.kernel.org>; Tue,  1 Mar 2011 15:47:29 -0500 (EST)
Received: from d03av05.boulder.ibm.com (d03av05.boulder.ibm.com [9.17.195.85])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p21KlSe2196124
	for <linux-ext4@vger.kernel.org>; Tue, 1 Mar 2011 15:47:28 -0500
Received: from d03av05.boulder.ibm.com (loopback [127.0.0.1])
	by d03av05.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p21KlS0a025112
	for <linux-ext4@vger.kernel.org>; Tue, 1 Mar 2011 13:47:28 -0700
In-Reply-To: <02A57041-5FC1-419D-89D2-47D541616DD4@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2/28/2011 11:42 PM, Andreas Dilger wrote:
> On 2011-02-28, at 8:08 PM, Allison Henderson wrote:
>> This first patch adds a function to convert a range of blocks
>> to an uninitialized extent.  This function will
>> be used to first convert the blocks to extents before
>> punching them out.
> 
> This was proposed as a separate function for FALLOCATE by Dave Chinner (based on XFS_IOC_ZERO_RANGE), so this is useful as a standalone function.
> 
>> +/*
>> + * ext4_split_extents() Splits a given extent at the block "split"
>> + * @handle: The journal handle
>> + * @inode: The file inode
>> + * @split: The block where the extent will be split
>> + * @path: The path to the extent
>> + * @flags: flags used to insert the new extent
>> + */
>> +static int ext4_split_extents(handle_t *handle,
>> +					struct inode *inode,
>> +					ext4_lblk_t split,
>> +					struct ext4_ext_path *path,
>> +					int flags)
> 
> Isn't this already done when converting an uninitialized extent into a regular extent when it is being written to?  Hmm, ext4_ext_convert_to_initialized() is splitting the extent, but it is doing that "by hand".  It might make sense to convert ext4_ext_convert_to_initialized() to use this routine, but this depends on whether it makes the code simpler or not.

Alrighty, I will look into getting ext4_ext_convert_to_initialized() to use this routine. If it looks like it helps make the code simpler, maybe I can add an extra code clean up patch on top of what I already have.  That way if people like it we can keep it, or we can drop the last patch if they don't. :)

> 
>> +	/* if the block is not actually in the extent, go to out */
>> +	if(split>  ee_block+ee_len || split<  ee_block)
>> +		goto out;
> 
> Is this actually needed?

Ideally no.  All the code that calls this routine does this math before hand to make sure this never happens, but I thought I might add this check here anyway just in case someone in the future tries to use this routine and doesnt do the math right.  If for some reason we feel this code should be removed, the rest of the patch should function just fine without it though.

> 
>> +	ext_debug("The new block is %llu, the orig block is: %llu\n", newblock, origblock);
> 
> (style) please wrap lines at 80 columns.  This patch should be run through checkpatch.pl, which should catch issues like this.
> 
>> +	if(EXT_LAST_EXTENT(eh)>=  EXT_MAX_EXTENT(eh)){
>> +
>> +	/* otherwise just scoot all ther other extents down  */
>> +	else{
>> +		for(i_ex = EXT_LAST_EXTENT(eh); i_ex>  ex1; i_ex-- ){
>> +			memcpy(i_ex+1, i_ex, sizeof(struct ext4_extent));
>> +		}
>> +		memcpy(ex1+1, ex2, sizeof(struct ext4_extent));
> 
> (style) the whitespace in several other places is also not following the Linux coding style
> 
> 
> Cheers, Andreas
> 
> 
> 
> 
> 

Thx for the feed back!  I will get the rest of the style comments integrated into the patch.

Allison Henderson

