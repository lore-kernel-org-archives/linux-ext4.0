From: Kalpak Shah <kalpak@clusterfs.com>
Subject: Re: [PATCH] ext2/ext3/ext4: Add block bitmap validation
Date: Fri, 03 Aug 2007 13:14:11 +0530
Message-ID: <1186127051.3866.12.camel@garfield>
References: <11861250501999-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: cmm@us.ibm.com, linux-ext4@vger.kernel.org,
	Andreas Dilger <adilger@clusterfs.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:55717 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701AbXHCHmi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 3 Aug 2007 03:42:38 -0400
In-Reply-To: <11861250501999-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, 2007-08-03 at 12:40 +0530, Aneesh Kumar K.V wrote:
>  	desc = ext2_get_group_desc (sb, block_group, NULL);
>  	if (!desc)
> -		goto error_out;
> -	bh = sb_bread(sb, le32_to_cpu(desc->bg_block_bitmap));
> +		return NULL;
> +	bitmap_blk = le32_to_cpu(desc->bg_block_bitmap);
> +	bh = sb_bread(sb, bitmap_blk);
>  	if (!bh)
> -		ext2_error (sb, "read_block_bitmap",
> +		ext2_error (sb, __FUNCTION__,
>  			    "Cannot read block bitmap - "
>  			    "block_group = %d, block_bitmap = %u",
>  			    block_group, le32_to_cpu(desc->bg_block_bitmap));

bitmap_blk should be used here instead of
le32_to_cpu(desc->bg_block_bitmap). It reduces one endianness
conversion.

> -error_out:
> +
> +	/* check whether block bitmap block number is set */
> +	if (!block_in_use(bitmap_blk, sb, bh->b_data)) {
> +		/* bad block bitmap */
> +		goto error_out;
> +	}
> +	/* check whether the inode bitmap block number is set */
> +	bitmap_blk = le32_to_cpu(desc->bg_inode_bitmap);
> +	if (!block_in_use(bitmap_blk, sb, bh->b_data)) {
> +		/* bad block bitmap */
> +		goto error_out;
> +	}
> +	/* check whether the inode table block number is set */
> +	bitmap_blk = le32_to_cpu(desc->bg_inode_table);
> +	for (i = 0; i < EXT2_SB(sb)->s_itb_per_group; i++, bitmap_blk++) {
> +		if (!block_in_use(bitmap_blk, sb, bh->b_data)) {
> +			/* bad block bitmap */
> +			goto error_out;
> +		}
> +	}

Why not reduce a lot of this code by having:
int block_range_in_use(ext4_fsblk_t start_blk, ext4_fsblk_t num_blks,
struct super_block *sb, unsigned char *map)?

It will also help to do away with a lot of repetitive calculations in
block_in_use().

> +	ext3_error(sb, __FUNCTION__,
> +			"Invalid block bitmap - "
> +			"block_group = %d, block = %lu",
> +			block_group, bitmap_blk);

Please align this according to kernel coding style.

Thanks,
Kalpak.
