From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH -v2] ext4: respect the nobarrier mount option in
 nojournal mode
Date: Thu, 16 Jun 2016 20:07:37 +0200
Message-ID: <20160616180737.GD2106@quack2.suse.cz>
References: <8421f4bf-a49c-572c-c8db-29709a17eee6@redhat.com>
 <1465584290-2101-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45211 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753853AbcFPSHo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 16 Jun 2016 14:07:44 -0400
Content-Disposition: inline
In-Reply-To: <1465584290-2101-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri 10-06-16 14:44:50, Ted Tso wrote:
> Also, if we are going to issue the barrier, we should do this after we
> write out the parent directories if necessary.
> 
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>

The patch looks good. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/fsync.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/fsync.c b/fs/ext4/fsync.c
> index 8850254..5c43725 100644
> --- a/fs/ext4/fsync.c
> +++ b/fs/ext4/fsync.c
> @@ -106,9 +106,11 @@ int ext4_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
>  	}
>  
>  	if (!journal) {
> -		ret = generic_file_fsync(file, start, end, datasync);
> +		ret = __generic_file_fsync(file, start, end, datasync);
>  		if (!ret && !hlist_empty(&inode->i_dentry))
>  			ret = ext4_sync_parent(inode);
> +		if (test_opt(inode->i_sb, BARRIER))
> +			goto issue_flush;
>  		goto out;
>  	}
>  
> @@ -140,6 +142,7 @@ int ext4_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
>  		needs_barrier = true;
>  	ret = jbd2_complete_transaction(journal, commit_tid);
>  	if (needs_barrier) {
> +	issue_flush:
>  		err = blkdev_issue_flush(inode->i_sb->s_bdev, GFP_KERNEL, NULL);
>  		if (!ret)
>  			ret = err;
> -- 
> 2.5.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
