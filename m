From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH 2/4 v2] e2fsprogs: Add rbtree backend for bitmaps, use
 it instead of bitarrays
Date: Fri, 18 Mar 2011 10:55:38 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1103181046370.4087@dhcp-27-109.brq.redhat.com>
References: <1300387821-21705-1-git-send-email-lczerner@redhat.com> <1300387821-21705-3-git-send-email-lczerner@redhat.com> <1C50C58A-4A2A-4BAC-918D-054E0BD0EE1A@dilger.ca>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org,
	tytso@mit.edu, sandeen@redhat.com
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8356 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932384Ab1CRJzp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 18 Mar 2011 05:55:45 -0400
In-Reply-To: <1C50C58A-4A2A-4BAC-918D-054E0BD0EE1A@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 17 Mar 2011, Andreas Dilger wrote:

> On 2011-03-17, at 12:50 PM, Lukas Czerner wrote:
> > +++ b/lib/ext2fs/blkmap64_rb.c
> > +struct bmap_rb_extent {
> > +	struct rb_node node;
> > +	__u64 start;
> > +	__u32 count;
> > +};
> 
> On 32-bit machines (where memory consumption is even more critical) this will pack better by arranging it with "count" aligned with rb_parent_color:
> 
> struct bmap_rb_extent {
> 	__u64 start;
> 	__u32 count;
> 	struct rb_node node;
> };
> 
> That will give a leaf size of 24 bytes on a 32-bit arch, instead of 32 bytes with padding.  On a 64-bit arch it won't make any difference.

Oh, of course, do not know how I missed that.

> 
> > static errcode_t rb_resize_bmap(ext2fs_generic_bitmap bmap,
> > +				__u64 new_end, __u64 new_real_end)
> > +{
> > +	struct ext2fs_rb_private *bp;
> > +
> > +	if (new_real_end >= bmap->real_end) {
> > +		bmap->end = new_end;
> > +		bmap->real_end = new_real_end;
> > +		return 0;
> > +	}
> > +
> > +	bp = (struct ext2fs_rb_private *) bmap->private;
> > +	*bp->rcursor = NULL;
> > +	*bp->wcursor = NULL;
> > +
> > +	/* truncate tree to new_real_end size */
> > +	rb_truncate(new_real_end, &bp->root);
> > +
> > +	bmap->end = new_end;
> > +	bmap->real_end = new_real_end;
> > +	return 0;
> > +
> > +}
> 
> This might be a bit better written as:
> 
> static errcode_t rb_resize_bmap(ext2fs_generic_bitmap bmap,
> 				__u64 new_end, __u64 new_real_end)
> {
> 	struct ext2fs_rb_private *bp;
> 
> 	if (new_real_end < bmap->real_end) {
> 		bp = (struct ext2fs_rb_private *)bmap->private;
> 		*bp->rcursor = NULL;
> 		*bp->wcursor = NULL;
> 
> 		/* truncate tree to new_real_end size */
> 		rb_truncate(new_real_end, &bp->root);
> 	}
> 
> 	bmap->end = new_end;
> 	bmap->real_end = new_real_end;
> 	return 0;
> 
> }

Right that's definitely better.

> 
> > +inline static int
> > +rb_test_bit(struct ext2fs_rb_private *bp, __u64 bit)
> > +{
> > +	struct bmap_rb_extent *rcursor;
> > +	struct rb_node *parent = NULL;
> > +	struct rb_node **n = &bp->root.rb_node;
> > +	struct bmap_rb_extent *ext;
> > +	int i=0;
> > +
> > +	rcursor = *bp->rcursor;
> > +	if (!rcursor)
> > +		goto search_tree;
> > +
> > +	if (bit >= rcursor->start && bit < rcursor->start + rcursor->count)
> > +		return 1;
> > +
> > +	rcursor = *bp->wcursor;
> > +	if (!rcursor)
> > +		goto search_tree;
> > +
> > +	if (bit >= rcursor->start && bit < rcursor->start + rcursor->count)
> > +		return 1;
> > +
> > +search_tree:
> > +
> > +	while (*n) {
> > +		parent = *n;
> > +		ext = rb_entry(parent, struct bmap_rb_extent, node);
> > +		if (bit < ext->start)
> > +			n = &(*n)->rb_left;
> > +		else if (bit >= (ext->start + ext->count))
> > +			n = &(*n)->rb_right;
> > +		else {
> > +			*bp->rcursor = ext;
> > +			return 1;
> > +		}
> > +	}
> > +	return 0;
> > +}
> 
> This seems quite large for a static inline?  I guess it is only called by a single function, so maybe not a big deal.

It is actually called for two functions and since this is the most
called function, I think this it is worth it (there is approx. 1%
performance boost bound with this).

> 
> > +inline
> > +static int rb_test_bmap(ext2fs_generic_bitmap bitmap, __u64 arg)
> > +{
> > +	struct ext2fs_rb_private *bp;
> > +
> > +	bp = (struct ext2fs_rb_private *) bitmap->private;
> > +	arg -= bitmap->start;
> > +
> > +	return rb_test_bit(bp, arg);
> > +}
> 
> This definitely doesn't make sense to be static inline, since its only use is by ext2_bitmap_ops table, so it can't possibly be inline...

Right, I'll fix that.

> 
> > @@ -158,6 +161,7 @@ void ext2fs_free_generic_bmap(ext2fs_generic_bitmap bmap)
> > 		bmap->description = 0;
> > 	}
> > 	bmap->magic = 0;
> > +	ext2fs_free_mem(&bmap);
> > }
> 
> This is really a defect in the original e2fsprogs, so it might make sense to submit it independently in case Ted isn't going to apply this patch right away.

Yes, somehow I forgot about that. Thanks.

> 
> Cheers, Andreas
> 

Thanks!
-Lukas
