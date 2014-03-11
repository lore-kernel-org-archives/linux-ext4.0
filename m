From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] ext4: Find the group descriptors on a 1k-block
 bigalloc,meta_bg filesystem
Date: Tue, 11 Mar 2014 00:02:30 -0700
Message-ID: <20140311070230.GM9875@birch.djwong.org>
References: <20131220001541.GA10189@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:24171 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752725AbaCKHCe (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 11 Mar 2014 03:02:34 -0400
Content-Disposition: inline
In-Reply-To: <20131220001541.GA10189@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Dec 19, 2013 at 04:15:42PM -0800, Darrick J. Wong wrote:
> On a filesystem with a 1k block size, the group descriptors live in
> block 2, not block 1.  If the filesystem has bigalloc,meta_bg set,
> however, the calculation of the group descriptor table location does
> not take this into account and returns the wrong block number.  Fix
> the calculation to return the correct value for this case.

Hey Ted,

Any comments on this one?

--D
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/ext4/super.c |   10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 7f52a54..d968c64 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -2420,6 +2420,16 @@ static ext4_fsblk_t descriptor_loc(struct super_block *sb,
>  	if (ext4_bg_has_super(sb, bg))
>  		has_super = 1;
>  
> +	/*
> +	 * If we have a meta_bg fs with 1k blocks, group 0's GDT is at
> +	 * block 2, not 1.  If s_first_data_block == 0 (bigalloc is enabled
> +	 * on modern mke2fs or blksize > 1k on older mke2fs) then we must
> +	 * compensate.
> +	 */
> +	if (sb->s_blocksize == 1024 && nr == 0 &&
> +	    le32_to_cpu(EXT4_SB(sb)->s_es->s_first_data_block) == 0)
> +		has_super++;
> +
>  	return (has_super + ext4_group_first_block_no(sb, bg));
>  }
>  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
