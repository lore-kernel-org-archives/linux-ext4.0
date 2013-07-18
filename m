From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH 2/5] ext4: print the block number of invalid extent tree
 blocks
Date: Thu, 18 Jul 2013 08:56:26 +0800
Message-ID: <20130718005626.GA4369@gmail.com>
References: <1373987883-4466-1-git-send-email-tytso@mit.edu>
 <1373987883-4466-3-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:56589 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934244Ab3GRAhf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 17 Jul 2013 20:37:35 -0400
Received: by mail-pa0-f45.google.com with SMTP id bi5so2545651pad.4
        for <linux-ext4@vger.kernel.org>; Wed, 17 Jul 2013 17:37:34 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1373987883-4466-3-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jul 16, 2013 at 11:18:00AM -0400, Theodore Ts'o wrote:
> When we find an invalid extent tree block, report the block number of
> the bad block for debugging purposes.
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>
                                                - Zheng

> ---
>  fs/ext4/extents.c | 24 ++++++++++++------------
>  1 file changed, 12 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index dd422db..ba58815 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -407,7 +407,7 @@ static int ext4_valid_extent_entries(struct inode *inode,
>  
>  static int __ext4_ext_check(const char *function, unsigned int line,
>  			    struct inode *inode, struct ext4_extent_header *eh,
> -			    int depth)
> +			    int depth, ext4_fsblk_t pblk)
>  {
>  	const char *error_msg;
>  	int max = 0;
> @@ -447,21 +447,21 @@ static int __ext4_ext_check(const char *function, unsigned int line,
>  
>  corrupted:
>  	ext4_error_inode(inode, function, line, 0,
> -			"bad header/extent: %s - magic %x, "
> -			"entries %u, max %u(%u), depth %u(%u)",
> -			error_msg, le16_to_cpu(eh->eh_magic),
> -			le16_to_cpu(eh->eh_entries), le16_to_cpu(eh->eh_max),
> -			max, le16_to_cpu(eh->eh_depth), depth);
> -
> +			 "pblk %llu bad header/extent: %s - magic %x, "
> +			 "entries %u, max %u(%u), depth %u(%u)",
> +			 (unsigned long long) pblk, error_msg,
> +			 le16_to_cpu(eh->eh_magic),
> +			 le16_to_cpu(eh->eh_entries), le16_to_cpu(eh->eh_max),
> +			 max, le16_to_cpu(eh->eh_depth), depth);
>  	return -EIO;
>  }
>  
> -#define ext4_ext_check(inode, eh, depth)	\
> -	__ext4_ext_check(__func__, __LINE__, inode, eh, depth)
> +#define ext4_ext_check(inode, eh, depth, pblk)			\
> +	__ext4_ext_check(__func__, __LINE__, (inode), (eh), (depth), (pblk))
>  
>  int ext4_ext_check_inode(struct inode *inode)
>  {
> -	return ext4_ext_check(inode, ext_inode_hdr(inode), ext_depth(inode));
> +	return ext4_ext_check(inode, ext_inode_hdr(inode), ext_depth(inode), 0);
>  }
>  
>  static struct buffer_head *
> @@ -484,7 +484,7 @@ __read_extent_tree_block(const char *function, unsigned int line,
>  	if (buffer_verified(bh))
>  		return bh;
>  	err = __ext4_ext_check(function, line, inode,
> -			       ext_block_hdr(bh), depth);
> +			       ext_block_hdr(bh), depth, pblk);
>  	if (err)
>  		goto errout;
>  	set_buffer_verified(bh);
> @@ -2775,7 +2775,7 @@ again:
>  		path[0].p_hdr = ext_inode_hdr(inode);
>  		i = 0;
>  
> -		if (ext4_ext_check(inode, path[0].p_hdr, depth)) {
> +		if (ext4_ext_check(inode, path[0].p_hdr, depth, 0)) {
>  			err = -EIO;
>  			goto out;
>  		}
> -- 
> 1.7.12.rc0.22.gcdd159b
> 
