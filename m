From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/5] ext4: let ext4 journal deletion of data blocks
Date: Wed, 28 Dec 2011 12:23:24 -0500
Message-ID: <20111228172324.GB12370@thunk.org>
References: <1321344474-14707-1-git-send-email-xiaoqiangnk@gmail.com>
 <1321344474-14707-2-git-send-email-xiaoqiangnk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:47206 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753779Ab1L1RX3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 28 Dec 2011 12:23:29 -0500
Content-Disposition: inline
In-Reply-To: <1321344474-14707-2-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Nov 15, 2011 at 04:07:51PM +0800, Yongqiang Yang wrote:
> This patch lets ext4 journal deletion of data blocks. Besides this,
> a unnecessary variable is removed.
> 
> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>

I don't see the point of this patch; it seems to be a code
simplification, but in fact it introduces a bug which has to get fixed
in patch 3/5 of this series.

The code here is a little arcane, because if bh is non-null, then
count must be 1.  This is expressed in the BUG_ON found in the
function:

>  		BUG_ON(bh && (count > 1));

The reason for this bit of complexity is to avoid needing to call
sb_find_get_block() in those places where we have the buffer_head
already.  This happens in exactly two locations: in an error cleanup
path in fs/ext4/indirect.c, and when releasing an xattr block in
ext4_xattr_release_block().

The better way of dealing with this is to drop the bh argument from
ext4_free_blocks() completely, and explicitly call ext4_forget() on
the bh in those two functions.

This will require changing all of the call sites of
ext4_free_blocks(), but it simplifies the function signature as well
as simplifying the code.

					- Ted

>  fs/ext4/mballoc.c |    7 ++-----
>  1 files changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index e2d8be8..2529efc 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -4562,19 +4562,16 @@ void ext4_free_blocks(handle_t *handle, struct inode *inode,
>  	trace_ext4_free_blocks(inode, block, count, flags);
>  
>  	if (flags & EXT4_FREE_BLOCKS_FORGET) {
> -		struct buffer_head *tbh = bh;
>  		int i;
>  
>  		BUG_ON(bh && (count > 1));
>  
>  		for (i = 0; i < count; i++) {
>  			if (!bh)
> -				tbh = sb_find_get_block(inode->i_sb,
> +				bh = sb_find_get_block(inode->i_sb,
>  							block + i);
> -			if (unlikely(!tbh))
> -				continue;
>  			ext4_forget(handle, flags & EXT4_FREE_BLOCKS_METADATA,
> -				    inode, tbh, block + i);
> +				    inode, bh, block + i);
>  		}
>  	}
>  
> -- 
> 1.7.5.1
> 
