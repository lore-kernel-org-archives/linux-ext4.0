From: Andreas Dilger <adilger.kernel@dilger.ca>
Subject: Re: [PATCH] make ext4_valid_block_bitmap() more verbose
Date: Fri, 12 Nov 2010 16:56:04 -0700
Message-ID: <E2A9104D-764C-42AD-B479-51333960AF19@dilger.ca>
References: <201011130026.51268.bs_lists@aakef.fastmail.fm>
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-ext4@vger.kernel.org, Bernd Schubert <bschubert@ddn.com>
To: Bernd Schubert <bs_lists@aakef.fastmail.fm>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:14344 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933008Ab0KLX4G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 12 Nov 2010 18:56:06 -0500
In-Reply-To: <201011130026.51268.bs_lists@aakef.fastmail.fm>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2010-11-12, at 16:26, Bernd Schubert wrote:
> The real issue we want to debug with the patch below actually came up while 
> stress testing Lustre using the RHEL5.5 kernel (so 2.6.32'ish ext4), but a 
> more verbose error function should not hurt for vanilla ext4 either.
> 
> make ext4_valid_block_bitmap() more verbose
> 
> While running our stress test suite, ext4_valid_block_bitmap() 
> frequently complains about an invalid block bitmap.
> However, e2fsck does not find anything. So in oder to be able
> to better debug this issue, make the function more verbose and 
> let it complain about the two possible invalid bitmaps.

Bernd,
thanks for sending this in.  I like the idea of making these messages more verbose, since they should rarely be hit and when they are it would be good to know why these checks failed.

> +/**
> + * ext4_get_group_desc() -- load group descriptor from disk
> + * @sb:			super block
> + * @ext4_group_desc:	blocks group descriptor
> + * @block_group		block group to check
> + * @bh:			pointer to the buffer head to store the block
> + *			group descriptor
> + *
> + * return 0 on error or 1 if valid
> + */
> static int ext4_valid_block_bitmap(struct super_block *sb,
> 					struct ext4_group_desc *desc,
> 					unsigned int block_group,

The function name in the comment block does not actually match the function...

> @@ -254,16 +265,20 @@ static int ext4_valid_block_bitmap(struc
> +	if (!ext4_test_bit(offset, bh->b_data)) {
> +		ext4_warning(sb, "bad block bitmap block = %llu, offset = %d",
> +			     bitmap_blk, (int) offset);
> +		valid = 0;
> +	}
> 
> 	/* check whether the inode bitmap block number is set */
> 	bitmap_blk = ext4_inode_bitmap(sb, desc);
> 	offset = bitmap_blk - group_first_block;
> +	if (!ext4_test_bit(offset, bh->b_data)) {
> +		ext4_warning(sb, "bad inode bitmap block = %llu, offset = %d",
> +			     bitmap_blk, (int) offset);
> +		valid = 0;

This message (while correct) is a bit confusing, since it implies there is something wrong with the inode bitmap block itself, rather than the the bit in the block bitmap.  I think it would be clearer to rewrite this as follows:

        "unset bit for inode bitmap: block %llu, bit %u"

for consistency we should then change the block bitmap error to match.

While we are changing this code, all of the ext4_test_bit() checks should be wrapped in unlikely(), since we should very rarely be seeing these errors.

> @@ -271,14 +286,17 @@ static int ext4_valid_block_bitmap(struc
> +	if (next_zero_bit < offset + EXT4_SB(sb)->s_itb_per_group) {
> +		ext4_warning(sb, "bad inode table block = %llu, offset = %d",
> +			     bitmap_blk, (int) offset);
> +		valid = 0;

Similarly, this implies that there is a bad inode table block, so I prefer:

        "unset bit for inode table block %u: block %llu, bit %u"

where the "inode table block" value is, I think, (next_zero_bit - offset)

> +	if (!valid)
> +		ext4_error(sb, "Invalid block bitmap - block_group = %d",
> +			   block_group);

It would probably be worthwhile to also print the block number of the bitmap itself.

Cheers, Andreas





