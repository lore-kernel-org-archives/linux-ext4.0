From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: handle errors on ext4_commit_super
Date: Thu, 19 Apr 2018 17:18:53 +0200
Message-ID: <20180419151853.jtif7ncjuhf6yuwl@quack2.suse.cz>
References: <20180330014429.27824-1-jaegeuk@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, Jaegeuk Kim <jaegeuk@google.com>,
        Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org
To: Jaegeuk Kim <jaegeuk@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180330014429.27824-1-jaegeuk@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu 29-03-18 18:44:29, Jaegeuk Kim wrote:
> From: Jaegeuk Kim <jaegeuk@google.com>
> 
> When remounting ext4 from ro to rw, currently it allows its transition,
> even if ext4_commit_super() returns EIO. Even worse thing is, after that,
> fs/buffer complains buffer dirty bits like:
> 
>  Call trace:
>  [<ffffff9750c259dc>] mark_buffer_dirty+0x184/0x1a4
>  [<ffffff9750cb398c>] __ext4_handle_dirty_super+0x4c/0xfc
>  [<ffffff9750c7a9fc>] ext4_file_open+0x154/0x1c0
>  [<ffffff9750bea51c>] do_dentry_open+0x114/0x2d0
>  [<ffffff9750bea75c>] vfs_open+0x5c/0x94
>  [<ffffff9750bf879c>] path_openat+0x668/0xfe8
>  [<ffffff9750bf8088>] do_filp_open+0x74/0x120
>  [<ffffff9750beac98>] do_sys_open+0x148/0x254
>  [<ffffff9750beade0>] SyS_openat+0x10/0x18
>  [<ffffff9750a83ab0>] el0_svc_naked+0x24/0x28
>  EXT4-fs (dm-1): previous I/O error to superblock detected
>  Buffer I/O error on dev dm-1, logical block 0, lost sync page write
>  EXT4-fs (dm-1): re-mounted. Opts: (null)
>  Buffer I/O error on dev dm-1, logical block 80, lost async page write
> 
> Cc: "Theodore Ts'o" <tytso@mit.edu>
> Cc: Andreas Dilger <adilger.kernel@dilger.ca>
> Cc: linux-ext4@vger.kernel.org
> Cc: Jaegeuk Kim <jaegeuk@kernel.org>
> Signed-off-by: Jaegeuk Kim <jaegeuk@google.com>
> ---
>  fs/ext4/super.c | 21 +++++++++++++--------
>  1 file changed, 13 insertions(+), 8 deletions(-)

Thanks for the patch. Some comments below.

> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 39bf464c35f1..b268bfea879c 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -2151,7 +2151,7 @@ static int ext4_setup_super(struct super_block *sb, struct ext4_super_block *es,
>  	if (sbi->s_journal)
>  		ext4_set_feature_journal_needs_recovery(sb);
>  
> -	ext4_commit_super(sb, 1);
> +	res = ext4_commit_super(sb, 1);
>  done:
>  	if (test_opt(sb, DEBUG))
>  		printk(KERN_INFO "[EXT4 FS bs=%lu, gc=%u, "

So return value of ext4_setup_super() looks a bit strange and it seems it
currently returns 0 or SB_RDONLY. So I think you first need to clean this
up before making ext4_setup_super() return error code (as your patch could
make ext4_fill_super() return SB_RDONLY under some circumstances).

> @@ -4739,11 +4739,10 @@ static int ext4_commit_super(struct super_block *sb, int sync)
>  		unlock_buffer(sbh);
>  		error = __sync_dirty_buffer(sbh,
>  			REQ_SYNC | (test_opt(sb, BARRIER) ? REQ_FUA : 0));
> -		if (error)
> +		if (error && !buffer_write_io_error(sbh))
>  			return error;
>  
> -		error = buffer_write_io_error(sbh);
> -		if (error) {
> +		if (buffer_write_io_error(sbh)) {
>  			ext4_msg(sb, KERN_ERR, "I/O error while writing "
>  			       "superblock");
>  			clear_buffer_write_io_error(sbh);

I'd rather rewrite this as:
		if (buffer_write_io_error(sbh)) {
			do stuff as now
		}
		if (error)
			return error;

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
