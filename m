From: Tao Ma <tm@tao.ma>
Subject: Re: [PATCH] ext4: Fix memory leak in ext4_init_new_dir
Date: Fri, 11 Jan 2013 18:12:17 +0800
Message-ID: <50EFE581.3070309@tao.ma>
References: <20130111100639.GA3302@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Theodore Ts'o <tytso@mit.edu>, Tao Ma <boyu.mt@taobao.com>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Mel Gorman <mgorman@suse.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:38597 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754261Ab3AKKMf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 11 Jan 2013 05:12:35 -0500
In-Reply-To: <20130111100639.GA3302@suse.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Mel,

Thanks for the report.

This bug is already spotted by Guo Chao and the patch has been accepted
by Ted already.

Thanks,
Tao
On 01/11/2013 06:06 PM, Mel Gorman wrote:
> Commit a774f9c2 "ext4: make ext4_init_dot_dotdot for inline dir usage"
> is a preparation cleanup for later ext4 patches but there was a snag
> when moving code to the newly created ext4_init_new_dir() function.
> ext4_bread() is called twice but brelse() is only called one leading to a
> memory leak. The user-visible effect is that after a compile-orientated
> benchmark 0% of memory could be allocated as transparent huge pages.
> This patch deletes the extra call and after it is applied, 76% of memory
> could be allocated after the same test.
> 
> Signed-off-by: Mel Gorman <mgorman@suse.de>
> ---
>  fs/ext4/namei.c |    1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index 8990165..d068885 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -2368,7 +2368,6 @@ static int ext4_init_new_dir(handle_t *handle, struct inode *dir,
>  	}
>  
>  	inode->i_size = EXT4_I(inode)->i_disksize = blocksize;
> -	dir_block = ext4_bread(handle, inode, 0, 1, &err);
>  	if (!(dir_block = ext4_bread(handle, inode, 0, 1, &err))) {
>  		if (!err) {
>  			err = -EIO;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

