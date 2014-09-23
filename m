From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 3/3] ext4: fold ext4_nojournal_sops into ext4_sops
Date: Tue, 23 Sep 2014 14:31:48 +0200
Message-ID: <20140923123148.GG2359@quack.suse.cz>
References: <1411071989-4974-1-git-send-email-tytso@mit.edu>
 <1411071989-4974-3-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Dexuan Cui <decui@microsoft.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36844 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751860AbaIWMbv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 23 Sep 2014 08:31:51 -0400
Content-Disposition: inline
In-Reply-To: <1411071989-4974-3-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 18-09-14 16:26:29, Ted Tso wrote:
> There's no longer any need to have a separate set of super_operations
> for nojournal mode.
> 
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
  Nice :) You can add:
Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/super.c | 27 +--------------------------
>  1 file changed, 1 insertion(+), 26 deletions(-)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 921d5b4..e747b97 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -1123,27 +1123,6 @@ static const struct super_operations ext4_sops = {
>  	.bdev_try_to_free_page = bdev_try_to_free_page,
>  };
>  
> -static const struct super_operations ext4_nojournal_sops = {
> -	.alloc_inode	= ext4_alloc_inode,
> -	.destroy_inode	= ext4_destroy_inode,
> -	.write_inode	= ext4_write_inode,
> -	.dirty_inode	= ext4_dirty_inode,
> -	.drop_inode	= ext4_drop_inode,
> -	.evict_inode	= ext4_evict_inode,
> -	.sync_fs	= ext4_sync_fs,
> -	.freeze_fs	= ext4_freeze,
> -	.unfreeze_fs	= ext4_unfreeze,
> -	.put_super	= ext4_put_super,
> -	.statfs		= ext4_statfs,
> -	.remount_fs	= ext4_remount,
> -	.show_options	= ext4_show_options,
> -#ifdef CONFIG_QUOTA
> -	.quota_read	= ext4_quota_read,
> -	.quota_write	= ext4_quota_write,
> -#endif
> -	.bdev_try_to_free_page = bdev_try_to_free_page,
> -};
> -
>  static const struct export_operations ext4_export_ops = {
>  	.fh_to_dentry = ext4_fh_to_dentry,
>  	.fh_to_parent = ext4_fh_to_parent,
> @@ -3941,11 +3920,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
>  	/*
>  	 * set up enough so that it can read an inode
>  	 */
> -	if (!test_opt(sb, NOLOAD) &&
> -	    EXT4_HAS_COMPAT_FEATURE(sb, EXT4_FEATURE_COMPAT_HAS_JOURNAL))
> -		sb->s_op = &ext4_sops;
> -	else
> -		sb->s_op = &ext4_nojournal_sops;
> +	sb->s_op = &ext4_sops;
>  	sb->s_export_op = &ext4_export_ops;
>  	sb->s_xattr = ext4_xattr_handlers;
>  #ifdef CONFIG_QUOTA
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
