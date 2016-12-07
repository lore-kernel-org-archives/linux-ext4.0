From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext2: reject inodes with negative size
Date: Wed, 7 Dec 2016 13:05:09 +0100
Message-ID: <20161207120509.GF8394@quack2.suse.cz>
References: <20161206235901.GB16804@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
        linux-ext4 <linux-ext4@vger.kernel.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40010 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751742AbcLGMFu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 7 Dec 2016 07:05:50 -0500
Content-Disposition: inline
In-Reply-To: <20161206235901.GB16804@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 06-12-16 15:59:01, Darrick J. Wong wrote:
> Don't load an inode with a negative size; this causes integer overflow
> problems in the VFS.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, I've added the patch to my tree.

								Honza

> ---
>  fs/ext2/inode.c |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
> index 41b8b44..01f6d4b 100644
> --- a/fs/ext2/inode.c
> +++ b/fs/ext2/inode.c
> @@ -1476,6 +1476,10 @@ struct inode *ext2_iget (struct super_block *sb, unsigned long ino)
>  		inode->i_size |= ((__u64)le32_to_cpu(raw_inode->i_size_high)) << 32;
>  	else
>  		ei->i_dir_acl = le32_to_cpu(raw_inode->i_dir_acl);
> +	if (i_size_read(inode) < 0) {
> +		ret = -EFSCORRUPTED;
> +		goto bad_inode;
> +	}
>  	ei->i_dtime = 0;
>  	inode->i_generation = le32_to_cpu(raw_inode->i_generation);
>  	ei->i_state = 0;
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
