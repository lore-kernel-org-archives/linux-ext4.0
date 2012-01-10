From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] libquota: Do not build libquota when disabled
Date: Tue, 10 Jan 2012 20:38:14 +0100
Message-ID: <20120110193814.GC4516@quack.suse.cz>
References: <1326213996-13759-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>,
	Aditya Kali <adityakali@google.com>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44526 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752479Ab2AJTiQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 Jan 2012 14:38:16 -0500
Content-Disposition: inline
In-Reply-To: <1326213996-13759-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 10-01-12 17:46:36, Jan Kara wrote:
> Due to missing QUOTA_CMT definition in configure.in, libquota was built
> (and e.g. include file was installed) even when quota support was disabled.
> Fix it. Also fix help text of the configure option when we are at it.
  Hum, but after this e2fsck does not compile because of missing
libquota.a. So should it be possible to disable quota support (and thus
e2fsck should be fixed) or not (and then config option should be removed)?

Also I've also noticed that libquota is generated as a static library even
if --enable-elf-shlibs is specified. Bug? Or is libquota supposed to be
internal library of e2fsprogs and never used outside of e2fsprogs? But then
why is it and its header files installed?

BTW, since the library is tied to ext4 anyway, won't it be more logical for
external developpers to make it part of libext2fs?

								Honza
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  configure    |   11 ++++++-----
>  configure.in |    4 +++-
>  2 files changed, 9 insertions(+), 6 deletions(-)
> 
> diff --git a/configure b/configure
> index 9f5eeb5..965f7cf 100755
> --- a/configure
> +++ b/configure
> @@ -1462,7 +1462,7 @@ Optional Features:
>    --disable-testio-debug  disable the use of the test I/O manager for debugging
>    --disable-libuuid	  do not build private uuid library
>    --disable-libblkid	  do not build private blkid library
> -  --enable-libquota	  enable quota support
> +  --enable-quota	  enable quota support
>    --disable-debugfs   	  disable support of debugfs program
>    --disable-imager   	  disable support of e2image program
>    --disable-resizer   	  disable support of e2resize program
> @@ -5209,11 +5209,13 @@ fi
>  if test "${enable_quota+set}" = set; then :
>    enableval=$enable_quota; if test "$enableval" = "no"
>  then
> +	QUOTA_CMT="#"
>  	{ $as_echo "$as_me:${as_lineno-$LINENO}: result: Disabling quota support" >&5
>  $as_echo "Disabling quota support" >&6; }
>  else
>  	$as_echo "#define CONFIG_QUOTA 1" >>confdefs.h
>  
> +	QUOTA_CMT=""
>  	{ $as_echo "$as_me:${as_lineno-$LINENO}: result: Enabling quota support" >&5
>  $as_echo "Enabling quota support" >&6; }
>  fi
> @@ -7127,7 +7129,6 @@ int
>  main ()
>  {
>    char *data, *data2, *data3;
> -  const char *cdata2;
>    int i, pagesize;
>    int fd, fd2;
>  
> @@ -7152,10 +7153,10 @@ main ()
>    fd2 = open ("conftest.txt", O_RDWR | O_CREAT | O_TRUNC, 0600);
>    if (fd2 < 0)
>      return 4;
> -  cdata2 = "";
> -  if (write (fd2, cdata2, 1) != 1)
> +  data2 = "";
> +  if (write (fd2, data2, 1) != 1)
>      return 5;
> -  data2 = (char *) mmap (0, pagesize, PROT_READ | PROT_WRITE, MAP_SHARED, fd2, 0L);
> +  data2 = mmap (0, pagesize, PROT_READ | PROT_WRITE, MAP_SHARED, fd2, 0L);
>    if (data2 == MAP_FAILED)
>      return 6;
>    for (i = 0; i < pagesize; ++i)
> diff --git a/configure.in b/configure.in
> index c304a8d..94e7c21 100644
> --- a/configure.in
> +++ b/configure.in
> @@ -531,12 +531,14 @@ dnl
>  PKG_PROG_PKG_CONFIG
>  AH_TEMPLATE([CONFIG_QUOTA], [Define to 1 to enable quota support])
>  AC_ARG_ENABLE([quota],
> -[  --enable-libquota	  enable quota support],
> +[  --enable-quota	  enable quota support],
>  if test "$enableval" = "no"
>  then
> +	QUOTA_CMT="#"
>  	AC_MSG_RESULT([Disabling quota support])
>  else
>  	AC_DEFINE(CONFIG_QUOTA, 1)
> +	QUOTA_CMT=""
>  	AC_MSG_RESULT([Enabling quota support])
>  fi
>  ,
> -- 
> 1.7.1
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
