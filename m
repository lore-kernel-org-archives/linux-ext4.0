From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH 2/6] mke2fs: clean up kernel version tests
Date: Tue, 21 Jan 2014 15:32:40 +0800
Message-ID: <20140121073240.GC1819@gmail.com>
References: <20140121062138.20507.60259.stgit@birch.djwong.org>
 <20140121062151.20507.41042.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f180.google.com ([209.85.192.180]:35520 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809AbaAUH2S (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 21 Jan 2014 02:28:18 -0500
Received: by mail-pd0-f180.google.com with SMTP id x10so6564366pdj.11
        for <linux-ext4@vger.kernel.org>; Mon, 20 Jan 2014 23:28:18 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20140121062151.20507.41042.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jan 20, 2014 at 10:21:51PM -0800, Darrick J. Wong wrote:
> Refactor the running kernel version checks to hide the details of
> version code checking, etc.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>
                                                - Zheng

> ---
>  misc/mke2fs.c |   39 +++++++++++++++++++++++++--------------
>  1 file changed, 25 insertions(+), 14 deletions(-)
> 
> 
> diff --git a/misc/mke2fs.c b/misc/mke2fs.c
> index 527f25b..f8232d4 100644
> --- a/misc/mke2fs.c
> +++ b/misc/mke2fs.c
> @@ -27,6 +27,7 @@
>  #include <time.h>
>  #ifdef __linux__
>  #include <sys/utsname.h>
> +#include <linux/version.h>
>  #endif
>  #ifdef HAVE_GETOPT_H
>  #include <getopt.h>
> @@ -169,7 +170,28 @@ static int parse_version_number(const char *s)
>  	rev = strtol(cp, &endptr, 10);
>  	if (cp == endptr)
>  		return 0;
> -	return ((((major * 256) + minor) * 256) + rev);
> +	return KERNEL_VERSION(major, minor, rev);
> +}
> +
> +static int is_before_linux_ver(unsigned int major, unsigned int minor)
> +{
> +	struct		utsname ut;
> +	int		linux_version_code = 0;
> +
> +	if (uname(&ut)) {
> +		perror("uname");
> +		exit(1);
> +	}
> +	linux_version_code = parse_version_number(ut.release);
> +	if (linux_version_code == 0)
> +		return 0;
> +
> +	return linux_version_code < KERNEL_VERSION(major, minor, 0);
> +}
> +#else
> +static int is_before_linux_ver(unsigned int major, unsigned int minor)
> +{
> +	return 0;
>  }
>  #endif
>  
> @@ -1362,9 +1384,6 @@ static void PRS(int argc, char *argv[])
>  	 * Finally, we complain about fs_blocks_count > 2^32 on a non-64bit fs.
>  	 */
>  	blk64_t		fs_blocks_count = 0;
> -#ifdef __linux__
> -	struct 		utsname ut;
> -#endif
>  	long		sysval;
>  	int		s_opt = -1, r_opt = -1;
>  	char		*fs_features = 0;
> @@ -1430,15 +1449,8 @@ profile_error:
>  	memset(&fs_param, 0, sizeof(struct ext2_super_block));
>  	fs_param.s_rev_level = 1;  /* Create revision 1 filesystems now */
>  
> -#ifdef __linux__
> -	if (uname(&ut)) {
> -		perror("uname");
> -		exit(1);
> -	}
> -	linux_version_code = parse_version_number(ut.release);
> -	if (linux_version_code && linux_version_code < (2*65536 + 2*256))
> +	if (is_before_linux_ver(2, 2))
>  		fs_param.s_rev_level = 0;
> -#endif
>  
>  	if (argc && *argv) {
>  		program_name = get_progname(*argv);
> @@ -1876,8 +1888,7 @@ profile_error:
>  
>  		if (use_bsize == -1) {
>  			use_bsize = sys_page_size;
> -			if ((linux_version_code < (2*65536 + 6*256)) &&
> -			    (use_bsize > 4096))
> +			if (is_before_linux_ver(2, 6) && use_bsize > 4096)
>  				use_bsize = 4096;
>  		}
>  		if (lsector_size && use_bsize < lsector_size)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
