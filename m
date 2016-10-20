From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 1/1 linux-next] ext4: make online resizing conditional
Date: Thu, 20 Oct 2016 14:46:16 -0600
Message-ID: <C741A09F-9926-4861-9744-71EE0494738B@dilger.ca>
References: <20161020183734.18024-1-fabf@skynet.be>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: multipart/signed; boundary="Apple-Mail=_2CFC065F-36CA-4AE1-A06D-2E1184A056A4"; protocol="application/pgp-signature"; micalg=pgp-sha256
Cc: tytso@mit.edu, Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Fabian Frederick <fabf@skynet.be>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20161020183734.18024-1-fabf@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--Apple-Mail=_2CFC065F-36CA-4AE1-A06D-2E1184A056A4
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Oct 20, 2016, at 12:37 PM, Fabian Frederick <fabf@skynet.be> wrote:
>=20
> This patch tries to address the following comment in ext4/resize.c
> "This could probably be made into a module, because it is not often in =
use."
>=20
> Having ext4 resizing in a module would give a lot of depmod dependency =
cycles
> but we can make it an option.
>=20
> resize.h has been added for more readability.
>=20
> Tried the following resizing:
> dd if=3D/dev/zero of=3Dddext4 bs=3D1M count=3D100
> losetup -f ddext4
> mkfs -t ext4 /dev/loop0
> losetup -D
> dd if=3D/dev/zero of=3Dddappend bs=3D1M count=3D50
> cat ddappend >> ddext4
> losetup -f ddext4
> mount /dev/loop0 /mnt
> resize2fs /dev/loop0
>=20
> With option disabled:
> "Operation not supported While checking for on-line resizing support"

Patch looks mostly good, some comments and cleanups below.

> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---
> fs/ext4/Kconfig  |  7 +++++++
> fs/ext4/Makefile |  3 ++-
> fs/ext4/ext4.h   | 12 ------------
> fs/ext4/ioctl.c  |  1 +
> fs/ext4/resize.c |  2 +-
> fs/ext4/resize.h | 42 ++++++++++++++++++++++++++++++++++++++++++
> 6 files changed, 53 insertions(+), 14 deletions(-)
> create mode 100644 fs/ext4/resize.h
>=20
> diff --git a/fs/ext4/Kconfig b/fs/ext4/Kconfig
> index e38039f..2ec35c3 100644
> --- a/fs/ext4/Kconfig
> +++ b/fs/ext4/Kconfig
> @@ -122,3 +122,10 @@ config EXT4_DEBUG
> 	  If you select Y here, then you will be able to turn on =
debugging
> 	  with a command such as:
> 		echo 1 > /sys/module/ext4/parameters/mballoc_debug
> +
> +config EXT4_RESIZE
> +	bool "EXT4 resize"
> +	depends on EXT4_FS
> +	default y
> +	help
> +	  Support online ext4 partition resizing.
> diff --git a/fs/ext4/Makefile b/fs/ext4/Makefile
> index 354103f..efe6579 100644
> --- a/fs/ext4/Makefile
> +++ b/fs/ext4/Makefile
> @@ -5,10 +5,11 @@
> obj-$(CONFIG_EXT4_FS) +=3D ext4.o
>=20
> ext4-y	:=3D balloc.o bitmap.o dir.o file.o fsync.o ialloc.o =
inode.o page-io.o \
> -		ioctl.o namei.o super.o symlink.o hash.o resize.o =
extents.o \
> +		ioctl.o namei.o super.o symlink.o hash.o extents.o \
> 		ext4_jbd2.o migrate.o mballoc.o block_validity.o =
move_extent.o \
> 		mmp.o indirect.o extents_status.o xattr.o xattr_user.o \
> 		xattr_trusted.o inline.o readpage.o sysfs.o
>=20
> ext4-$(CONFIG_EXT4_FS_POSIX_ACL)	+=3D acl.o
> ext4-$(CONFIG_EXT4_FS_SECURITY)		+=3D xattr_security.o
> +ext4-$(CONFIG_EXT4_RESIZE)		+=3D resize.o
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 282a51b..819a07b 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -2555,14 +2555,6 @@ extern int ext4_generic_delete_entry(handle_t =
*handle,
> 				     int csum_size);
> extern bool ext4_empty_dir(struct inode *inode);
>=20
> -/* resize.c */
> -extern int ext4_group_add(struct super_block *sb,
> -				struct ext4_new_group_data *input);
> -extern int ext4_group_extend(struct super_block *sb,
> -				struct ext4_super_block *es,
> -				ext4_fsblk_t n_blocks_count);
> -extern int ext4_resize_fs(struct super_block *sb, ext4_fsblk_t =
n_blocks_count);
> -
> /* super.c */
> extern int ext4_seq_options_show(struct seq_file *seq, void *offset);
> extern int ext4_calculate_overhead(struct super_block *sb);
> @@ -3239,10 +3231,6 @@ static inline void =
ext4_inode_resume_unlocked_dio(struct inode *inode)
> 					    EXT4_WQ_HASH_SZ])
> extern wait_queue_head_t ext4__ioend_wq[EXT4_WQ_HASH_SZ];
>=20
> -#define EXT4_RESIZING	0
> -extern int ext4_resize_begin(struct super_block *sb);
> -extern void ext4_resize_end(struct super_block *sb);
> -
> static inline void ext4_set_io_unwritten_flag(struct inode *inode,
> 					      struct ext4_io_end =
*io_end)
> {
> diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
> index bf5ae8e..81d28d2 100644
> --- a/fs/ext4/ioctl.c
> +++ b/fs/ext4/ioctl.c
> @@ -18,6 +18,7 @@
> #include <asm/uaccess.h>
> #include "ext4_jbd2.h"
> #include "ext4.h"
> +#include "resize.h"
>=20
> /**
>  * Swap memory between @a and @b for @len bytes.
> diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
> index cf68100..8192194 100644
> --- a/fs/ext4/resize.c
> +++ b/fs/ext4/resize.c
> @@ -5,7 +5,6 @@
>  *
>  * Copyright (C) 2001, 2002 Andreas Dilger <adilger@clusterfs.com>
>  *
> - * This could probably be made into a module, because it is not often =
in use.

This comment is probably still valid?

>  */
>=20
>=20
> @@ -15,6 +14,7 @@
> #include <linux/slab.h>
>=20
> #include "ext4_jbd2.h"
> +#include "resize.h"
>=20
> int ext4_resize_begin(struct super_block *sb)
> {
> diff --git a/fs/ext4/resize.h b/fs/ext4/resize.h
> new file mode 100644
> index 0000000..1375434
> --- /dev/null
> +++ b/fs/ext4/resize.h
> @@ -0,0 +1,42 @@
> +/*
> + * linux/fs/ext4/resize.h
> + *
> + */
> +
> +#define EXT4_RESIZING	0

Moving this here is a bit confusing, since it has no context of what it =
is
used for.  This only makes sense together with =
ext4_resize_{begin,end}(),
so it should be declared below, inside CONFIG_EXT4_RESIZE.

It also wouldn't hurt to rename this something like EXT4_RESIZE_ACTIVE,
and add to the comment at s_resize_flags indicating it is using
EXT4_RESIZE_* bits.

> +
> +#if IS_ENABLED(CONFIG_EXT4_RESIZE)

IS_ENABLED() seems unnecessary, as most CONFIG_* symbols are checked via

#ifdef CONFIG_EXT4_RESIZE

Is there some reason to use IS_ENABLED() for this?  My quick reading of
the ugly macro series this uses is for CONFIG_ values that may be 0 or =
1,
and #ifdef CONFIG_* is fine for values that may be "y" or "m".

> +extern int ext4_resize_fs(struct super_block *, ext4_fsblk_t);
> +extern int ext4_resize_begin(struct super_block *);
> +extern void ext4_resize_end(struct super_block *);
> +extern int ext4_group_add(struct super_block *, struct =
ext4_new_group_data *);
> +extern int ext4_group_extend(struct super_block *, struct =
ext4_super_block *,
> +			     ext4_fsblk_t);
> +#else
> +static int ext4_resize_begin(struct super_block *sb)
> +{
> +	return -EOPNOTSUPP;
> +}
> +
> +static void ext4_resize_end(struct super_block *sb)
> +{
> +}
> +
> +static inline int ext4_group_add(struct super_block *sb,
> +				 struct ext4_new_group_data *input)
> +{
> +	return -EOPNOTSUPP;
> +}
> +
> +static inline int ext4_group_extend(struct super_block *sb,
> +		struct ext4_super_block *es, ext4_fsblk_t =
n_blocks_count)
> +{
> +	return -EOPNOTSUPP;
> +}
> +
> +static inline int ext4_resize_fs(struct super_block *sb,
> +				 ext4_fsblk_t n_blocks_count)
> +{
> +	return -EOPNOTSUPP;
> +}
> +#endif
> --
> 2.9.3
>=20


Cheers, Andreas






--Apple-Mail=_2CFC065F-36CA-4AE1-A06D-2E1184A056A4
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBWAktGHKl2rkXzB/gAQgZ0Q//XzZbin7mk3Qy8aRpR0gMTMVuEB16QTur
ezB+2svUbRB56Pnm6nN9VTSK9qdOO7lUrWF1Hb9kTIwn98DYkmP7Wz8rlCx/cw+m
AQ4pXLlIW+jTCuNIpqdRT062rXmK1iavsLm9JeKwmIcx+rrw54qyE7O/YJML3pM8
VRMdRnI7VVjtep5Uv6ASJepBzYDWedPKyd6dpehk9DVlyRy5391JYnBCORp8woNn
6Ujg8YB2LfZFsEo0UvWp6qYusqc8EFcq72RJjIvxeS8+dm91ZSboOePa17Hjn3oK
k84hN5VaG3tY6QeksywmzuoProNahDuctmBrjIwV7o9mlLVSs57VzFyvvNpV2NgU
kbxiMEh1zTgSlqJpa8F7c0W7UxBG+ikBdNnHlfl8IiRmPXZp8IN7/piCZ+5We2Q0
D6B6Ab9oe8jUQrf+xE94UsuoLhP88AFRKsNLzzf4EEvLUJP1zuTz1QDQPRu8FY5y
qWZmT7xe3+97PKbgmgMlVVfF01x6Q+oj1urPG/yV0FF3DWkHGLA4MB9MS0KY+JdP
ddjJa/2nfbCLzVsl6BDOpjKL4y6sAJP9M88dNYaap3W+ZzhQsDnvI1zEL2GbeihJ
qlv2iRyhX8Z9hQ9KYB1IMsq9Zi4cODxZXsuaRA5HhanDZ0pPT419aAvI9MvNvJ60
OLdrtzpIbwk=
=HFQu
-----END PGP SIGNATURE-----

--Apple-Mail=_2CFC065F-36CA-4AE1-A06D-2E1184A056A4--
