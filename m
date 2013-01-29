From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/4] ext4: remove unused variable in add_dirent_to_buf()
Date: Mon, 28 Jan 2013 17:12:18 -0800
Message-ID: <20130129011218.GA4754@blackbox.djwong.org>
References: <1358496074-6228-1-git-send-email-yan@linux.vnet.ibm.com>
 <1358496074-6228-2-git-send-email-yan@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: Guo Chao <yan@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:27019 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754460Ab3A2BOD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 28 Jan 2013 20:14:03 -0500
Content-Disposition: inline
In-Reply-To: <1358496074-6228-2-git-send-email-yan@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jan 18, 2013 at 04:01:12PM +0800, Guo Chao wrote:
> After commit 978fef9 (create __ext4_insert_dentry for dir entry
> insertion), 'reclen' is not used anymore.
> 
> Signed-off-by: Guo Chao <yan@linux.vnet.ibm.com>
This one looks ok too.
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/ext4/namei.c |    2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index a445247..b3717a3 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -1703,7 +1703,6 @@ static int add_dirent_to_buf(handle_t *handle, struct dentry *dentry,
>  	const char	*name = dentry->d_name.name;
>  	int		namelen = dentry->d_name.len;
>  	unsigned int	blocksize = dir->i_sb->s_blocksize;
> -	unsigned short	reclen;
>  	int		csum_size = 0;
>  	int		err;
>  
> @@ -1711,7 +1710,6 @@ static int add_dirent_to_buf(handle_t *handle, struct dentry *dentry,
>  				       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
>  		csum_size = sizeof(struct ext4_dir_entry_tail);
>  
> -	reclen = EXT4_DIR_REC_LEN(namelen);
>  	if (!de) {
>  		err = ext4_find_dest_de(dir, inode,
>  					bh, bh->b_data, blocksize - csum_size,
> -- 
> 1.7.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
