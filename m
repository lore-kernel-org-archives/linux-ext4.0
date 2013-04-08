From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH] ext4: Do not convert to indirect with bigalloc enabled
Date: Mon, 8 Apr 2013 13:59:43 +0800
Message-ID: <20130408055943.GA328@gmail.com>
References: <1365070685-5088-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f181.google.com ([209.85.192.181]:35129 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756087Ab3DHFmw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 8 Apr 2013 01:42:52 -0400
Received: by mail-pd0-f181.google.com with SMTP id y10so3030539pdj.26
        for <linux-ext4@vger.kernel.org>; Sun, 07 Apr 2013 22:42:51 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1365070685-5088-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Apr 04, 2013 at 12:18:05PM +0200, Lukas Czerner wrote:
> With bigalloc feature enabled we do not support indirect addressing at all
> so we have to prevent extent addressing to indirect addressing
> conversion in this case. The problem has been introduced with the commit
> "ext4: support simple conversion of extent-mapped inodes to use i_blocks"
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

Looks good to me.
Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>

Regards,
                                                - Zheng

> ---
>  fs/ext4/extents.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 6c5a70a..ddb6628 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -4735,6 +4735,10 @@ int ext4_ind_migrate(struct inode *inode)
>  	    (!ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)))
>  		return -EINVAL;
>  
> +	if (EXT4_HAS_RO_COMPAT_FEATURE(inode->i_sb,
> +				       EXT4_FEATURE_RO_COMPAT_BIGALLOC))
> +		return -EOPNOTSUPP;
> +
>  	down_write(&EXT4_I(inode)->i_data_sem);
>  	ret = ext4_ext_check_inode(inode);
>  	if (ret)
> -- 
> 1.7.7.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
