From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [Ext4 punch hole 1/5] Ext4 Punch Hole Support: Convert Blocks
 to Uninit Exts
Date: Tue, 01 Mar 2011 15:16:10 -0800
Message-ID: <1299021370.6761.493.camel@mingming-laptop>
References: <4D6C6318.2010105@linux.vnet.ibm.com>
	 <02A57041-5FC1-419D-89D2-47D541616DD4@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Allison Henderson <achender@linux.vnet.ibm.com>,
	linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:54579 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757148Ab1CAXQS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 1 Mar 2011 18:16:18 -0500
Received: from d03relay05.boulder.ibm.com (d03relay05.boulder.ibm.com [9.17.195.107])
	by e35.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id p21N1UgS024863
	for <linux-ext4@vger.kernel.org>; Tue, 1 Mar 2011 16:01:30 -0700
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay05.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p21NGF9Y103370
	for <linux-ext4@vger.kernel.org>; Tue, 1 Mar 2011 16:16:15 -0700
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p21NGEHc007432
	for <linux-ext4@vger.kernel.org>; Tue, 1 Mar 2011 16:16:14 -0700
In-Reply-To: <02A57041-5FC1-419D-89D2-47D541616DD4@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 2011-02-28 at 23:42 -0700, Andreas Dilger wrote:
> On 2011-02-28, at 8:08 PM, Allison Henderson wrote:
> > This first patch adds a function to convert a range of blocks
> > to an uninitialized extent.  This function will
> > be used to first convert the blocks to extents before
> > punching them out.
> 
> This was proposed as a separate function for FALLOCATE by Dave Chinner (based on XFS_IOC_ZERO_RANGE), so this is useful as a standalone function.
> 
> > +/*
> > + * ext4_split_extents() Splits a given extent at the block "split"
> > + * @handle: The journal handle
> > + * @inode: The file inode
> > + * @split: The block where the extent will be split
> > + * @path: The path to the extent
> > + * @flags: flags used to insert the new extent
> > + */
> > +static int ext4_split_extents(handle_t *handle,
> > +					struct inode *inode,
> > +					ext4_lblk_t split,
> > +					struct ext4_ext_path *path,
> > +					int flags)
> 
> Isn't this already done when converting an uninitialized extent into a regular extent when it is being written to?  Hmm, ext4_ext_convert_to_initialized() is splitting the extent, but it is doing that "by hand".  It might make sense to convert ext4_ext_convert_to_initialized() to use this routine, but this depends on whether it makes the code simpler or not.
> 

Yes, the ext4_ext_convert_to_initialized() and
ext4_split_unwritten_extents() both does similar thing, split the
extents to prepare for filling unwritten extents...which is opposite
than punching holes.  these two functions should be merged/factor out
the same code first.

ext4_ext_convert_to_initialized() handles write to unwritten extents for
buffered IO case, which does the zerout optimization for filling holes
to small area handling(avoid frequent convert to initizatlized). And it
does the optimization to try to merge extents with neighbors if
possible. Those two are not needed for punch holes.

ext4_split_unwritten_extents() is more straightforward to reuse for
punch hole(no need for merge with neighbors, no need to zero out for
optimization) -- for punch hole, just opposite the logic in
ext4_split_unwritten_extents().


> > +	/* if the block is not actually in the extent, go to out */
> > +	if(split > ee_block+ee_len || split < ee_block)
> > +		goto out;
> 
> Is this actually needed?
> 
> > +	ext_debug("The new block is %llu, the orig block is: %llu\n", newblock, origblock);  
> 
> (style) please wrap lines at 80 columns.  This patch should be run through checkpatch.pl, which should catch issues like this.
> 
> > +	if(EXT_LAST_EXTENT(eh) >=  EXT_MAX_EXTENT(eh)){
> > +
> > +	/* otherwise just scoot all ther other extents down  */
> > +	else{
> > +		for(i_ex = EXT_LAST_EXTENT(eh); i_ex > ex1; i_ex-- ){
> > +			memcpy(i_ex+1, i_ex, sizeof(struct ext4_extent));
> > +		}
> > +		memcpy(ex1+1, ex2, sizeof(struct ext4_extent));
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
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


