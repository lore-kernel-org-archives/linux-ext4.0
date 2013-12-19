From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: [PATCH 2/2] ext4: ext4_inode_is_fast_symlink should use cluster size
Date: Thu, 19 Dec 2013 14:40:42 +0800
Message-ID: <CAGBYx2a1w+REq6634mOpSZhWWSVuYMuXy48LhAJq7q4kB5Wdew@mail.gmail.com>
References: <1387435099-11163-1-git-send-email-yangyongqiang01@baidu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	"Theodore Ts'o" <tytso@mit.edu>
To: Yongqiang Yang <yangyongqiang01@baidu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ee0-f47.google.com ([74.125.83.47]:36558 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196Ab3LSGlE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 19 Dec 2013 01:41:04 -0500
Received: by mail-ee0-f47.google.com with SMTP id e51so207206eek.34
        for <linux-ext4@vger.kernel.org>; Wed, 18 Dec 2013 22:41:02 -0800 (PST)
In-Reply-To: <1387435099-11163-1-git-send-email-yangyongqiang01@baidu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

can be reproduced by xfstests 62 with  bigalloc and 128bit size inode.

Thanks,
Yongqiang.

On Thu, Dec 19, 2013 at 2:38 PM, Yongqiang Yang
<yangyongqiang01@baidu.com> wrote:
> From: Yongqiang Yang <xiaoqiangnk@gmail.com>
>
> Signed-off-by: Yongqiang Yang <yangyongqiang01@baidu.com>
> ---
>  fs/ext4/inode.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 9115f28..1869fcf 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -145,7 +145,7 @@ static int ext4_meta_trans_blocks(struct inode *inode, int lblocks,
>  static int ext4_inode_is_fast_symlink(struct inode *inode)
>  {
>         int ea_blocks = EXT4_I(inode)->i_file_acl ?
> -               (inode->i_sb->s_blocksize >> 9) : 0;
> +                       EXT4_CLUSTER_SIZE(inode->i_sb) >> 9 : 0;
>
>         return (S_ISLNK(inode->i_mode) && inode->i_blocks - ea_blocks == 0);
>  }
> --
> 1.8.5.2
>



-- 
Best Wishes
Yongqiang Yang
