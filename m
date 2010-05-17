From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH V2] mke2fs: account for physical as well as logical sector
 size
Date: Mon, 17 May 2010 16:44:55 -0500
Message-ID: <4BF1B8D7.4020501@redhat.com>
References: <4B7090B7.4060708@redhat.com> <4B70914B.3000102@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751894Ab0EQVpA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 17 May 2010 17:45:00 -0400
Received: from int-mx05.intmail.prod.int.phx2.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.18])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o4HLj03R021261
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Mon, 17 May 2010 17:45:00 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx05.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o4HLitJd001143
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 17 May 2010 17:44:59 -0400
In-Reply-To: <4B70914B.3000102@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Eric Sandeen wrote:
> Some devices, notably 4k sector drives, may have a 512 logical
> sector size, mapped onto a 4k physical sector size.
> 
> When mke2fs is ratcheting down the blocksize for small filesystems,
> or when a blocksize is specified on the commandline, we should not
> willingly go below the physical sector size of the device.
> 
> When a blocksize is specified, we -must- not go below
> the logical sector size of the device.
> 
> Add a new library function, ext2fs_get_device_phys_sectsize()
> to get the physical sector size if possible, and adjust the
> logic in mke2fs to enforce the above rules.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

ping on this one?

-Eric

> ---
> 
> (V2: just forgot to update the subject after changing the patch)
> 
> diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
> index 213a819..9c06048 100644
> --- a/lib/ext2fs/ext2fs.h
> +++ b/lib/ext2fs/ext2fs.h
> @@ -1086,6 +1086,7 @@ extern errcode_t ext2fs_get_device_size2(const char *file, int blocksize,
>  
>  /* getsectsize.c */
>  errcode_t ext2fs_get_device_sectsize(const char *file, int *sectsize);
> +errcode_t ext2fs_get_device_phys_sectsize(const char *file, int *sectsize);
>  
>  /* i_block.c */
>  errcode_t ext2fs_iblk_add_blocks(ext2_filsys fs, struct ext2_inode *inode,
> diff --git a/lib/ext2fs/getsectsize.c b/lib/ext2fs/getsectsize.c
> index ae9139d..0c7fa82 100644
> --- a/lib/ext2fs/getsectsize.c
> +++ b/lib/ext2fs/getsectsize.c
> @@ -26,15 +26,20 @@
>  #include <linux/fd.h>
>  #endif
>  
> -#if defined(__linux__) && defined(_IO) && !defined(BLKSSZGET)
> +#if defined(__linux__) && defined(_IO)
> +#if !defined(BLKSSZGET)
>  #define BLKSSZGET  _IO(0x12,104)/* get block device sector size */
>  #endif
> +#if !defined(BLKPBSZGET)
> +#define BLKPBSZGET _IO(0x12,123)/* get block physical sector size */
> +#endif
> +#endif
>  
>  #include "ext2_fs.h"
>  #include "ext2fs.h"
>  
>  /*
> - * Returns the number of blocks in a partition
> + * Returns the logical sector size of a device 
>   */
>  errcode_t ext2fs_get_device_sectsize(const char *file, int *sectsize)
>  {
> @@ -58,3 +63,29 @@ errcode_t ext2fs_get_device_sectsize(const char *file, int *sectsize)
>  	close(fd);
>  	return 0;
>  }
> +
> +/*
> + * Returns the physical sector size of a device 
> + */
> +errcode_t ext2fs_get_device_phys_sectsize(const char *file, int *sectsize)
> +{
> +	int	fd;
> +
> +#ifdef HAVE_OPEN64
> +	fd = open64(file, O_RDONLY);
> +#else
> +	fd = open(file, O_RDONLY);
> +#endif
> +	if (fd < 0)
> +		return errno;
> +
> +#ifdef BLKPBSZGET
> +	if (ioctl(fd, BLKPBSZGET, sectsize) >= 0) {
> +		close(fd);
> +		return 0;
> +	}
> +#endif
> +	*sectsize = 0;
> +	close(fd);
> +	return 0;
> +}
> diff --git a/lib/ext2fs/tst_getsectsize.c b/lib/ext2fs/tst_getsectsize.c
> index cb1b8c6..31599d2 100644
> --- a/lib/ext2fs/tst_getsectsize.c
> +++ b/lib/ext2fs/tst_getsectsize.c
> @@ -27,7 +27,7 @@
>  
>  int main(int argc, char **argv)
>  {
> -	int	sectsize;
> +	int	lsectsize, psectsize;
>  	int	retval;
>  
>  	if (argc < 2) {
> @@ -35,13 +35,19 @@ int main(int argc, char **argv)
>  		exit(1);
>  	}
>  
> -	retval = ext2fs_get_device_sectsize(argv[1], &sectsize);
> +	retval = ext2fs_get_device_sectsize(argv[1], &lsectsize);
>  	if (retval) {
>  		com_err(argv[0], retval,
>  			"while calling ext2fs_get_device_sectsize");
>  		exit(1);
>  	}
> -	printf("Device %s has a hardware sector size of %d.\n",
> -	       argv[1], sectsize);
> +	retval = ext2fs_get_device_phys_sectsize(argv[1], &psectsize);
> +	if (retval) {
> +		com_err(argv[0], retval,
> +			"while calling ext2fs_get_device_phys_sectsize");
> +		exit(1);
> +	}
> +	printf("Device %s has logical/physical sector size of %d/%d.\n",
> +	       argv[1], lsectsize, psectsize);
>  	exit(0);
>  }
> diff --git a/misc/mke2fs.c b/misc/mke2fs.c
> index 94b4c81..1a1307b 100644
> --- a/misc/mke2fs.c
> +++ b/misc/mke2fs.c
> @@ -1068,7 +1068,7 @@ static void PRS(int argc, char *argv[])
>  	int		inode_size = 0;
>  	unsigned long	flex_bg_size = 0;
>  	double		reserved_ratio = 5.0;
> -	int		sector_size = 0;
> +	int		lsector_size = 0, psector_size = 0;
>  	int		show_version_only = 0;
>  	unsigned long long num_inodes = 0; /* unsigned long long to catch too-large input */
>  	errcode_t	retval;
> @@ -1586,16 +1586,25 @@ got_size:
>  	    ((tmp = getenv("MKE2FS_FIRST_META_BG"))))
>  		fs_param.s_first_meta_bg = atoi(tmp);
>  
> -	/* Get the hardware sector size, if available */
> -	retval = ext2fs_get_device_sectsize(device_name, &sector_size);
> +	/* Get the hardware sector sizes, if available */
> +	retval = ext2fs_get_device_sectsize(device_name, &lsector_size);
>  	if (retval) {
>  		com_err(program_name, retval,
>  			_("while trying to determine hardware sector size"));
>  		exit(1);
>  	}
> +	retval = ext2fs_get_device_phys_sectsize(device_name, &psector_size);
> +	if (retval) {
> +		com_err(program_name, retval,
> +			_("while trying to determine physical sector size"));
> +		exit(1);
> +	}
> +	/* Older kernels may not have physical/logical distinction */
> +	if (!psector_size)
> +		psector_size = lsector_size;
>  
>  	if ((tmp = getenv("MKE2FS_DEVICE_SECTSIZE")) != NULL)
> -		sector_size = atoi(tmp);
> +		psector_size = atoi(tmp);
>  
>  	if (blocksize <= 0) {
>  		use_bsize = get_int_from_profile(fs_types, "blocksize", 4096);
> @@ -1606,14 +1615,25 @@ got_size:
>  			    (use_bsize > 4096))
>  				use_bsize = 4096;
>  		}
> -		if (sector_size && use_bsize < sector_size)
> -			use_bsize = sector_size;
> +		if (psector_size && use_bsize < psector_size)
> +			use_bsize = psector_size;
>  		if ((blocksize < 0) && (use_bsize < (-blocksize)))
>  			use_bsize = -blocksize;
>  		blocksize = use_bsize;
>  		ext2fs_blocks_count_set(&fs_param,
>  					ext2fs_blocks_count(&fs_param) /
>  					(blocksize / 1024));
> +	} else {
> +		if (blocksize < lsector_size ||			/* Impossible */
> +		    (!force && (blocksize < psector_size))) {	/* Suboptimal */
> +			com_err(program_name, EINVAL,
> +				_("while setting blocksize; too small for device\n"));
> +			exit(1);
> +		} else if (blocksize < psector_size) {
> +			fprintf(stderr, _("Warning: specified blocksize %d is "
> +				"less than device physical sectorsize %d, "
> +				"forced to continue\n"), blocksize, psector_size);
> +		}
>  	}
>  
>  	if (inode_ratio == 0) {
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

