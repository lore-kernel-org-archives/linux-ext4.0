From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH 08/25] debugfs: fix various minor bogosity
Date: Mon, 25 Nov 2013 16:08:24 +0800
Message-ID: <20131125080824.GC5964@gmail.com>
References: <20131018044854.7339.48457.stgit@birch.djwong.org>
 <20131018044948.7339.56696.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, Darren Hart <dvhart@linux.intel.com>,
	linux-ext4@vger.kernel.org, Robert Yang <liezhi.yang@windriver.com>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36947 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752273Ab3KYIFi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 25 Nov 2013 03:05:38 -0500
Received: by mail-pb0-f46.google.com with SMTP id md12so5181790pbc.19
        for <linux-ext4@vger.kernel.org>; Mon, 25 Nov 2013 00:05:37 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20131018044948.7339.56696.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Oct 17, 2013 at 09:49:48PM -0700, Darrick J. Wong wrote:
> We should really use the ext2fs memory allocator functions in
> copy_file(), and we really should return a value if there's allocation
> problems.
> 
> Also fix up a minor bogosity in an error message.
> 
> Cc: Robert Yang <liezhi.yang@windriver.com>
> Cc: Darren Hart <dvhart@linux.intel.com>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Two places are missing to be fixed.  Otherwise the patch looks good to
me.
Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>

                                                - Zheng

diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
index d3db356..cc8dd20 100644
--- a/debugfs/debugfs.c
+++ b/debugfs/debugfs.c
@@ -1611,7 +1611,7 @@ static errcode_t copy_file(int fd, ext2_ino_t newfile, int bufsize, int make_hol
 	retval = ext2fs_get_memzero(bufsize, &zero_buf);
 	if (retval) {
 		com_err("copy_file", retval, "can't allocate buffer\n");
-		free(buf);
+		ext2fs_free_mem(&buf);
 		return retval;
 	}
 
@@ -1649,7 +1649,7 @@ static errcode_t copy_file(int fd, ext2_ino_t newfile, int bufsize, int make_hol
 			ptr += written;
 		}
 	}
-	free(buf);
+	ext2fs_free_mem(&buf);
 	ext2fs_free_mem(&zero_buf);
 	retval = ext2fs_file_close(e2_file);
 	return retval;

> ---
>  debugfs/debugfs.c |   11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
> 
> 
> diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
> index 4f6108d..d3db356 100644
> --- a/debugfs/debugfs.c
> +++ b/debugfs/debugfs.c
> @@ -1601,9 +1601,10 @@ static errcode_t copy_file(int fd, ext2_ino_t newfile, int bufsize, int make_hol
>  	if (retval)
>  		return retval;
>  
> -	if (!(buf = (char *) malloc(bufsize))){
> -		com_err("copy_file", errno, "can't allocate buffer\n");
> -		return;
> +	retval = ext2fs_get_mem(bufsize, &buf);
> +	if (retval) {
> +		com_err("copy_file", retval, "can't allocate buffer\n");
> +		return retval;
>  	}
>  
>  	/* This is used for checking whether the whole block is zero */
> @@ -1654,7 +1655,7 @@ static errcode_t copy_file(int fd, ext2_ino_t newfile, int bufsize, int make_hol
>  	return retval;
>  
>  fail:
> -	free(buf);
> +	ext2fs_free_mem(&buf);
>  	ext2fs_free_mem(&zero_buf);
>  	(void) ext2fs_file_close(e2_file);
>  	return retval;
> @@ -2112,7 +2113,7 @@ void do_bmap(int argc, char *argv[])
>  
>  	errcode = ext2fs_bmap2(current_fs, ino, 0, 0, 0, blk, 0, &pblk);
>  	if (errcode) {
> -		com_err("argv[0]", errcode,
> +		com_err(argv[0], errcode,
>  			"while mapping logical block %llu\n", blk);
>  		return;
>  	}
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
