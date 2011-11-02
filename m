From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 1/8 bigalloc] ext4: get blocks from ext4_ext_get_actual_len
Date: Wed, 2 Nov 2011 12:29:12 -0600
Message-ID: <3CF57267-8DFB-4AFE-94AA-48036AC80C19@dilger.ca>
References: <1320144817-16397-1-git-send-email-hao.bigrat@gmail.com> <1320144817-16397-2-git-send-email-hao.bigrat@gmail.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-ext4@vger.kernel.org, Robin Dong <sanbai@taobao.com>
To: Robin Dong <hao.bigrat@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:11623 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754731Ab1KBS2r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 2 Nov 2011 14:28:47 -0400
In-Reply-To: <1320144817-16397-2-git-send-email-hao.bigrat@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-11-01, at 4:53 AM, Robin Dong wrote:
> From: Robin Dong <sanbai@taobao.com>
> 
> Since ee_len's unit change to cluster, it need to transform from clusters
> to blocks when use ext4_ext_get_actual_len.

Robin,
thanks for working on and submitting these patches so quickly.

> struct ext4_extent {
> 	__le32	ee_block;	/* first logical block extent covers */
> -	__le16	ee_len;		/* number of blocks covered by extent */
> +	__le16	ee_len;		/* number of clusters covered by extent */

It would make sense that ee_block should also be changed to be measured
in units of clusters instead of blocks, since there is no value to
using extents with cluster size if they are not also cluster aligned.

I think this would also simplify some of the code.

> static int ext4_valid_extent(struct inode *inode, struct ext4_extent *ext)
> {
> +	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);

Why allocate "*sbi" on the stack in all of these functions for a
single use?  This provides no benefit, but can increase the stack
usage considerably due to repeated allocations.

> 	ext4_fsblk_t block = ext4_ext_pblock(ext);
> +	int len = EXT4_C2B(sbi, ext4_ext_get_actual_len(ext));

It probably makes more sense to pass "sb" or "sbi" as a parameter to 
ext4_ext_get_actual_len() and then have it return the proper length
in blocks (i.e. call EXT4_C2B() internally), which will simplify all
of the callers and avoid potential bugs if some code does not use it.

> @@ -1523,7 +1534,7 @@ ext4_can_extents_be_merged(struct inode *inode, struct ext4_extent *ex1,
> 	ext1_ee_len = ext4_ext_get_actual_len(ex1);
> 	ext2_ee_len = ext4_ext_get_actual_len(ex2);
> 
> -	if (le32_to_cpu(ex1->ee_block) + ext1_ee_len !=
> +	if (le32_to_cpu(ex1->ee_block) + EXT4_C2B(sbi, ext1_ee_len) !=
> 			le32_to_cpu(ex2->ee_block))

If both ee_len and ee_block are in the same units (blocks or clusters),
then there is no need to convert units for this function at all.


Cheers, Andreas





