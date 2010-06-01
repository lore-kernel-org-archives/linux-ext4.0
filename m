From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/2] quota: check quota reservation on remove_dquot_ref
Date: Tue, 1 Jun 2010 13:54:33 +0200
Message-ID: <20100601115433.GD4275@quack.suse.cz>
References: <20100531191130.GE5334@quack.suse.cz>
 <1275377988-4299-1-git-send-email-dmonakhov@openvz.org>
 <1275377988-4299-2-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	jack@suse.cz
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1275377988-4299-2-git-send-email-dmonakhov@openvz.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue 01-06-10 11:39:48, Dmitry Monakhov wrote:
> Reserved space must being claimed before remove_dquot_ref() for a
> given inode. Filesystem is responsible for performing force blocks
> allocation in case of dealloc in ->quota_off. Let's add sanity check
> for that case. Do it similar to add_dquot_ref().
  Thanks. I've merged this patch since it's independent of the first one
(and unless someone runs with CONFIG_QUOTA_DEBUG it shouldn't cause
additional warnings either).

								Honza

> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> ---
>  fs/quota/dquot.c |   14 +++++++++++++-
>  1 files changed, 13 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
> index 12c233d..dfb8c16 100644
> --- a/fs/quota/dquot.c
> +++ b/fs/quota/dquot.c
> @@ -986,6 +986,7 @@ static void remove_dquot_ref(struct super_block *sb, int type,
>  		struct list_head *tofree_head)
>  {
>  	struct inode *inode;
> +	int reserved = 0;
>  
>  	spin_lock(&inode_lock);
>  	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
> @@ -995,10 +996,21 @@ static void remove_dquot_ref(struct super_block *sb, int type,
>  		 *  only quota pointers and these have separate locking
>  		 *  (dqptr_sem).
>  		 */
> -		if (!IS_NOQUOTA(inode))
> +		if (!IS_NOQUOTA(inode)) {
> +			if (unlikely(inode_get_rsv_space(inode) > 0))
> +				reserved = 1;
>  			remove_inode_dquot_ref(inode, type, tofree_head);
> +		}
>  	}
>  	spin_unlock(&inode_lock);
> +#ifdef CONFIG_QUOTA_DEBUG
> +	if (reserved) {
> +		printk(KERN_WARNING "VFS (%s): Writes happened after quota"
> +			" was disabled thus quota information is probably "
> +			"inconsistent. Please run quotacheck(8).\n", sb->s_id);
> +	}
> +#endif
> +
>  }
>  
>  /* Gather all references from inodes and drop them */
> -- 
> 1.6.6.1
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
