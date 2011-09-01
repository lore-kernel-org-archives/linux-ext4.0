From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH 1/5 v2] e2fsprogs: create open() and stat() helpers
Date: Thu, 1 Sep 2011 10:39:50 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1109011039350.3665@dhcp-27-109.brq.redhat.com>
References: <1313167380-3283-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, adilger@dilger.ca
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:13156 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756165Ab1IAIj4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 1 Sep 2011 04:39:56 -0400
In-Reply-To: <1313167380-3283-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 12 Aug 2011, Lukas Czerner wrote:

> In many places we are using #ifdef HAVE_OPEN64 to determine if we can
> use open64() but that's ugly. This commit creates two new helpers
> ext2fs_open_file() for open() and ext2fs_stat() for stat(). Also we need
> new typedef ext2fs_struct_stat for struct stat.

Hi Ted,

ping on the whole series.

Thanks!
-Lukas
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> ---
> v2: This is the actually the first version of the patch
> 
>  lib/ext2fs/ext2fs.h      |   38 ++++++++++++++++++++++++++++++++++++++
>  lib/ext2fs/getsectsize.c |   12 ++----------
>  lib/ext2fs/getsize.c     |    6 +-----
>  lib/ext2fs/unix_io.c     |   10 +++-------
>  misc/e2image.c           |   18 +++---------------
>  misc/util.c              |   10 ++--------
>  resize/main.c            |    6 +-----
>  7 files changed, 50 insertions(+), 50 deletions(-)
> 
> diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
> index dc83fb0..bf61b37 100644
> --- a/lib/ext2fs/ext2fs.h
> +++ b/lib/ext2fs/ext2fs.h
> @@ -584,6 +584,12 @@ typedef struct ext2_icount *ext2_icount_t;
>  #define EXT2FS_NUM_B2C(fs, blks)	(((blks) + EXT2FS_CLUSTER_MASK(fs)) >> \
>  					 (fs)->cluster_ratio_bits)
>  
> +#ifdef HAVE_OPEN64
> +typedef struct stat64 ext2fs_struct_stat;
> +#else
> +typedef struct stat ext2fs_struct_stat;
> +#endif
> +
>  /*
>   * function prototypes
>   */
> @@ -1388,6 +1394,8 @@ extern blk_t ext2fs_inode_data_blocks(ext2_filsys fs,
>  				      struct ext2_inode *inode);
>  extern unsigned int ext2fs_div_ceil(unsigned int a, unsigned int b);
>  extern __u64 ext2fs_div64_ceil(__u64 a, __u64 b);
> +extern int ext2fs_open_file(const char *pathname, int flags, ...);
> +extern int ext2fs_stat(const char *path, ext2fs_struct_stat *buf);
>  
>  /*
>   * The actual inlined functions definitions themselves...
> @@ -1638,6 +1646,36 @@ _INLINE_ __u64 ext2fs_div64_ceil(__u64 a, __u64 b)
>  	return ((a - 1) / b) + 1;
>  }
>  
> +_INLINE_ int ext2fs_open_file(const char *pathname, int flags, ...)
> +{
> +	va_list args;
> +	mode_t mode;
> +
> +	va_start(args, flags);
> +	mode = va_arg(args, mode_t);
> +	va_end(args);
> +
> +	if (mode)
> +#ifdef HAVE_OPEN64
> +		return open64(pathname, flags, mode);
> +	else
> +		return open64(pathname, flags);
> +#else
> +		return open(pathname, flags, mode);
> +	else
> +		return open(pathname, flags);
> +#endif
> +}
> +
> +_INLINE_ int ext2fs_stat(const char *path, ext2fs_struct_stat *buf)
> +{
> +#ifdef HAVE_OPEN64
> +	return stat64(path, buf);
> +#else
> +	return open(path, buf);
> +#endif
> +}
> +
>  #undef _INLINE_
>  #endif
>  
> diff --git a/lib/ext2fs/getsectsize.c b/lib/ext2fs/getsectsize.c
> index 64f42a6..f129be1 100644
> --- a/lib/ext2fs/getsectsize.c
> +++ b/lib/ext2fs/getsectsize.c
> @@ -45,11 +45,7 @@ errcode_t ext2fs_get_device_sectsize(const char *file, int *sectsize)
>  {
>  	int	fd;
>  
> -#ifdef HAVE_OPEN64
> -	fd = open64(file, O_RDONLY);
> -#else
> -	fd = open(file, O_RDONLY);
> -#endif
> +	fd = ext2fs_open_file(file, O_RDONLY);
>  	if (fd < 0)
>  		return errno;
>  
> @@ -71,11 +67,7 @@ errcode_t ext2fs_get_device_phys_sectsize(const char *file, int *sectsize)
>  {
>  	int	fd;
>  
> -#ifdef HAVE_OPEN64
> -	fd = open64(file, O_RDONLY);
> -#else
> -	fd = open(file, O_RDONLY);
> -#endif
> +	fd = ext2fs_open_file(file, O_RDONLY);
>  	if (fd < 0)
>  		return errno;
>  
> diff --git a/lib/ext2fs/getsize.c b/lib/ext2fs/getsize.c
> index 0c91b5b..41da6b9 100644
> --- a/lib/ext2fs/getsize.c
> +++ b/lib/ext2fs/getsize.c
> @@ -159,11 +159,7 @@ errcode_t ext2fs_get_device_size2(const char *file, int blocksize,
>  	char ch;
>  #endif /* HAVE_SYS_DISKLABEL_H */
>  
> -#ifdef HAVE_OPEN64
> -	fd = open64(file, O_RDONLY);
> -#else
> -	fd = open(file, O_RDONLY);
> -#endif
> +	fd = ext2fs_open_file(file, O_RDONLY);
>  	if (fd < 0)
>  		return errno;
>  
> diff --git a/lib/ext2fs/unix_io.c b/lib/ext2fs/unix_io.c
> index c1d0561..21a273d 100644
> --- a/lib/ext2fs/unix_io.c
> +++ b/lib/ext2fs/unix_io.c
> @@ -441,7 +441,7 @@ static errcode_t unix_open(const char *name, int flags, io_channel *channel)
>  	struct unix_private_data *data = NULL;
>  	errcode_t	retval;
>  	int		open_flags, zeroes = 0;
> -	struct stat	st;
> +	ext2fs_struct_stat st;
>  #ifdef __linux__
>  	struct 		utsname ut;
>  #endif
> @@ -482,11 +482,7 @@ static errcode_t unix_open(const char *name, int flags, io_channel *channel)
>  #endif
>  	data->flags = flags;
>  
> -#ifdef HAVE_OPEN64
> -	data->dev = open64(io->name, open_flags);
> -#else
> -	data->dev = open(io->name, open_flags);
> -#endif
> +	data->dev = ext2fs_open_file(io->name, open_flags);
>  	if (data->dev < 0) {
>  		retval = errno;
>  		goto cleanup;
> @@ -552,7 +548,7 @@ static errcode_t unix_open(const char *name, int flags, io_channel *channel)
>  	     (ut.release[2] == '4') && (ut.release[3] == '.') &&
>  	     (ut.release[4] == '1') && (ut.release[5] >= '0') &&
>  	     (ut.release[5] < '8')) &&
> -	    (fstat(data->dev, &st) == 0) &&
> +	    (ext2fs_stat(io->name, &st) == 0) &&
>  	    (S_ISBLK(st.st_mode))) {
>  		struct rlimit	rlim;
>  
> diff --git a/misc/e2image.c b/misc/e2image.c
> index 83a9d02..ca6fd41 100644
> --- a/misc/e2image.c
> +++ b/misc/e2image.c
> @@ -1176,11 +1176,7 @@ static void install_image(char *device, char *image_fn, int type)
>  		exit(1);
>  	}
>  
> -#ifdef HAVE_OPEN64
> -	fd = open64(image_fn, O_RDONLY);
> -#else
> -	fd = open(image_fn, O_RDONLY);
> -#endif
> +	fd = ext2fs_open_file(image_fn, O_RDONLY);
>  	if (fd < 0) {
>  		perror(image_fn);
>  		exit(1);
> @@ -1212,11 +1208,7 @@ static void install_image(char *device, char *image_fn, int type)
>  static struct ext2_qcow2_hdr *check_qcow2_image(int *fd, char *name)
>  {
>  
> -#ifdef HAVE_OPEN64
> -	*fd = open64(name, O_RDONLY, 0600);
> -#else
> -	*fd = open(name, O_RDONLY, 0600);
> -#endif
> +	*fd = ext2fs_open_file(name, O_RDONLY, 0600);
>  	if (*fd < 0)
>  		return NULL;
>  
> @@ -1300,11 +1292,7 @@ skip_device:
>  	if (strcmp(image_fn, "-") == 0)
>  		fd = 1;
>  	else {
> -#ifdef HAVE_OPEN64
> -		fd = open64(image_fn, O_CREAT|O_TRUNC|O_WRONLY, 0600);
> -#else
> -		fd = open(image_fn, O_CREAT|O_TRUNC|O_WRONLY, 0600);
> -#endif
> +		fd = ext2fs_open_file(image_fn, O_CREAT|O_TRUNC|O_WRONLY, 0600);
>  		if (fd < 0) {
>  			com_err(program_name, errno,
>  				_("while trying to open %s"), argv[optind+1]);
> diff --git a/misc/util.c b/misc/util.c
> index 51bdb60..cd78b00 100644
> --- a/misc/util.c
> +++ b/misc/util.c
> @@ -79,15 +79,9 @@ void proceed_question(void)
>  void check_plausibility(const char *device)
>  {
>  	int val;
> -#ifdef HAVE_OPEN64
> -	struct stat64 s;
> +	ext2fs_struct_stat s;
>  
> -	val = stat64(device, &s);
> -#else
> -	struct stat s;
> -
> -	val = stat(device, &s);
> -#endif
> +	val = ext2fs_stat(device, &s);
>  
>  	if(val == -1) {
>  		fprintf(stderr, _("Could not stat %s --- %s\n"),
> diff --git a/resize/main.c b/resize/main.c
> index 28a49ba..daa68c5 100644
> --- a/resize/main.c
> +++ b/resize/main.c
> @@ -256,11 +256,7 @@ int main (int argc, char ** argv)
>  		len = 2 * len;
>  	}
>  
> -#ifdef HAVE_OPEN64
> -	fd = open64(device_name, O_RDWR);
> -#else
> -	fd = open(device_name, O_RDWR);
> -#endif
> +	fd = ext2fs_open_file(device_name, O_RDWR);
>  	if (fd < 0) {
>  		com_err("open", errno, _("while opening %s"),
>  			device_name);
> 

-- 
