From: Andreas Dilger <adilger@sun.com>
Subject: Re: [RFC PATCH 04/17] Implement 64-bit "bitarray" bmap ops
Date: Wed, 12 Nov 2008 13:47:56 -0700
Message-ID: <20081112204756.GO16005@webber.adilger.int>
References: <1226461390-5502-1-git-send-email-vaurora@redhat.com>
 <1226461390-5502-2-git-send-email-vaurora@redhat.com>
 <1226461390-5502-3-git-send-email-vaurora@redhat.com>
 <1226461390-5502-4-git-send-email-vaurora@redhat.com>
 <1226461390-5502-5-git-send-email-vaurora@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org
To: Valerie Aurora Henson <vaurora@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:57732 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753720AbYKLUsA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 12 Nov 2008 15:48:00 -0500
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id mACKlwUU009696
	for <linux-ext4@vger.kernel.org>; Wed, 12 Nov 2008 12:47:59 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0KA800L01MX11R00@fe-sfbay-10.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Wed, 12 Nov 2008 12:47:58 -0800 (PST)
In-reply-to: <1226461390-5502-5-git-send-email-vaurora@redhat.com>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Nov 11, 2008  19:42 -0800, Valerie Aurora Henson wrote:
> +/*
> + * Private data for bit array implementation of bitmap ops.
> + * Currently, this is just a pointer to our big flat hunk of memory,
> + * exactly equivalent to the old-skool char * bitmap member.
> + */
> +
> +struct ext2fs_ba_private_struct {
> +	char *bitarray;
> +};

Since we're going to the expense of allocating a 1-pointer data structure,
we may as well make it useful by adding a magic value in there that can
be verified later and catch code bugs or corruption.

> +static errcode_t ba_new_bmap(ext2_filsys fs, ext2fs_generic_bitmap64 bitmap)
>  {
> +	bp = (ext2fs_ba_private) bitmap->private;

Then use a simple accessor function ba_private_to_bitarray() to verify the
pointer magic and return the bitarray pointer directly.  That would remove
the direct use of "ext2fs_ba_private" in the majority of the code.
 
>  static errcode_t ba_copy_bmap(ext2fs_generic_bitmap64 src,
> +			      ext2fs_generic_bitmap64 dest)
>  {
> +	size = (size_t) (((src->real_end - src->start) / 8) + 1);
> +	memcpy (dest_bp->bitarray, src_bp->bitarray, size);

Would it also be worthwhile to store the size of the bitarray in the
ba_private_struct for verification?

> -	errcode_t (*new_bmap)(ext2_filsys fs, ext2fs_generic_bitmap64 *bmap);
> +	errcode_t (*new_bmap)(ext2_filsys fs, ext2fs_generic_bitmap64 bmap);

As a general rule, I dislike types that are pointers, as it isn't clear
from looking at this code if you are passing "bmap" by reference or a
copy.

> @@ -162,37 +163,53 @@ errcode_t ext2fs_copy_generic_bmap(ext2fs_generic_bitmap64 src,
>  					  ext2fs_generic_bitmap64 *dest)
>  {
>  	if (!EXT2FS_IS_64_BITMAP(src))
> -		return;
> +		return EINVAL;

Is this worth a better error than "EINVAL"?  In general, anything that
returns "errcode_t" can have a very specific error return value as
defined in lib/ext2fs/ext2_err.et.in.  This is true of all of these
functions that return EINVAL.

> +__u64 ext2fs_get_generic_bmap_start(ext2fs_generic_bitmap64 bitmap)
> +{
> +	if (!bitmap)
> +		return EINVAL;
> +
> +	if (EXT2FS_IS_32_BITMAP(bitmap)) {
> +		return ext2fs_get_generic_bitmap_start((ext2fs_generic_bitmap)
> +						       bitmap);
> +
> +	}
> +
> +	if (!EXT2FS_IS_64_BITMAP(bitmap))
> +		return EINVAL;
> +
> +	return bitmap->start;
> +}

Hmm, how do you distinguish between EINVAL and an actual start value here?

> +void ext2fs_clear_generic_bmap(ext2fs_generic_bitmap64 bitmap)
> +{
> +	if (EXT2FS_IS_32_BITMAP(bitmap)) {
> +		ext2fs_clear_generic_bitmap((ext2fs_generic_bitmap) bitmap);
> +		return;
> +	}
> +
> +	bitmap->bitmap_ops->clear_bmap (bitmap);
> +}

To be "fail safe" this should probably prefer to believe there is a 32-bit
bitmap (i.e. what is used in all existing applications/deployments) instead
of a 64-bit bitmap.  Failing that, is there a reason the 32-bit bitmap
cannot register a ->clear_bmap() method itself, and this code can never
fail?

> +int ext2fs_test_block_bitmap_range2(ext2fs_block_bitmap64 bmap,
> +				    blk64_t block, int num)
> +{
> +	int	i;
> +
> +	if (!bmap)
> +		return EINVAL;
> +
> +	if (EXT2FS_IS_32_BITMAP(bmap)) {
> +		if ((block+num) & ~0xffffffffULL) {
> +			ext2fs_warn_bitmap2((ext2fs_generic_bitmap) bmap,
> +					    EXT2FS_UNMARK_ERROR, 0xffffffff);
> +			return EINVAL;
> +		}
> +		return ext2fs_test_block_bitmap_range((ext2fs_generic_bitmap) bmap,
> +						      block, num);
> +	}
> +
> +	if (!EXT2FS_IS_64_BITMAP(bmap))
> +		return EINVAL;

Similarly, I don't see how the caller of this code can distinguish between
EINVAL and (what is expected to be a boolean) whether the entire bitmap
range is clear or not.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

