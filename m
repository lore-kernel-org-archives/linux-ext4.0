From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] mke2fs: clarify inline data inode size error message
Date: Sun, 28 Sep 2014 22:53:50 -0700
Message-ID: <20140929055350.GL10150@birch.djwong.org>
References: <20140927155515.GA2322@wallace>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Eric Whitney <enwlinux@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:51892 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146AbaI2Fx5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 29 Sep 2014 01:53:57 -0400
Content-Disposition: inline
In-Reply-To: <20140927155515.GA2322@wallace>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Sep 27, 2014 at 11:55:15AM -0400, Eric Whitney wrote:
> The existing error message can be made more helpful by more clearly
> implying the attempt to make a file system with undersized inodes is
> failing and suggesting a corrective action.
> 
> Signed-off-by: Eric Whitney <enwlinux@gmail.com>
> ---
>  misc/mke2fs.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/misc/mke2fs.c b/misc/mke2fs.c
> index 2bc435b..00bb00d 100644
> --- a/misc/mke2fs.c
> +++ b/misc/mke2fs.c
> @@ -2358,7 +2358,8 @@ profile_error:
>  	     EXT4_FEATURE_INCOMPAT_INLINE_DATA) &&
>  	    fs_param.s_inode_size == EXT2_GOOD_OLD_INODE_SIZE) {
>  		com_err(program_name, 0,
> -			_("inode size is %d, inline data is useless"),
> +			_("%d byte inodes are too small for inline data; "
> +			  "specify larger size"),

How much larger?  The next larger inode size is 256 bytes, so we ought to tell
the user that.  ("specify a size at least 256 bytes"?)

--D

>  			fs_param.s_inode_size);
>  		exit(1);
>  	}
> -- 
> 1.9.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
