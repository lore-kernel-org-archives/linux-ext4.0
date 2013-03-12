From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH] Ext2: do not mark_inode_dirty to avoid BUG_ON
Date: Tue, 12 Mar 2013 09:14:21 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1303120904030.7128@dhcp-1-104.brq.redhat.com>
References: <513EB7DD.3020103@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: jack@suse.cz, tyhicks@canonical.com, linux-ext4@vger.kernel.org,
	wangshilong1991@gmail.com
To: fanchaoting <fanchaoting@cn.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32049 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754019Ab3CLIPN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 12 Mar 2013 04:15:13 -0400
In-Reply-To: <513EB7DD.3020103@cn.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 12 Mar 2013, fanchaoting wrote:

> Date: Tue, 12 Mar 2013 13:06:37 +0800
> From: fanchaoting <fanchaoting@cn.fujitsu.com>
> To: jack@suse.cz
> Cc: tyhicks@canonical.com, linux-ext4@vger.kernel.org,
>     wangshilong1991@gmail.com
> Subject: [PATCH] Ext2: do not mark_inode_dirty to avoid BUG_ON
> 
> From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
> 
> commit 8e3dffc651cb668e1ff4d8b89cc1c3dde7540d3b leads into
> a regression that casue BUG_ON when unlinking inode.

Hi,

it seems to be that we do need to mark the inode dirty, because
we're changing inode->i_blocks from within
dquot_free_block_nodirty().

However looking at the code we usually call mark_inode_dirty(inode)
after we call ext2_free_blocks() except when we're about to remove
the inode so it seems that having that call within ext2_free_blocks()
is not necessary.

However I am not sure about the error path in ext2_alloc_branch()
which does not dirty the inode after calling ext2_free_blocks().
However presumably since we're just undoing the changes we might
have done and not actually allocating, or freeing any space for
real, dirtying the inode might not be necessary. Can you confirm
that ?

Thanks!
-Lukas

> 
> Reported-by: tyhicks@canonical.com
> Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
> ---
>  fs/ext2/balloc.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ext2/balloc.c b/fs/ext2/balloc.c
> index 9f9992b..06d82fc 100644
> --- a/fs/ext2/balloc.c
> +++ b/fs/ext2/balloc.c
> @@ -562,7 +562,6 @@ error_return:
>  	if (freed) {
>  		percpu_counter_add(&sbi->s_freeblocks_counter, freed);
>  		dquot_free_block_nodirty(inode, freed);
> -		mark_inode_dirty(inode);
>  	}
>  }
>  
> -- 1.7.7.6 
> 
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
