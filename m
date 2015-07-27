From: Jan Kara <jack@suse.cz>
Subject: Re: [patch] ext4: memory leak on error in ext4_symlink()
Date: Mon, 27 Jul 2015 14:32:38 +0200
Message-ID: <20150727123238.GD4891@quack.suse.cz>
References: <20150724110533.GA14424@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, kernel-janitors@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150724110533.GA14424@mwanda>
Sender: kernel-janitors-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri 24-07-15 14:05:33, Dan Carpenter wrote:
> We should release "sd" before returning.
> 
> Fixes: 0fa12ad1b285 ('ext4: Handle error from dquot_initialize()')
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Thanks! I've added the fix to my tree.

								Honza
 
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index d3ff837..9f61e76 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -3084,7 +3084,7 @@ static int ext4_symlink(struct inode *dir,
>  
>  	err = dquot_initialize(dir);
>  	if (err)
> -		return err;
> +		goto err_free_sd;
>  
>  	if ((disk_link.len > EXT4_N_BLOCKS * 4)) {
>  		/*
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
