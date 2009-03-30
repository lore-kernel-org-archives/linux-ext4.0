From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH v2] ext4: add checks of block references for non-extent
	inodes
Date: Mon, 30 Mar 2009 16:13:20 +0530
Message-ID: <20090330104320.GD4796@skywalker>
References: <49B94396.2020800@ph.tum.de> <49C3A51C.1030201@ph.tum.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Thiemo Nagel <thiemo.nagel@ph.tum.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:57492 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155AbZC3Knc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 30 Mar 2009 06:43:32 -0400
Received: from d23relay01.au.ibm.com (d23relay01.au.ibm.com [202.81.31.243])
	by e23smtp03.au.ibm.com (8.13.1/8.13.1) with ESMTP id n2UAfh1e032057
	for <linux-ext4@vger.kernel.org>; Mon, 30 Mar 2009 21:41:43 +1100
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by d23relay01.au.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n2UAhUBJ487494
	for <linux-ext4@vger.kernel.org>; Mon, 30 Mar 2009 21:43:30 +1100
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n2UAhTLD029007
	for <linux-ext4@vger.kernel.org>; Mon, 30 Mar 2009 21:43:29 +1100
Content-Disposition: inline
In-Reply-To: <49C3A51C.1030201@ph.tum.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Mar 20, 2009 at 03:15:56PM +0100, Thiemo Nagel wrote:
> Dear Ted,
>
> I'm sending an improved patch as I've come to the conclusion that the  
> previous patch is too lenient in two ways:
> * off-by-one in the check of the upper block limit
> * it shouldn't stop when encountering a reference to block number zero  
> because, if I'm not mistaken, references behind it still might be  
> accessed in sparse files / when seeking behind the end of a file.
>
> On the other hand, I decided to drop the check against  
> s_first_data_block at the low end to improve performance, since the  
> purpose of the patch is to prevent access to blocks outside the  
> filesystem, and not to do the best-possible consistency check against  
> indirect blocks, which probably is better done in fsck.
>
> Anyways, in case you would be interested in having more checks here (eg.  
> as a compile-time option), I have available a more sophisticated patch  
> which also checks for non-zero block references behind the end of the 
> file.
>
> Kind regards,
>
> Signed-off-by: Thiemo Nagel <thiemo.nagel@ph.tum.de>
>
>

> --- linux-2.6.29-rc7/fs/ext4/inode.c.orig	2009-03-20 11:35:45.000000000 +0100
> +++ linux-2.6.29-rc7/fs/ext4/inode.c	2009-03-20 13:48:25.000000000 +0100
> @@ -371,6 +371,34 @@
>  	return n;
>  }
> 
> +static int __ext4_check_blockref(const char *function, struct inode *inode,
> +				 unsigned int *p, unsigned int max) {
> +
> +	unsigned int maxblocks = ext4_blocks_count(EXT4_SB(inode->i_sb)->s_es);
> +	unsigned int *bref = p;
> +	while (bref < p+max) {
> +		if (unlikely(*bref >= maxblocks)) {
> +			ext4_error(inode->i_sb, function,
> +				   "block reference %u >= max (%u) "
> +				   "in inode #%lu, offset=%u",
> +				   *bref, maxblocks,
> +				   inode->i_ino, bref-p);
> + 			return -EIO;
> + 		}
> +		bref++;
> + 	}
> + 	return 0;
> +}
> +
> +
> +#define ext4_check_indirect_blockref(inode, bh)                         \
> +        __ext4_check_blockref(__func__, inode, (__le32 *)(bh)->b_data,  \
> +			      EXT4_ADDR_PER_BLOCK((inode)->i_sb))
> +
> +#define ext4_check_inode_blockref(inode)                                \
> +        __ext4_check_blockref(__func__, inode, EXT4_I(inode)->i_data,   \
> +			      EXT4_NDIR_BLOCKS)
> +
>  /**
>   *	ext4_get_branch - read the chain of indirect blocks leading to data
>   *	@inode: inode in question
> @@ -418,6 +446,9 @@
>  		bh = sb_bread(sb, le32_to_cpu(p->key));
>  		if (!bh)
>  			goto failure;
> +		if (ext4_check_indirect_blockref(inode, bh))
> +			goto failure;
> +                  


Since on errors=continue we are not adding the bh to the chain. We leak
a buffer_head reference here. I guess we need a put_bh before goto
failure.



-aneesh
