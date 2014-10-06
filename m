From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/2] ext4: don't orphan or truncate the boot loader inode
Date: Mon, 6 Oct 2014 17:06:47 +0200
Message-ID: <20141006150647.GH7526@quack.suse.cz>
References: <20141005001239.GD27150@sli.dy.fi>
 <1412563682-5720-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	stable@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54169 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752758AbaJFPGt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 6 Oct 2014 11:06:49 -0400
Content-Disposition: inline
In-Reply-To: <1412563682-5720-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun 05-10-14 22:48:01, Ted Tso wrote:
> The boot loader inode (inode #5) should never be visible in the
> directory hierarchy, but it's possible if the file system is corrupted
> that there will be a directory entry that points at inode #5.  In
> order to avoid accidentally trashing it, when such a directory inode
> is opened, the inode will be marked as a bad inode, so that it's not
> possible to modify (or read) the inode from userspace.
> 
> Unfortunately, when we unlink this (invalid/illegal) directory entry,
> we will put the bad inode on the ophan list, and then when try to
> unlink the directory, we don't actually remove the bad inode from the
> orphan list before freeing in-memory inode structure.  This means the
> in-memory orphan list is corrupted, leading to a kernel oops.
> 
> In addition, avoid truncating a bad inode in ext4_destroy_inode(),
> since truncating the boot loader inode is not a smart thing to do.
> 
> Reported-by: Sami Liedes <sami.liedes@iki.fi>
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> Cc: stable@vger.kernel.org
  The patch looks good. You can add:
Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/inode.c | 7 +++----
>  fs/ext4/namei.c | 2 +-
>  2 files changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 41c4f97..59983b2 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -224,16 +224,15 @@ void ext4_evict_inode(struct inode *inode)
>  		goto no_delete;
>  	}
>  
> -	if (!is_bad_inode(inode))
> -		dquot_initialize(inode);
> +	if (is_bad_inode(inode))
> +		goto no_delete;
> +	dquot_initialize(inode);
>  
>  	if (ext4_should_order_data(inode))
>  		ext4_begin_ordered_truncate(inode, 0);
>  	truncate_inode_pages_final(&inode->i_data);
>  
>  	WARN_ON(atomic_read(&EXT4_I(inode)->i_ioend_count));
> -	if (is_bad_inode(inode))
> -		goto no_delete;
>  
>  	/*
>  	 * Protect us against freezing - iput() caller didn't have to have any
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index 51705f8..a2a9d40 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -2544,7 +2544,7 @@ int ext4_orphan_add(handle_t *handle, struct inode *inode)
>  	int err = 0, rc;
>  	bool dirty = false;
>  
> -	if (!sbi->s_journal)
> +	if (!sbi->s_journal || is_bad_inode(inode))
>  		return 0;
>  
>  	WARN_ON_ONCE(!(inode->i_state & (I_NEW | I_FREEING)) &&
> -- 
> 2.1.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
