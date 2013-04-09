From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH 2/2 v2] ext4: Do not convert to indirect with bigalloc
 enabled
Date: Tue, 9 Apr 2013 20:48:18 +0800
Message-ID: <20130409124818.GB11144@gmail.com>
References: <1365506687-9216-1-git-send-email-lczerner@redhat.com>
 <1365506687-9216-2-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f175.google.com ([209.85.192.175]:36775 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936814Ab3DIMbZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 9 Apr 2013 08:31:25 -0400
Received: by mail-pd0-f175.google.com with SMTP id g10so3545200pdj.34
        for <linux-ext4@vger.kernel.org>; Tue, 09 Apr 2013 05:31:24 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1365506687-9216-2-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Apr 09, 2013 at 01:24:47PM +0200, Lukas Czerner wrote:
> With bigalloc feature enabled we do not support indirect addressing at all
> so we have to prevent extent addressing to indirect addressing
> conversion in this case. The problem has been introduced with the commit
> "ext4: support simple conversion of extent-mapped inodes to use i_blocks"
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>

Regards,
                                                - Zheng

> ---
> v2: added to the series
> 
>  fs/ext4/migrate.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/ext4/migrate.c b/fs/ext4/migrate.c
> index 3464604..f13a289 100644
> --- a/fs/ext4/migrate.c
> +++ b/fs/ext4/migrate.c
> @@ -625,6 +625,10 @@ int ext4_ind_migrate(struct inode *inode)
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
