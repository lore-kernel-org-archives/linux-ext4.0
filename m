From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: [PATCH 2/2] ext4: check free inode count before allocaing an inode
Date: Wed, 5 Sep 2012 10:17:32 +0800
Message-ID: <CAGBYx2a2RODjmJWgAck9XOeH=7+dvcGieTx5oZkwpCrO3oMD6g@mail.gmail.com>
References: <1346579109-25016-1-git-send-email-xiaoqiangnk@gmail.com> <1346579109-25016-2-git-send-email-xiaoqiangnk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:55656 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752763Ab2IECRy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 4 Sep 2012 22:17:54 -0400
Received: by lbbgj3 with SMTP id gj3so50740lbb.19
        for <linux-ext4@vger.kernel.org>; Tue, 04 Sep 2012 19:17:52 -0700 (PDT)
In-Reply-To: <1346579109-25016-2-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Sep 2, 2012 at 5:45 PM, Yongqiang Yang <xiaoqiangnk@gmail.com> wrote:
> Recnetly, I ecountered some corrupted filesystems in which some
> groups' free inode counts were negative, it seemed that free inode
This comment is not exactly, it is not negative but 65535.  I will
resend the patch later.

Thanks,
Yongqiang.
> count was overflow.  This patch teaches ext4 to check free inode
> count before allocaing an inode.
>
> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
> ---
>  fs/ext4/ialloc.c |    9 +++++++++
>  1 files changed, 9 insertions(+), 0 deletions(-)
>
> diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
> index 26154b8..fa36372 100644
> --- a/fs/ext4/ialloc.c
> +++ b/fs/ext4/ialloc.c
> @@ -697,6 +697,15 @@ got_group:
>                 if (!gdp)
>                         goto fail;
>
> +               /*
> +                * Check free inodes count before loading bitmap.
> +                */
> +               if (ext4_free_inodes_count(sb, gdp) == 0) {
> +                       if (++group == ngroups)
> +                               group = 0;
> +                       continue;
> +               }
> +
>                 brelse(inode_bitmap_bh);
>                 inode_bitmap_bh = ext4_read_inode_bitmap(sb, group);
>                 if (!inode_bitmap_bh)
> --
> 1.7.5.1
>



-- 
Best Wishes
Yongqiang Yang
