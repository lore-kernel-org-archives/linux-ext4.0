From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 5/5] libext2fs: Implement fast find_first_zero() for
 bitarray bitmaps.
Date: Sun, 25 Mar 2012 22:34:00 -0400
Message-ID: <20120326023400.GA16642@thunk.org>
References: <20120310213321.GK6961@sli.dy.fi>
 <20120310213840.GP6961@sli.dy.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Sami Liedes <sami.liedes@iki.fi>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:57798 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756901Ab2CZDSe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 25 Mar 2012 23:18:34 -0400
Content-Disposition: inline
In-Reply-To: <20120310213840.GP6961@sli.dy.fi>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Mar 10, 2012 at 11:38:40PM +0200, Sami Liedes wrote:
> +/* Find the first zero bit between start and end, inclusive. */
> +static errcode_t ba_find_first_zero(ext2fs_generic_bitmap bitmap,
> +				    __u64 start, __u64 end, __u64 *out)
> +{
> +	ext2fs_ba_private bp = (ext2fs_ba_private)bitmap->private;
> +	unsigned long bitpos = start - bitmap->start;
> +	unsigned long count = end - start + 1;
> +	int byte_found = 0; /* whether a != 0xff byte has been found */
> +	const unsigned char *pos;
> +	unsigned long max_loop_count, i;
> +
> +	if (start < bitmap->start || end > bitmap->end || start > end)
> +		return EINVAL;
> +
> +	if (bitmap->cluster_bits)
> +		return EINVAL;
> +
> +	/* scan bits until we hit a byte boundary */
> +	while ((bitpos & 0x7) != 0 && count > 0) {
> +		if (!ext2fs_test_bit64(bitpos, bp->bitarray)) {
> +			*out = bitpos + bitmap->start;
> +			return 0;
> +		}
> +		bitpos++;
> +		count--;
> +	}
> +
> +	if (!count)
> +		return ENOENT;

Um, this can't possibly be right.  Once we hit a byte boundary, we
will bomb out with ENOENT, and not proceed to the rest of the
function.  How much testing did you do before you submitted this patch
series?

I think we just need to delete the two lines, but we also need a good
regression test to make sure the implementation is really correct....

					- Ted

> +
> +	pos = ((unsigned char *)bp->bitarray) + (bitpos >> 3);
> +	/* scan bytes until 8-byte (64-bit) aligned */
> +	while (count >= 8 && (((unsigned long)pos) & 0x07)) {
> +		if (*pos != 0xff) {
> +			byte_found = 1;
> +			break;
> +		}
> +		pos++;
> +		count -= 8;
> +		bitpos += 8;
> +	}
> +
> +	if (!byte_found) {
> +		max_loop_count = count >> 6; /* 8-byte blocks */
> +		i = max_loop_count;
> +		while (i) {
> +			if (*((const __u64 *)pos) != ((__u64)-1))
> +				break;
> +			pos += 8;
> +			i--;
> +		}
> +		count -= 64 * (max_loop_count - i);
> +		bitpos += 64 * (max_loop_count - i);
> +
> +		max_loop_count = count >> 3;
> +		i = max_loop_count;
> +		while (i) {
> +			if (*pos != 0xff) {
> +				byte_found = 1;
> +				break;
> +			}
> +			pos++;
> +			i--;
> +		}
> +		count -= 8 * (max_loop_count - i);
> +		bitpos += 8 * (max_loop_count - i);
> +	}
> +
> +	/* Here either count < 8 or byte_found == 1. */
> +	while (count-- > 0) {
> +		if (!ext2fs_test_bit64(bitpos, bp->bitarray)) {
> +			*out = bitpos + bitmap->start;
> +			return 0;
> +		}
> +		bitpos++;
> +	}
> +
> +	return ENOENT;
> +}
> +
>  struct ext2_bitmap_ops ext2fs_blkmap64_bitarray = {
>  	.type = EXT2FS_BMAP64_BITARRAY,
>  	.new_bmap = ba_new_bmap,
> @@ -333,4 +413,5 @@ struct ext2_bitmap_ops ext2fs_blkmap64_bitarray = {
>  	.get_bmap_range = ba_get_bmap_range,
>  	.clear_bmap = ba_clear_bmap,
>  	.print_stats = ba_print_stats,
> +	.find_first_zero = ba_find_first_zero
>  };


