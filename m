From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 4/6] ext4: remove code related to punching hole from ext4_ext_insert_extent
Date: Thu, 17 Nov 2011 09:56:15 -0700
Message-ID: <FB6BBDEB-61D7-42B2-B532-69ABBF21F125@dilger.ca>
References: <1321495405-9583-1-git-send-email-xiaoqiangnk@gmail.com> <1321495405-9583-4-git-send-email-xiaoqiangnk@gmail.com>
Mime-Version: 1.0 (iPhone Mail 8L1)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: "tytso@mit.edu" <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from shawmail.shawcable.com ([64.59.128.220]:28892 "EHLO
	mail.shawcable.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932294Ab1KQQzL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 17 Nov 2011 11:55:11 -0500
In-Reply-To: <1321495405-9583-4-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-11-16, at 19:03, Yongqiang Yang <xiaoqiangnk@gmail.com> wrote:

> Punch hole should never call ext4_ext_insert_extent, so this patch
> removes code related to it from ext4_ext_insert_extent.

Is that still true if punch hole is used beyond the end of the file?  I don't recall whether the semantics of this mean to extend the file size or to shrink it?

> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
> ---
> fs/ext4/extents.c |    2 --
> 1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 6888d1a..720070d 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -1737,8 +1737,6 @@ int ext4_ext_insert_extent(handle_t *handle, struct inode *inode,
>     * There is no free space in the found leaf.
>     * We're gonna add a new leaf in the tree.
>     */
> -    if (flag & EXT4_GET_BLOCKS_PUNCH_OUT_EXT)
> -        flags = EXT4_MB_USE_ROOT_BLOCKS;
>    err = ext4_ext_create_new_leaf(handle, inode, flags, path, newext);
>    if (err)
>        goto cleanup;
> -- 
> 1.7.5.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
