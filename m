From: Wang Shilong <wshilong@ddn.com>
Subject: RE: [PATCH 1/4] ext4: fix forgetten xattr lock protection in
 ext4_expand_extra_isize
Date: Thu, 13 Jul 2017 13:04:08 +0000
Message-ID: <3ED34739A4E85E4F894367D57617CDEFE1DD2EEC@LAX-EX-MB2.datadirect.datadirectnet.com>
References: <1499360993-17130-1-git-send-email-miaoxie@huawei.com>,<e7301611-0fed-fbbf-3ab9-49f2287a14eb@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "tytso@mit.edu" <tytso@mit.edu>, Li Xi <lixi@ddn.com>,
        "yi.zhang@huawei.com" <yi.zhang@huawei.com>,
        "adilger@dilger.ca" <adilger@dilger.ca>,
        Shuichi Ihara <sihara@ddn.com>
To: "miaoxie@huawei.com" <miaoxie@huawei.com>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from legacy.ddn.com ([64.47.133.206]:34373 "EHLO legacy.ddn.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751915AbdGMNEL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 13 Jul 2017 09:04:11 -0400
In-Reply-To: <e7301611-0fed-fbbf-3ab9-49f2287a14eb@huawei.com>
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  I guess Maintainer will reply you when development cycle is ready for this.
Please be patient Miao!, let's play Glory of the king.^^^_^^^

________________________________________
From: Miao Xie [miaoxie@huawei.com]
Sent: Thursday, July 13, 2017 20:55
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu; Li Xi; yi.zhang@huawei.com; adilger@dilger.ca; Wang Shilong; Shuichi Ihara
Subject: Re: [PATCH 1/4] ext4: fix forgetten xattr lock protection in ext4_expand_extra_isize

Ping......

on 2017/7/7 at 1:09, Miao Xie wrote:
> We should avoid the contention between the i_extra_isize update and
> the inline data insertion, so move the xattr trylock in front of
> i_extra_isize update.
>
> Signed-off-by: Miao Xie <miaoxie@huawei.com>
> Reviewed-by: Wang Shilong <wshilong@ddn.com>
> ---
>  fs/ext4/inode.c | 18 ++++++++++++++++--
>  fs/ext4/xattr.c | 10 ----------
>  2 files changed, 16 insertions(+), 12 deletions(-)
>
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 5cf82d0..4af3edc 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -5639,10 +5639,15 @@ static int ext4_expand_extra_isize(struct inode *inode,
>  {
>       struct ext4_inode *raw_inode;
>       struct ext4_xattr_ibody_header *header;
> +     int no_expand;
> +     int error;
>
>       if (EXT4_I(inode)->i_extra_isize >= new_extra_isize)
>               return 0;
>
> +     if (ext4_write_trylock_xattr(inode, &no_expand) == 0)
> +             return 0;
> +
>       raw_inode = ext4_raw_inode(&iloc);
>
>       header = IHDR(inode, raw_inode);
> @@ -5654,12 +5659,21 @@ static int ext4_expand_extra_isize(struct inode *inode,
>                      EXT4_I(inode)->i_extra_isize, 0,
>                      new_extra_isize - EXT4_I(inode)->i_extra_isize);
>               EXT4_I(inode)->i_extra_isize = new_extra_isize;
> +             ext4_write_unlock_xattr(inode, &no_expand);
>               return 0;
>       }
>
>       /* try to expand with EAs present */
> -     return ext4_expand_extra_isize_ea(inode, new_extra_isize,
> -                                       raw_inode, handle);
> +     error = ext4_expand_extra_isize_ea(inode, new_extra_isize,
> +                                        raw_inode, handle);
> +     if (error) {
> +             /*
> +              * Inode size expansion failed; don't try again
> +              */
> +             no_expand = 1;
> +     }
> +     ext4_write_unlock_xattr(inode, &no_expand);
> +     return error;
>  }
>
>  /*
> diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
> index 5d3c253..12ee5fb 100644
> --- a/fs/ext4/xattr.c
> +++ b/fs/ext4/xattr.c
> @@ -1472,10 +1472,6 @@ int ext4_expand_extra_isize_ea(struct inode *inode, int new_extra_isize,
>       int error = 0, tried_min_extra_isize = 0;
>       int s_min_extra_isize = le16_to_cpu(EXT4_SB(inode->i_sb)->s_es->s_min_extra_isize);
>       int isize_diff; /* How much do we need to grow i_extra_isize */
> -     int no_expand;
> -
> -     if (ext4_write_trylock_xattr(inode, &no_expand) == 0)
> -             return 0;
>
>  retry:
>       isize_diff = new_extra_isize - EXT4_I(inode)->i_extra_isize;
> @@ -1558,16 +1554,10 @@ int ext4_expand_extra_isize_ea(struct inode *inode, int new_extra_isize,
>       EXT4_I(inode)->i_extra_isize = new_extra_isize;
>       brelse(bh);
>  out:
> -     ext4_write_unlock_xattr(inode, &no_expand);
>       return 0;
>
>  cleanup:
>       brelse(bh);
> -     /*
> -      * Inode size expansion failed; don't try again
> -      */
> -     no_expand = 1;
> -     ext4_write_unlock_xattr(inode, &no_expand);
>       return error;
>  }
>
>
