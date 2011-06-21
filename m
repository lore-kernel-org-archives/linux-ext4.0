From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH] Free allocated and pre-allocated blocks when check_eofblocks_fl
 fails
Date: Tue, 21 Jun 2011 17:24:58 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1106211717100.21178@dhcp-27-109.brq.redhat.com>
References: <20110621032816.6A0A942247@ruihe.smo.corp.google.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: Jiaying Zhang <jiayingz@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32855 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751603Ab1FUPZD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 21 Jun 2011 11:25:03 -0400
In-Reply-To: <20110621032816.6A0A942247@ruihe.smo.corp.google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 20 Jun 2011, Jiaying Zhang wrote:

> We have hit the same BUG_ON as described in
> https://bugzilla.kernel.org/show_bug.cgi?id=31222
> on some of our servers that have disk failures or corrupted inodes. After
> looking at the code, I think the problem is that we are not freeing inode's
> preallocation list when check_eofblocks_fl fails in ext4_ext_map_blocks(),
> which leaves the inode's preallocation list in an inconsistent state.
> 
> Below is a proposed patch to fix the bug. I have tested it by manually
> inserting a random failure in check_eofblocks_fl() and run a test that
> creates and uses an inode's preallocated blocks. Without the fix, the kernel
> crashes after a few runs. With the fix, no crash is observed.
>     
> ext4: free allocated and pre-allocated blocks when check_eofblocks_fl fails
> 
> Upon corrupted inode or disk failures, we may fail after we already allocate
> some blocks from the inode or take some blocks from the inode's preallocation
> list, but before we successfully insert the corresponding extent to the extent
> tree. In this case, we should free any allocated blocks and discard the inode's
> preallocated blocks because the entries in the inode's preallocation list may
> be in an inconsistent state.
> 
> Signed-off-by: Jiaying Zhang <jiayingz@google.com>

Hi,

the change looks good to me (with one note), but the patch itself is not very
well formated, and Ted would have to copy it out. Please use this:

ext4: free allocated and pre-allocated blocks when check_eofblocks_fl fails

for Subject line and put any comments which should not appear in the
commit description after signed-off-by line starting with "--- " line.
Or just use git format-patch.

> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 5199bac..8cf6ec9 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -3596,10 +3596,8 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
>  	}
>  
>  	err = check_eofblocks_fl(handle, inode, map->m_lblk, path, ar.len);
> -	if (err)
> -		goto out2;
> -
> -	err = ext4_ext_insert_extent(handle, inode, path, &newex, flags);
> +	if (!err)
> +		err = ext4_ext_insert_extent(handle, inode, path, &newex, flags);
>  	if (err) {

why not to use:
	else {


>  		/* free data blocks we just allocated */
>  		/* not a good idea to call discard here directly,
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

Thanks!
-Lukas
