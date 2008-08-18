From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [Bugme-new] [Bug 11266] New: unable to handle kernel paging
	request in ext2_free_blocks
Date: Mon, 18 Aug 2008 22:21:31 +0530
Message-ID: <20080818165131.GC6491@skywalker>
References: <bug-11266-10286@http.bugzilla.kernel.org/> <0K5800031SEDU2@smtp02.hut-mail> <20080807200717.GB26307@lh.kyla.fi> <20080807202840.GC26307@lh.kyla.fi> <20080818145841.GC10621@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Sami Liedes <sliedes@cc.hut.fi>,
	Andrew Morton <akpm@linux-foundation.org>,
	bugme-daemon@bugzilla.kernel.org, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:48941 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753279AbYHRQvq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 18 Aug 2008 12:51:46 -0400
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp06.au.ibm.com (8.13.1/8.13.1) with ESMTP id m7IGp0TQ031415
	for <linux-ext4@vger.kernel.org>; Tue, 19 Aug 2008 02:51:00 +1000
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7IGphpE3936334
	for <linux-ext4@vger.kernel.org>; Tue, 19 Aug 2008 02:51:44 +1000
Received: from d23av01.au.ibm.com (loopback [127.0.0.1])
	by d23av01.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m7IGphqB007555
	for <linux-ext4@vger.kernel.org>; Tue, 19 Aug 2008 02:51:43 +1000
Content-Disposition: inline
In-Reply-To: <20080818145841.GC10621@atrey.karlin.mff.cuni.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Aug 18, 2008 at 04:58:41PM +0200, Jan Kara wrote:
> 
> From 06953717138efe3ad535e78343beb7204ac0d274 Mon Sep 17 00:00:00 2001
> From: Jan Kara <jack@suse.cz>
> Date: Mon, 18 Aug 2008 16:45:11 +0200
> Subject: [PATCH] ext2: Check for corrupted group descriptor before using data in it
> 
> We have to check whether a group descriptor isn't corrupted in
> read_block_bitmap(). Otherwise ext2_valid_block_bitmap() will try
> to access bits outside of bitmap and Oops happens.
> 
> CC: Vegard Nossum <vegard.nossum@gmail.com>
> CC: Sami Liedes <sliedes@cc.hut.fi>
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/ext2/balloc.c |   29 +++++++++++++++++++++++++++++
>  1 files changed, 29 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/ext2/balloc.c b/fs/ext2/balloc.c
> index 10bb02c..9104712 100644
> --- a/fs/ext2/balloc.c
> +++ b/fs/ext2/balloc.c
> @@ -113,6 +113,17 @@ err_out:
>  	return 0;
>  }
> 
> +static int ext2_block_in_group(struct super_block *sb,
> +			unsigned int block_group, ext2_fsblk_t block)
> +{
> +	if (block < ext2_group_first_block_no(sb, block_group))
> +		return 0;
> +	if (block >= ext2_group_first_block_no(sb, block_group) +
> +	    EXT2_BLOCKS_PER_GROUP(sb))
> +		return 0;
> +	return 1;
> +}
> +
>  /*
>   * Read the bitmap for a given block_group,and validate the
>   * bits for block/inode/inode tables are set in the bitmaps
> @@ -129,6 +140,24 @@ read_block_bitmap(struct super_block *sb, unsigned int block_group)
>  	desc = ext2_get_group_desc(sb, block_group, NULL);
>  	if (!desc)
>  		return NULL;
> +	if (!ext2_block_in_group(sb, block_group,
> +				le32_to_cpu(desc->bg_block_bitmap)) ||
> +	    !ext2_block_in_group(sb, block_group,
> +				le32_to_cpu(desc->bg_inode_bitmap)) ||
> +	    !ext2_block_in_group(sb, block_group,
> +				le32_to_cpu(desc->bg_inode_table)) ||
> +	    !ext2_block_in_group(sb, block_group,
> +				le32_to_cpu(desc->bg_inode_table) +
> +				EXT2_SB(sb)->s_itb_per_group - 1)) {
> +		ext2_error(sb, __func__, "Corrupted group descriptor - "
> +				"block_group = %u, block_bitmap = %u, "
> +				"inode_bitmap = %u, inode_table = %u",
> +				block_group,
> +				le32_to_cpu(desc->bg_block_bitmap),
> +				le32_to_cpu(desc->bg_inode_bitmap),
> +				le32_to_cpu(desc->bg_inode_table));
> +		return NULL;
> +	}
>  	bitmap_blk = le32_to_cpu(desc->bg_block_bitmap);
>  	bh = sb_getblk(sb, bitmap_blk);
>  	if (unlikely(!bh)) {

Do we need to do this validation every time we do a read_block_bitmap ?
I guess we need to move the validation where we read the desc blocks
from the disk.

-aneesh
