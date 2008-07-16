From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: Re: [PATCH 15/15][e2fsprogs] 64-bit mke2fs cleanup
Date: Wed, 16 Jul 2008 12:44:37 -0500
Message-ID: <20080716124437.700cd00f@ichigo>
References: <20080715164332.28567.27913.stgit@ichigo>
	<20080715165129.28567.7837.stgit@ichigo>
	<87fxq99810.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Goswin von Brederlow <goswin-v-b@web.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:36877 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921AbYGPRo4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 16 Jul 2008 13:44:56 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e36.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m6GHir7O030746
	for <linux-ext4@vger.kernel.org>; Wed, 16 Jul 2008 13:44:53 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m6GHii0T075118
	for <linux-ext4@vger.kernel.org>; Wed, 16 Jul 2008 11:44:47 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m6GHihTj026078
	for <linux-ext4@vger.kernel.org>; Wed, 16 Jul 2008 11:44:43 -0600
In-Reply-To: <87fxq99810.fsf@frosties.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 16 Jul 2008 17:13:31 +0200
Goswin von Brederlow <goswin-v-b@web.de> wrote:

> From: Goswin von Brederlow <goswin-v-b@web.de>
> 
> Bring back overflow checks in mke2fs.c and remove dead code in
> getsize.c
> 
> - ext2fs_get_device_size2() no longer returns EFBIG, the code path for
>   it is dead. remove.
> 
> - Change code to check actual dev_size against 2^32.
> 
> - Check for EXT4_FEATURE_INCOMPAT_64BIT before bailing out with
>   excessive size error.
> 
> - Move check, only check dev_size when it is actualy used. Not when
>   overridden by command line args.
> 
> FIXME: check command line args for excessive size too.
> 
> Signed-off-by: Goswin von Brederlow <goswin-v-b@web.de>
> --
> 
>  lib/ext2fs/getsize.c |   15 ---------------
>  misc/mke2fs.c        |   30 +++++++++++++++---------------
>  2 files changed, 15 insertions(+), 30 deletions(-)
> 
> Index: e2fsprogs/misc/mke2fs.c
> ===================================================================
> --- e2fsprogs.orig/misc/mke2fs.c	2008-07-16 15:59:48.000000000 +0200
> +++ e2fsprogs/misc/mke2fs.c	2008-07-16 16:57:54.000000000 +0200
> @@ -1410,21 +1410,6 @@ static void PRS(int argc, char *argv[])
>  		retval = ext2fs_get_device_size2(device_name,
>  						EXT2_BLOCK_SIZE(&fs_param),
>  						&dev_size);
> -		if ((retval == EFBIG) &&
> -		    (blocksize == 0) && 
> -		    (fs_param.s_log_block_size == 0)) {
> -			fs_param.s_log_block_size = 2;
> -			blocksize = 4096;
> -			goto retry;
> -		}
> -	}
> -			
> -	if (retval == EFBIG) {
> -		fprintf(stderr, _("%s: Size of device %s too big "
> -				  "to be expressed in 32 bits\n\t"
> -				  "using a blocksize of %d.\n"),
> -			program_name, device_name, EXT2_BLOCK_SIZE(&fs_param));
> -		exit(1);
>  	}
>  	if (retval && (retval != EXT2_ET_UNIMPLEMENTED)) {
>  		com_err(program_name, retval,
> @@ -1451,7 +1436,22 @@ static void PRS(int argc, char *argv[])
>  				  ));
>  				exit(1);
>  			}
> +			if ((dev_size >= 1LLU << 32) &&
> +			    (blocksize == 0) &&
> +			    (fs_param.s_log_block_size == 0)) {
> +				fs_param.s_log_block_size = 2;
> +				blocksize = 4096;
> +				goto retry;
> +			}
> +			if (!(fs_param.s_feature_incompat & EXT4_FEATURE_INCOMPAT_64BIT) && (dev_size >= 1ULL << 32)) {
> +				fprintf(stderr, _("%s: Size of device %s too big "
> +						  "to be expressed in 32 bits\n\t"
> +						  "using a blocksize of %d.\n"),
> +					program_name, device_name, EXT2_BLOCK_SIZE(&fs_param));
> +				exit(1);
> +			}

Well, EXT4_FEATURE_INCOMPAT_64BIT should be setup later in PRS() along
with setting up large group descriptors so this piece need work.  This
should fail if what we are making is a ext3 filesystem and if we are
making a ext4 filesystem with > 32bit blocks, set the
EXT4_FEATURE_INCOMPAT_64BIT flag as well as the large bgd.

I'll fix this on the next release.

>  			ext2fs_blocks_count_set(&fs_param, dev_size);
> +fprintf(stderr, "blocks count = %llu\n", ext2fs_blocks_count(&fs_param));
>  			if (sys_page_size > EXT2_BLOCK_SIZE(&fs_param)) {
>  				blk64_t tmp = ext2fs_blocks_count(&fs_param);
>  				tmp &= ~((sys_page_size /
> Index: e2fsprogs/lib/ext2fs/getsize.c
> ===================================================================
> --- e2fsprogs.orig/lib/ext2fs/getsize.c	2008-07-16 16:34:58.000000000 +0200
> +++ e2fsprogs/lib/ext2fs/getsize.c	2008-07-16 16:49:03.000000000 +0200
> @@ -188,11 +188,6 @@ errcode_t ext2fs_get_device_size2(const 
>  #endif
>  	if (valid_blkgetsize64 &&
>  	    ioctl(fd, BLKGETSIZE64, &size64) >= 0) {
> -		if ((sizeof(*retblocks) < sizeof(unsigned long long)) &&
> -		    ((size64 / blocksize) > 0xFFFFFFFF)) {
> -			rc = EFBIG;
> -			goto out;
> -		}
>  		*retblocks = size64 / blocksize;
>  		goto out;
>  	}
> @@ -253,11 +248,6 @@ errcode_t ext2fs_get_device_size2(const 
>  		if (fstat(fd, &st) == 0)
>  #endif
>  			if (S_ISREG(st.st_mode)) {
> -				if ((sizeof(*retblocks) < sizeof(unsigned long long)) &&
> -				    ((st.st_size / blocksize) > 0xFFFFFFFF)) {
> -					rc = EFBIG;
> -					goto out;
> -				}
>  				*retblocks = st.st_size / blocksize;
>  				goto out;
>  			}
> @@ -282,11 +272,6 @@ errcode_t ext2fs_get_device_size2(const 
>  	}
>  	valid_offset (fd, 0);
>  	size64 = low + 1;
> -	if ((sizeof(*retblocks) < sizeof(unsigned long long))
> -	    && ((size64 / blocksize) > 0xFFFFFFFF)) {
> -		rc = EFBIG;
> -		goto out;
> -	}
>  	*retblocks = size64 / blocksize;
>  out:
>  	close(fd);
