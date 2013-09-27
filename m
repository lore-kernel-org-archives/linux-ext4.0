From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: avoid exposure of stale data in ext4_punch_hole()
 -v2
Date: Fri, 27 Sep 2013 18:05:17 +0200
Message-ID: <20130927160517.GA5777@quack.suse.cz>
References: <20130926173113.23276.77451.stgit@dhcp-10-30-17-2.sw.ru>
 <20130927155329.3272.64086.stgit@dhcp-10-30-17-2.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org, jack@suse.cz,
	linux-kernel@vger.kernel.org
To: Maxim Patlasov <MPatlasov@parallels.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130927155329.3272.64086.stgit@dhcp-10-30-17-2.sw.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri 27-09-13 19:54:03, Maxim Patlasov wrote:
> While handling punch-hole fallocate, it's useless to truncate page cache
> before removing the range from extent tree (or block map in indirect case)
> because page cache can be re-populated (by read-ahead or read(2) or mmap-ed
> read) immediately after truncating page cache, but before updating extent
> tree (or block map). In that case the user will see stale data even after
> fallocate is completed.
> 
> Changed in v2 (Thanks to Jan Kara):
>  - Until the problem of data corruption resulting from pages backed by
>    already freed blocks is fully resolved, the simple thing we can do now
>    is to add another truncation of pagecache after punch hole is done.
  The patch looks good. You can add:
Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> Signed-off-by: Maxim Patlasov <mpatlasov@parallels.com>
> ---
>  fs/ext4/inode.c |    6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 0d424d7..2984ddf 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -3621,6 +3621,12 @@ int ext4_punch_hole(struct inode *inode, loff_t offset, loff_t length)
>  	up_write(&EXT4_I(inode)->i_data_sem);
>  	if (IS_SYNC(inode))
>  		ext4_handle_sync(handle);
> +
> +	/* Now release the pages again to reduce race window */
> +	if (last_block_offset > first_block_offset)
> +		truncate_pagecache_range(inode, first_block_offset,
> +					 last_block_offset);
> +
>  	inode->i_mtime = inode->i_ctime = ext4_current_time(inode);
>  	ext4_mark_inode_dirty(handle, inode);
>  out_stop:
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
