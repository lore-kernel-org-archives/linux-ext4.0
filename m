From: Jan Kara <jack@suse.cz>
Subject: Re: [patch 5/5] ext2: convert to use the new truncate convention.
Date: Tue, 1 Sep 2009 20:29:29 +0200
Message-ID: <20090901182929.GG8242@duck.novell.com>
References: <20090710073028.782561541@suse.de> <20090710073231.195528273@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, hch@infradead.org,
	viro@zeniv.linux.org.uk, jack@suse.cz, linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
To: npiggin@suse.de
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090710073231.195528273@suse.de>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

  Hi Nick,

On Fri 10-07-09 17:30:33, npiggin@suse.de wrote:
> I have some questions, marked with XXX.
> 
> Cc: linux-ext4@vger.kernel.org
> Signed-off-by: Nick Piggin <npiggin@suse.de>
> ---
>  fs/ext2/ext2.h  |    1 
>  fs/ext2/file.c  |    2 
>  fs/ext2/inode.c |  138 +++++++++++++++++++++++++++++++++++++++++++++-----------
>  3 files changed, 113 insertions(+), 28 deletions(-)
> 
> Index: linux-2.6/fs/ext2/inode.c
> ===================================================================
> --- linux-2.6.orig/fs/ext2/inode.c
> +++ linux-2.6/fs/ext2/inode.c
...
> +static void ext2_truncate_blocks(struct inode *inode, loff_t offset)
> +{
> +	/*
> +	 * XXX: it seems like a bug here that we don't allow
> +	 * IS_APPEND inode to have blocks-past-i_size trimmed off.
> +	 * review and fix this.
> +	 */
> +	if (!(S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode) ||
> +	    S_ISLNK(inode->i_mode)))
> +		return -EINVAL;
> +	if (ext2_inode_is_fast_symlink(inode))
> +		return -EINVAL;
> +	if (IS_APPEND(inode) || IS_IMMUTABLE(inode))
> +		return -EPERM;
> +	__ext2_truncate_blocks(inode, offset);
> +}
  Actually, looking again into this, I think you've introduced a subtle bug
into the code. When a write fails for some reason, we did vmtruncate()
previously which called block_truncate_page() which zeroed a tail of the
last block. Now, ext2_truncate_blocks() does not do this and I think it
could be a problem because at least in direct IO case, we could have written
some data into that block on disk.
  We really rely on the tail of the block being zeroed because otherwise
extending truncate will show those old data in the block. I plan to change
that in my mkwrite fixes but until then, we should preserve the old
assumptions.
  So I think that ext2_truncate_blocks() should do all that tail page magic
as well (although it's not needed in all cases).

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
