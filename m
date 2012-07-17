From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] E2fsprogs/filefrag: fix filefrag regression
Date: Tue, 17 Jul 2012 16:57:15 -0500
Message-ID: <5005DFBB.4090004@redhat.com>
References: <1339663486-5417-1-git-send-email-liubo2009@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Liu Bo <liubo2009@cn.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33285 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751007Ab2GQV5U (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 17 Jul 2012 17:57:20 -0400
In-Reply-To: <1339663486-5417-1-git-send-email-liubo2009@cn.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 6/14/12 3:44 AM, Liu Bo wrote:
> filefrag has several bugs:
> 
> 1.
> $ touch f1
> $ filefrag f1
> f1: 1 extent found  ----> bug!
> $ filefrag -v f1
> Filesystem type is: ef53
> File size of f1 is 0 (0 blocks, blocksize 4096)
> f1: 0 extents found
> 
> 2.
> $ truncate -s 1m f2
> $ filefrag f2
> f2: 1 extent found  ----> bug!
> $ filefrag -v f2
> Filesystem type is: ef53
> File size of f2 is 1048576 (256 blocks, blocksize 4096)
> f2: 0 extents found
> 
> 3.
> $ for i in `seq 11 -2 0`; do dd if=/dev/zero of=f4 bs=4k count=1 seek=$i conv=notrunc oflag=sync &>/dev/null; done
> $ ll f4
> -rw-r--r-- 1 root root 49152 Jun  9 15:09 f4
> $ filefrag f4
> f4: 7 extents found
> $ filefrag -v f4
> Filesystem type is: ef53
> File size of f4 is 49152 (12 blocks, blocksize 4096)
>  ext logical physical expected length flags
>    0       1  1109993               1
>    1       3  1109992  1109994      1
>    2       5  1109991  1109993      1
>    3       7  1109990  1109992      1
>    4       9  1109989  1109991      1
>    5      11  1108207  1109990      1 eof
> f4: 7 extents found  --------------------------> but we only have 6 extents, bug!
> 
> All of these bugs come from the fact that we've made a mistake on calculating
> total extents:
> o   we set 1 as default for 'total extents', and this will report 1 extent found
>     even when we don't get any extent from fiemap.
> o   if our first extent does not start from 0(logical addr), total extents will
>     be one more than what it should be.
> 
> Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>

Looks right to me.  FWIW, there's a Fedora bug open for this, #840848

Maybe another one for merging, Ted?

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  misc/filefrag.c |   25 ++++++++++---------------
>  1 files changed, 10 insertions(+), 15 deletions(-)
> 
> diff --git a/misc/filefrag.c b/misc/filefrag.c
> index 0583e91..af008fb 100644
> --- a/misc/filefrag.c
> +++ b/misc/filefrag.c
> @@ -175,7 +175,7 @@ static int filefrag_fiemap(int fd, int blk_shift, int *num_extents)
>  	unsigned int i;
>  	static int fiemap_incompat_printed;
>  	int fiemap_header_printed = 0;
> -	int tot_extents = 1, n = 0;
> +	int tot_extents = 0, n = 0;
>  	int last = 0;
>  	int rc;
>  
> @@ -201,25 +201,17 @@ static int filefrag_fiemap(int fd, int blk_shift, int *num_extents)
>  			return rc;
>  		}
>  
> +		/* If 0 extents are returned, then more ioctls are not needed */
> +		if (fiemap->fm_mapped_extents == 0)
> +			break;
> +
>  		if (verbose && !fiemap_header_printed) {
> -			/*
> -			 * No extents on first call?
> -			 * Skip header and show 0 extents.
> -			 */
> -			if (fiemap->fm_mapped_extents == 0) {
> -				*num_extents = 0;
> -				goto out;
> -			}
>  			printf(" ext %*s %*s %*s length flags\n", logical_width,
>  			       "logical", physical_width, "physical",
>  			       physical_width, "expected");
>  			fiemap_header_printed = 1;
>  		}
>  
> -		/* If 0 extents are returned, then more ioctls are not needed */
> -		if (fiemap->fm_mapped_extents == 0)
> -			break;
> -
>  		for (i = 0; i < fiemap->fm_mapped_extents; i++) {
>  			__u64 phy_blk, logical_blk;
>  			unsigned long ext_len;
> @@ -228,10 +220,13 @@ static int filefrag_fiemap(int fd, int blk_shift, int *num_extents)
>  			ext_len = fm_ext[i].fe_length >> blk_shift;
>  			logical_blk = fm_ext[i].fe_logical >> blk_shift;
>  
> -			if (logical_blk && phy_blk != expected)
> +			if (logical_blk && phy_blk != expected) {
>  				tot_extents++;
> -			else
> +			} else {
>  				expected = 0;
> +				if (!tot_extents)
> +					tot_extents = 1;
> +			}
>  			if (verbose)
>  				print_extent_info(&fm_ext[i], n, expected,
>  						  blk_shift);
> 


