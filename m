From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: fix incorrect indentation of if statement
Date: Thu, 4 Jan 2018 16:40:18 +0100
Message-ID: <20180104154018.GB2170@quack2.suse.cz>
References: <20171129142059.21898-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171129142059.21898-1-colin.king@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed 29-11-17 14:20:59, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The indentation is incorrect and spaces need replacing with a tab
> on the if statement.
> 
> Cleans up smatch warning:
> fs/ext4/namei.c:3220 ext4_link() warn: inconsistent indenting
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

This seems to fall through cracks. The patch looks good. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza


> ---
>  fs/ext4/namei.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index 798b3ac680db..d3fabc553c65 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -3217,8 +3217,8 @@ static int ext4_link(struct dentry *old_dentry,
>  	if (err)
>  		return err;
>  
> -       if ((ext4_test_inode_flag(dir, EXT4_INODE_PROJINHERIT)) &&
> -	   (!projid_eq(EXT4_I(dir)->i_projid,
> +	if ((ext4_test_inode_flag(dir, EXT4_INODE_PROJINHERIT)) &&
> +	    (!projid_eq(EXT4_I(dir)->i_projid,
>  		       EXT4_I(old_dentry->d_inode)->i_projid)))
>  		return -EXDEV;
>  
> -- 
> 2.14.1
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
