From: Valerie Aurora Henson <vaurora@redhat.com>
Subject: Re: [RFC PATCH 04/17] Implement 64-bit "bitarray" bmap ops
Date: Thu, 13 Nov 2008 21:59:57 -0500
Message-ID: <20081114025957.GF20637@shell>
References: <1226461390-5502-1-git-send-email-vaurora@redhat.com> <1226461390-5502-2-git-send-email-vaurora@redhat.com> <1226461390-5502-3-git-send-email-vaurora@redhat.com> <1226461390-5502-4-git-send-email-vaurora@redhat.com> <1226461390-5502-5-git-send-email-vaurora@redhat.com> <20081112204756.GO16005@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Theodore Tso <tytso@mit.edu>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:39141 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750984AbYKNDAd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 13 Nov 2008 22:00:33 -0500
Content-Disposition: inline
In-Reply-To: <20081112204756.GO16005@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Thanks for the prompt (and helpful) review, Andreas!

On Wed, Nov 12, 2008 at 01:47:56PM -0700, Andreas Dilger wrote:
> On Nov 11, 2008  19:42 -0800, Valerie Aurora Henson wrote:
> > -	errcode_t (*new_bmap)(ext2_filsys fs, ext2fs_generic_bitmap64 *bmap);
> > +	errcode_t (*new_bmap)(ext2_filsys fs, ext2fs_generic_bitmap64 bmap);
> 
> As a general rule, I dislike types that are pointers, as it isn't clear
> from looking at this code if you are passing "bmap" by reference or a
> copy.

Me too, but that's the way they are...

The deal here is that the caller of the new_bmap() op has already
allocated the ext2fs_generic_bitmap64 (which is a typedef'd pointer to
struct) itself.  This function is only allowed to fill in members of
the bitmap; in particular, the private data pointer.  So initially it
seems like it should take a pointer to an ext2fs_generic_bitmap64, but
in actuality that's an invitation to disaster - e.g., this function
should not free the generic bitmap structure on failure, only things
that it has allocated.

> > @@ -162,37 +163,53 @@ errcode_t ext2fs_copy_generic_bmap(ext2fs_generic_bitmap64 src,
> >  					  ext2fs_generic_bitmap64 *dest)
> >  {
> >  	if (!EXT2FS_IS_64_BITMAP(src))
> > -		return;
> > +		return EINVAL;
> 
> Is this worth a better error than "EINVAL"?  In general, anything that
> returns "errcode_t" can have a very specific error return value as
> defined in lib/ext2fs/ext2_err.et.in.  This is true of all of these
> functions that return EINVAL.

I agree, EINVAL is just a placeholder.

> > +__u64 ext2fs_get_generic_bmap_start(ext2fs_generic_bitmap64 bitmap)
> > +{
> > +	if (!bitmap)
> > +		return EINVAL;
> > +
> > +	if (EXT2FS_IS_32_BITMAP(bitmap)) {
> > +		return ext2fs_get_generic_bitmap_start((ext2fs_generic_bitmap)
> > +						       bitmap);
> > +
> > +	}
> > +
> > +	if (!EXT2FS_IS_64_BITMAP(bitmap))
> > +		return EINVAL;
> > +
> > +	return bitmap->start;
> > +}
> 
> Hmm, how do you distinguish between EINVAL and an actual start value here?

I just cut and paste this from other functions, it shouldn't return an
error at all.

> > +void ext2fs_clear_generic_bmap(ext2fs_generic_bitmap64 bitmap)
> > +{
> > +	if (EXT2FS_IS_32_BITMAP(bitmap)) {
> > +		ext2fs_clear_generic_bitmap((ext2fs_generic_bitmap) bitmap);
> > +		return;
> > +	}
> > +
> > +	bitmap->bitmap_ops->clear_bmap (bitmap);
> > +}
> 
> To be "fail safe" this should probably prefer to believe there is a 32-bit
> bitmap (i.e. what is used in all existing applications/deployments) instead
> of a 64-bit bitmap.  Failing that, is there a reason the 32-bit bitmap
> cannot register a ->clear_bmap() method itself, and this code can never
> fail?

In Ted's design, the assumption is 64-bit and the check is for 32-bit.
Having the 32-bit code use the new bmap_ops() interface seems to me to
be overkill - we just want to abandon the old 32-bit code as much as
possible, not rewrite it to new interfaces. 

> > +int ext2fs_test_block_bitmap_range2(ext2fs_block_bitmap64 bmap,
> > +				    blk64_t block, int num)
[snip]
> 
> Similarly, I don't see how the caller of this code can distinguish between
> EINVAL and (what is expected to be a boolean) whether the entire bitmap
> range is clear or not.

Same cut-n-paste issue, I'll fix it too.

-VAL
