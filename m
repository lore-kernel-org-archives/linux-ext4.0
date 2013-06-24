From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH] ext4: check error return from
 ext4_write_inline_data_end()
Date: Mon, 24 Jun 2013 21:40:02 +0800
Message-ID: <20130624134002.GB7709@gmail.com>
References: <20130620144421.GC28309@thunk.org>
 <1371739943-31176-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	jonernst07@gmx.com, Zheng Liu <wenqing.lz@taobao.com>,
	stable@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1371739943-31176-1-git-send-email-tytso@mit.edu>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Jun 20, 2013 at 10:52:23AM -0400, Theodore Ts'o wrote:
> The function ext4_write_inline_data_end() can return an error.  So we
> need to assign it to a signed integer variable to check for an error
> return (since copied is an unsigned int).
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> Cc: Zheng Liu <wenqing.lz@taobao.com>
> Cc: stable@vger.kernel.org

Sorry for the late reply.  Thanks for fixing this.  The patch looks good
to me.
Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>

                                                - Zheng

> ---
>  fs/ext4/inode.c | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index baf5c2b..567a734 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -1061,10 +1061,13 @@ static int ext4_write_end(struct file *file,
>  		}
>  	}
>  
> -	if (ext4_has_inline_data(inode))
> -		copied = ext4_write_inline_data_end(inode, pos, len,
> -						    copied, page);
> -	else
> +	if (ext4_has_inline_data(inode)) {
> +		ret = ext4_write_inline_data_end(inode, pos, len,
> +						 copied, page);
> +		if (ret < 0)
> +			goto errout;
> +		copied = ret;
> +	} else
>  		copied = block_write_end(file, mapping, pos,
>  					 len, copied, page, fsdata);
>  
> -- 
> 1.7.12.rc0.22.gcdd159b
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
