From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] libext2fs: Fix rbtree backend for extent lengths greater than 2^32
Date: Fri, 25 May 2012 17:21:55 -0600
Message-ID: <C17AD030-FE6E-4004-B8D6-16DE792989D5@dilger.ca>
References: <4FBFE0F9.8050509@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	=?windows-1252?Q?Luk=E1=9A_Czerner?= <lczerner@redhat.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:8450 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757389Ab2EYXV5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 25 May 2012 19:21:57 -0400
In-Reply-To: <4FBFE0F9.8050509@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2012-05-25, at 1:43 PM, Eric Sandeen wrote:
> In short, for a completely full filesystem with more than 2^32
> blocks, the rbtree bitmap backend can assemble an extent of used
> blocks which is longer than 2^32.  If it does, it will overflow
> ->count, and corrupt the rbtree for the bitmaps.
> 
> Discovered by completely filling a 32T filesystem using fallocate, and
> then observing debugfs, dumpe2fs, and e2fsck all behaving badly.
> 
> (Note that filling with only 31 x 1T files did not show the problem,
> because freespace was fragmented enough that there was no sufficiently
> long range of used blocks.)
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> An alternative solution might be to limit the rb_extent to
> 32-bit counts, and not merging beyond that.  For fragmented
> freespace, as normal, perhaps that would be a better memory
> savings?  But this fixes the immediate problem and seems worth
> merging to avoid bad situations such as e2fsck corrupting a
> perfectly good 32T filesystem...

That was my initial thought as well, but the bmap_rb_extent struct
already has several 64-bit values in it on a 64-bit arch, so there
would not be any space savings.  On a 32-bit arch, in theory we
could save 8 bytes by locating a 32-bit count adjacent to rb_node
instead of after __u64 start, but then 32-bit systems can't handle
block devices over 16TB anyway, so the point is moot...

Reviewed-by: Andreas Dilger <adilger@whamcloud.com>

> diff --git a/lib/ext2fs/blkmap64_rb.c b/lib/ext2fs/blkmap64_rb.c
> index 7ab72f4..a83f8ac 100644
> --- a/lib/ext2fs/blkmap64_rb.c
> +++ b/lib/ext2fs/blkmap64_rb.c
> @@ -33,7 +33,7 @@
> struct bmap_rb_extent {
> 	struct rb_node node;
> 	__u64 start;
> -	__u32 count;
> +	__u64 count;
> };
> 
> struct ext2fs_rb_private {
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas





