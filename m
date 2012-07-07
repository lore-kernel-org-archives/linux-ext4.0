From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH 1/2] ext4: fix the comment in ext4_ext_insert_extent for
 ext4_ext_try_to_merge in extents.c
Date: Sat, 7 Jul 2012 23:15:06 +0800
Message-ID: <CANWLp03uEyPZUbUD+rO=AtRQPLVSvTMTJERhCX94Nfw-7QRtmQ@mail.gmail.com>
References: <4FF68511.9050207@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Wang Sheng-Hui <shhuiw@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61051 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646Ab2GGPPH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 7 Jul 2012 11:15:07 -0400
In-Reply-To: <4FF68511.9050207@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Sheng-Hui,

It seems that there has a patch to fix it.
http://www.spinics.net/lists/linux-ext4/msg32611.html

Regards,
Zheng

On Fri, Jul 6, 2012 at 2:26 PM, Wang Sheng-Hui <shhuiw@gmail.com> wrote:
> The left and right extents merge is done by
> ext4_ext_try_to_merge. No specific left/right
> fun calls any more.
>
> Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
> ---
>  fs/ext4/extents.c |    4 +---
>  1 files changed, 1 insertions(+), 3 deletions(-)
>
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 5207b7b..6c2a37d 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -1891,12 +1891,10 @@ has_space:
>         nearex->ee_len = newext->ee_len;
>
>  merge:
> -       /* try to merge extents to the right */
> +       /* try to merge extents to the neighbours */
>         if (!(flag & EXT4_GET_BLOCKS_PRE_IO))
>                 ext4_ext_try_to_merge(inode, path, nearex);
>
> -       /* try to merge extents to the left */
> -
>         /* time to correct all indexes above */
>         err = ext4_ext_correct_indexes(handle, inode, path);
>         if (err)
> --
> 1.7.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
