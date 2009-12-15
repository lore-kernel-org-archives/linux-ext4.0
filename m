From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: fix sleep inside spinlock issue aka #14739 V2
Date: Tue, 15 Dec 2009 22:48:06 +0100
Message-ID: <20091215214806.GD9554@quack.suse.cz>
References: <1260409362-4349-1-git-send-email-dmonakhov@openvz.org>
 <20091210161553.GG26516@atrey.karlin.mff.cuni.cz>
 <87bpi6zquv.fsf_-_@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>, cmm@us.ibm.com
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:52440 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932817AbZLOVsO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 15 Dec 2009 16:48:14 -0500
Content-Disposition: inline
In-Reply-To: <87bpi6zquv.fsf_-_@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 10-12-09 20:22:16, Dmitry Monakhov wrote:
> 
> drop i_block_reservation_lock before vfs_dq_reserve_block().
> this patch fix http://bugzilla.kernel.org/show_bug.cgi?id=14739
> 
> changes from previous version:
>  - simplify the patch according to Jan's comments
  Dmitry, I suppose I should also merge this patch together with your other
fixes, right? For some reason, it was not part of the last submission of
your patch series...

								Honza

> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> ---
>  fs/ext4/inode.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 942e183..2327f7a 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -1851,6 +1851,7 @@ repeat:
>  
>  	md_needed = mdblocks - EXT4_I(inode)->i_reserved_meta_blocks;
>  	total = md_needed + nrblocks;
> +	spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
>  
>  	/*
>  	 * Make quota reservation here to prevent quota overflow
> @@ -1858,12 +1859,10 @@ repeat:
>  	 * time.
>  	 */
>  	if (vfs_dq_reserve_block(inode, total)) {
> -		spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
>  		return -EDQUOT;
>  	}
>  
>  	if (ext4_claim_free_blocks(sbi, total)) {
> -		spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
>  		vfs_dq_release_reservation_block(inode, total);
>  		if (ext4_should_retry_alloc(inode->i_sb, &retries)) {
>  			yield();
> @@ -1871,10 +1870,11 @@ repeat:
>  		}
>  		return -ENOSPC;
>  	}
> +	spin_lock(&EXT4_I(inode)->i_block_reservation_lock);
>  	EXT4_I(inode)->i_reserved_data_blocks += nrblocks;
>  	EXT4_I(inode)->i_reserved_meta_blocks = mdblocks;
> -
>  	spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
> +
>  	return 0;       /* success */
>  }
>  
> -- 
> 1.6.0.4
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
