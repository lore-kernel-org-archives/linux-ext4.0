From: Adrian Bunk <bunk@stusta.de>
Subject: Re: [patch 15/23] ext3 -nobh option causes oops
Date: Thu, 16 Nov 2006 23:51:54 +0100
Message-ID: <20061116225154.GK31879@stusta.de>
References: <20060804053258.391158155@quad.kroah.org> <20060804054003.GP769@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:35335 "HELO
	mailout.stusta.mhn.de") by vger.kernel.org with SMTP
	id S1754890AbWKPWvz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 16 Nov 2006 17:51:55 -0500
To: Badari Pulavarty <pbadari@us.ibm.com>, linux-ext4@vger.kernel.org
Content-Disposition: inline
In-Reply-To: <20060804054003.GP769@kroah.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

It seems this patch that went into 2.6.17.8 should also be included in 
the 2.6.16.x branch, or do I miss anything?

TIA
Adrian


On Thu, Aug 03, 2006 at 10:40:03PM -0700, Greg KH wrote:
> -stable review patch.  If anyone has any objections, please let us know.
> 
> ------------------
> From: Badari Pulavarty <pbadari@us.ibm.com>
> 
> For files other than IFREG, nobh option doesn't make sense.  Modifications
> to them are journalled and needs buffer heads to do that.  Without this
> patch, we get kernel oops in page_buffers().
> 
> Signed-off-by: Badari Pulavarty <pbadari@us.ibm.com>
> Signed-off-by: Andrew Morton <akpm@osdl.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> ---
>  fs/ext3/inode.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> --- linux-2.6.17.7.orig/fs/ext3/inode.c
> +++ linux-2.6.17.7/fs/ext3/inode.c
> @@ -1159,7 +1159,7 @@ retry:
>  		ret = PTR_ERR(handle);
>  		goto out;
>  	}
> -	if (test_opt(inode->i_sb, NOBH))
> +	if (test_opt(inode->i_sb, NOBH) && ext3_should_writeback_data(inode))
>  		ret = nobh_prepare_write(page, from, to, ext3_get_block);
>  	else
>  		ret = block_prepare_write(page, from, to, ext3_get_block);
> @@ -1245,7 +1245,7 @@ static int ext3_writeback_commit_write(s
>  	if (new_i_size > EXT3_I(inode)->i_disksize)
>  		EXT3_I(inode)->i_disksize = new_i_size;
>  
> -	if (test_opt(inode->i_sb, NOBH))
> +	if (test_opt(inode->i_sb, NOBH) && ext3_should_writeback_data(inode))
>  		ret = nobh_commit_write(file, page, from, to);
>  	else
>  		ret = generic_commit_write(file, page, from, to);
> @@ -1495,7 +1495,7 @@ static int ext3_writeback_writepage(stru
>  		goto out_fail;
>  	}
>  
> -	if (test_opt(inode->i_sb, NOBH))
> +	if (test_opt(inode->i_sb, NOBH) && ext3_should_writeback_data(inode))
>  		ret = nobh_writepage(page, ext3_get_block, wbc);
>  	else
>  		ret = block_write_full_page(page, ext3_get_block, wbc);
> 
