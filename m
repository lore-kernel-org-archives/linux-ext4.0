From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] mke2fs: do not initialize block bitmaps of groups having super block
Date: Wed, 9 Nov 2011 09:23:46 -0700
Message-ID: <D8CD6456-1740-4FA6-83E5-EFB0045EE74E@dilger.ca>
References: <1320836006-6946-1-git-send-email-xiaoqiangnk@gmail.com>
Mime-Version: 1.0 (iPhone Mail 8L1)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: "tytso@mit.edu" <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from shawmail.shawcable.com ([64.59.128.220]:58641 "EHLO
	mail.shawcable.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201Ab1KIQWo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 9 Nov 2011 11:22:44 -0500
In-Reply-To: <1320836006-6946-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-11-09, at 3:53 AM, Yongqiang Yang <xiaoqiangnk@gmail.com> wrote:

> Now mke2fs initializes block bitmaps of groups having super block, on
> the other hand ext4_init_block_bitmap in kernel can handle this case
> rightly.  So let mke2fs let block bitmaps of groups having super block
> be uninitialized.

Is that true of older kernels, or only newer ones?  What about filesystems with META_BG set?

Cheers, Andreas

> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
> ---
> lib/ext2fs/alloc_sb.c |    2 --
> 1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/lib/ext2fs/alloc_sb.c b/lib/ext2fs/alloc_sb.c
> index 0d1c000..7517fbc 100644
> --- a/lib/ext2fs/alloc_sb.c
> +++ b/lib/ext2fs/alloc_sb.c
> @@ -65,8 +65,6 @@ int ext2fs_reserve_super_and_bgd(ext2_filsys fs,
>        ext2fs_mark_block_bitmap2(bmap, 0);
> 
>    if (old_desc_blk) {
> -        if (fs->super->s_reserved_gdt_blocks && fs->block_map == bmap)
> -            ext2fs_bg_flags_clear(fs, group, EXT2_BG_BLOCK_UNINIT);
>        for (j=0; j < old_desc_blocks; j++)
>            if (old_desc_blk + j < ext2fs_blocks_count(fs->super))
>                ext2fs_mark_block_bitmap2(bmap,
> -- 
> 1.7.5.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
