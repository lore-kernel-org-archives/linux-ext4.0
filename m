From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] mke2fs: add make_hugefile feature
Date: Tue, 21 Jan 2014 11:45:17 -0700
Message-ID: <24F1EAE7-6E6D-4411-9092-D159E0BE3A9C@dilger.ca>
References: <1390285023-23133-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0 (Mac OS X Mail 7.1 \(1827\))
Content-Type: multipart/signed; boundary="Apple-Mail=_EE583FFD-120D-4575-B6C1-7A5B0086D4D9"; protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f53.google.com ([209.85.160.53]:63111 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754358AbaAUSpZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 21 Jan 2014 13:45:25 -0500
Received: by mail-pb0-f53.google.com with SMTP id md12so3730094pbc.40
        for <linux-ext4@vger.kernel.org>; Tue, 21 Jan 2014 10:45:25 -0800 (PST)
In-Reply-To: <1390285023-23133-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_EE583FFD-120D-4575-B6C1-7A5B0086D4D9
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Jan 20, 2014, at 11:17 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> This feature is enabled via settings in /etc/mke2fs.conf.  For
> example:
>=20
> 	hugefile =3D {
> 		features =3D =
extent,huge_file,flex_bg,uninit_bg,dir_nlink,extra_isize,^resize_inode,spa=
rse_super2
> 		inode_size =3D 128
> 		packed_meta_blocks =3D 1
> 		make_hugefiles =3D 1
> 		inode_ratio =3D 4194304
> 		hugefiles_dir =3D /database
> 		hugefiles_uid =3D 120
> 		hugefiles_gid =3D 50
> 		hugefiles_name =3D storage
> 		hugefiles_digits =3D 4
> 		hugefile_size =3D 1G
> 		num_hugefiles =3D 0
> 	}
>=20
> Then "mke2fs -T hugefile /dev/sdXX" will create as many 1G files
> needed to fill the file system.

How is this different from using fallocate to allocate the files?
Is this just to create a test image for e2fsck or similar?  It
might make sense to include f_hugefiles/script and expect.1 for it?

Cheers, Andreas

> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> ---
>=20
> This is an enhancement to mke2fs which I developed for a use case at
> work, where it is convenient to create a set of pre-allocated files
> which use all or most of the space in the file system.  I've tried to
> make it to be as general as possible, but I'm still considering =
whether
> it's appropriate to include this in the e2fprogs sources, perhaps =
under
> a configure --enable-make-hugefiles option or some such.  Nearly all =
of
> the new code is in a separate file for ease of maintenance.
>=20
>=20
> misc/Makefile.in      |   3 +-
> misc/mk_hugefiles.c   | 385 =
++++++++++++++++++++++++++++++++++++++++++++++++++
> misc/mke2fs.c         |  21 +--
> misc/mke2fs.conf.5.in |  45 ++++++
> misc/mke2fs.h         |  29 ++++
> 5 files changed, 474 insertions(+), 9 deletions(-)
> create mode 100644 misc/mk_hugefiles.c
> create mode 100644 misc/mke2fs.h
>=20
> diff --git a/misc/Makefile.in b/misc/Makefile.in
> index 8342940..c5f332b 100644
> --- a/misc/Makefile.in
> +++ b/misc/Makefile.in
> @@ -42,7 +42,8 @@ LPROGS=3D		@E2INITRD_PROG@
>=20
> TUNE2FS_OBJS=3D	tune2fs.o util.o
> MKLPF_OBJS=3D	mklost+found.o
> -MKE2FS_OBJS=3D	mke2fs.o util.o profile.o prof_err.o =
default_profile.o
> +MKE2FS_OBJS=3D	mke2fs.o util.o profile.o prof_err.o =
default_profile.o \
> +			mk_hugefiles.o
> CHATTR_OBJS=3D	chattr.o
> LSATTR_OBJS=3D	lsattr.o
> UUIDGEN_OBJS=3D	uuidgen.o
> diff --git a/misc/mk_hugefiles.c b/misc/mk_hugefiles.c
> new file mode 100644
> index 0000000..c43a2b0
> --- /dev/null
> +++ b/misc/mk_hugefiles.c
> @@ -0,0 +1,385 @@
> +/*
> + * mk_hugefiles.c -- create huge files
> + */
> +
> +#define _XOPEN_SOURCE 600 /* for inclusion of PATH_MAX in Solaris */
> +
> +#include "config.h"
> +#include <stdio.h>
> +#include <string.h>
> +#include <strings.h>
> +#include <fcntl.h>
> +#include <ctype.h>
> +#include <time.h>
> +#ifdef __linux__
> +#include <sys/utsname.h>
> +#endif
> +#ifdef HAVE_GETOPT_H
> +#include <getopt.h>
> +#else
> +extern char *optarg;
> +extern int optind;
> +#endif
> +#ifdef HAVE_UNISTD_H
> +#include <unistd.h>
> +#endif
> +#ifdef HAVE_STDLIB_H
> +#include <stdlib.h>
> +#endif
> +#ifdef HAVE_ERRNO_H
> +#include <errno.h>
> +#endif
> +#include <sys/ioctl.h>
> +#include <sys/types.h>
> +#include <sys/stat.h>
> +#include <libgen.h>
> +#include <limits.h>
> +#include <blkid/blkid.h>
> +
> +#include "ext2fs/ext2_fs.h"
> +#include "ext2fs/ext2fsP.h"
> +#include "et/com_err.h"
> +#include "uuid/uuid.h"
> +#include "e2p/e2p.h"
> +#include "ext2fs/ext2fs.h"
> +#include "util.h"
> +#include "profile.h"
> +#include "prof_err.h"
> +#include "nls-enable.h"
> +#include "mke2fs.h"
> +
> +static int uid;
> +static int gid;
> +static blk64_t num_blocks;
> +static blk64_t num_slack;
> +static unsigned long num_files;
> +static blk64_t goal;
> +static char *fn_prefix;
> +static int idx_digits;
> +static char *fn_buf;
> +static char *fn_numbuf;
> +
> +static errcode_t create_directory(ext2_filsys fs, char *dir,
> +				  ext2_ino_t *ret_ino)
> +
> +{
> +	struct ext2_inode	inode;
> +	ext2_ino_t		ino =3D EXT2_ROOT_INO;
> +	ext2_ino_t		newdir;
> +	errcode_t		retval;
> +	char			*fn, *cp, *next;
> +
> +	fn =3D malloc(strlen(dir) + 1);
> +	if (fn =3D=3D NULL)
> +		return ENOMEM;
> +
> +	strcpy(fn, dir);
> +	cp =3D fn;
> +	while(1) {
> +		next =3D strchr(cp, '/');
> +		if (next)
> +			*next++ =3D 0;
> +		if (*cp) {
> +			retval =3D ext2fs_new_inode(fs, ino, =
LINUX_S_IFDIR,
> +						  NULL, &newdir);
> +			if (retval)
> +				goto errout;
> +
> +			retval =3D ext2fs_mkdir(fs, ino, newdir, cp);
> +			if (retval)
> +				goto errout;
> +
> +			ino =3D newdir;
> +			retval =3D ext2fs_read_inode(fs, ino, &inode);
> +			if (retval)
> +				goto errout;
> +
> +			inode.i_uid =3D uid & 0xFFFF;
> +			ext2fs_set_i_uid_high(inode, (uid >> 16) & =
0xffff);
> +			inode.i_gid =3D gid & 0xFFFF;
> +			ext2fs_set_i_gid_high(inode, (gid >> 16) & =
0xffff);
> +			retval =3D ext2fs_write_inode(fs, ino, &inode);
> +			if (retval)
> +				goto errout;
> +		}
> +		if (next =3D=3D NULL || *next =3D=3D '\0')
> +			break;
> +		cp =3D next;
> +	}
> +errout:
> +	free(fn);
> +	if (retval =3D=3D 0)
> +		*ret_ino =3D ino;
> +	return retval;
> +}
> +
> +static errcode_t mk_hugefile(ext2_filsys fs, blk64_t num,
> +			     ext2_ino_t dir, int idx, ext2_ino_t *ino)
> +
> +{
> +	errcode_t		retval;
> +	blk64_t			lblk, blk, bend;
> +	__u64			size;
> +	blk64_t			left;
> +	blk64_t			count =3D 0;
> +	struct ext2_inode	inode;
> +	ext2_extent_handle_t	handle;
> +
> +	retval =3D ext2fs_new_inode(fs, 0, LINUX_S_IFREG, NULL, ino);
> +	if (retval)
> +		return retval;
> +
> +	memset(&inode, 0, sizeof(struct ext2_inode));
> +	inode.i_mode =3D LINUX_S_IFREG | (0666 & ~fs->umask);
> +	inode.i_links_count =3D 1;
> +	inode.i_uid =3D uid & 0xFFFF;
> +	ext2fs_set_i_uid_high(inode, (uid >> 16) & 0xffff);
> +	inode.i_gid =3D gid & 0xFFFF;
> +	ext2fs_set_i_gid_high(inode, (gid >> 16) & 0xffff);
> +
> +	retval =3D ext2fs_write_new_inode(fs, *ino, &inode);
> +	if (retval)
> +		return retval;
> +
> +	ext2fs_inode_alloc_stats2(fs, *ino, +1, 0);
> +
> +	retval =3D ext2fs_extent_open2(fs, *ino, &inode, &handle);
> +	if (retval)
> +		return retval;
> +
> +	lblk =3D 0;
> +	left =3D num ? num : 1;
> +	while (left) {
> +		blk64_t pblk, end;
> +		blk64_t n =3D left;
> +
> +		retval =3D  =
ext2fs_find_first_zero_block_bitmap2(fs->block_map,
> +			goal, ext2fs_blocks_count(fs->super) - 1, &end);
> +		if (retval)
> +			return ENOSPC;
> +		goal =3D end;
> +
> +		retval =3D  =
ext2fs_find_first_set_block_bitmap2(fs->block_map, goal,
> +			       ext2fs_blocks_count(fs->super) - 1, =
&bend);
> +		if (retval =3D=3D ENOENT) {
> +			bend =3D ext2fs_blocks_count(fs->super);
> +			if (num =3D=3D 0)
> +				left =3D 0;
> +		}
> +		if (!num || bend - goal < left)
> +			n =3D bend - goal;
> +		pblk =3D goal;
> +		if (num)
> +			left -=3D n;
> +		goal +=3D n;
> +		count +=3D n;
> +		ext2fs_block_alloc_stats_range(fs, pblk, n, +1);
> +
> +		while (n) {
> +			blk64_t l =3D n;
> +			struct ext2fs_extent newextent;
> +
> +			if (l > EXT_INIT_MAX_LEN)
> +				l =3D EXT_INIT_MAX_LEN;
> +
> +			newextent.e_len =3D l;
> +			newextent.e_pblk =3D pblk;
> +			newextent.e_lblk =3D lblk;
> +			newextent.e_flags =3D 0;
> +
> +			retval =3D ext2fs_extent_insert(handle,
> +					EXT2_EXTENT_INSERT_AFTER, =
&newextent);
> +			if (retval)
> +				return retval;
> +			pblk +=3D l;
> +			lblk +=3D l;
> +			n -=3D l;
> +		}
> +	}
> +
> +	retval =3D ext2fs_read_inode(fs, *ino, &inode);
> +	if (retval)
> +		goto errout;
> +
> +	retval =3D ext2fs_iblk_add_blocks(fs, &inode,
> +					count / =
EXT2FS_CLUSTER_RATIO(fs));
> +	if (retval)
> +		goto errout;
> +	size =3D (__u64) count * fs->blocksize;
> +	inode.i_size =3D size & 0xffffffff;
> +	inode.i_size_high =3D (size >> 32);
> +
> +	retval =3D ext2fs_write_new_inode(fs, *ino, &inode);
> +	if (retval)
> +		goto errout;
> +
> +	if (idx_digits)
> +		sprintf(fn_numbuf, "%0*d", idx_digits, idx);
> +	else if (num_files > 1)
> +		sprintf(fn_numbuf, "%d", idx);
> +
> +retry:
> +	retval =3D ext2fs_link(fs, dir, fn_buf, *ino, EXT2_FT_REG_FILE);
> +	if (retval =3D=3D EXT2_ET_DIR_NO_SPACE) {
> +		retval =3D ext2fs_expand_dir(fs, dir);
> +		if (retval)
> +			goto errout;
> +		goto retry;
> +	}
> +
> +	if (retval)
> +		goto errout;
> +
> +errout:
> +	if (handle)
> +		ext2fs_extent_free(handle);
> +
> +	return retval;
> +}
> +
> +static blk64_t calc_overhead(ext2_filsys fs, blk64_t num_blocks)
> +{
> +	blk64_t e_blocks, e_blocks2, e_blocks3, e_blocks4;
> +	int extents_per_block;
> +	int extents =3D (num_blocks + EXT_INIT_MAX_LEN - 1) / =
EXT_INIT_MAX_LEN;
> +
> +	if (extents <=3D 4)
> +		return 0;
> +
> +	/*
> +	 * This calculation is due to the fact that we are inefficient
> +	 * in how handle extent splits when appending to the end of
> +	 * the extent tree.  Sigh.  We should fix this so that we can
> +	 * actually store 340 extents per 4k block, instead of only 170.
> +	 */
> +	extents_per_block =3D ((fs->blocksize -
> +			      sizeof(struct ext3_extent_header)) /
> +			     sizeof(struct ext3_extent));
> +	extents_per_block =3D (extents_per_block/ 2) - 1;
> +
> +	e_blocks =3D (extents + extents_per_block - 1) / =
extents_per_block;
> +	e_blocks2 =3D (e_blocks + extents_per_block - 1) / =
extents_per_block;
> +	e_blocks3 =3D (e_blocks2 + extents_per_block - 1) / =
extents_per_block;
> +	e_blocks4 =3D (e_blocks3 + extents_per_block - 1) / =
extents_per_block;
> +	return e_blocks + e_blocks2 + e_blocks3 + e_blocks4;
> +}
> +
> +/*
> + * Find the place where we should start allocating blocks for the =
huge
> + * files.  Leave <slack> free blocks at the beginning of the file
> + * system for things like metadata blocks.
> + */
> +static blk64_t get_start_block(ext2_filsys fs, blk64_t slack)
> +{
> +	errcode_t retval;
> +	blk64_t goal =3D fs->super->s_first_data_block, next;
> +	blk64_t last_blk =3D ext2fs_blocks_count(fs->super) - 1;
> +
> +	while (slack) {
> +		retval =3D =
ext2fs_find_first_zero_block_bitmap2(fs->block_map,
> +						goal, last_blk, &goal);
> +		if (retval)
> +			break;
> +
> +		retval =3D =
ext2fs_find_first_set_block_bitmap2(fs->block_map,
> +						goal, last_blk, &next);
> +		if (retval)
> +			next =3D last_blk;
> +		next--;
> +
> +		if (next - goal > slack) {
> +			goal +=3D slack;
> +			break;
> +		}
> +
> +		slack -=3D (next - goal);
> +		goal =3D next;
> +	}
> +	return goal;
> +}
> +
> +errcode_t mk_hugefiles(ext2_filsys fs)
> +{
> +	errcode_t retval;
> +	ext2_ino_t dir;
> +	int i;
> +	char *t;
> +
> +	if (!get_bool_from_profile(fs_types, "make_hugefiles", 0))
> +		return 0;
> +
> +	uid =3D get_int_from_profile(fs_types, "hugefiles_uid", 0);
> +	gid =3D get_int_from_profile(fs_types, "hugefiles_gid", 0);
> +	fs->umask =3D get_int_from_profile(fs_types, "hugefiles_umask", =
077);
> +	num_files =3D get_int_from_profile(fs_types, "num_hugefiles", =
0);
> +	t =3D get_string_from_profile(fs_types, "hugefiles_slack", =
"1M");
> +	num_slack =3D parse_num_blocks2(t, fs->super->s_log_block_size);
> +	t =3D get_string_from_profile(fs_types, "hugefiles_size", "0");
> +	num_blocks =3D parse_num_blocks2(t, =
fs->super->s_log_block_size);
> +
> +	retval =3D create_directory(fs, =
get_string_from_profile(fs_types,
> +					"hugefiles_dir", "/"), &dir);
> +	if (retval)
> +		return dir;
> +
> +	if (num_blocks =3D=3D 0 && num_files =3D=3D 0)
> +		num_files =3D 1;
> +
> +	if (num_files =3D=3D 0 && num_blocks) {
> +		blk64_t fs_blocks =3D =
ext2fs_free_blocks_count(fs->super);
> +
> +		fs_blocks -=3D num_slack;
> +		num_files =3D fs_blocks / num_blocks;
> +		fs_blocks -=3D (num_files / 16) + 1;
> +		fs_blocks -=3D calc_overhead(fs, num_blocks) * =
num_files;
> +		num_files =3D fs_blocks / num_blocks;
> +	}
> +
> +	if (num_blocks =3D=3D 0 && num_files > 1) {
> +		blk64_t fs_blocks =3D =
ext2fs_free_blocks_count(fs->super);
> +
> +		fs_blocks -=3D num_slack;
> +		num_blocks =3D fs_blocks / num_files;
> +
> +		fs_blocks -=3D calc_overhead(fs, num_blocks) * =
num_files;
> +		fs_blocks -=3D num_slack;
> +		num_blocks =3D fs_blocks / num_files;
> +		printf("Using num_blocks %llu\n", num_blocks);
> +	}
> +
> +	num_slack +=3D calc_overhead(fs, num_blocks) * num_files;
> +	num_slack +=3D (num_files / 16) + 1; /* space for dir entries */
> +	goal =3D get_start_block(fs, num_slack);
> +
> +	fn_prefix =3D get_string_from_profile(fs_types, =
"hugefiles_name",
> +					    "hugefile");
> +	idx_digits =3D get_int_from_profile(fs_types, =
"hugefiles_digits", 5);
> +	i =3D int_log10(num_files) + 1;
> +	if (idx_digits > i)
> +		i =3D idx_digits;
> +	fn_buf =3D malloc(strlen(fn_prefix) + i + 1);
> +	if (!fn_buf)
> +		return ENOMEM;
> +	strcpy(fn_buf, fn_prefix);
> +	fn_numbuf =3D fn_buf + strlen(fn_prefix);
> +
> +	if (!quiet) {
> +		printf(_("Creating %d huge file(s) "), num_files);
> +		if (num_blocks)
> +			printf(_("with %llu blocks each"), num_blocks);
> +		fputc('\n', stdout);
> +	}
> +	for (i=3D0; i < num_files; i++) {
> +		ext2_ino_t ino;
> +
> +		retval =3D mk_hugefile(fs, num_blocks, dir, i, &ino);
> +		if (retval) {
> +			com_err(program_name, retval,
> +				_("while creating huge file %d"), i);
> +			goto errout;
> +		}
> +	}
> +errout:
> +	free(fn_buf);
> +	return retval;
> +}
> diff --git a/misc/mke2fs.c b/misc/mke2fs.c
> index e798648..9d7673f 100644
> --- a/misc/mke2fs.c
> +++ b/misc/mke2fs.c
> @@ -62,6 +62,7 @@ extern int optind;
> #include "../version.h"
> #include "nls-enable.h"
> #include "quota/mkquota.h"
> +#include "mke2fs.h"
>=20
> #define STRIDE_LENGTH 8
>=20
> @@ -76,13 +77,13 @@ extern int optind;
> extern int isatty(int);
> extern FILE *fpopen(const char *cmd, const char *mode);
>=20
> -static const char * program_name =3D "mke2fs";
> +const char * program_name =3D "mke2fs";
> static const char * device_name /* =3D NULL */;
>=20
> /* Command line options */
> static int	cflag;
> -static int	verbose;
> -static int	quiet;
> +int	verbose;
> +int	quiet;
> static int	super_only;
> static int	discard =3D 1;	/* attempt to discard device before fs =
creation */
> static int	direct_io;
> @@ -107,7 +108,7 @@ static char *volume_label;
> static char *mount_dir;
> char *journal_device;
> static int sync_kludge;	/* Set using the MKE2FS_SYNC env. option =
*/
> -static char **fs_types;
> +char **fs_types;
>=20
> static profile_t	profile;
>=20
> @@ -142,7 +143,7 @@ static int int_log2(unsigned long long arg)
> 	return l;
> }
>=20
> -static int int_log10(unsigned long long arg)
> +int int_log10(unsigned long long arg)
> {
> 	int	l;
>=20
> @@ -1253,7 +1254,7 @@ static char **parse_fs_type(const char *fs_type,
> 	return (list.list);
> }
>=20
> -static char *get_string_from_profile(char **types, const char *opt,
> +char *get_string_from_profile(char **types, const char *opt,
> 				     const char *def_val)
> {
> 	char *ret =3D 0;
> @@ -1270,7 +1271,7 @@ static char *get_string_from_profile(char =
**types, const char *opt,
> 	return (ret);
> }
>=20
> -static int get_int_from_profile(char **types, const char *opt, int =
def_val)
> +int get_int_from_profile(char **types, const char *opt, int def_val)
> {
> 	int ret;
> 	char **cpp;
> @@ -1293,7 +1294,7 @@ static double get_double_from_profile(char =
**types, const char *opt,
> 	return ret;
> }
>=20
> -static int get_bool_from_profile(char **types, const char *opt, int =
def_val)
> +int get_bool_from_profile(char **types, const char *opt, int def_val)
> {
> 	int ret;
> 	char **cpp;
> @@ -2847,6 +2848,10 @@ no_journal:
> 				       EXT4_FEATURE_RO_COMPAT_QUOTA))
> 		create_quota_inodes(fs);
>=20
> +	retval =3D mk_hugefiles(fs);
> +	if (retval)
> +		com_err(program_name, retval, "while creating huge =
files");
> +
> 	if (!quiet)
> 		printf("%s", _("Writing superblocks and "
> 		       "filesystem accounting information: "));
> diff --git a/misc/mke2fs.conf.5.in b/misc/mke2fs.conf.5.in
> index 1aba87b..8f628a7 100644
> --- a/misc/mke2fs.conf.5.in
> +++ b/misc/mke2fs.conf.5.in
> @@ -417,6 +417,51 @@ system feature is enabled.  It can be overridden =
via the
> .B \-C
> command line option to
> .BR mke2fs (8)
> +.TP
> +.I make_hugefiles
> +This boolean relation enables the creation of pre-allocated files as
> +part of formatting the file system.
> +.TP
> +.I hugefiles_uid
> +This relation controls the user ownership for all of the files and
> +directories created by the
> +.I make_hugefiles
> +feature.
> +.TP
> +.I hugefiles_gid
> +This relation controls the group ownership for all of the files and
> +directories created by the
> +.I make_hugefiles
> +feature.
> +.TP
> +.I hugefiles_umask
> +This relation specifies the umask used when creating the files and
> +directories by the
> +.I make_hugefiles
> +feature.
> +.TP
> +.I num_hugefiles
> +This relation specifies the number of huge files to be created.  If =
this
> +relation is not specified, or is set to zero, and the
> +.I hugefiles_size
> +relation is non-zero, then
> +.I make_hugefiles
> +will create as many huge files as can fit to fill the entire file =
system.
> +.TP
> +.I hugefiles_slack
> +This relation specifies how much space should be reserved for other
> +files.
> +.TP
> +.I hugefiles_size
> +This relation specifies the size of the huge files.  If this relation =
is
> +not specified, the default is to fill th efile system.
> +.TP
> +.I hugefiles_name
> +This relation specifies the base file name for the huge files.
> +.TP
> +.I hugefiles_digits
> +This relation specifies the (zero-padded) width of the field for the
> +huge file number.
> .SH THE [devices] STANZA
> Each tag in the
> .I [devices]=20
> diff --git a/misc/mke2fs.h b/misc/mke2fs.h
> new file mode 100644
> index 0000000..73d8c71
> --- /dev/null
> +++ b/misc/mke2fs.h
> @@ -0,0 +1,29 @@
> +/*
> + * mke2fs.h
> + *
> + * Copyright (C) 1994, 1995, 1996, 1997, 1998, 1999, 2000, 2001, =
2002,
> + * 	2003, 2004, 2005 by Theodore Ts'o.
> + *
> + * %Begin-Header%
> + * This file may be redistributed under the terms of the GNU Public
> + * License.
> + * %End-Header%
> + */
> +
> +/* mke2fs.c */
> +extern const char * program_name;
> +extern int	quiet;
> +extern int	verbose;
> +extern char **fs_types;
> +
> +extern char *get_string_from_profile(char **types, const char *opt,
> +				     const char *def_val);
> +extern int get_int_from_profile(char **types, const char *opt, int =
def_val);
> +extern int get_bool_from_profile(char **types, const char *opt, int =
def_val);
> +extern int int_log10(unsigned long long arg);
> +
> +/* mk_hugefiles.c */
> +extern errcode_t mk_hugefiles(ext2_filsys fs);
> +
> +
> +
> --=20
> 1.8.5.rc3.362.gdf10213
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas






--Apple-Mail=_EE583FFD-120D-4575-B6C1-7A5B0086D4D9
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBUt7APnKl2rkXzB/gAQJzTA//TJ+JjOSaiiFOvFy3HUDhU1ZFy1xvN2ZL
1ZmaZpeXIeNdjp42mzLgKhhuwwrB3HycPqvA/7MUWW+lR/x3Kv+eyPvri0SwgGHr
3mIGdzfigHu/kejvsN5dG0Y/nCN/f+gUahxqHsMfwFXbptipjRjlTkmGnnQMyVIB
IMttGIjC2JwprU16fp+l0azA0UKCrmLzZKRpkIRBjlupxPb9aHw3piHE/o0cwyDj
6QRyld9YHAekDeIGEADqa/jM5pZPJ70gX2nf7jqIQ2D7f0rXNPP0whmxZcc10xNS
e8z89mUsgX7wnxwKOPi1HTA7qls8IwmIQY4nN2b6/ceJG4GtQNRFz9sfjmvBvTcT
sgBRmDbjNX+CHS6yjOcQJTR7YlycKPXsUMXD2T2nPj/c8ewU21SeagJxbKQTud9T
76lHF1Mqr+hDelIhcWUSHuqbCXUbHiyizhseTRKFgtdb58ZiqHpScjyA+0Y6euQc
OPw0+J/j7gW55rmWahV8jf3HnWgu+blBba3u/USuy+OxR6X4twGUwm/nJtNGIGGQ
DzgEvXNjHz02kRaNRc152Mg3XpEWIyNpp/T4wA0i7yebXf3ldQ+vt/XHCeG7qLfT
V+dAeUSdArE3FPoyTsHmvCXDzMqJ5cjRCgYn57nY9ExFZRpcerl1a7JEFV5qgMi2
EYm1vZT0+js=
=YYIe
-----END PGP SIGNATURE-----

--Apple-Mail=_EE583FFD-120D-4575-B6C1-7A5B0086D4D9--
