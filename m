From: Sami Liedes <sami.liedes@iki.fi>
Subject: Re: [PATCH 5/5] libext2fs: Implement fast find_first_zero() for
 bitarray bitmaps.
Date: Mon, 26 Mar 2012 16:22:58 +0300
Message-ID: <20120326132258.GA31953@cc.hut.fi>
References: <20120310213321.GK6961@sli.dy.fi>
 <20120310213840.GP6961@sli.dy.fi>
 <20120326023400.GA16642@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out-02.aalto.fi ([130.233.228.121]:62472 "EHLO
	smtp-out-02.aalto.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754886Ab2CZN20 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 26 Mar 2012 09:28:26 -0400
Content-Disposition: inline
In-Reply-To: <20120326023400.GA16642@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Mar 25, 2012 at 10:34:00PM -0400, Ted Ts'o wrote:
> On Sat, Mar 10, 2012 at 11:38:40PM +0200, Sami Liedes wrote:
> > +/* Find the first zero bit between start and end, inclusive. */
> > +static errcode_t ba_find_first_zero(ext2fs_generic_bitmap bitmap,
> > +				    __u64 start, __u64 end, __u64 *out)
> > +{
> > +	ext2fs_ba_private bp = (ext2fs_ba_private)bitmap->private;
> > +	unsigned long bitpos = start - bitmap->start;
> > +	unsigned long count = end - start + 1;
> > +	int byte_found = 0; /* whether a != 0xff byte has been found */
> > +	const unsigned char *pos;
> > +	unsigned long max_loop_count, i;
> > +
> > +	if (start < bitmap->start || end > bitmap->end || start > end)
> > +		return EINVAL;
> > +
> > +	if (bitmap->cluster_bits)
> > +		return EINVAL;
> > +
> > +	/* scan bits until we hit a byte boundary */
> > +	while ((bitpos & 0x7) != 0 && count > 0) {
> > +		if (!ext2fs_test_bit64(bitpos, bp->bitarray)) {
> > +			*out = bitpos + bitmap->start;
> > +			return 0;
> > +		}
> > +		bitpos++;
> > +		count--;
> > +	}
> > +
> > +	if (!count)
> > +		return ENOENT;
> 
> Um, this can't possibly be right.  Once we hit a byte boundary, we
> will bomb out with ENOENT, and not proceed to the rest of the
> function.  How much testing did you do before you submitted this patch
> series?
> 
> I think we just need to delete the two lines, but we also need a good
> regression test to make sure the implementation is really correct....

Hmm, no, I don't think so? count==0 here iff we have tested as many
bits as the caller requested. So this code will bail out if the number
of bits to test is not large enough to even hit a byte boundary, or if
the last bit to test and the byte boundary coincide. Perhaps count
should be renamed to something like bits_left_to_test if it's
confusing now?

Looking at the code, in retrospect I think it's indeed safe to delete
these two lines, but then the path to the "return ENOENT" in the end
of the function is a bit contrived and laden with calculations that
really expect that bitpos points to a byte boundary. Personally I
think it's better anyway to bail out earlier here if count reaches 0,
if only because it is (or so I thought...) immediately obvious this
way that this special case is handled too.

As to the question of testing of this patch set:

1) I did some throwaway tests on this function; I didn't notice there
   were tests in the sources until Andreas pointed that out, so I
   didn't put any of that in tst_bitmaps.c...

2) I ran resize2fs on an actual filesystem and verified that the
   outputs of dumpe2fs were identical, except for the last written
   time, for the resulting filesystems with and without this patch
   set.

I realize it would have been better to test that the resulting
filesystem images are identical except for the bytes where the
timestamp is stored. I don't actually know how much relevant
information dumpe2fs outputs. In fact I first tried to test for
identical output, but then noticed the timestamp, became lazy and
reasoned that dumpe2fs would probably show any relevant differences
since we're talking about inode allocation here.

I agree that a regression test is needed. I'll look into writing that.

	Sami

> > +
> > +	pos = ((unsigned char *)bp->bitarray) + (bitpos >> 3);
> > +	/* scan bytes until 8-byte (64-bit) aligned */
> > +	while (count >= 8 && (((unsigned long)pos) & 0x07)) {
> > +		if (*pos != 0xff) {
> > +			byte_found = 1;
> > +			break;
> > +		}
> > +		pos++;
> > +		count -= 8;
> > +		bitpos += 8;
> > +	}
> > +
> > +	if (!byte_found) {
> > +		max_loop_count = count >> 6; /* 8-byte blocks */
> > +		i = max_loop_count;
> > +		while (i) {
> > +			if (*((const __u64 *)pos) != ((__u64)-1))
> > +				break;
> > +			pos += 8;
> > +			i--;
> > +		}
> > +		count -= 64 * (max_loop_count - i);
> > +		bitpos += 64 * (max_loop_count - i);
> > +
> > +		max_loop_count = count >> 3;
> > +		i = max_loop_count;
> > +		while (i) {
> > +			if (*pos != 0xff) {
> > +				byte_found = 1;
> > +				break;
> > +			}
> > +			pos++;
> > +			i--;
> > +		}
> > +		count -= 8 * (max_loop_count - i);
> > +		bitpos += 8 * (max_loop_count - i);
> > +	}
> > +
> > +	/* Here either count < 8 or byte_found == 1. */
> > +	while (count-- > 0) {
> > +		if (!ext2fs_test_bit64(bitpos, bp->bitarray)) {
> > +			*out = bitpos + bitmap->start;
> > +			return 0;
> > +		}
> > +		bitpos++;
> > +	}
> > +
> > +	return ENOENT;
> > +}
> > +
> >  struct ext2_bitmap_ops ext2fs_blkmap64_bitarray = {
> >  	.type = EXT2FS_BMAP64_BITARRAY,
> >  	.new_bmap = ba_new_bmap,
> > @@ -333,4 +413,5 @@ struct ext2_bitmap_ops ext2fs_blkmap64_bitarray = {
> >  	.get_bmap_range = ba_get_bmap_range,
> >  	.clear_bmap = ba_clear_bmap,
> >  	.print_stats = ba_print_stats,
> > +	.find_first_zero = ba_find_first_zero
> >  };
> 
> 
