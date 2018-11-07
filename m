Return-Path: <SRS0=XuXQ=NS=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:49530 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726752AbeKHCEy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 7 Nov 2018 21:04:54 -0500
Date: Wed, 7 Nov 2018 11:33:46 -0500
From: "Theodore Y. Ts'o" <tytso@mit.edu>
To: Vasily Averin <vvs@virtuozzo.com>
Cc: linux-ext4@vger.kernel.org,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext4: missing !bh check in ext4_xattr_inode_write()
Message-ID: <20181107163346.GH9919@thunk.org>
References: <710ddac8-eb88-e631-3b27-74410039d15f@virtuozzo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <710ddac8-eb88-e631-3b27-74410039d15f@virtuozzo.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Nov 04, 2018 at 08:29:39PM +0300, Vasily Averin wrote:
> ext4_getblk() called with map_flags=0 can return NULL,
> it can lead to oops on bh dereferemce
> 
> Fixes e50e5129f384 ("ext4: xattr-in-inode support")
> Cc: stable@kernel.org # 4.13
> 
> Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
> ---
>  fs/ext4/xattr.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
> index 0b9688683526..6dc6c70828f0 100644
> --- a/fs/ext4/xattr.c
> +++ b/fs/ext4/xattr.c
> @@ -1384,6 +1384,8 @@ static int ext4_xattr_inode_write(handle_t *handle, struct inode *ea_inode,
>  		bh = ext4_getblk(handle, ea_inode, block, 0);
>  		if (IS_ERR(bh))
>  			return PTR_ERR(bh);
> +		if (!bh)
> +			return -ENOMEM;

ext4_getblk() should never return NULL here; and if it does, it won't
be because of ENOMEM.  If we did have a memory allocation problem, we
would have returned ERR_PTR(-ENOMEM). 

In the while loop above this point, the blocks in ea_inode would have
been allocated, and so when ext4_getblk() is called with map_flags ==
0, it will return NULL if there is a hole in the inode --- but we had
*just* allocated the blocks in question.

The only time that bh could be NULL, then, would be in the case of
something really going wrong; a programming error elsewhere (perhaps a
wild pointer dereference) or I/O error causing on-disk file system
corruption (although that would be highly unlikely given that we had
*just* allocated the blocks and so the metadata blocks in question
probably would still be in the cache).

If we do want to handle this case, what we should do is something like
call WARN_ON_ONCE(1), call ext4_error() since the file system may have
gotten corrupted, and then return -EFSCORRUPTED.

(Linus has said that there should be no new BUG_ON's, so the
WARN_ON_ONE is to help debugging, and flaging the file system as
corrupted is probably the best we could do here, and is marginally
better than what we do now, which is just let the Oops take place.)

						- Ted
