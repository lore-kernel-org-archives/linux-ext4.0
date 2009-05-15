From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: More ext4 acl/xattr corruption - 4th occurence now
Date: Fri, 15 May 2009 10:28:27 +0530
Message-ID: <20090515045827.GB1279@skywalker>
References: <20090513062634.GE4972@kulgan> <20090514044011.GC11352@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Kevin Shanahan <kmshanah@ucwb.org.au>, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:52069 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751986AbZEOE6i (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 15 May 2009 00:58:38 -0400
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by e28smtp03.in.ibm.com (8.13.1/8.13.1) with ESMTP id n4F4warM027045
	for <linux-ext4@vger.kernel.org>; Fri, 15 May 2009 10:28:36 +0530
Received: from d28av05.in.ibm.com (d28av05.in.ibm.com [9.184.220.67])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n4F4waDA1192122
	for <linux-ext4@vger.kernel.org>; Fri, 15 May 2009 10:28:36 +0530
Received: from d28av05.in.ibm.com (loopback [127.0.0.1])
	by d28av05.in.ibm.com (8.13.1/8.13.3) with ESMTP id n4F4wZu6022892
	for <linux-ext4@vger.kernel.org>; Fri, 15 May 2009 14:58:36 +1000
Content-Disposition: inline
In-Reply-To: <20090514044011.GC11352@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, May 14, 2009 at 12:40:11AM -0400, Theodore Tso wrote:
> On Wed, May 13, 2009 at 03:56:34PM +0930, Kevin Shanahan wrote:
> > 
> > Now, this is (possibly) interesting - that block contains a bunch of
> > file data. Looks like a html email (I can tell it's email because of
> > the FIXED_ prefix added to the tags by the mail sanitizer).
> 
> That is interesting.  Knowing that it is file data means we might be
> able to track things down this way.
> 
> Are you able to apply the following patch to your kernel?  If so,
> hopefully we'll be able to catch whatever is causing the problem in
> the act.
> 
> 						- Ted
> 
> commit 8ff799da106e9fc4da9b2a3753b5b86caab27f13
> Author: Theodore Ts'o <tytso@mit.edu>
> Date:   Thu May 14 00:39:48 2009 -0400
> 
>     ext4: Add a block validity check to ext4_get_blocks_wrap()
>     
>     A few users with very large disks have been reporting low block number
>     filesystem corruptions, potentially zapping the block group
>     descriptors or inodes in the first inode table block.  It's not clear
>     what is causing this, but most recently, it appears that whatever is
>     trashing the filesystem metadata appears to be file data.  So let's
>     try to set a trap for the corruption in ext4_get_blocks_wrap(), which
>     is where logical blocks in an inode are mapped to physical blocks.


We already do block validation in allocator. In
ext4_mb_mark_diskspace_used we check whether the block allocator is
wrongly getting blocks from system zone. So  i guess we don't need this
patch. Or may be we need to remove the check in
ext4_mb_mark_diskspace_used and add the ckeck in get_block so that it
catches the extent cache corruption as found by this bug.

-aneesh



>     
>     Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 4e7f363..4fad4fa 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -1120,6 +1120,35 @@ static void ext4_da_update_reserve_space(struct inode *inode, int used)
>  		ext4_discard_preallocations(inode);
>  }
> 
> +static int check_block_validity(struct inode *inode, sector_t logical,
> +				sector_t phys, int len)
> +{
> +	ext4_fsblk_t valid_block, itable_block;
> +	struct ext4_super_block *es = EXT4_SB(inode->i_sb)->s_es;
> +	struct ext4_group_desc *gdp = ext4_get_group_desc(inode->i_sb, 0, 0);
> +	unsigned int itable_len = EXT4_SB(inode->i_sb)->s_itb_per_group;
> +
> +	valid_block = le32_to_cpu(es->s_first_data_block) +
> +		EXT4_SB(inode->i_sb)->s_gdb_count;
> +	itable_block = ext4_inode_table(inode->i_sb, gdp);
> +
> +	if (unlikely((phys <= valid_block) ||
> +		     ((phys + len - 1) > ext4_blocks_count(es)) ||
> +		     ((phys >= itable_block) &&
> +		      (phys <= itable_block + itable_len)) ||
> +		     ((phys + len - 1 >= itable_block) &&
> +		      (phys + len - 1 <= itable_block + itable_len)))) {
> +		ext4_error(inode->i_sb, "check_block_validity",
> +			   "inode #%lu logical block %llu mapped to %llu "
> +			   "(size %d)", inode->i_ino,
> +			   (unsigned long long) logical,
> +			   (unsigned long long) phys, len);
> +		WARN_ON(1);
> +		return -EIO;
> +	}
> +	return 0;
> +}
> +
>  /*
>   * The ext4_get_blocks_wrap() function try to look up the requested blocks,
>   * and returns if the blocks are already mapped.
> @@ -1165,6 +1194,13 @@ int ext4_get_blocks_wrap(handle_t *handle, struct inode *inode, sector_t block,
>  	}
>  	up_read((&EXT4_I(inode)->i_data_sem));
> 
> +	if (retval > 0 && buffer_mapped(bh)) {
> +		int ret = check_block_validity(inode, block, 
> +					       bh->b_blocknr, retval);
> +		if (ret != 0)
> +			return ret;
> +	}
> +
>  	/* If it is only a block(s) look up */
>  	if (!create)
>  		return retval;
> @@ -1241,6 +1277,12 @@ int ext4_get_blocks_wrap(handle_t *handle, struct inode *inode, sector_t block,
>  	}
> 
>  	up_write((&EXT4_I(inode)->i_data_sem));
> +	if (retval > 0 && buffer_mapped(bh)) {
> +		int ret = check_block_validity(inode, block, 
> +					       bh->b_blocknr, retval);
> +		if (ret != 0)
> +			return ret;
> +	}
>  	return retval;
>  }
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
