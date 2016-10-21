From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH V2 linux-next] ext4: make online resizing conditional
Date: Fri, 21 Oct 2016 12:31:58 -0600
Message-ID: <C9F75389-C7EB-4139-988C-A2CD89FF1097@dilger.ca>
References: <1477073814-27482-1-git-send-email-fabf@skynet.be>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: multipart/signed; boundary="Apple-Mail=_A688EF12-5F5F-4F66-A002-8310A53FA8A1"; protocol="application/pgp-signature"; micalg=pgp-sha256
Cc: tytso@mit.edu, Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Fabian Frederick <fabf@skynet.be>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1477073814-27482-1-git-send-email-fabf@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--Apple-Mail=_A688EF12-5F5F-4F66-A002-8310A53FA8A1
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Oct 21, 2016, at 12:16 PM, Fabian Frederick <fabf@skynet.be> wrote:
>=20
> This patch tries to address the following comment in ext4/resize.c
> "This could probably be made into a module, because it is not often in =
use."
>=20
> Having ext4 resizing in a module would give a lot of depmod
> dependency cycles but we can make it an option.
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
>=20
> Signed-off-by: Fabian Frederick <fabf@skynet.be>

Reviewed-by: Andreas Dilger <adilger@dilger.ca>

> ---
>=20
> V2:
>=20
> -Fix checkpatch warnings on identifier names like:
> WARNING: function definition argument 'struct super_block *'
> should also have an identifier name
> #130: FILE: fs/ext4/resize.h:8:
> +extern int ext4_resize_fs(struct super_block *, ext4_fsblk_t);
>=20
> -Reorder extern functions in resize.h to match -EOPNOTSUPP definitions
>=20
> -Rename EXT4_RESIZING to EXT4_RESIZING_ACTIVE
> (Andreas Dilger suggested EXT4_RESIZE_ACTIVE but we already have
> EXT4_RESIZE_INO in another context)
>=20
> Other suggestions by Andreas:
>=20
> -Add comment to s_resize_flags for EXT4_RESIZING_* bits
> -Leave the module comment in resize.h
> -Use ifdef CONFIG instead of IS_ENABLED()
>=20
> fs/ext4/Kconfig  |  7 +++++++
> fs/ext4/Makefile |  3 ++-
> fs/ext4/ext4.h   | 16 +++-------------
> fs/ext4/ioctl.c  |  1 +
> fs/ext4/resize.c |  6 ++++--
> fs/ext4/resize.h | 42 ++++++++++++++++++++++++++++++++++++++++++
> 6 files changed, 59 insertions(+), 16 deletions(-)
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
> index 282a51b..542ebc2 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -1403,7 +1403,9 @@ struct ext4_sb_info {
> 	struct list_head s_orphan;
> 	struct mutex s_orphan_lock;
> 	unsigned long s_resize_flags;		/* Flags indicating if =
there
> -						   is a resizer */
> +						 *  is a resizer using
> +						 * EXT4_RESIZING_* bits
> +						 */
> 	unsigned long s_commit_interval;
> 	u32 s_max_batch_time;
> 	u32 s_min_batch_time;
> @@ -2555,14 +2557,6 @@ extern int ext4_generic_delete_entry(handle_t =
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
> @@ -3239,10 +3233,6 @@ static inline void =
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
> index cf68100..4c7cd75 100644
> --- a/fs/ext4/resize.c
> +++ b/fs/ext4/resize.c
> @@ -15,6 +15,7 @@
> #include <linux/slab.h>
>=20
> #include "ext4_jbd2.h"
> +#include "resize.h"
>=20
> int ext4_resize_begin(struct super_block *sb)
> {
> @@ -45,7 +46,8 @@ int ext4_resize_begin(struct super_block *sb)
> 		return -EPERM;
> 	}
>=20
> -	if (test_and_set_bit_lock(EXT4_RESIZING, =
&EXT4_SB(sb)->s_resize_flags))
> +	if (test_and_set_bit_lock(EXT4_RESIZING_ACTIVE,
> +				  &EXT4_SB(sb)->s_resize_flags))
> 		ret =3D -EBUSY;
>=20
> 	return ret;
> @@ -53,7 +55,7 @@ int ext4_resize_begin(struct super_block *sb)
>=20
> void ext4_resize_end(struct super_block *sb)
> {
> -	clear_bit_unlock(EXT4_RESIZING, &EXT4_SB(sb)->s_resize_flags);
> +	clear_bit_unlock(EXT4_RESIZING_ACTIVE, =
&EXT4_SB(sb)->s_resize_flags);
> 	smp_mb__after_atomic();
> }
>=20
> diff --git a/fs/ext4/resize.h b/fs/ext4/resize.h
> new file mode 100644
> index 0000000..df15285
> --- /dev/null
> +++ b/fs/ext4/resize.h
> @@ -0,0 +1,42 @@
> +/*
> + * linux/fs/ext4/resize.h
> + *
> + */
> +
> +#ifdef CONFIG_EXT4_RESIZE
> +#define EXT4_RESIZING_ACTIVE 0
> +extern int ext4_resize_begin(struct super_block *sb);
> +extern void ext4_resize_end(struct super_block *sb);
> +extern int ext4_group_add(struct super_block *sb,
> +			  struct ext4_new_group_data *input);
> +extern int ext4_group_extend(struct super_block *sb,
> +		     struct ext4_super_block *es, ext4_fsblk_t =
n_blocks_count);
> +extern int ext4_resize_fs(struct super_block *sb, ext4_fsblk_t =
n_blocks_count);
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
> 2.7.4
>=20


Cheers, Andreas






--Apple-Mail=_A688EF12-5F5F-4F66-A002-8310A53FA8A1
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBWApfHnKl2rkXzB/gAQhHVw//YOPRv3XXhl4vdrdWM3gaGqlXlN2gyQY5
s9+HiXJiauqv5+7jygWbeXI2X8GorFXVoWQRvgaVhWor2kJHZpyP+cFE1XBwXGzt
n+a1R+H+3xZcnLPfzT7q0XogF5GkvEj5WIdwy7T77D1tK2zECypkKfLEJw3PJOBc
w7pV7Eb0f+oA1UatnAzcQyDVVxeL7Ew6Iol+iDrDXK6bK+tAMYudIL/HKAdjkMAB
/33SDIneIc/Y62MA1vKzvA+iTjUe00OW59uvt+zNpf1veW6RxU2vrd1sdMGUYkv7
ODJOdOU0ejyxoEt2RQ0jVsSn8sIqpgZaJ9z6R5cDH8pftNcHzLmCebJOzjZnUerO
urP41gIeu6IFBOFsHaIJW20g+82ASqMvOWKLJUSTQAlL2guPbuLClIG1w1lp55Ql
FrG8zYkm531X94c7iy/tdd7sGf4DBIf97xfrgfa7+eJHXQdvYS4yALaJM99iTbhy
9xNdSCtanxcbRqONEOjTdQqOY01sPsfW57aghA6JLX93djJ1CniYvZEeqGWW3a5X
uVjo9Znstmhvhux8CJ0yr9b2nB/UPv4f2nhHpx2F2FtVUTITE73bEOLHKUPHcKUD
l0qX8iP3ZkV8uXSf/kIzUjQABZHBhbuxt7HXwHPc+352rxXCmvOus9VIjuRw3xXT
+i2qRga7Cl4=
=JwhT
-----END PGP SIGNATURE-----

--Apple-Mail=_A688EF12-5F5F-4F66-A002-8310A53FA8A1--
