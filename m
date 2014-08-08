From: Timofey Titovets <nefelim4ag@gmail.com>
Subject: Re: [PATCH] libext2fs: have UNIX IO manager use pread64/pwrite64
Date: Sat, 9 Aug 2014 00:21:23 +0300
Message-ID: <CAGqmi75Qedh2CBo0M+hNh2qQKcm5UUJ56+cnHxub8xBXUDMWJw@mail.gmail.com>
References: <1407531663-1816-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: unlisted-recipients:; (no To-header on input)
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-we0-f173.google.com ([74.125.82.173]:56215 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932914AbaHHVVp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 8 Aug 2014 17:21:45 -0400
Received: by mail-we0-f173.google.com with SMTP id q58so6238813wes.18
        for <linux-ext4@vger.kernel.org>; Fri, 08 Aug 2014 14:21:43 -0700 (PDT)
In-Reply-To: <1407531663-1816-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

unsubscribe linux-ext4

2014-08-09 0:01 GMT+03:00 Theodore Ts'o <tytso@mit.edu>:
> Commit baa3544609da3c ("libext2fs: have UNIX IO manager use
> pread/pwrite) causes a breakage on 32-bit systems where off_t is
> 32-bits for file systems larger than 4GB.  Fix this by using
> pread64/pwrite64 if possible, and if pread64/pwrite64 is not present,
> using pread/pwrite only if the size of off_t is at least as big as
> ext2_loff_t.
>
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> ---
>  configure            |  2 +-
>  configure.in         |  2 ++
>  lib/config.h.in      |  6 ++++++
>  lib/ext2fs/unix_io.c | 24 ++++++++++++++++++++++--
>  4 files changed, 31 insertions(+), 3 deletions(-)
>
> diff --git a/configure b/configure
> index f0af1d5..b9ce43d 100755
> --- a/configure
> +++ b/configure
> @@ -12994,7 +12994,7 @@ if test "$ac_res" != no; then :
>  fi
>
>  fi
> -for ac_func in         __secure_getenv         backtrace       blkid_probe_get_topology        blkid_probe_enable_partitions   chflags         fadvise64       fallocate       fallocate64     fchown  fdatasync       fstat64         ftruncate64     futimes         getcwd  getdtablesize   getmntinfo      getpwuid_r      getrlimit       getrusage       jrand48         llseek  lseek64         mallinfo        mbstowcs        memalign        mempcpy         mmap    msync   nanosleep       open64  pathconf        posix_fadvise   posix_fadvise64         posix_memalign  prctl   pread   pwrite  secure_getenv   setmntent       setresgid       setresuid       snprintf        srandom         stpcpy  strcasecmp      strdup  strnlen         strptime        strtoull        sync_file_range         syscon
 f         usleep  utime   valloc
> +for ac_func in         __secure_getenv         backtrace       blkid_probe_get_topology        blkid_probe_enable_partitions   chflags         fadvise64       fallocate       fallocate64     fchown  fdatasync       fstat64         ftruncate64     futimes         getcwd  getdtablesize   getmntinfo      getpwuid_r      getrlimit       getrusage       jrand48         llseek  lseek64         mallinfo        mbstowcs        memalign        mempcpy         mmap    msync   nanosleep       open64  pathconf        posix_fadvise   posix_fadvise64         posix_memalign  prctl   pread   pwrite  pread64         pwrite64        secure_getenv   setmntent       setresgid       setresuid       snprintf        srandom         stpcpy  strcasecmp      strdup  strnlen         strptime        strtoull      
   sync_file_range         sysconf         usleep  utime   valloc
>  do :
>    as_ac_var=`$as_echo "ac_cv_func_$ac_func" | $as_tr_sh`
>  ac_fn_c_check_func "$LINENO" "$ac_func" "$as_ac_var"
> diff --git a/configure.in b/configure.in
> index b825f3d..2e59fde 100644
> --- a/configure.in
> +++ b/configure.in
> @@ -1061,6 +1061,8 @@ AC_CHECK_FUNCS(m4_flatten([
>         prctl
>         pread
>         pwrite
> +       pread64
> +       pwrite64
>         secure_getenv
>         setmntent
>         setresgid
> diff --git a/lib/config.h.in b/lib/config.h.in
> index 34fb0cc..50cf312 100644
> --- a/lib/config.h.in
> +++ b/lib/config.h.in
> @@ -328,6 +328,9 @@
>  /* Define to 1 if you have the `pread' function. */
>  #undef HAVE_PREAD
>
> +/* Define to 1 if you have the `pread64' function. */
> +#undef HAVE_PREAD64
> +
>  /* Define if the <pthread.h> defines PTHREAD_MUTEX_RECURSIVE. */
>  #undef HAVE_PTHREAD_MUTEX_RECURSIVE
>
> @@ -340,6 +343,9 @@
>  /* Define to 1 if you have the `pwrite' function. */
>  #undef HAVE_PWRITE
>
> +/* Define to 1 if you have the `pwrite64' function. */
> +#undef HAVE_PWRITE64
> +
>  /* Define to 1 if dirent has d_reclen */
>  #undef HAVE_RECLEN_DIRENT
>
> diff --git a/lib/ext2fs/unix_io.c b/lib/ext2fs/unix_io.c
> index 0dd1490..eb39b28 100644
> --- a/lib/ext2fs/unix_io.c
> +++ b/lib/ext2fs/unix_io.c
> @@ -131,11 +131,21 @@ static errcode_t raw_read_blk(io_channel channel,
>         data->io_stats.bytes_read += size;
>         location = ((ext2_loff_t) block * channel->block_size) + data->offset;
>
> -#ifdef HAVE_PREAD
> +#ifdef HAVE_PREAD64
>         /* Try an aligned pread */
>         if ((channel->align == 0) ||
>             (IS_ALIGNED(buf, channel->align) &&
>              IS_ALIGNED(size, channel->align))) {
> +               actual = pread64(data->dev, buf, size, location);
> +               if (actual == size)
> +                       return 0;
> +       }
> +#elif HAVE_PREAD
> +       /* Try an aligned pread */
> +       if ((sizeof(off_t) >= sizeof(ext2_loff_t)) &&
> +           ((channel->align == 0) ||
> +            (IS_ALIGNED(buf, channel->align) &&
> +             IS_ALIGNED(size, channel->align)))) {
>                 actual = pread(data->dev, buf, size, location);
>                 if (actual == size)
>                         return 0;
> @@ -213,11 +223,21 @@ static errcode_t raw_write_blk(io_channel channel,
>
>         location = ((ext2_loff_t) block * channel->block_size) + data->offset;
>
> -#ifdef HAVE_PWRITE
> +#ifdef HAVE_PWRITE64
>         /* Try an aligned pwrite */
>         if ((channel->align == 0) ||
>             (IS_ALIGNED(buf, channel->align) &&
>              IS_ALIGNED(size, channel->align))) {
> +               actual = pwrite64(data->dev, buf, size, location);
> +               if (actual == size)
> +                       return 0;
> +       }
> +#elif HAVE_PWRITE
> +       /* Try an aligned pwrite */
> +       if ((sizeof(off_t) >= sizeof(ext2_loff_t)) &&
> +           ((channel->align == 0) ||
> +            (IS_ALIGNED(buf, channel->align) &&
> +             IS_ALIGNED(size, channel->align)))) {
>                 actual = pwrite(data->dev, buf, size, location);
>                 if (actual == size)
>                         return 0;
> --
> 2.0.0
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Best regards,
Timofey.
