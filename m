From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/2] Ext2: use unlikely to improve the efficiency of
 the kernel
Date: Mon, 14 Jan 2013 15:21:32 +0100
Message-ID: <20130114142132.GD6597@quack.suse.cz>
References: <CAP9B-Qkxe-hmCJN9dR1qbjqE35XyWn=KTa47j57Zn3ww2QBjeg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: shilong wang <wangshilong1991@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAP9B-Qkxe-hmCJN9dR1qbjqE35XyWn=KTa47j57Zn3ww2QBjeg@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat 12-01-13 01:34:50, shilong wang wrote:
> From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
> 
> Because the function 'sb_getblk' seldomly fails to return
> NULL value. It will be better to use unlikely to optimize it.
  Thanks, I've merged the patch. But your mailer has apparently wrapped
lines in the patch so I had to fix it up. Please either use mailer that
doesn't wrap lines or send patches as text/plain attachments. Thanks!

								Honza
> 
> Signed-off-by: Wang shilong <wangsl-fnst@cn.fujitsu.com>
> ---
>  fs/ext2/super.c |    2 +-
>  fs/ext2/xattr.c |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext2/super.c b/fs/ext2/super.c
> index af74d9e..c0f4fc6 100644
> --- a/fs/ext2/super.c
> +++ b/fs/ext2/super.c
> @@ -1495,7 +1495,7 @@ static ssize_t ext2_quota_write(struct
> super_block *sb, int type,
>  			bh = sb_bread(sb, tmp_bh.b_blocknr);
>  		else
>  			bh = sb_getblk(sb, tmp_bh.b_blocknr);
> -		if (!bh) {
> +		if (unlikely(!bh)) {
>  			err = -EIO;
>  			goto out;
>  		}
> diff --git a/fs/ext2/xattr.c b/fs/ext2/xattr.c
> index b6754db..06209ec 100644
> --- a/fs/ext2/xattr.c
> +++ b/fs/ext2/xattr.c
> @@ -662,7 +662,7 @@ ext2_xattr_set2(struct inode *inode, struct
> buffer_head *old_bh,
>  			ea_idebug(inode, "creating block %d", block);
> 
>  			new_bh = sb_getblk(sb, block);
> -			if (!new_bh) {
> +			if (unlikely(!new_bh)) {
>  				ext2_free_blocks(inode, block, 1);
>  				mark_inode_dirty(inode);
>  				error = -EIO;
> -- 
> 1.7.7.6
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
