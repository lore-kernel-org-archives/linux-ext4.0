From: Peng Tao <bergwolf@gmail.com>
Subject: Re: [PATCH 2/2] ext4: simple cleanup in fiemap codepath
Date: Wed, 21 Nov 2012 18:48:34 +0800
Message-ID: <CA+a=Yy6U4Md9_LU3e9Hy0QJ_LyEQPbg7xxOtGWrUuddH7=r2gQ@mail.gmail.com>
References: <1353423460-12178-1-git-send-email-lczerner@redhat.com> <1353423460-12178-3-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-ext4@vger.kernel.org, gnehzuil.liu@gmail.com, tytso@mit.edu,
	dmonakhov@openvz.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:42724 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754124Ab2KUKs4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 21 Nov 2012 05:48:56 -0500
Received: by mail-lb0-f174.google.com with SMTP id gi11so2583550lbb.19
        for <linux-ext4@vger.kernel.org>; Wed, 21 Nov 2012 02:48:55 -0800 (PST)
In-Reply-To: <1353423460-12178-3-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Nov 20, 2012 at 10:57 PM, Lukas Czerner <lczerner@redhat.com> wrote:
> This commit is simple cleanup of fiemap codepath which has not been
> included in previous commit to make the changes clearer. In this commit
> we rename cbex variable to newex in ext4_fill_fiemap_extents() and more
> importantly remove unnecessary condition in ext4_find_delayed_extent().
                    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
missing some code or commit message needs updating?

Thanks,
Tao

>
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> ---
>  fs/ext4/extents.c |   28 ++++++++++++++--------------
>  1 files changed, 14 insertions(+), 14 deletions(-)
>
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index c7e3b58..ec34a0c 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -1967,7 +1967,7 @@ static int ext4_fill_fiemap_extents(struct inode *inode,
>                                     struct fiemap_extent_info *fieinfo)
>  {
>         struct ext4_ext_path *path = NULL;
> -       struct ext4_ext_cache cbex;
> +       struct ext4_ext_cache newex;
>         struct ext4_extent *ex;
>         ext4_lblk_t next, next_del, start = 0, end = 0;
>         ext4_lblk_t last = block + num;
> @@ -2044,26 +2044,26 @@ static int ext4_fill_fiemap_extents(struct inode *inode,
>                 BUG_ON(end <= start);
>
>                 if (!exists) {
> -                       cbex.ec_block = start;
> -                       cbex.ec_len = end - start;
> -                       cbex.ec_start = 0;
> +                       newex.ec_block = start;
> +                       newex.ec_len = end - start;
> +                       newex.ec_start = 0;
>                 } else {
> -                       cbex.ec_block = le32_to_cpu(ex->ee_block);
> -                       cbex.ec_len = ext4_ext_get_actual_len(ex);
> -                       cbex.ec_start = ext4_ext_pblock(ex);
> +                       newex.ec_block = le32_to_cpu(ex->ee_block);
> +                       newex.ec_len = ext4_ext_get_actual_len(ex);
> +                       newex.ec_start = ext4_ext_pblock(ex);
>                         if (ext4_ext_is_uninitialized(ex))
>                                 flags |= FIEMAP_EXTENT_UNWRITTEN;
>                 }
>
> -               next_del = ext4_find_delayed_extent(inode, &cbex);
> +               next_del = ext4_find_delayed_extent(inode, &newex);
>                 if (next_del) {
>                         exists = 1;
>                         flags |= FIEMAP_EXTENT_DELALLOC;
>                 }
>                 up_read(&EXT4_I(inode)->i_data_sem);
>
> -               if (unlikely(cbex.ec_len == 0)) {
> -                       EXT4_ERROR_INODE(inode, "cbex.ec_len == 0");
> +               if (unlikely(newex.ec_len == 0)) {
> +                       EXT4_ERROR_INODE(inode, "newex.ec_len == 0");
>                         err = -EIO;
>                         break;
>                 }
> @@ -2084,9 +2084,9 @@ static int ext4_fill_fiemap_extents(struct inode *inode,
>
>                 if (exists) {
>                         err = fiemap_fill_next_extent(fieinfo,
> -                               (__u64)cbex.ec_block << blksize_bits,
> -                               (__u64)cbex.ec_start << blksize_bits,
> -                               (__u64)cbex.ec_len << blksize_bits,
> +                               (__u64)newex.ec_block << blksize_bits,
> +                               (__u64)newex.ec_start << blksize_bits,
> +                               (__u64)newex.ec_len << blksize_bits,
>                                 flags);
>                         if (err < 0)
>                                 break;
> @@ -2096,7 +2096,7 @@ static int ext4_fill_fiemap_extents(struct inode *inode,
>                         }
>                 }
>
> -               block = cbex.ec_block + cbex.ec_len;
> +               block = newex.ec_block + newex.ec_len;
>         }
>
>         if (path) {
> --
> 1.7.7.6
>
