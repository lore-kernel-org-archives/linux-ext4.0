From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/2] ext3: Don't update ctime in ext3_splice_branch()
Date: Mon, 30 Jan 2012 18:52:17 +0100
Message-ID: <20120130175217.GA7827@quack.suse.cz>
References: <4F2657BD.8030208@sx.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 <linux-ext4@vger.kernel.org>, Jan Kara <jack@suse.cz>,
	Andreas Dilger <adilger@dilger.ca>
To: Kazuya Mio <k-mio@sx.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44878 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752028Ab2A3RwT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 30 Jan 2012 12:52:19 -0500
Content-Disposition: inline
In-Reply-To: <4F2657BD.8030208@sx.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 30-01-12 17:41:33, Kazuya Mio wrote:
> VFS handles updating ctime, so we don't need to update i_ctime
> in ext3_splace_branch().
  Thanks for the patches.  This is true for ordinary writes but not true
when you write via mmap. We call file_update_time() during page fault so
ctime won't be completely wrong but still we should update it after block
is allocated during writeback to reflect that new block is allocated to
the inode.

								Honza

> I backport the following patch for ext3:
> http://marc.info/?l=linux-ext4&m=124505184027078&w=4
> 
> Signed-off-by: Kazuya Mio <k-mio@sx.jp.nec.com>
> ---
>  fs/ext3/inode.c |    6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
> diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
> index 2d0afec..95cb0d1 100644
> --- a/fs/ext3/inode.c
> +++ b/fs/ext3/inode.c
> @@ -795,10 +795,6 @@ static int ext3_splice_branch(handle_t *handle, struct inode *inode,
>  	}
>  
>  	/* We are done with atomic stuff, now do the rest of housekeeping */
> -
> -	inode->i_ctime = CURRENT_TIME_SEC;
> -	ext3_mark_inode_dirty(handle, inode);
> -	/* ext3_mark_inode_dirty already updated i_sync_tid */
>  	atomic_set(&ei->i_datasync_tid, handle->h_transaction->t_tid);
>  
>  	/* had we spliced it onto indirect block? */
> @@ -819,9 +815,9 @@ static int ext3_splice_branch(handle_t *handle, struct inode *inode,
>  	} else {
>  		/*
>  		 * OK, we spliced it into the inode itself on a direct block.
> -		 * Inode was dirtied above.
>  		 */
>  		jbd_debug(5, "splicing direct\n");
> +		ext3_mark_inode_dirty(handle, inode);
>  	}
>  	return err;
>  
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
