From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] libext2fs: make ext2fs_open_file() always use 3 arguments
 instead of varargs
Date: Fri, 07 Oct 2011 10:47:32 -0500
Message-ID: <4E8F1F14.2000609@redhat.com>
References: <1317922238-3847-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60036 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753291Ab1JGPrk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 7 Oct 2011 11:47:40 -0400
In-Reply-To: <1317922238-3847-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 10/6/11 12:30 PM, Theodore Ts'o wrote:
> Some architectures have narrow mode_t's which can cause some
> portability warnings with varargs.
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

seems fine.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>


> ---
>  lib/ext2fs/ext2fs.h      |    9 ++-------
>  lib/ext2fs/getsectsize.c |    4 ++--
>  lib/ext2fs/getsize.c     |    2 +-
>  lib/ext2fs/unix_io.c     |    2 +-
>  misc/e2image.c           |    2 +-
>  resize/main.c            |    2 +-
>  6 files changed, 8 insertions(+), 13 deletions(-)
> 
> diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
> index b04b0d1..411a383 100644
> --- a/lib/ext2fs/ext2fs.h
> +++ b/lib/ext2fs/ext2fs.h
> @@ -1438,7 +1438,7 @@ extern blk_t ext2fs_inode_data_blocks(ext2_filsys fs,
>  				      struct ext2_inode *inode);
>  extern unsigned int ext2fs_div_ceil(unsigned int a, unsigned int b);
>  extern __u64 ext2fs_div64_ceil(__u64 a, __u64 b);
> -extern int ext2fs_open_file(const char *pathname, int flags, ...);
> +extern int ext2fs_open_file(const char *pathname, int flags, mode_t mode);
>  extern int ext2fs_stat(const char *path, ext2fs_struct_stat *buf);
>  extern int ext2fs_fstat(int fd, ext2fs_struct_stat *buf);
>  
> @@ -1691,14 +1691,9 @@ _INLINE_ __u64 ext2fs_div64_ceil(__u64 a, __u64 b)
>  	return ((a - 1) / b) + 1;
>  }
>  
> -_INLINE_ int ext2fs_open_file(const char *pathname, int flags, ...)
> +_INLINE_ int ext2fs_open_file(const char *pathname, int flags, mode_t mode)
>  {
>  	va_list args;
> -	mode_t mode;
> -
> -	va_start(args, flags);
> -	mode = va_arg(args, mode_t);
> -	va_end(args);
>  
>  	if (mode)
>  #if defined(HAVE_OPEN64) && !defined(__OSX_AVAILABLE_BUT_DEPRECATED)
> diff --git a/lib/ext2fs/getsectsize.c b/lib/ext2fs/getsectsize.c
> index 9d61553..30faecc 100644
> --- a/lib/ext2fs/getsectsize.c
> +++ b/lib/ext2fs/getsectsize.c
> @@ -46,7 +46,7 @@ errcode_t ext2fs_get_device_sectsize(const char *file, int *sectsize)
>  {
>  	int	fd;
>  
> -	fd = ext2fs_open_file(file, O_RDONLY);
> +	fd = ext2fs_open_file(file, O_RDONLY, 0);
>  	if (fd < 0)
>  		return errno;
>  
> @@ -68,7 +68,7 @@ errcode_t ext2fs_get_device_phys_sectsize(const char *file, int *sectsize)
>  {
>  	int	fd;
>  
> -	fd = ext2fs_open_file(file, O_RDONLY);
> +	fd = ext2fs_open_file(file, O_RDONLY, 0);
>  	if (fd < 0)
>  		return errno;
>  
> diff --git a/lib/ext2fs/getsize.c b/lib/ext2fs/getsize.c
> index a2e6e47..1e0ed16 100644
> --- a/lib/ext2fs/getsize.c
> +++ b/lib/ext2fs/getsize.c
> @@ -160,7 +160,7 @@ errcode_t ext2fs_get_device_size2(const char *file, int blocksize,
>  	char ch;
>  #endif /* HAVE_SYS_DISKLABEL_H */
>  
> -	fd = ext2fs_open_file(file, O_RDONLY);
> +	fd = ext2fs_open_file(file, O_RDONLY, 0);
>  	if (fd < 0)
>  		return errno;
>  
> diff --git a/lib/ext2fs/unix_io.c b/lib/ext2fs/unix_io.c
> index 787990d..5337022 100644
> --- a/lib/ext2fs/unix_io.c
> +++ b/lib/ext2fs/unix_io.c
> @@ -486,7 +486,7 @@ static errcode_t unix_open(const char *name, int flags, io_channel *channel)
>  #endif
>  	data->flags = flags;
>  
> -	data->dev = ext2fs_open_file(io->name, open_flags);
> +	data->dev = ext2fs_open_file(io->name, open_flags, 0);
>  	if (data->dev < 0) {
>  		retval = errno;
>  		goto cleanup;
> diff --git a/misc/e2image.c b/misc/e2image.c
> index c108a7a..23a4df2 100644
> --- a/misc/e2image.c
> +++ b/misc/e2image.c
> @@ -1178,7 +1178,7 @@ static void install_image(char *device, char *image_fn, int type)
>  		exit(1);
>  	}
>  
> -	fd = ext2fs_open_file(image_fn, O_RDONLY);
> +	fd = ext2fs_open_file(image_fn, O_RDONLY, 0);
>  	if (fd < 0) {
>  		perror(image_fn);
>  		exit(1);
> diff --git a/resize/main.c b/resize/main.c
> index e6e9e7b..1ab0e04 100644
> --- a/resize/main.c
> +++ b/resize/main.c
> @@ -258,7 +258,7 @@ int main (int argc, char ** argv)
>  		len = 2 * len;
>  	}
>  
> -	fd = ext2fs_open_file(device_name, O_RDWR);
> +	fd = ext2fs_open_file(device_name, O_RDWR, 0);
>  	if (fd < 0) {
>  		com_err("open", errno, _("while opening %s"),
>  			device_name);

