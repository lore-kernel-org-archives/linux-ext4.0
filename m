From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] Add support for DragonFly BSD operating system.
Date: Thu, 12 Jul 2012 16:25:19 -0600
Message-ID: <6030B7F4-E721-4323-9767-607F71C99F5E@dilger.ca>
References: <op.whcml3m4f7p71t@sixfeet.quantumachine.net>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: =?iso-8859-1?Q?Antonio_Huete_Jim=E9nez?= <ahuete.devel@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:45842 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964820Ab2GLWZJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 12 Jul 2012 18:25:09 -0400
In-Reply-To: <op.whcml3m4f7p71t@sixfeet.quantumachine.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2012-07-12, at 1:48 PM, Antonio Huete Jim=E9nez wrote:
> Find below a patch to add support for DragonFly BSD to e2fsprogs. In =
the case it gets rejected please indicate a reason so I can get it fixe=
d.
> @@ -87,8 +89,10 @@ blkid_loff_t blkid_get_dev_size(int fd)
> #endif
> #ifdef HAVE_SYS_DISKLABEL_H
> 	int part =3D -1;
> +#ifndef __DragonFly__
> 	struct disklabel lab;
> 	struct partition *pp;
> +#endif /* __DragonFly__ */
> 	char ch;
> 	struct stat st;
> #endif /* HAVE_SYS_DISKLABEL_H */

Hmm, why not #ifndef out the whole HAVE_SYS_DISKLABEL_H block?  The "pa=
rt",
"ch", and "st" variables are only used inside HAVE_SYS_DISKLABEL_H belo=
w,
and it appears that "ch" isn't even used anywhere and could just be rem=
oved.

It would be cleaner to move these declarations into a small sub-context
at the HAVE_SYS_DISKLABEL_H case (ala HAVE_FSTAT64), since $diety knows
this code has too many #ifdefs already and could use some cleanup.

> @@ -129,11 +133,19 @@ blkid_loff_t blkid_get_dev_size(int fd)
> 		return (off_t)size64;
> #endif /* DIOCGMEDIASIZE */
>=20
> +/* tested on DragonFly 3.1-DEVELOPMENT i386/X86_64 */
> +#ifdef DIOCGPART
> +	struct partinfo dp;
> +	if (ioctl(fd, DIOCGPART, &dp) >=3D 0)
> +		return (off_t)dp.media_size;
> +#endif /* DIOCGPART */

While supported by newer C standards, it is atypical to have variable
declarations in the middle of the code.  Better would be to make this a
small sub-context, like is done with HAVE_FSTAT64.

> #ifdef FDGETPRM
> 	if (ioctl(fd, FDGETPRM, &this_floppy) >=3D 0)
> 		return (blkid_loff_t)this_floppy.size << 9;
> #endif
> #ifdef HAVE_SYS_DISKLABEL_H
> +#ifndef __DragonFly__

Better (IMHO) would be:

#if defined(HAVE_SYS_DISKLABEL_H) && !defined __DragonFly__

> 	/*
> 	 * This code works for FreeBSD 4.11 i386, except for the full device
> 	 * (such as /dev/ad0). It doesn't work properly for newer FreeBSD
> @@ -151,6 +163,7 @@ blkid_loff_t blkid_get_dev_size(int fd)
> 		if (pp->p_size)
> 			return pp->p_size << 9;
> 	}
> +#endif / __DragonFly__ */
> #endif /* HAVE_SYS_DISKLABEL_H */
> 	{
> #if defined(HAVE_FSTAT64) && !defined(__OSX_AVAILABLE_BUT_DEPRECATED)
> diff --git a/lib/e2p/ostype.c b/lib/e2p/ostype.c
> index d002e75..6d5579a 100644
> --- a/lib/e2p/ostype.c
> +++ b/lib/e2p/ostype.c
> @@ -20,6 +20,7 @@ static const char *os_tab[] =3D
> 	  "Masix",
> 	  "FreeBSD",
> 	  "Lites",
> +	  "DragonFly",
> 	  0 };
>=20
> /*
> @@ -30,7 +31,7 @@ char *e2p_os2string(int os_type)
>         const char	*os;
> 	char 		*ret;
>=20
> -	if (os_type <=3D EXT2_OS_LITES)
> +	if (os_type <=3D EXT2_OS_DRAGONFLY)
> 		os =3D os_tab[os_type];
> 	else
> 		os =3D "(unknown os)";
> @@ -62,7 +63,7 @@ int main(int argc, char **argv)
> 	char 	*s;
> 	int	i, os;
>=20
> -	for (i=3D0; i <=3D EXT2_OS_LITES; i++) {
> +	for (i=3D0; i <=3D EXT2_OS_DRAGONFLY; i++) {
> 		s =3D e2p_os2string(i);
> 		os =3D e2p_string2os(s);
> 		printf("%d: %s (%d)\n", i, s, os);
> diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
> index fb3f7cc..d85fb2f 100644
> --- a/lib/ext2fs/ext2_fs.h
> +++ b/lib/ext2fs/ext2_fs.h
> @@ -659,6 +659,7 @@ struct ext2_super_block {
> #define EXT2_OBSO_OS_MASIX	2
> #define EXT2_OS_FREEBSD		3
> #define EXT2_OS_LITES		4
> +#define EXT2_OS_DRAGONFLY	5
>=20
> /*
>  * Revision levels
> diff --git a/lib/ext2fs/getsize.c b/lib/ext2fs/getsize.c
> index 0a7053e..1b7cca2 100644
> --- a/lib/ext2fs/getsize.c
> +++ b/lib/ext2fs/getsize.c
> @@ -46,6 +46,9 @@
> #include <sys/stat.h>
> #endif
> #include <ctype.h>
> +#ifdef __DragonFly__
> +#include <sys/diskslice.h>
> +#endif
>=20
> #if defined(__linux__) && defined(_IO) && !defined(BLKGETSIZE)
> #define BLKGETSIZE _IO(0x12,96)	/* return device size */
> @@ -155,8 +158,10 @@ errcode_t ext2fs_get_device_size2(const char *fi=
le, int blocksize,
> #endif
> #ifdef HAVE_SYS_DISKLABEL_H
> 	int part;
> +#ifndef __DragonFly__
> 	struct disklabel lab;
> 	struct partition *pp;
> +#endif /*__DragonFly__ */
> 	char ch;
> #endif /* HAVE_SYS_DISKLABEL_H */
>=20
> @@ -228,6 +233,14 @@ errcode_t ext2fs_get_device_size2(const char *fi=
le, int blocksize,
> 			goto out;
> 		}
> 	}
> +#elif defined(DIOCGPART)
> +/* DragonFly partition information */
> +        struct partinfo dp;
> +        if (ioctl(fd, DIOCGPART, &dp) >=3D 0) {
> +		*retblocks =3D dp.media_size / blocksize;
> +		goto out;
> +	}
> +
> #endif /* defined(DIOCG*) */
> #endif /* HAVE_SYS_DISKLABEL_H */

Same comments here.  Makes me wonder if we couldn't share this code in
some manner, but they are independent libraries and we didn't want to h=
ave blkid depending on e2fsprogs, though the reverse is already true so=
 maybe
we should just beef up blkid_get_dev_size() and have ext2fs_get_device_=
size()
and ext2fs_get_device_size2() be thin wrappers around that function?

I don't think it changes frequently enough that we need to worry about =
the
fact that on Linux the libblkid code is now maintained in util-linux-ng=
=2E

> diff --git a/lib/ext2fs/initialize.c b/lib/ext2fs/initialize.c
> index b06371c..e7acb19 100644
> --- a/lib/ext2fs/initialize.c
> +++ b/lib/ext2fs/initialize.c
> @@ -40,7 +40,11 @@
> #if defined(LITES) 	   &&	defined(EXT2_OS_LITES)
> #define CREATOR_OS EXT2_OS_LITES
> #else
> +#if defined(__DragonFly__) &&	defined(EXT2_OS_DRAGONFLY)
> +#define CREATOR_OS EXT2_OS_DRAGONFLY
> +#else
> #define CREATOR_OS EXT2_OS_LINUX /* by default */
> +#endif /* defined(__DragonFly__) &&   defined(EXT2_OS_DRAGONFLY) */
> #endif /* defined(LITES) && defined(EXT2_OS_LITES) */
> #endif /* defined(__FreeBSD__) && defined(EXT2_OS_FREEBSD) */
> #endif /* defined(__GNU__)     && defined(EXT2_OS_HURD) */

Ugh.  Existing code uglyness aside, this would be better as an #elif
instead of a nested series if #if/#else blocks.

> diff --git a/lib/ext2fs/unix_io.c b/lib/ext2fs/unix_io.c
> index 02570f0..c305a6c 100644
> --- a/lib/ext2fs/unix_io.c
> +++ b/lib/ext2fs/unix_io.c
> @@ -554,7 +554,7 @@ static errcode_t unix_open(const char *name, int =
flags, io_channel *channel)
> 		io->flags |=3D CHANNEL_FLAGS_DISCARD_ZEROES;
> #endif
>=20
> -#if defined(__CYGWIN__) || defined(__FreeBSD__) || defined(__FreeBSD=
_kernel__)
> +#if defined(__CYGWIN__) || defined(__FreeBSD__) || defined(__FreeBSD=
_kernel__) || defined(__DragonFly__)
> 	/*
> 	 * Some operating systems require that the buffers be aligned,
> 	 * regardless of O_DIRECT
> diff --git a/misc/mke2fs.c b/misc/mke2fs.c
> index 7ec8cc2..1bd7f6b 100644
> --- a/misc/mke2fs.c
> +++ b/misc/mke2fs.c
> @@ -641,6 +641,8 @@ static int set_os(struct ext2_super_block *sb, ch=
ar *os)
> 		sb->s_creator_os =3D EXT2_OS_FREEBSD;
> 	else if (strcasecmp(os, "lites") =3D=3D 0)
> 		sb->s_creator_os =3D EXT2_OS_LITES;
> +	else if (strcasecmp(os, "dragonfly") =3D=3D 0)
> +		sb->s_creator_os =3D EXT2_OS_DRAGONFLY;
> 	else
> 		return 0;
> 	return 1;
> diff --git a/misc/util.c b/misc/util.c
> index 6c93e1c..ead4467 100644
> --- a/misc/util.c
> +++ b/misc/util.c
> @@ -93,7 +93,7 @@ void check_plausibility(const char *device)
> 				"did you specify it correctly?\n"), stderr);
> 		exit(1);
> 	}
> -#if defined(__FreeBSD__) || defined(__FreeBSD_kernel__)
> +#if defined(__FreeBSD__) || defined(__FreeBSD_kernel__) || defined(_=
_DragonFly__)
> 	/* On FreeBSD, all disk devices are character specials */
> 	if (!S_ISBLK(s.st_mode) && !S_ISCHR(s.st_mode))
> #else
> --=20
> 1.7.3.4
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas





--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
