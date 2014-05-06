From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH -v2 3/3] mke2fs: check for a partition table and warn if
 present
Date: Tue, 6 May 2014 15:47:03 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1405061546220.2255@localhost.localdomain>
References: <1399338133-21373-1-git-send-email-tytso@mit.edu> <1399338133-21373-3-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51423 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755141AbaEFNrI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 6 May 2014 09:47:08 -0400
In-Reply-To: <1399338133-21373-3-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 5 May 2014, Theodore Ts'o wrote:

> Date: Mon,  5 May 2014 21:02:13 -0400
> From: Theodore Ts'o <tytso@mit.edu>
> To: Ext4 Developers List <linux-ext4@vger.kernel.org>
> Cc: Theodore Ts'o <tytso@mit.edu>
> Subject: [PATCH -v2 3/3] mke2fs: check for a partition table and warn if
>     present
> 
> This supercedes the "whole disk" check, since it does a better job and
> there are times when it is quite legitimate to want to use the whole
> disk.
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> ---
>  configure       |  2 +-
>  configure.in    |  1 +
>  lib/config.h.in |  3 +++
>  misc/util.c     | 61 ++++++++++++++++++++++++++++++++++++++++++++++++++-------
>  4 files changed, 59 insertions(+), 8 deletions(-)
> 
> diff --git a/configure b/configure
> index 44664c3..6fe33f5 100755
> --- a/configure
> +++ b/configure
> @@ -11078,7 +11078,7 @@ if test "$ac_res" != no; then :
>  fi
>  
>  fi
> -for ac_func in  	__secure_getenv 	backtrace 	blkid_probe_get_topology 	chflags 	fadvise64 	fallocate 	fallocate64 	fchown 	fdatasync 	fstat64 	ftruncate64 	futimes 	getcwd 	getdtablesize 	getmntinfo 	getpwuid_r 	getrlimit 	getrusage 	jrand48 	llseek 	lseek64 	mallinfo 	mbstowcs 	memalign 	mempcpy 	mmap 	msync 	nanosleep 	open64 	pathconf 	posix_fadvise 	posix_fadvise64 	posix_memalign 	prctl 	secure_getenv 	setmntent 	setresgid 	setresuid 	srandom 	stpcpy 	strcasecmp 	strdup 	strnlen 	strptime 	strtoull 	sync_file_range 	sysconf 	usleep 	utime 	valloc
> +for ac_func in  	__secure_getenv 	backtrace 	blkid_probe_get_topology 	blkid_probe_enable_partitions 	chflags 	fadvise64 	fallocate 	fallocate64 	fchown 	fdatasync 	fstat64 	ftruncate64 	futimes 	getcwd 	getdtablesize 	getmntinfo 	getpwuid_r 	getrlimit 	getrusage 	jrand48 	llseek 	lseek64 	mallinfo 	mbstowcs 	memalign 	mempcpy 	mmap 	msync 	nanosleep 	open64 	pathconf 	posix_fadvise 	posix_fadvise64 	posix_memalign 	prctl 	secure_getenv 	setmntent 	setresgid 	setresuid 	srandom 	stpcpy 	strcasecmp 	strdup 	strnlen 	strptime 	strtoull 	sync_file_range 	sysconf 	usleep 	utime 	valloc
>  do :
>    as_ac_var=`$as_echo "ac_cv_func_$ac_func" | $as_tr_sh`
>  ac_fn_c_check_func "$LINENO" "$ac_func" "$as_ac_var"
> diff --git a/configure.in b/configure.in
> index e0e6d48..781b6f5 100644
> --- a/configure.in
> +++ b/configure.in
> @@ -1050,6 +1050,7 @@ AC_CHECK_FUNCS(m4_flatten([
>  	__secure_getenv
>  	backtrace
>  	blkid_probe_get_topology
> +	blkid_probe_enable_partitions
>  	chflags
>  	fadvise64
>  	fallocate
> diff --git a/lib/config.h.in b/lib/config.h.in
> index b575a5c..92b3c49 100644
> --- a/lib/config.h.in
> +++ b/lib/config.h.in
> @@ -55,6 +55,9 @@
>  /* Define to 1 if you have the `backtrace' function. */
>  #undef HAVE_BACKTRACE
>  
> +/* Define to 1 if you have the `blkid_probe_enable_partitions' function. */
> +#undef HAVE_BLKID_PROBE_ENABLE_PARTITIONS
> +
>  /* Define to 1 if you have the `blkid_probe_get_topology' function. */
>  #undef HAVE_BLKID_PROBE_GET_TOPOLOGY
>  
> diff --git a/misc/util.c b/misc/util.c
> index d63e21b..ce3c416 100644
> --- a/misc/util.c
> +++ b/misc/util.c
> @@ -139,13 +139,54 @@ static void print_ext2_info(const char *device)
>  	ext2fs_close(fs);
>  }
>  
> +/*
> + * return 1 if there is no partition table, 0 if a partition table is
> + * detected, and -1 on an error.
> + */
> +static int check_partition_table(const char *device)
> +{
> +#ifdef HAVE_BLKID_PROBE_ENABLE_PARTITIONS
> +	blkid_probe pr;
> +	const char *value;
> +	int ret;
> +
> +	pr = blkid_new_probe_from_filename(device);
> +	if (!pr)
> +		return -1;
> +
> +        ret = blkid_probe_enable_partitions(pr, 1);
> +        if (ret < 0)

Wrong indentation (spaces instead of tab), but otherwise it looks
good. Thanks!

Reviewed-by: Lukas Czerner <lczerner@redhat.com>

> +		goto errout;
> +
> +	ret = blkid_probe_enable_superblocks(pr, 0);
> +	if (ret < 0)
> +		goto errout;
> +
> +	ret = blkid_do_fullprobe(pr);
> +	if (ret < 0)
> +		goto errout;
> +
> +	ret = blkid_probe_lookup_value(pr, "PTTYPE", &value, NULL);
> +	if (ret == 0)
> +		fprintf(stderr, _("Found a %s partition table in %s\n"),
> +			value, device);
> +	else
> +		ret = 1;
> +
> +errout:
> +	blkid_free_probe(pr);
> +	return ret;
> +#else
> +	return -1;
> +#endif
> +}
>  
>  /*
>   * return 1 if the device looks plausible, creating the file if necessary
>   */
>  int check_plausibility(const char *device, int flags, int *ret_is_dev)
>  {
> -	int fd, is_dev = 0;
> +	int fd, ret, is_dev = 0;
>  	ext2fs_struct_stat s;
>  	int fl = O_RDONLY;
>  	blkid_cache cache = NULL;
> @@ -189,6 +230,15 @@ int check_plausibility(const char *device, int flags, int *ret_is_dev)
>  		return 0;
>  	}
>  
> +	/*
> +	 * Note: we use the older-style blkid API's here because we
> +	 * want as much functionality to be available when using the
> +	 * internal blkid library, when e2fsprogs is compiled for
> +	 * non-Linux systems that will probably not have the libraries
> +	 * from util-linux available.  We only use the newer
> +	 * blkid-probe interfaces to access functionality not
> +	 * available in the original blkid library.
> +	 */
>  	if ((flags & CHECK_FS_EXIST) && blkid_get_cache(&cache, NULL) >= 0) {
>  		fs_type = blkid_get_tag_value(cache, "TYPE", device);
>  		if (fs_type)
> @@ -210,12 +260,9 @@ int check_plausibility(const char *device, int flags, int *ret_is_dev)
>  		return 0;
>  	}
>  
> -	/*
> -	 * We should eventually replace this with a test for the
> -	 * presence of a partition table.  Unfortunately the blkid
> -	 * library doesn't test for partition tabels, and checking for
> -	 * valid GPT and MBR and possibly others isn't quite trivial.
> -	 */
> +	ret = check_partition_table(device);
> +	if (ret >= 0)
> +		return ret;
>  
>  #ifdef HAVE_LINUX_MAJOR_H
>  #ifndef MAJOR
> 
