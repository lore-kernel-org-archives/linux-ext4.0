From: Baruch Siach <baruch@tkos.co.il>
Subject: Re: [PATCH] e4defrag: choose the best available posix_fadvise variant
Date: Sun, 5 Jan 2014 08:46:31 +0200
Message-ID: <20140105064631.GC5316@tarshish>
References: <23c2b99441922fe311235e241eca52e9701e54d4.1388645034.git.baruch@tkos.co.il>
 <20140103004710.GA31411@thunk.org>
 <20140103045747.GM6589@tarshish>
 <20140103162344.GD31411@thunk.org>
 <20140105061233.GA5849@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from guitar.tcltek.co.il ([192.115.133.116]:46174 "EHLO
	mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750798AbaAEGqg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 5 Jan 2014 01:46:36 -0500
Content-Disposition: inline
In-Reply-To: <20140105061233.GA5849@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

On Sun, Jan 05, 2014 at 01:12:33AM -0500, Theodore Ts'o wrote:
> On Fri, Jan 03, 2014 at 11:23:44AM -0500, Theodore Ts'o wrote:
> >=20
> > Oh, oops.  I'll find the other version of the patch and fix it up. =
=20
>=20
> Here is the revised version of your patch which I currently have in m=
y
> sources.  Let me know what you think.

Thanks. A few comments below.

> commit e47e7100a357ed9ba1575a6a8caca9258b1aab77
> Author: Baruch Siach <baruch@tkos.co.il>
> Date:   Thu Jan 2 13:05:37 2014 -0500
>=20
>     e4defrag: choose the best available posix_fadvise variant
>    =20
>     Use posix_fadvise64() when available. This allows 64bit offsets o=
n 32bit
>     systems.
>    =20
>     Rename the internal posix_fadvise() implementation to avoid colli=
sion with the
>     C library signature that is sometimes present event when the impl=
ementation
>     itself is not. This fixes build errors like:

This paragraph is not needed anymore, since the internal posix_fadvise =
is=20
completely removed.

>    =20
>     e4defrag.c:189:2: warning: #warning Using locally defined posix_f=
advise interface. [-Wcpp
>     e4defrag.c:203:12: error: conflicting types for =E2=80=98posix_fa=
dvise=E2=80=99
>    =20
>     [ Modified by tytso to try to use fadvise64 as well, and to remov=
e the
>       attempt to use the syscall directly, since between fadvise64,
>       fadvise64_64, and complexities caused by required dummy argumen=
ts on
>       some architectures, it's not worth the hair.  ]
>    =20
>     Signed-off-by: Baruch Siach <baruch@tkos.co.il>
>     Signed-off-by: Theodore Ts'o <tytso@mit.edu>
>=20
> diff --git a/configure b/configure
> index 6f8f1ab..5943849 100755
> --- a/configure
> +++ b/configure
> @@ -11051,7 +11051,7 @@ if test "$ac_res" !=3D no; then :
>  fi
> =20
>  fi
> -for ac_func in  	__secure_getenv 	backtrace 	blkid_probe_get_topolog=
y 	chflags 	fallocate 	fallocate64 	fchown 	fdatasync 	fstat64 	ftrunca=
te64 	futimes 	getdtablesize 	getmntinfo 	getpwuid_r 	getrlimit 	getrus=
age 	jrand48 	llseek 	lseek64 	mallinfo 	mbstowcs 	memalign 	mmap 	msyn=
c 	nanosleep 	open64 	pathconf 	posix_fadvise 	posix_memalign 	prctl 	s=
ecure_getenv 	setmntent 	setresgid 	setresuid 	srandom 	strcasecmp 	str=
dup 	strnlen 	strptime 	strtoull 	sync_file_range 	sysconf 	usleep 	uti=
me 	valloc
> +for ac_func in  	__secure_getenv 	backtrace 	blkid_probe_get_topolog=
y 	chflags 	fadvise64 	fallocate 	fallocate64 	fchown 	fdatasync 	fstat=
64 	ftruncate64 	futimes 	getdtablesize 	getmntinfo 	getpwuid_r 	getrli=
mit 	getrusage 	jrand48 	llseek 	lseek64 	mallinfo 	mbstowcs 	memalign =
	mmap 	msync 	nanosleep 	open64 	pathconf 	posix_fadvise 	posix_fadvise=
64 	posix_memalign 	prctl 	secure_getenv 	setmntent 	setresgid 	setresu=
id 	srandom 	strcasecmp 	strdup 	strnlen 	strptime 	strtoull 	sync_file=
_range 	sysconf 	usleep 	utime 	valloc
>  do :
>    as_ac_var=3D`$as_echo "ac_cv_func_$ac_func" | $as_tr_sh`
>  ac_fn_c_check_func "$LINENO" "$ac_func" "$as_ac_var"
> diff --git a/configure.in b/configure.in
> index b70a3f9..214d3f6 100644
> --- a/configure.in
> +++ b/configure.in
> @@ -1026,6 +1026,7 @@ AC_CHECK_FUNCS(m4_flatten([
>  	backtrace
>  	blkid_probe_get_topology
>  	chflags
> +	fadvise64

There is no such symbol in any C library that I know of (unlike falloca=
te64).=20
Where have you see this?

>  	fallocate
>  	fallocate64
>  	fchown
> @@ -1050,6 +1051,7 @@ AC_CHECK_FUNCS(m4_flatten([
>  	open64
>  	pathconf
>  	posix_fadvise
> +	posix_fadvise64
>  	posix_memalign
>  	prctl
>  	secure_getenv
> diff --git a/lib/config.h.in b/lib/config.h.in
> index ef2e664..0197b56 100644
> --- a/lib/config.h.in
> +++ b/lib/config.h.in
> @@ -103,6 +103,9 @@
>  /* Define to 1 if Ext2 ioctls present */
>  #undef HAVE_EXT2_IOCTLS
> =20
> +/* Define to 1 if you have the `fadvise64' function. */
> +#undef HAVE_FADVISE64
> +
>  /* Define to 1 if you have the `fallocate' function. */
>  #undef HAVE_FALLOCATE
> =20
> @@ -287,6 +290,9 @@
>  /* Define to 1 if you have the `posix_fadvise' function. */
>  #undef HAVE_POSIX_FADVISE
> =20
> +/* Define to 1 if you have the `posix_fadvise64' function. */
> +#undef HAVE_POSIX_FADVISE64
> +
>  /* Define to 1 if you have the `posix_memalign' function. */
>  #undef HAVE_POSIX_MEMALIGN
> =20
> diff --git a/misc/e4defrag.c b/misc/e4defrag.c
> index c6a5f0d..65933b1 100644
> --- a/misc/e4defrag.c
> +++ b/misc/e4defrag.c
> @@ -34,13 +34,11 @@
>  #include <unistd.h>
>  #include <ext2fs/ext2_types.h>
>  #include <ext2fs/ext2fs.h>
> -#include <linux/fs.h>
>  #include <sys/ioctl.h>
>  #include <ext2fs/fiemap.h>
>  #include <sys/mman.h>
>  #include <sys/stat.h>
>  #include <sys/statfs.h>
> -#include <sys/syscall.h>
>  #include <sys/vfs.h>
> =20
>  /* A relatively new ioctl interface ... */
> @@ -183,28 +181,21 @@ static ext4_fsblk_t	files_block_count;
>  static struct frag_statistic_ino	frag_rank[SHOW_FRAG_FILES];
> =20
> =20
> -/* Local definitions of some syscalls glibc may not yet have */
> -
> -#ifndef HAVE_POSIX_FADVISE
> -#warning Using locally defined posix_fadvise interface.
> -
> -#ifndef __NR_fadvise64_64
> -#error Your kernel headers dont define __NR_fadvise64_64
> -#endif
> -
> -/*
> - * fadvise() -		Give advice about file access.
> +/* Local definitions of some syscalls glibc may not yet have

This comment becomes redundant. We now rely on the C library to provide=
 the=20
system call.

>   *
> - * @fd:			defrag target file's descriptor.
> - * @offset:		file offset.
> - * @len:		area length.
> - * @advise:		process flag.
> + * We prefer posix_fadvise64 when available, as it allows 64bit offs=
et on
> + * 32bit systems
>   */
> -static int posix_fadvise(int fd, loff_t offset, size_t len, int advi=
se)
> -{
> -	return syscall(__NR_fadvise64_64, fd, offset, len, advise);
> -}
> -#endif /* ! HAVE_FADVISE64_64 */
> +
> +#if defined(HAVE_POSIX_FADVISE64)
> +#define posix_fadvise	posix_fadvise64
> +#elif defined(HAVE_FADVISE64)
> +#define posix_fadvise	fadvise64
> +#elif defined(HAVE_POSIX_FADVISE)
> +#define posix_fadvise	posix_fadvise

Also not needed.

> +#else
> +#error posix_fadvise not available!
> +#endif
> =20
>  #ifndef HAVE_SYNC_FILE_RANGE
>  #warning Using locally defined sync_file_range interface.

baruch

--=20
     http://baruch.siach.name/blog/                  ~. .~   Tk Open Sy=
stems
=3D}------------------------------------------------ooO--U--Ooo--------=
----{=3D
   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
