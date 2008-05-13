From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] ext3/4: fix uninitialized bs in
 ext3/4_xattr_set_handle()
Date: Mon, 12 May 2008 17:02:54 -0700
Message-ID: <20080512170254.f79fe869.akpm@linux-foundation.org>
References: <4827B878.50903@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, Andreas Gruenbacher <agruen@suse.de>,
	stable@kernel.org
To: Tiger Yang <tiger.yang@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41492 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756009AbYEMADx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 12 May 2008 20:03:53 -0400
In-Reply-To: <4827B878.50903@oracle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 12 May 2008 11:24:40 +0800
Tiger Yang <tiger.yang@oracle.com> wrote:

> I met a bug when I try to replace a xattr entry in ibody with a big size 
> value. But in ibody there has no space for the new value. So it should 
> set new xattr entry in block and remove the old xattr entry in ibody.
> 
> Best regards,
> tiger
> 
> 
> [xattr.patch  text/x-patch (1.3KB)]
> This fix the uninitialized bs when we try to replace a xattr entry in ibody with the new value which require more than free space.
> 
> Signed-off-by: Tiger Yang <tiger.yang@oracle.com>
> 
> diff --git a/fs/ext3/xattr.c b/fs/ext3/xattr.c
> index a6ea4d6..e1af9bd 100644
> --- a/fs/ext3/xattr.c
> +++ b/fs/ext3/xattr.c
> @@ -1000,6 +1000,11 @@ ext3_xattr_set_handle(handle_t *handle, struct inode *inode, int name_index,
>  			i.value = NULL;
>  			error = ext3_xattr_block_set(handle, inode, &i, &bs);
>  		} else if (error == -ENOSPC) {
> +			if (EXT3_I(inode)->i_file_acl && !bs.s.base) {
> +				error = ext3_xattr_block_find(inode, &i, &bs);
> +				if (error)
> +					goto cleanup;
> +			}
>  			error = ext3_xattr_block_set(handle, inode, &i, &bs);
>  			if (error)
>  				goto cleanup;

That sounds fairly bad.

What are the consequences of this bug, when someone hits it?

It appears that we should backport this fix into 2.6.25.x (and perhaps
earlier).  What do you think?

