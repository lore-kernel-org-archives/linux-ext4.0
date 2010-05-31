From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/2] ext4: force block allocation on quota_off
Date: Mon, 31 May 2010 21:11:31 +0200
Message-ID: <20100531191130.GE5334@quack.suse.cz>
References: <1275046062-457-1-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	jack@suse.cz
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:56361 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756947Ab0EaTLo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 31 May 2010 15:11:44 -0400
Content-Disposition: inline
In-Reply-To: <1275046062-457-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri 28-05-10 15:27:41, Dmitry Monakhov wrote:
> Perform full sync procedure to guarantee quota consistency.
  The series looks OK, but please rediff the patch against the latest
Linus' tree.

								Honza
> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> ---
>  fs/ext4/super.c |   15 ++++++++++++++-
>  1 files changed, 14 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index e5166e5..4e8a7b5 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -1075,6 +1075,7 @@ static int ext4_mark_dquot_dirty(struct dquot *dquot);
>  static int ext4_write_info(struct super_block *sb, int type);
>  static int ext4_quota_on(struct super_block *sb, int type, int format_id,
>  				char *path, int remount);
> +static int ext4_quota_off(struct super_block *sb, int type, int remount);
>  static int ext4_quota_on_mount(struct super_block *sb, int type);
>  static ssize_t ext4_quota_read(struct super_block *sb, int type, char *data,
>  			       size_t len, loff_t off);
> @@ -1096,7 +1097,7 @@ static const struct dquot_operations ext4_quota_operations = {
>  
>  static const struct quotactl_ops ext4_qctl_operations = {
>  	.quota_on	= ext4_quota_on,
> -	.quota_off	= vfs_quota_off,
> +	.quota_off	= ext4_quota_off,
>  	.quota_sync	= vfs_quota_sync,
>  	.get_info	= vfs_get_dqinfo,
>  	.set_info	= vfs_set_dqinfo,
> @@ -3986,6 +3987,18 @@ static int ext4_quota_on(struct super_block *sb, int type, int format_id,
>  	return err;
>  }
>  
> +static int ext4_quota_off(struct super_block *sb, int type, int remount)
> +{
> +	/* Force all delayed allocation blocks to be allocated */
> +	if (test_opt(sb, DELALLOC) && !remount) {
> +		down_read(&sb->s_umount);
> +		sync_filesystem(sb);
> +		up_read(&sb->s_umount);
> +	}
> +
> +	return vfs_quota_off(sb, type, remount);
> +}
> +
>  /* Read data from quotafile - avoid pagecache and such because we cannot afford
>   * acquiring the locks... As quota files are never truncated and quota code
>   * itself serializes the operations (and noone else should touch the files)
> -- 
> 1.6.6.1
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
