From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 2/4 v2] e2fsprogs: Add rbtree backend for bitmaps, use it instead of bitarrays
Date: Thu, 17 Mar 2011 13:56:42 -0600
Message-ID: <1C50C58A-4A2A-4BAC-918D-054E0BD0EE1A@dilger.ca>
References: <1300387821-21705-1-git-send-email-lczerner@redhat.com> <1300387821-21705-3-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, sandeen@redhat.com
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:13180 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754358Ab1CQT4o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 17 Mar 2011 15:56:44 -0400
In-Reply-To: <1300387821-21705-3-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-03-17, at 12:50 PM, Lukas Czerner wrote:
> +++ b/lib/ext2fs/blkmap64_rb.c
> +struct bmap_rb_extent {
> +	struct rb_node node;
> +	__u64 start;
> +	__u32 count;
> +};

On 32-bit machines (where memory consumption is even more critical) this will pack better by arranging it with "count" aligned with rb_parent_color:

struct bmap_rb_extent {
	__u64 start;
	__u32 count;
	struct rb_node node;
};

That will give a leaf size of 24 bytes on a 32-bit arch, instead of 32 bytes with padding.  On a 64-bit arch it won't make any difference.

> static errcode_t rb_resize_bmap(ext2fs_generic_bitmap bmap,
> +				__u64 new_end, __u64 new_real_end)
> +{
> +	struct ext2fs_rb_private *bp;
> +
> +	if (new_real_end >= bmap->real_end) {
> +		bmap->end = new_end;
> +		bmap->real_end = new_real_end;
> +		return 0;
> +	}
> +
> +	bp = (struct ext2fs_rb_private *) bmap->private;
> +	*bp->rcursor = NULL;
> +	*bp->wcursor = NULL;
> +
> +	/* truncate tree to new_real_end size */
> +	rb_truncate(new_real_end, &bp->root);
> +
> +	bmap->end = new_end;
> +	bmap->real_end = new_real_end;
> +	return 0;
> +
> +}

This might be a bit better written as:

static errcode_t rb_resize_bmap(ext2fs_generic_bitmap bmap,
				__u64 new_end, __u64 new_real_end)
{
	struct ext2fs_rb_private *bp;

	if (new_real_end < bmap->real_end) {
		bp = (struct ext2fs_rb_private *)bmap->private;
		*bp->rcursor = NULL;
		*bp->wcursor = NULL;

		/* truncate tree to new_real_end size */
		rb_truncate(new_real_end, &bp->root);
	}

	bmap->end = new_end;
	bmap->real_end = new_real_end;
	return 0;

}

> +inline static int
> +rb_test_bit(struct ext2fs_rb_private *bp, __u64 bit)
> +{
> +	struct bmap_rb_extent *rcursor;
> +	struct rb_node *parent = NULL;
> +	struct rb_node **n = &bp->root.rb_node;
> +	struct bmap_rb_extent *ext;
> +	int i=0;
> +
> +	rcursor = *bp->rcursor;
> +	if (!rcursor)
> +		goto search_tree;
> +
> +	if (bit >= rcursor->start && bit < rcursor->start + rcursor->count)
> +		return 1;
> +
> +	rcursor = *bp->wcursor;
> +	if (!rcursor)
> +		goto search_tree;
> +
> +	if (bit >= rcursor->start && bit < rcursor->start + rcursor->count)
> +		return 1;
> +
> +search_tree:
> +
> +	while (*n) {
> +		parent = *n;
> +		ext = rb_entry(parent, struct bmap_rb_extent, node);
> +		if (bit < ext->start)
> +			n = &(*n)->rb_left;
> +		else if (bit >= (ext->start + ext->count))
> +			n = &(*n)->rb_right;
> +		else {
> +			*bp->rcursor = ext;
> +			return 1;
> +		}
> +	}
> +	return 0;
> +}

This seems quite large for a static inline?  I guess it is only called by a single function, so maybe not a big deal.

> +inline
> +static int rb_test_bmap(ext2fs_generic_bitmap bitmap, __u64 arg)
> +{
> +	struct ext2fs_rb_private *bp;
> +
> +	bp = (struct ext2fs_rb_private *) bitmap->private;
> +	arg -= bitmap->start;
> +
> +	return rb_test_bit(bp, arg);
> +}

This definitely doesn't make sense to be static inline, since its only use is by ext2_bitmap_ops table, so it can't possibly be inline...

> @@ -158,6 +161,7 @@ void ext2fs_free_generic_bmap(ext2fs_generic_bitmap bmap)
> 		bmap->description = 0;
> 	}
> 	bmap->magic = 0;
> +	ext2fs_free_mem(&bmap);
> }

This is really a defect in the original e2fsprogs, so it might make sense to submit it independently in case Ted isn't going to apply this patch right away.

Cheers, Andreas





