From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/2] ext4: force block allocation on quota_off
Date: Tue, 1 Jun 2010 14:11:08 +0200
Message-ID: <20100601121107.GE4275@quack.suse.cz>
References: <20100531191130.GE5334@quack.suse.cz>
 <1275377988-4299-1-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	jack@suse.cz, tytso@mit.edu
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1275377988-4299-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue 01-06-10 11:39:47, Dmitry Monakhov wrote:
> Perform full sync procedure to guarantee quota consistency.
  The patch looks OK to me. Acked-by: Jan Kara <jack@suse.cz>
Ted, will you merge it or should I do it?

							Honza
> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> ---
>  fs/ext4/super.c |   15 ++++++++++++++-
>  1 files changed, 14 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 4e8983a..107fb03 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -1065,6 +1065,7 @@ static int ext4_mark_dquot_dirty(struct dquot *dquot);
>  static int ext4_write_info(struct super_block *sb, int type);
>  static int ext4_quota_on(struct super_block *sb, int type, int format_id,
>  				char *path);
> +static int ext4_quota_off(struct super_block *sb, int type);
>  static int ext4_quota_on_mount(struct super_block *sb, int type);
>  static ssize_t ext4_quota_read(struct super_block *sb, int type, char *data,
>  			       size_t len, loff_t off);
> @@ -1086,7 +1087,7 @@ static const struct dquot_operations ext4_quota_operations = {
>  
>  static const struct quotactl_ops ext4_qctl_operations = {
>  	.quota_on	= ext4_quota_on,
> -	.quota_off	= dquot_quota_off,
> +	.quota_off	= ext4_quota_off,
>  	.quota_sync	= dquot_quota_sync,
>  	.get_info	= dquot_get_dqinfo,
>  	.set_info	= dquot_set_dqinfo,
> @@ -3981,6 +3982,18 @@ static int ext4_quota_on(struct super_block *sb, int type, int format_id,
>  	return err;
>  }
>  
> +static int ext4_quota_off(struct super_block *sb, int type)
> +{
> +	/* Force all delayed allocation blocks to be allocated */
> +	if (test_opt(sb, DELALLOC)) {
> +		down_read(&sb->s_umount);
> +		sync_filesystem(sb);
> +		up_read(&sb->s_umount);
> +	}
> +
> +	return dquot_quota_off(sb, type);
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
