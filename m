From: Dan Carpenter <error27@gmail.com>
Subject: Re: [PATCH] check name_len before down_read xattr_sem and sb_read
	in ext2_xattr_get
Date: Tue, 13 Jul 2010 16:56:08 +0200
Message-ID: <20100713145608.GM5658@bicker>
References: <201007122229025316610@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	kernel-janitors <kernel-janitors@vger.kernel.org>
To: crosslonelyover <crosslonelyover@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:61755 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752510Ab0GMO5x (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 13 Jul 2010 10:57:53 -0400
Content-Disposition: inline
In-Reply-To: <201007122229025316610@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 12, 2010 at 10:29:09PM +0800, crosslonelyover wrote:
> Hi,
>        I walked through ext2_xattr_get, and felt that we can
> do some optimization on it. For name_len check, it's done
> after down xattr_sem and sb_read, both of which are time
> consuming operation compared with strlen:
>          down_read(&EXT2_I(inode)->xattr_sem);
>  ...
>          bh = sb_bread(inode->i_sb, EXT2_I(inode)->i_file_acl);
>  ...
>          /* find named attribute */
>          name_len = strlen(name);
> 
>          error = -ERANGE;
>          if (name_len > 255)
>                  goto cleanup;
> 
>        Most of the case, you'll get one valid block, but if the
> name len > 255, then the xattr_sem down and sb_bread operation
> can be seen as a waste of time. So I think we'd better do
> name len check as early as possible.
>        Following is my patch, and it's against 2.6.35-rc4.
> Please check it.
> 
> Signed-off-by: Wang Sheng-Hui <crosslonelyover@gmail.com>
> ---
>  fs/ext2/xattr.c |   12 +++++++-----
>  1 files changed, 7 insertions(+), 5 deletions(-)

For what it's worth, this change looks OK to me.

Reviewed-by: Dan Carpenter <error27@gmail.com>

regards,
dan carpenter


