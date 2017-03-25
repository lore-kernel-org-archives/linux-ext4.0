From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fix spelling of "don't"
Date: Sat, 25 Mar 2017 15:55:13 -0400
Message-ID: <20170325195513.uugak4xknknob6p5@thunk.org>
References: <1490073611.313465.918041856.1A5E4239@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Benjamin Peterson <bp@benjamin.pe>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:50628 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750899AbdCYT4E (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sat, 25 Mar 2017 15:56:04 -0400
Content-Disposition: inline
In-Reply-To: <1490073611.313465.918041856.1A5E4239@webmail.messagingengine.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 20, 2017 at 10:20:11PM -0700, Benjamin Peterson wrote:
> Signed-off-by: Benjamin Peterson <bp@benjamin.pe>

Hi Benjamin,

	I generally don't take spelling fixes unless it's part of a
related code change.  If you are a beginning kernel developer, most of
kernelnewbies tutorials advise beginners to send patches to the code
in the drivers/staging directory.

Also, please note that this patch arrived white-space damaged.  I'm
guessing it's because you are using a web-based engine, and it
line-wraped the patch, thus damaging it:

> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 7385e6a..4247d8d 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -5400,7 +5400,7 @@ int ext4_getattr(const struct path *path, struct
> kstat *stat,
>  	 * If there is inline data in the inode, the inode will normally
>  	 not
         ^^^^ webmail damage
>  	 * have data blocks allocated (it may have an external xattr
>  	 block).
         ^^^^ webmail damage

>  	 * Report at least one sector for such files, so tools like tar,
>  	 rsync,
         ^^^^ webmail damage
> -        * others doen't incorrectly think the file is completely
> sparse.
  ^^^^ webmail damage
> +        * others don't incorrectly think the file is completely sparse.
>  	 */
>  	if (unlikely(ext4_has_inline_data(inode)))
>  		stat->blocks += (stat->size + 511) >> 9;

Cheers,

					- Ted
