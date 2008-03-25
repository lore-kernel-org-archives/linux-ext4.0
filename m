From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH] ext3: Return EIO if new block is allocated from system
	zone.
Date: Tue, 25 Mar 2008 14:59:22 -0600
Message-ID: <20080325205922.GT2691@webber.adilger.int>
References: <1206378298-10341-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <20080324223251.GL2691@webber.adilger.int> <20080325110311.GA7151@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: cmm@us.ibm.com, akpm@linux-foundation.org,
	linux-ext4@vger.kernel.org, Mingming Cao <cmm@us.vnet.ibm.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:51691 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754261AbYCYU7r (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 25 Mar 2008 16:59:47 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m2PKxkmp016432
	for <linux-ext4@vger.kernel.org>; Tue, 25 Mar 2008 13:59:47 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0JYB003010HJF100@fe-sfbay-10.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Tue, 25 Mar 2008 13:59:46 -0700 (PDT)
In-reply-to: <20080325110311.GA7151@skywalker>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mar 25, 2008  16:33 +0530, Aneesh Kumar K.V wrote:
> On Mon, Mar 24, 2008 at 04:32:51PM -0600, Andreas Dilger wrote:
> > I think the problem here is that this "goto" is simply an in-effective
> > method of error handling.  The block HAS to be marked in-use in the
> > bitmap, or it will just continue to try and be allocated.  After marking
> > the block in-use there should be a "goto retry-alloc" instead of error.
> > To be honest, I thought in 2.6 this would invoke the block bitmap checking
> > code to revalidate the whole bitmap at this point and then retry the alloc.
> > 
> > In 2.4 this similar code looks like:
> > 
> >         if (tmp == le32_to_cpu(gdp->bg_block_bitmap) ||
> >             tmp == le32_to_cpu(gdp->bg_inode_bitmap) ||
> >             in_range (tmp, le32_to_cpu(gdp->bg_inode_table),
> >                       EXT3_SB(sb)->s_itb_per_group)) {
> >                 ext3_error(sb, __FUNCTION__,
> >                            "Allocating block in system zone - block = %u", tmp);
> > 
> >                 /* Note: This will potentially use up one of the handle's
> >                  * buffer credits.  Normally we have way too many credits,
> >                  * so that is OK.  In _very_ rare cases it might not be OK.
> >                  * We will trigger an assertion if we run out of credits,
> >                  * and we will have to do a full fsck of the filesystem -
> >                  * better than randomly corrupting filesystem metadata.
> >                  */
> >                 ext3_set_bit(j, bh->b_data);
> >                 goto repeat;
> >         }
> > 
> > 
> 
> How about this. Patch is not complete, we leak some of the blocks here.
> 
> diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
> index 6d30af2..a9f27c7 100644
> --- a/fs/ext4/balloc.c
> +++ b/fs/ext4/balloc.c
> @@ -289,11 +289,11 @@ read_block_bitmap(struct super_block *sb, ext4_group_t block_group)
>  			    (int)block_group, (unsigned long long)bitmap_blk);
>  		return NULL;
>  	}
> -	if (!ext4_valid_block_bitmap(sb, desc, block_group, bh)) {
> -		put_bh(bh);
> -		return NULL;
> -	}
> -
> +	ext4_valid_block_bitmap(sb, desc, block_group, bh);
> +	/*
> +	 * file system mounted to not panic on error.
> +	 * continue with corrput bitmap
> +	 */
>  	return bh;
>  }

Part of the problem here is that ext4_valid_block_bitmap() only reports if
the bitmap is good or bad.  It doesn't actually try to fix the problems it
finds.  Instead of changing read_block_bitmap() to return an invalid bitmap
to the caller on error, it makes more sense to keep this code as-is and
change ext4_new_blocks_old() to change the bg_free_blocks_count = 0 for
this group and then continue to find a different group to allocate in:

        if (free_blocks > 0) {
                 bitmap_bh = read_block_bitmap(sb, group_no);
                 if (bitmap_bh != NULL) {
			 grp_alloc_blk =
				ext4_try_to_allocate_with_rsv(sb, handle,
							      group_no,
							      bitmap_bh,
							      grp_target_blk,
							      my_rsv, &num,
							      &fatal);
			 if (fatal)
				 goto out;
			 if (grp_alloc_blk >= 0)
				 goto allocated;
		} else {
			/* on error skip this group in future allocations */
			ext4_journal_get_write_access(handle, gdp_bh);
			gdp->bg_free_blocks_count = 0;
			ext4_journal_dirty_metadata(handle, gdp_bh);
		}
         }

> @@ -1779,7 +1779,12 @@ allocated:
>  			    "Allocating block in system zone - "
>  			    "blocks from %llu, length %lu",
>  			     ret_block, num);
> -		goto io_error;
> +		/*
> +		 * claim_block marked the buffer we allocated
> +		 * as in use. So we may want to selectively
> +		 * mark some of the blocks as free
> +		 */
> +		goto retry_alloc;

However, the above is only half of the story (though the most important
half).  If the bitmap has been loaded into memory read_block_bitmap()
will not check the validity of the bitmap anymore.  What 2.4 did here is
actually mark the system zone bits in use and continue on.  We could either
do that directly, or have a flag to ext4_valid_block_bitmap() to tell it
to set the bits, or just skip the group entirely.

Probably skipping the group entirely is safest and easiest because who
knows what else is wrong with the bitmap, and this is what is done
above (set bg_free_blocks_count = 0, write it to disk and the ext4_error()
call will have already marked the filesystem as needing a check.


Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

