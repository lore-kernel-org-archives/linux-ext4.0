From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH v3]Ext4: journal credits reservation fixes for DIO,
	fallocate and delalloc writepages
Date: Wed, 30 Jul 2008 05:36:23 -0600
Message-ID: <20080730113623.GW3342@webber.adilger.int>
References: <48841077.500@cse.unsw.edu.au> <20080721082010.GC8788@skywalker>
 <1216774311.6505.4.camel@mingming-laptop> <20080723074226.GA15091@skywalker>
 <1217032947.6394.2.camel@mingming-laptop>
 <1217383118.27664.14.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: tytso <tytso@mit.edu>, Shehjar Tikoo <shehjart@cse.unsw.edu.au>,
	linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:57487 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812AbYG3Lg0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 30 Jul 2008 07:36:26 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m6UBaPa6029687
	for <linux-ext4@vger.kernel.org>; Wed, 30 Jul 2008 04:36:25 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K4T00I01HGFYM00@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Wed, 30 Jul 2008 04:36:25 -0700 (PDT)
In-reply-to: <1217383118.27664.14.camel@mingming-laptop>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jul 29, 2008  18:58 -0700, Mingming Cao wrote:
> + * For inserting a single extent, in the worse case extent tree depth is 5
> + * for old tree and new tree, for every level we need to reserve
> + * credits to log the bitmap and block group descriptors
> + *
> + * credit needed for the update of super block + inode block + quota files
> + * are not included here. The caller of this function need to take care of this.
>   */
> -int ext4_ext_calc_credits_for_insert(struct inode *inode,
> +int ext4_ext_calc_credits_for_single_extent(struct inode *inode,
>  						struct ext4_ext_path *path)
>  {
>  	int depth, needed;
>  
> +	depth = ext_depth(inode);
> +
>  	if (path) {
>  		/* probably there is space in leaf? */
>  		if (le16_to_cpu(path[depth].p_hdr->eh_entries)
>  				< le16_to_cpu(path[depth].p_hdr->eh_max))

Please fix code style here - '<' at end of previous line, align with "if (".

> +			/* 1 for block bitmap, 1 for group descriptor */
> +			return 2;
>  	}
>  
> +	/* add one more level in case of tree increase when insert a extent */
> +	depth += 1;

Shouldn't this only be if depth < 5?

>	/*
>	 * tree can be full, so it would need to grow in depth:
>	 * we need one credit to modify old root, credits for
>	 * new root will be added in split accounting
>	 */
>	needed += 1;

Similarly, this should only be if depth < 5?  We should have a

/*
 * given 32-bit logical block (4294967296 blocks), max. tree
 * can be 4 levels in depth -- 4 * 340^4 == 53453440000.
 * Let's also add one more level for imbalance.
 */
#define EXT4_EXT_MAX_DEPTH 5

>	/*
>	 * Index split can happen, we would need:
>	 *    allocate intermediate indexes (bitmap + group)
>	 *  + change two blocks at each level, but root (already included)
>  	 */
>  	needed += (depth * 2) + (depth * 2);

Again, this can only happen if < EXT4_EXT_MAX_DEPTH.

> +int  ext4_ext_writeblocks_trans_credits(struct inode *inode, int nrblocks)

please remove duplicate space after "int"

>  {
>  	int needed;
>  
> +	/* cost of adding a single extent:
> +	 * index blocks, leafs, bitmaps,
> +	 * groupdescp
> +	 */
> +	needed = ext4_ext_calc_credits_for_single_extent(inode, NULL);
> +	/*
> +	 * For data=journalled mode need to account for the data blocks
> +	 * Also need to add super block and inode block
> +	 */
> +	if (ext4_should_journal_data(inode))
> +		needed = nrblocks * (needed + 1)  + 2;
> +	else
> +		needed = nrblocks * needed  + 2;

It is also hard to understand why we need "nrblocks" times a single extent
insert.  That would assume we need a full tree split on EVERY block
inserted, which I don't think is reasonable.  Have you printed out some
of these values to see how large they actually are?

Instead, we shouldn't have ext4_ext_calc_credits_for_single_extent()
at all, and instead pass in the nrblocks parameter and work it out
on this basis.  That means at most nrblocks/340 extents/bitmaps/groups
at one time, plus at most 4 more levels of split in worst case.  We
don't need 4 * nrblocks for each write.

> @@ -2202,10 +2181,31 @@ static int ext4_da_writepages(struct add
> +		/*
> +		 * Estimate the worse case needed credits to write out
> +		 * to_write pages
> +		 */
> +		needed_blocks = ext4_writepages_trans_blocks(inode,
> +							     wbc->nr_to_write);
> +		while (needed_blocks > max_credit_blocks) {
> +			wbc->nr_to_write --;
> +			needed_blocks = ext4_writepages_trans_blocks(inode,
> +							     wbc->nr_to_write);
> +		}

This isn't a very efficient loop to decrement nr_to_write by one each time.
It is best to pass multiples of the RAID stripe size to mballoc to avoid
extra overhead.  I'd check something like below:

		needed_blocks = ~0U;

		while (needed_blocks > max_credit_blocks) {
			needed_blocks = ext4_writepages_trans_blocks(inode,
							     wbc->nr_to_write);
			/* We are more than twice the max_credit_blocks */
			if (needed_blocks + max_credit_blocks / 2 >
			    2 * max_credit_blocks)
				wbc->nr_to_write /= 2;
			else
				wbc->nr_to_write -=
					(needed_blocks-max_credit_blocks+3) / 4;

> +static inline int ext4_journal_max_transaction_buffers(struct inode *inode)
> +{
> +	/*
> +	 * max transaction buffers
> + 	 * calculation based on
> + 	 * journal->j_max_transaction_buffers = journal->j_maxlen / 4;
> + 	 */
> +        return (EXT4_JOURNAL(inode))->j_maxlen / 4;

Why does this not use "j_max_transaction_buffers" directly?  That is what
start_this_handle() checks against.  Also, this function should probably
be in fs/jbd2 instead of in fs/ext4.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

