From: Dan Carpenter <error27@gmail.com>
Subject: Re: [PATCH]trivial: clear the comment on parameters for
	ext2_xattr_set
Date: Tue, 13 Jul 2010 21:24:26 +0200
Message-ID: <20100713192426.GQ5658@bicker>
References: <4C3C8043.3030700@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kernel-janitors <kernel-janitors@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>
To: Wang Sheng-Hui <crosslonelyover@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44309 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752212Ab0GMT0I (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 13 Jul 2010 15:26:08 -0400
Content-Disposition: inline
In-Reply-To: <4C3C8043.3030700@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jul 13, 2010 at 11:03:31PM +0800, Wang Sheng-Hui wrote:
> diff --git a/fs/ext2/xattr.c b/fs/ext2/xattr.c
> index 5ecbbd8..f56b599 100644
> --- a/fs/ext2/xattr.c
> +++ b/fs/ext2/xattr.c
> @@ -355,7 +355,7 @@ static void ext2_xattr_update_super_block(struct
> super_block *sb)
> /*
> * ext2_xattr_set()
> *
> - * Create, replace or remove an extended attribute for this inode. Buffer
> + * Create, replace or remove an extended attribute for this inode. Value
> * is NULL to remove an existing extended attribute, and non-NULL to

It is talking about the "value" parameter, but your email client mangled
this patch so it doesn't apply.

regards,
dan carpenter

