From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: NULL pointer dereference in ext4_ext_remove_space on 3.5.1
Date: Mon, 17 Sep 2012 16:21:44 +0400
Message-ID: <87fw6get5z.fsf@openvz.org>
References: <CABRT9RAOhaxcYdCxMn5neJ9WT85r=h=7WgZ2dmLaOs-MMqDW9A@mail.gmail.com> <20120816024654.GB3781@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Kernel hackers <linux-kernel@vger.kernel.org>,
	ext4 hackers <linux-ext4@vger.kernel.org>, maze@google.com
To: Theodore Ts'o <tytso@mit.edu>, Marti Raudsepp <marti@juffo.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:45533 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755969Ab2IQMVs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 17 Sep 2012 08:21:48 -0400
In-Reply-To: <20120816024654.GB3781@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 15 Aug 2012 22:46:54 -0400, Theodore Ts'o <tytso@mit.edu> wrote:
> On Wed, Aug 15, 2012 at 09:33:29PM +0300, Marti Raudsepp wrote:
> > I was moving and deleting some files between two of my ext4 partitions
> > when it suddenly crashed and dropped me into an kernel oops screen
> > (below). I'm using ext4 on kernel 3.5.1 (Arch Linux). 
Ohh, I've missed that gigantic topic, but still i've found the bug.
patch is available here http://patchwork.ozlabs.org/patch/183649/
> 
> > BUG: unable to handle kernel NULL pointer dereference at 000...00028
> > IP: [...] ext4_ext_remove_space+0xaa4/0xef0 [ext4]
> 
> Someone else has reported a similar crash, but we don't yet have
> enough information to narrow it down quite yet.
> 
> If you could try applying the following debugging patch, and then try
> to reproduce the failure, it would be really helpful.
> 
> Thanks!!
> 
> 					- Ted
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 769151d..3394d52 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -2432,6 +2432,10 @@ ext4_ext_rm_leaf(handle_t *handle, struct inode *inode,
>  
>  	/* the header must be checked already in ext4_ext_remove_space() */
>  	ext_debug("truncate since %u in leaf to %u\n", start, end);
> +	if (!path[depth].p_hdr && !path[depth].p_bh) {
> +		EXT4_ERROR_INODE(inode, "depth %d", depth);
> +		BUG_ON(1);
> +	}
>  	if (!path[depth].p_hdr)
>  		path[depth].p_hdr = ext_block_hdr(path[depth].p_bh);
>  	eh = path[depth].p_hdr;
> @@ -2730,6 +2734,10 @@ cont:
>  		/* this is index block */
>  		if (!path[i].p_hdr) {
>  			ext_debug("initialize header\n");
> +			if (!path[i].p_hdr && !path[i].p_bh) {
> +				EXT4_ERROR_INODE(inode, "i=%d", i);
> +				BUG_ON(1);
> +			}
>  			path[i].p_hdr = ext_block_hdr(path[i].p_bh);
>  		}
>  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
