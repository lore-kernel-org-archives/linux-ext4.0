From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: [PATCH] ext4: ext4_split_extent shoult take care about extent zeroout
Date: Thu, 31 Jan 2013 21:35:10 +0800
Message-ID: <CAGBYx2anQAPb9zekwAMJZUTdHCQWEjSBCViM2KWNsRppEqM8Dw@mail.gmail.com>
References: <1359617098-18451-1-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	"Theodore Ts'o" <tytso@mit.edu>, Jan Kara <jack@suse.cz>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ea0-f182.google.com ([209.85.215.182]:34213 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754600Ab3AaNfc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 31 Jan 2013 08:35:32 -0500
Received: by mail-ea0-f182.google.com with SMTP id a12so1271826eaa.13
        for <linux-ext4@vger.kernel.org>; Thu, 31 Jan 2013 05:35:30 -0800 (PST)
In-Reply-To: <1359617098-18451-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Dmitry,

I am  a little confusing. ext4_convert_unwritten_extents_endio() is
used to convert uninit extent to init, it finds out uninit extent is
the expected case.  Am I missing something ?

I will look into the code this weekend.

In your description, extent [1000,128] is split to [1000,20] and
[1020, 108], right?

Thanks,
Yongqiang.

On Thu, Jan 31, 2013 at 3:24 PM, Dmitry Monakhov <dmonakhov@openvz.org> wrote:
> We have to update extent's state after first ext4_split_extent_at otherwise this result
> in following trace:
> ->ext4_ext_handle_uninitialized_extents (ex=[1000:20:uninit], lblock 1000, max_blocks 10)
>   ->ext4_split_extent_at(ex=[1000,128], lblk 10010) /// First split
>     ->ext4_ext_split() -> ENOSPC
>     ->ext4_ext_zeroout
>       ->ext4_ext_dirty  -> ex=[1000:20:init]
>   ->ext4_split_extent_at(ex=[1000,128], lblk 10000) /// Second split
>      if(split == ee_block)
>          if (split_flag & EXT4_EXT_MARK_UNINIT2)
>             ext4_ext_mark_uninitialized(ex); ex=[1000:20:uninit] /// The bug!
>      ->ext4_ext_dirty ->ex=[1000:20:uninit]
>
> At the end ext4_convert_unwritten_extents_endio() will findout large uninitialized
> extent.
>
> TESTCASE: https://github.com/dmonakhov/xfstests/commit/1a1c4f337d4d198803436c63a56625b1a78d8a5e
>
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> ---
>  fs/ext4/extents.c |   14 ++++++++++----
>  1 files changed, 10 insertions(+), 4 deletions(-)
>
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 97cac01..7a3f679 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -3091,18 +3091,24 @@ static int ext4_split_extent(handle_t *handle,
>                 if (err)
>                         goto out;
>         }
> -
> +       /* Update path is required because previous ext4_split_extent_at() may
> +        * result in split of original leaf or extent zeroout.
> +        */
>         ext4_ext_drop_refs(path);
>         path = ext4_ext_find_extent(inode, map->m_lblk, path);
>         if (IS_ERR(path))
>                 return PTR_ERR(path);
> +       depth = ext_depth(inode);
> +       ex = path[depth].p_ext;
> +       uninitialized = ext4_ext_is_uninitialized(ex);
>
>         if (map->m_lblk >= ee_block) {
>                 split_flag1 = split_flag & EXT4_EXT_MAY_ZEROOUT;
> -               if (uninitialized)
> +               if (uninitialized) {
>                         split_flag1 |= EXT4_EXT_MARK_UNINIT1;
> -               if (split_flag & EXT4_EXT_MARK_UNINIT2)
> -                       split_flag1 |= EXT4_EXT_MARK_UNINIT2;
> +                       if (split_flag & EXT4_EXT_MARK_UNINIT2)
> +                               split_flag1 |= EXT4_EXT_MARK_UNINIT2;
> +               }
>                 err = ext4_split_extent_at(handle, inode, path,
>                                 map->m_lblk, split_flag1, flags);
>                 if (err)
> --
> 1.7.1
>



-- 
Best Wishes
Yongqiang Yang
