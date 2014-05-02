From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 04/37] mke2fs: always warn if 128-byte inode and
 inline_data
Date: Fri, 2 May 2014 13:27:01 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1405021325170.2154@localhost.localdomain>
References: <20140501231222.31890.82860.stgit@birch.djwong.org> <20140501231249.31890.43562.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53278 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751745AbaEBL1G (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 2 May 2014 07:27:06 -0400
In-Reply-To: <20140501231249.31890.43562.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 1 May 2014, Darrick J. Wong wrote:

> Date: Thu, 01 May 2014 16:12:49 -0700
> From: Darrick J. Wong <darrick.wong@oracle.com>
> To: tytso@mit.edu, darrick.wong@oracle.com
> Cc: linux-ext4@vger.kernel.org
> Subject: [PATCH 04/37] mke2fs: always warn if 128-byte inode and inline_data
> 
> The combination of 128-byte inodes and inline_data is silly, since
> there's no room in the inode table.  Unfortunately, if neither
> mke2fs.conf nor the mkfs command line options specify an inode size,
> the default inode size is set to 128 bytes (by libext2fs) and the
> warning isn't printed.  Therefore, always do the check-and-warning.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  misc/mke2fs.c |   25 +++++++++++++------------
>  1 file changed, 13 insertions(+), 12 deletions(-)
> 
> 
> diff --git a/misc/mke2fs.c b/misc/mke2fs.c
> index aecd5d5..6507d0d 100644
> --- a/misc/mke2fs.c
> +++ b/misc/mke2fs.c
> @@ -2282,21 +2282,22 @@ profile_error:
>  				blocksize);
>  			exit(1);
>  		}
> -		/*
> -		 * If inode size is 128 and inline data is enabled, we need
> -		 * to notify users that inline data will never be useful.
> -		 */
> -		if ((fs_param.s_feature_incompat &
> -		     EXT4_FEATURE_INCOMPAT_INLINE_DATA) &&
> -		    inode_size == EXT2_GOOD_OLD_INODE_SIZE) {
> -			com_err(program_name, 0,
> -				_("inode size is %d, inline data is useless"),
> -				inode_size);
> -			exit(1);
> -		}
>  		fs_param.s_inode_size = inode_size;
>  	}
>  
> +	/*
> +	 * If inode size is 128 and inline data is enabled, we need
> +	 * to notify users that inline data will never be useful.
> +	 */
> +	if ((fs_param.s_feature_incompat &
> +	     EXT4_FEATURE_INCOMPAT_INLINE_DATA) &&
> +	    fs_param.s_inode_size == EXT2_GOOD_OLD_INODE_SIZE) {
> +		com_err(program_name, 0,
> +			_("inode size is %d, inline data is useless"),
> +			inode_size);

Oops :) copy-paste is tricky. You need to use fs_param.s_inode_size
rather than inode_size here. Otherwise it looks good.

Thanks!
-Lukas


> +		exit(1);
> +	}
> +
>  	/* Make sure number of inodes specified will fit in 32 bits */
>  	if (num_inodes == 0) {
>  		unsigned long long n;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
