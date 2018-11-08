Return-Path: <SRS0=LXqi=NT=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:54324 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726421AbeKIAaY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 8 Nov 2018 19:30:24 -0500
Date: Thu, 8 Nov 2018 09:54:29 -0500
From: "Theodore Y. Ts'o" <tytso@mit.edu>
To: Vasily Averin <vvs@virtuozzo.com>
Cc: linux-ext4@vger.kernel.org,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ext4: missing !bh check in ext4_xattr_inode_write()
Message-ID: <20181108145429.GE22459@thunk.org>
References: <20181107163346.GH9919@thunk.org>
 <a3f1e28c-fba0-2b07-b710-c559fab555b8@virtuozzo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a3f1e28c-fba0-2b07-b710-c559fab555b8@virtuozzo.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Nov 08, 2018 at 09:46:30AM +0300, Vasily Averin wrote:
> diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
> index 0b9688683526..415f73d4c9e6 100644
> --- a/fs/ext4/xattr.c
> +++ b/fs/ext4/xattr.c
> @@ -1384,6 +1384,12 @@ static int ext4_xattr_inode_write(handle_t *handle, struct inode *ea_inode,
>  		bh = ext4_getblk(handle, ea_inode, block, 0);
>  		if (IS_ERR(bh))
>  			return PTR_ERR(bh);
> +		if (!bh) {
> +			WARN_ON_ONCE(1);
> +			__ext4_error_inode(ea_inode, __func__, __LINE__, 0,
> +					   "ext4_getblk() return bh = NULL");

You should use EXT4_ERROR_INODE(), defined in ext4.h, not
__ext4_error_inode().  That way you don't need to explicitly specify
__func__ and __LINE__, and we the compiler will correctly do printf
format checking even when CONFIG_PRINTK is not set.

						- Ted
