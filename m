From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH V1 1/2] Ext2: return ENOMEM rather than EIO if
 sb_getblk fails
Date: Mon, 14 Jan 2013 15:25:41 +0100
Message-ID: <20130114142541.GF6597@quack.suse.cz>
References: <1358073846-1662-1-git-send-email-wangshilong1991@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jack@suse.cz, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	Wang Shilong <wangsl-fnst@cn.fujitsu.com>
To: Wang shilong <wangshilong1991@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1358073846-1662-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun 13-01-13 18:44:06, Wang shilong wrote:
> From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
> 
> As the only reason that sb_getblk fails is that allocation fails.
> It will be better to use ENOMEM rather than EIO.
> 
> Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
> ---
>  fs/ext2/super.c | 2 +-
>  fs/ext2/xattr.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext2/super.c b/fs/ext2/super.c
> index 663fdcd..3308a55 100644
> --- a/fs/ext2/super.c
> +++ b/fs/ext2/super.c
> @@ -1457,7 +1457,7 @@ static ssize_t ext2_quota_write(struct super_block *sb, int type,
>  		else
>  			bh = sb_getblk(sb, tmp_bh.b_blocknr);
>  		if (unlikely(!bh)) {
> -			err = -EIO;
> +			err = -ENOMEM;
  This is actually wrong. sb_bread() can return NULL in case of IO error as
well as in case of ENOMEM. In theory you could split the error check for
the sb_getblk() and sb_bread() branch but I prefer not to bother...

								Honza
>  			goto out;
>  		}
>  		lock_buffer(bh);
> diff --git a/fs/ext2/xattr.c b/fs/ext2/xattr.c
> index 06209ec..2d7557d 100644
> --- a/fs/ext2/xattr.c
> +++ b/fs/ext2/xattr.c
> @@ -665,7 +665,7 @@ ext2_xattr_set2(struct inode *inode, struct buffer_head *old_bh,
>  			if (unlikely(!new_bh)) {
>  				ext2_free_blocks(inode, block, 1);
>  				mark_inode_dirty(inode);
> -				error = -EIO;
> +				error = -ENOMEM;
>  				goto cleanup;
>  			}
>  			lock_buffer(new_bh);
> -- 
> 1.7.11.7
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
