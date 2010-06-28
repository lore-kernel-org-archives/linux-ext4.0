From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH][BUG] ext4: do not execute ext4_std_error with EFBIG at
 ext4_setattr
Date: Mon, 28 Jun 2010 09:58:53 -0500
Message-ID: <4C28B8AD.6040001@redhat.com>
References: <20100628114256.0c633779.toshi.okajima@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, adilger@sun.com, linux-ext4@vger.kernel.org
To: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:7923 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751193Ab0F1O7B (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Jun 2010 10:59:01 -0400
In-Reply-To: <20100628114256.0c633779.toshi.okajima@jp.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Toshiyuki Okajima wrote:
> From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
> 
> You know, do_truncate() can call ext4_setattr() (via notify_change()).
> And, ext4_setattr() can return with -EFBIG if the argument(length) of 
> do_truncate() is more than sbi->s_bitmap_maxbytes. At that time, 
> it also calls ext4_std_error() with -EFBIG.
> 
> Besides, a panic happens when ext4_setattr() returns with -EFBIG
> after we mount an ext4 filesystem with errors=panic.

...

> This changes prevent this problem from happening.

Whoops, that one was my fault; thanks for catching it.

I might just "return error" at that spot, but this works fine too.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>
 
> Signed-off-by: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
> ---
>  fs/ext4/inode.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 42272d6..e87bb45 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -5485,7 +5485,7 @@ int ext4_setattr(struct dentry *dentry, struct iattr *attr)
>  
>  			if (attr->ia_size > sbi->s_bitmap_maxbytes) {
>  				error = -EFBIG;
> -				goto err_out;
> +				goto err_out2;
>  			}
>  		}
>  	}
> @@ -5544,6 +5544,7 @@ err_out:
>  	ext4_std_error(inode->i_sb, error);
>  	if (!error)
>  		error = rc;
> +err_out2:
>  	return error;
>  }
>  

