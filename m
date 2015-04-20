From: Davide Italiano <dccitaliano@gmail.com>
Subject: Re: [PATCH] ext4: Move check under lock scope to close a race.
Date: Mon, 20 Apr 2015 13:50:18 -0700
Message-ID: <CADob98SWOMMw9rTw+s+-CpayNqiDpENzbhcYzUqp34YC3GtufQ@mail.gmail.com>
References: <1428468410-12793-1-git-send-email-dccitaliano@gmail.com>
	<1428468410-12793-2-git-send-email-dccitaliano@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Davide Italiano <dccitaliano@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:34978 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751997AbbDTUuU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 20 Apr 2015 16:50:20 -0400
Received: by widdi4 with SMTP id di4so114789182wid.0
        for <linux-ext4@vger.kernel.org>; Mon, 20 Apr 2015 13:50:19 -0700 (PDT)
In-Reply-To: <1428468410-12793-2-git-send-email-dccitaliano@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Apr 7, 2015 at 9:46 PM, Davide Italiano <dccitaliano@gmail.com> wrote:
> fallocate() checks that the file is extent-based and returns
> EOPNOTSUPP in case is not. Other tasks can convert from and to
> indirect and extent so it's safe to check only after grabbing
> the inode mutex.
>
> Signed-off-by: Davide Italiano <dccitaliano@gmail.com>
> ---
>  fs/ext4/extents.c | 16 +++++++++-------
>  1 file changed, 9 insertions(+), 7 deletions(-)
>
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index bed4308..8a9ee08 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -4934,13 +4934,6 @@ long ext4_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
>         if (ret)
>                 return ret;
>
> -       /*
> -        * currently supporting (pre)allocate mode for extent-based
> -        * files _only_
> -        */
> -       if (!(ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)))
> -               return -EOPNOTSUPP;
> -
>         if (mode & FALLOC_FL_COLLAPSE_RANGE)
>                 return ext4_collapse_range(inode, offset, len);
>
> @@ -4962,6 +4955,15 @@ long ext4_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
>
>         mutex_lock(&inode->i_mutex);
>
> +       /*
> +        * currently supporting (pre)allocate mode for extent-based
> +        * files _only_
> +        */
> +       if (!(ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))) {
> +               ret = -EOPNOTSUPP;
> +               goto out;
> +       }
> +
>         if (!(mode & FALLOC_FL_KEEP_SIZE) &&
>              offset + len > i_size_read(inode)) {
>                 new_size = offset + len;
> --
> 2.3.4
>

Any comment on this? Is it correct?
