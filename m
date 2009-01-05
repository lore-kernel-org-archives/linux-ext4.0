From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fix null pointer deref on mount
Date: Mon, 5 Jan 2009 18:44:11 -0500
Message-ID: <20090105234411.GD14500@mit.edu>
References: <4961603B.5020505@ph.tum.de> <20090105170259.GB8939@mit.edu> <49627285.8060407@ph.tum.de> <20090105213938.GG8939@mit.edu> <49628EBF.2040805@ph.tum.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Thiemo Nagel <thiemo.nagel@ph.tum.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:49622 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750772AbZAEXoO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 5 Jan 2009 18:44:14 -0500
Content-Disposition: inline
In-Reply-To: <49628EBF.2040805@ph.tum.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> @@ -2145,9 +2145,11 @@
>  	if (EXT4_BLOCKS_PER_GROUP(sb) == 0)
>  		goto cantfind_ext4;
>  
> -	/* ensure blocks_count calculation below doesn't sign-extend */
> -	if (ext4_blocks_count(es) + EXT4_BLOCKS_PER_GROUP(sb) <
> -	    le32_to_cpu(es->s_first_data_block) + 1) {
> +	/*
> +	 * ensure blocks_count calculation below doesn't sign-extend
> +	 * and after do_div() still blocks_count > 0
> +	 */
> +	if (ext4_blocks_count(es) < le32_to_cpu(es->s_first_data_block) + 1) {
>  		printk(KERN_WARNING "EXT4-fs: bad geometry: block count %llu, "
>  		       "first data block %u, blocks per group %lu\n",
>  			ext4_blocks_count(es),

I'd rewrite the test as:

	/*
	 * It makes no sense for the first data block to be beyond the end
	 * of the filesystem.
	 */
	if (le32_to_cpu(es->s_first_data_block) >= ext4_blocks_count(es)) {
  		printk(KERN_WARNING "EXT4-fs: bad geometry: first data"
			"block %u is beyond end of filesystem(%llu)\n",
			le32_to_cpu(es->s_first_data_block),
			ext4_blocks_count(es));
		...

There's no point printing the blocks per group if it's no longer in
the test, and having the comment talk about the physical meaning of
the superblock rather some esoteric explanation about sign extension
and do_div() is much more understable.

> @@ -2160,6 +2162,15 @@
>  			EXT4_BLOCKS_PER_GROUP(sb) - 1);
>  	do_div(blocks_count, EXT4_BLOCKS_PER_GROUP(sb));
>  	sbi->s_groups_count = blocks_count;
> +	if (sbi->s_groups_count > ((uint64_t)1<<32) - EXT4_DESC_PER_BLOCK(sb)) {

This can't possibly work, given that s_groups_count is an unsigned
int.  Even if were unsigned long, it wouldn't have worked on an x86_32
machine, since unsigned long is 32 bits on an x86_32.  See why it's
BadBadBad to use unsigned long?  It means that people running on
x86_64 machines can get deluded into thinking that code will work,
when in fact it won't work everywhere.

The blocks_count variable *is* an __u64, so simply using blocks_count
in the test would fix this problem.

						- Ted
