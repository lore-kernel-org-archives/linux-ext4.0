From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH, RFC] ext4: New inode/block allocation algorithms for
	flex_bg filesystems
Date: Tue, 24 Feb 2009 10:27:34 -0500
Message-ID: <20090224152734.GD5482@mit.edu>
References: <20090218154310.GH3600@mini-me.lan> <20090224085931.GA25657@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:41289 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752642AbZBXP1o (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 Feb 2009 10:27:44 -0500
Content-Disposition: inline
In-Reply-To: <20090224085931.GA25657@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Feb 24, 2009 at 02:29:31PM +0530, Aneesh Kumar K.V wrote:
> >  	/* OK. use inode's group */
> > -	bg_start = (ei->i_block_group * EXT4_BLOCKS_PER_GROUP(inode->i_sb)) +
> > +	block_group = ei->i_block_group;
> > +	if (flex_size >= 4) {
> > +		block_group &= ~(flex_size-1);
> > +		if (S_ISREG(inode->i_mode))
> > +			block_group++;
> > +	}
> 
> 
> Can you explain why we select 4 here ?
> 
> Also add a comment explaining directory/symlink block allocation goes to
> first group of flex_bg and regular files goes to second group and which
> type of workload that would help ? You have the comment in commit message. 

Yeah, I'll add a comment there.

> > +	/* 
> > +	 * If we are doing delayed allocation, we don't need take
> > +	 * colour into account.
> > +	 */
> > +	if (test_opt(inode->i_sb, DELALLOC))
> > +		return bg_start;
> > +
> 
> Again why we don't want to look at colour for delayed allocation ?

If we're doing delayed allocation, we'll be allocating data blocks in
large chunks at a time.  Colour is much more important if you have
multiple processes allocating singleton blocks at a time, so you don't
get interleved allocation (i.e, ABABAB or ABCABBCABC).  But if we're
grabbing chunks of blocks at a time, the benefits largely go away, and
in fact, artificially starting at different location depending on the
process id can actually lead to a greater fragmentation of the free
space.

> >  /*
> > + * Helper function for Orlov's allocator; returns critical information 
> > + * for a particular block group or flex_bg
> > + */
> > +struct orlov_stats {
> > +	__u32 free_inodes;
> > +	__u32 free_blocks;
> > +	__u32 used_dirs;  
> > +};
> > +
> > +void get_orlov_stats(struct super_block *sb, ext4_group_t g, 
> > +		       int flex_size, struct orlov_stats *stats)
> > +{
		...
> > +	g *= flex_size;
> 
> Can you add a comment to the function saying g can be flex group number
> or the actual group number depending on flex_size ?. Without that
> comment the above operation can be confusing.

Sure.

> > +/*
> >   * Orlov's allocator for directories.
> >   *
> 
> You can also remove further description about debt and INODE_COST and
> BLOCK_COST
> 

Yep, good point.


> > +	found_flex_bg:
> > +		if (flex_size == 1) {
> > +			*group = grp;
> > +			return 0;
> > +		}
> > +
> > +		grp *= flex_size;
> > +		for (i = 1; i < flex_size; i++) {
> 
> Why we start  with i = 1 ?
> 

I was putting directories in the second bg of flexgroups; thinking
about it some more, there's really no good reason to do that.  I'll
change that back to be one.

> Can you add a comment saying that we just pick the first group with
> free inode because the goal block for rest of the block allocation
> of the file/directory looks at the flex block group number with
> flex_bg. (more details on ext4_ext_find_goal)

I'll do that.

> > +	/*
> > +	 * If we are doing flex_bg style allocation, try to put
> > +	 * special inodes in the first block group; start files and
> > +	 * directories at the 2nd block group in the flex_bg.
> > +	 */
> 
> Why ? Can you explain whether this placing helps any specific work load
> ? or something where you have observed that this placement helps ?  

This was left over from when I was using the inode number to influence
block allocation.  We're not doing this any more, so this should go
away.   Thanks for asking the question.

							- Ted
