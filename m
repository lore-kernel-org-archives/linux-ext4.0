From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/6 ]Ext4 credits caclulation cleanup and fix that for
	nonextent writepage
Date: Wed, 13 Aug 2008 14:01:32 +0530
Message-ID: <20080813083132.GA6439@skywalker>
References: <48841077.500@cse.unsw.edu.au> <20080721082010.GC8788@skywalker> <1216774311.6505.4.camel@mingming-laptop> <20080723074226.GA15091@skywalker> <1217032947.6394.2.camel@mingming-laptop> <1218558190.6766.37.camel@mingming-laptop> <1218558354.6766.40.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	Andreas Dilger <adilger@sun.com>
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:51074 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755278AbYHMIhA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 13 Aug 2008 04:37:00 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp03.au.ibm.com (8.13.1/8.13.1) with ESMTP id m7D8ZppJ015048
	for <linux-ext4@vger.kernel.org>; Wed, 13 Aug 2008 18:35:51 +1000
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7D8VtWE159426
	for <linux-ext4@vger.kernel.org>; Wed, 13 Aug 2008 18:31:55 +1000
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m7D8VtNQ022294
	for <linux-ext4@vger.kernel.org>; Wed, 13 Aug 2008 18:31:55 +1000
Content-Disposition: inline
In-Reply-To: <1218558354.6766.40.camel@mingming-laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Aug 12, 2008 at 09:25:54AM -0700, Mingming Cao wrote:

....


> - * and dindirect block, and the "5" above becomes "3".
> + * Also account for superblock, inode, quota and xattr blocks
> + */
> +int ext4_meta_trans_blocks(struct inode* inode, int nrblocks, int idxblocks)
> +{
> +	int groups, gdpblocks;
> +	int ret = 0;
> +
> +	groups = nrblocks + idxblocks;
> +	gdpblocks = groups;
> +	if (groups > EXT4_SB(inode->i_sb)->s_groups_count)
> +		groups = EXT4_SB(inode->i_sb)->s_groups_count;
> +	if (groups > EXT4_SB(inode->i_sb)->s_gdb_count)
> +		gdpblocks = EXT4_SB(inode->i_sb)->s_gdb_count;
> +
> +	/* bitmaps and block group descriptor blocks */
> +	ret += groups + gdpblocks;


	ret = groups + gdpblocks;

> +
> +	ret += idxblocks;
> +
> +	/* journalled mode, include buffer to modify data blocks */
> +	if (ext4_should_journal_data(inode))
> +		ret += nrblocks;
> +
> +	/* Blocks for super block, inode, quota and xattr blocks */
> +	ret += EXT4_META_TRANS_BLOCKS(inode->i_sb);
> +
> +	return ret;
> +}
> +
> +static int ext4_indirect_trans_blocks(struct inode *inode, int nrblocks,
> +				      int chunk)
> +{

.....
.....

> 
> +/*
> + * Define the number of metadata blocks we need to account to modify data.
> + *
> + * This include super block, inode block, quota blocks and xattr blocks
> + */
> +#define EXT4_META_TRANS_BLOCKS(sb)	(EXT4_XATTR_TRANS_BLOCKS + \
> +					2*EXT4_QUOTA_TRANS_BLOCKS(sb))
> +

Do EXT4_XATTR_TRANS_BLOCKS blocks really account for super block
and inode block ? Looking at EXT4_DATA_TRANS_BLOCKS which also use
EXT4_XATTR_TRANS_BLOCKS I think it doesn't. But the comment above
EXT4_XATTR_TRANS_BLOCKS is confusing. I guess we would need a +2 here.



-aneesh
