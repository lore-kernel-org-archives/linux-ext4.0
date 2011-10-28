From: Andreas Dilger <aedilger@gmail.com>
Subject: Re: [PATCH] Ext4: Don't normalize an falloc request if it can fit in 1 extent.
Date: Fri, 28 Oct 2011 12:47:17 -0600
Message-ID: <472B9A86-7C0A-4AAC-882E-9A739BBBE523@gmail.com>
References: <1319824917-28345-1-git-send-email-gharm@google.com>
Mime-Version: 1.0 (iPhone Mail 8L1)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Greg Harm <gharm@google.com>
To: Greg Harm <gharm@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:44738 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932668Ab1J1Sq2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 28 Oct 2011 14:46:28 -0400
Received: by vws1 with SMTP id 1so3647639vws.19
        for <linux-ext4@vger.kernel.org>; Fri, 28 Oct 2011 11:46:27 -0700 (PDT)
In-Reply-To: <1319824917-28345-1-git-send-email-gharm@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-10-28, at 12:01 PM, Greg Harm <gharm@google.com> wrote:
> If an fallocate request fits in EXT_UNINIT_MAX_LEN, then set the
> EXT4_GET_BLOCKS_NO_NORMALIZE flag. For larger fallocate requests,
> let mballoc.c normalize the request.
> This fixes a problem where large requests were being split
> into non-contiguous extents due to haldar@google.com's
> "ext4: do not normalize block requests from fallocate."
> 
> Testing: Checked that 8.x MB falloc'ed files are still laid down
> next to each other (contiguously).
> Checked that the maximum size extent (127.9MB) is allocated as 1
> extent.
> Checked that a 1GB file is somewhat contiguous (often 5-6
> non-contiguous extents now).
> Checked that a 120MB file can still be falloc'ed even if there are no
> single extents large enough to hold it.

It would be great to add these test cases to xfstests so that this doesn't break in the future. 

> Signed-off-by: Greg Harm <gharm@google.com>
> ---
> fs/ext4/extents.c |   13 ++++++++++---
> 1 files changed, 10 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 57cf568..9819216 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -3761,6 +3761,7 @@ long ext4_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
>    int ret2 = 0;
>    int retries = 0;
>    struct ext4_map_blocks map;
> +    int map_blocks_flags;
>    unsigned int credits, blkbits = inode->i_blkbits;
> 
>    /*
> @@ -3805,9 +3806,15 @@ retry:
>            ret = PTR_ERR(handle);
>            break;
>        }
> -        ret = ext4_map_blocks(handle, inode, &map,
> -                      EXT4_GET_BLOCKS_CREATE_UNINIT_EXT |
> -                      EXT4_GET_BLOCKS_NO_NORMALIZE);
> +        map_blocks_flags = EXT4_GET_BLOCKS_CREATE_UNINIT_EXT;
> +        /*
> +         * Don't normalize the request if it can fit in one extent so
> +         * that it doesn't get unnecessarily split into multiple
> +         * extents.
> +         */
> +        if (len <= EXT_UNINIT_MAX_LEN << blkbits)
> +            map_blocks_flags |= EXT4_GET_BLOCKS_NO_NORMALIZE;
> +        ret = ext4_map_blocks(handle, inode, &map, map_blocks_flags);
>        if (ret <= 0) {
> #ifdef EXT4FS_DEBUG
>            WARN_ON(ret <= 0);
> -- 
> 1.7.3.1
> 
