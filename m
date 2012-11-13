From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] ext4: do not use ext4_error() when there is no space in
 dir leaf for csum
Date: Tue, 13 Nov 2012 10:16:05 -0800
Message-ID: <20121113181605.GA11794@blackbox.djwong.org>
References: <1352604025-22310-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:30711 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755548Ab2KMSQK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 13 Nov 2012 13:16:10 -0500
Content-Disposition: inline
In-Reply-To: <1352604025-22310-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Nov 10, 2012 at 10:20:25PM -0500, Theodore Ts'o wrote:
> If there is no space for a checksum in a directory leaf node,
> previously we would use EXT4_ERROR_INODE() which would mark the file
> system as inconsistent.  While it would be nice to use e2fsck -D, it
> certainly isn't required, so just print a warning using
> ext4_warning().
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> Cc: "Darrick J. Wong" <darrick.wong@oracle.com>

Looks fine to me, so you can change Cc: to Acked-By:.

--D
> ---
>  fs/ext4/namei.c | 18 ++++++++++--------
>  1 file changed, 10 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index 6d600a6..580af3d 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -261,6 +261,12 @@ static __le32 ext4_dirent_csum(struct inode *inode,
>  	return cpu_to_le32(csum);
>  }
>  
> +static void warn_no_space_for_csum(struct inode *inode)
> +{
> +	ext4_warning(inode->i_sb, "no space in directory inode %lu leaf for "
> +		     "checksum.  Please run e2fsck -D.", inode->i_ino);
> +}
> +
>  int ext4_dirent_csum_verify(struct inode *inode, struct ext4_dir_entry *dirent)
>  {
>  	struct ext4_dir_entry_tail *t;
> @@ -271,8 +277,7 @@ int ext4_dirent_csum_verify(struct inode *inode, struct ext4_dir_entry *dirent)
>  
>  	t = get_dirent_tail(inode, dirent);
>  	if (!t) {
> -		EXT4_ERROR_INODE(inode, "metadata_csum set but no space in dir "
> -				 "leaf for checksum.  Please run e2fsck -D.");
> +		warn_no_space_for_csum(inode);
>  		return 0;
>  	}
>  
> @@ -294,8 +299,7 @@ static void ext4_dirent_csum_set(struct inode *inode,
>  
>  	t = get_dirent_tail(inode, dirent);
>  	if (!t) {
> -		EXT4_ERROR_INODE(inode, "metadata_csum set but no space in dir "
> -				 "leaf for checksum.  Please run e2fsck -D.");
> +		warn_no_space_for_csum(inode);
>  		return;
>  	}
>  
> @@ -377,8 +381,7 @@ static int ext4_dx_csum_verify(struct inode *inode,
>  	count = le16_to_cpu(c->count);
>  	if (count_offset + (limit * sizeof(struct dx_entry)) >
>  	    EXT4_BLOCK_SIZE(inode->i_sb) - sizeof(struct dx_tail)) {
> -		EXT4_ERROR_INODE(inode, "metadata_csum set but no space for "
> -				 "tree checksum found.  Run e2fsck -D.");
> +		warn_no_space_for_csum(inode);
>  		return 1;
>  	}
>  	t = (struct dx_tail *)(((struct dx_entry *)c) + limit);
> @@ -408,8 +411,7 @@ static void ext4_dx_csum_set(struct inode *inode, struct ext4_dir_entry *dirent)
>  	count = le16_to_cpu(c->count);
>  	if (count_offset + (limit * sizeof(struct dx_entry)) >
>  	    EXT4_BLOCK_SIZE(inode->i_sb) - sizeof(struct dx_tail)) {
> -		EXT4_ERROR_INODE(inode, "metadata_csum set but no space for "
> -				 "tree checksum.  Run e2fsck -D.");
> +		warn_no_space_for_csum(inode);
>  		return;
>  	}
>  	t = (struct dx_tail *)(((struct dx_entry *)c) + limit);
> -- 
> 1.7.12.rc0.22.gcdd159b
> 
