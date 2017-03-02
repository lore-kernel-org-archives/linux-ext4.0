From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 2/3] e2info: create a tool to display ext4 fs geometry
 online
Date: Thu, 2 Mar 2017 12:49:46 -0700
Message-ID: <0AA96991-8F69-4004-BAC8-8C1DBB8368E0@dilger.ca>
References: <148843032650.21733.13980225191301375698.stgit@birch.djwong.org>
 <148843033922.21733.4922683685279348093.stgit@birch.djwong.org>
Mime-Version: 1.0 (Mac OS X Mail 10.2 \(3259\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_5629B9FC-A145-4B85-A4FD-DD1FD6EEF7BD";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-it0-f68.google.com ([209.85.214.68]:34133 "EHLO
        mail-it0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752047AbdCBUsS (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 2 Mar 2017 15:48:18 -0500
Received: by mail-it0-f68.google.com with SMTP id r141so186727ita.1
        for <linux-ext4@vger.kernel.org>; Thu, 02 Mar 2017 12:47:32 -0800 (PST)
In-Reply-To: <148843033922.21733.4922683685279348093.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_5629B9FC-A145-4B85-A4FD-DD1FD6EEF7BD
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Mar 1, 2017, at 9:52 PM, Darrick J. Wong <darrick.wong@oracle.com> =
wrote:
>=20
> From: Darrick J. Wong <darrick.wong@oracle.com>
>=20
> Create e2info, which reports the fs geometry of an online ext4 =
filesystem.

Besides providing a place to call the new EXT4_IOC_FSGEOMETRY ioctl, I
don't see how this is much different from "dumpe2fs -h"?

Cheers, Andreas

> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> configure            |    4 +
> configure.ac         |    3 +
> lib/ext2fs/ext2_fs.h |   34 ++++++++
> misc/Makefile.in     |   30 ++++++-
> misc/e2info.8.in     |   64 ++++++++++++++++
> misc/e2info.c        |  205 =
++++++++++++++++++++++++++++++++++++++++++++++++++
> 6 files changed, 336 insertions(+), 4 deletions(-)
> create mode 100644 misc/e2info.8.in
> create mode 100644 misc/e2info.c
>=20
>=20
> diff --git a/configure b/configure
> index 5f7b429..b553da1 100755
> --- a/configure
> +++ b/configure
> @@ -642,6 +642,7 @@ root_prefix
> UNIX_CMT
> CYGWIN_CMT
> LINUX_CMT
> +E2INFO_CMT
> UNI_DIFF_OPTS
> SEM_INIT_LIB
> FUSE_CMT
> @@ -13663,13 +13664,16 @@ fi
> { $as_echo "$as_me:${as_lineno-$LINENO}: result: $UNI_DIFF_OPTS" >&5
> $as_echo "$UNI_DIFF_OPTS" >&6; }
>=20
> +E2INFO_CMT=3D"#"
> case "$host_os" in
> linux*)
>=20
> $as_echo "#define HAVE_EXT2_IOCTLS 1" >>confdefs.h
>=20
> +	E2INFO_CMT=3D
> 	;;
> esac
> +
> LINUX_CMT=3D"#"
> CYGWIN_CMT=3D"#"
> UNIX_CMT=3D
> diff --git a/configure.ac b/configure.ac
> index 9da7b86..bf613fd 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -1260,11 +1260,14 @@ AC_SUBST(UNI_DIFF_OPTS)
> dnl
> dnl We use the EXT2 ioctls only under Linux
> dnl
> +E2INFO_CMT=3D"#"
> case "$host_os" in
> linux*)
> 	AC_DEFINE(HAVE_EXT2_IOCTLS, 1, [Define to 1 if Ext2 ioctls =
present])
> +	E2INFO_CMT=3D
> 	;;
> esac
> +AC_SUBST(E2INFO_CMT)
> dnl
> dnl OS-specific uncomment control
> dnl
> diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
> index 27a7d3a..bad7648 100644
> --- a/lib/ext2fs/ext2_fs.h
> +++ b/lib/ext2fs/ext2_fs.h
> @@ -372,6 +372,40 @@ struct ext4_new_group_input {
> #define EXT4_IOC_GROUP_ADD		_IOW('f', 8,struct =
ext4_new_group_input)
> #define EXT4_IOC_RESIZE_FS		_IOW('f', 16, __u64)
>=20
> +/* ext4 fs geometry. */
> +struct ext4_fsop_geom {
> +	__u32		efg_blocksize;	/* filesystem (data) block size =
*/
> +	__u32		efg_bgblocks;	/* fsblocks in an AG		=
*/
> +	__u32		efg_bgcount;	/* number of allocation groups	=
*/
> +	__u32		efg_logblocks;	/* fsblocks in the log		=
*/
> +	__u32		efg_resvblocks;	/* number of reserved blocks	=
*/
> +	__u32		efg_inodesize;	/* inode size in bytes		=
*/
> +	__u32		efg_bg_iblocks;	/* inode blocks per AG		=
*/
> +	__u32		efg_flags;	/* superblock version flags	=
*/
> +	__u64		efg_inodecount;	/* inode count			=
*/
> +	__u64		efg_blockcount;	/* fsblocks in filesystem	=
*/
> +	unsigned char	efg_uuid[16];	/* unique id of the filesystem	=
*/
> +	__u32		efg_sunit;	/* stripe unit, fsblocks	=
*/
> +	__u32		efg_swidth;	/* stripe width, fsblocks	=
*/
> +	__u32		efg_clustersize;/* fs cluster size		=
*/
> +	__u32		efg_flexbgsize;	/* number of bg's in a flexbg	=
*/
> +	__u64		efg_resv[6];
> +};
> +
> +#define EXT4_FSOP_GEOM_FLAGS_ATTR	0x00001	/* extended attr in use	 =
*/
> +#define EXT4_FSOP_GEOM_FLAGS_NLINK	0x00002	/* 32-bit nlink values	 =
*/
> +#define EXT4_FSOP_GEOM_FLAGS_QUOTA	0x00004	/* quotas enabled	 =
*/
> +#define EXT4_FSOP_GEOM_FLAGS_PROJQ	0x00008	/* project quotas	 =
*/
> +#define EXT4_FSOP_GEOM_FLAGS_META_CSUM	0x00010	/* metadata =
checksums	 */
> +#define EXT4_FSOP_GEOM_FLAGS_FTYPE	0x00020	/* inode directory types =
*/
> +#define EXT4_FSOP_GEOM_FLAGS_64BIT	0x00040	/* 64-bit support	 =
*/
> +#define EXT4_FSOP_GEOM_FLAGS_INLINEDATA	0x00080	/* inline data		=
 */
> +#define EXT4_FSOP_GEOM_FLAGS_ENCRYPT	0x00100	/* encrypted files	 =
*/
> +#define EXT4_FSOP_GEOM_FLAGS_LARGEDIR	0x00200	/* large =
directories	 */
> +#define EXT4_FSOP_GEOM_FLAGS_EXTENTS	0x00400	/* extents		 =
*/
> +
> +#define EXT4_IOC_FSGEOMETRY		_IOR ('f', 19, struct =
ext4_fsop_geom)
> +
> /*
>  * Structure of an inode on the disk
>  */
> diff --git a/misc/Makefile.in b/misc/Makefile.in
> index 467c15d..311aa57 100644
> --- a/misc/Makefile.in
> +++ b/misc/Makefile.in
> @@ -32,14 +32,19 @@ INSTALL =3D @INSTALL@
>=20
> @FUSE_CMT@FUSE_PROG=3D fuse2fs
>=20
> +@E2INFO_CMT@E2INFO_PROG=3D e2info
> +@E2INFO_CMT@E2INFO_MAN=3D e2info.8
> +
> SPROGS=3D		mke2fs badblocks tune2fs dumpe2fs $(BLKID_PROG) =
logsave \
> 			$(E2IMAGE_PROG) @FSCK_PROG@ e2undo
> USPROGS=3D	mklost+found filefrag e2freefrag $(UUIDD_PROG) \
> -			$(E4DEFRAG_PROG) $(E4CRYPT_PROG) $(FUSE_PROG)
> +			$(E4DEFRAG_PROG) $(E4CRYPT_PROG) $(FUSE_PROG) \
> +			$(E2INFO_PROG)
> SMANPAGES=3D	tune2fs.8 mklost+found.8 mke2fs.8 dumpe2fs.8 badblocks.8 =
\
> 			e2label.8 $(FINDFS_MAN) $(BLKID_MAN) =
$(E2IMAGE_MAN) \
> 			logsave.8 filefrag.8 e2freefrag.8 e2undo.8 \
> -			$(UUIDD_MAN) $(E4DEFRAG_MAN) $(E4CRYPT_MAN) =
@FSCK_MAN@
> +			$(UUIDD_MAN) $(E4DEFRAG_MAN) $(E4CRYPT_MAN) =
@FSCK_MAN@ \
> +			$(E2INFO_MAN)
> FMANPAGES=3D	mke2fs.conf.5 ext4.5
>=20
> UPROGS=3D		chattr lsattr @UUID_CMT@ uuidgen
> @@ -68,6 +73,7 @@ E4CRYPT_OBJS=3D   e4crypt.o
> E2FREEFRAG_OBJS=3D e2freefrag.o
> E2FUZZ_OBJS=3D	e2fuzz.o
> FUSE2FS_OBJS=3D	fuse2fs.o journal.o recovery.o revoke.o
> +E2INFO_OBJS=3D	e2info.o
>=20
> PROFILED_TUNE2FS_OBJS=3D	profiled/tune2fs.o profiled/util.o
> PROFILED_MKLPF_OBJS=3D	profiled/mklost+found.o
> @@ -90,8 +96,9 @@ PROFILED_E2FREEFRAG_OBJS=3D profiled/e2freefrag.o
> PROFILED_E2UNDO_OBJS=3D	profiled/e2undo.o
> PROFILED_E4DEFRAG_OBJS=3D	profiled/e4defrag.o
> PROFILED_E4CRYPT_OBJS=3D	profiled/e4crypt.o
> -PROFILED_FUSE2FS_OJBS=3D	profiled/fuse2fs.o profiled/journal.o \
> +PROFILED_FUSE2FS_OBJS=3D	profiled/fuse2fs.o profiled/journal.o \
> 			profiled/recovery.o profiled/revoke.o
> +PROFILED_E2INFO_OBJS=3D	profiled/e2info.o
>=20
> SRCS=3D	$(srcdir)/tune2fs.c $(srcdir)/mklost+found.c =
$(srcdir)/mke2fs.c $(srcdir)/mk_hugefiles.c \
> 		$(srcdir)/chattr.c $(srcdir)/lsattr.c =
$(srcdir)/dumpe2fs.c \
> @@ -102,7 +109,7 @@ SRCS=3D	$(srcdir)/tune2fs.c =
$(srcdir)/mklost+found.c $(srcdir)/mke2fs.c $(srcdir)/
> 		$(srcdir)/e2freefrag.c $(srcdir)/create_inode.c \
> 		$(srcdir)/fuse2fs.c \
> 		$(srcdir)/../debugfs/journal.c =
$(srcdir)/../e2fsck/revoke.c \
> -		$(srcdir)/../e2fsck/recovery.c
> +		$(srcdir)/../e2fsck/recovery.c $(srcdir)/e2info.c
>=20
> LIBS=3D $(LIBEXT2FS) $(LIBCOM_ERR) $(LIBSUPPORT)
> DEPLIBS=3D $(LIBEXT2FS) $(DEPLIBCOM_ERR) $(DEPLIBSUPPORT)
> @@ -391,6 +398,11 @@ fuse2fs: $(FUSE2FS_OBJS) $(DEPLIBS) =
$(DEPLIBBLKID) $(DEPLIBUUID) \
> 		$(LIBFUSE) $(LIBBLKID) $(LIBUUID) $(LIBEXT2FS) =
$(LIBINTL) \
> 		$(CLOCK_GETTIME_LIB) $(SYSLIBS)
>=20
> +e2info: $(E2INFO_OBJS) $(DEPLIBS)
> +	$(E) "	LD $@"
> +	$(Q) $(CC) $(ALL_LDFLAGS) -o e2info $(E2INFO_OBJS) $(LIBINTL) \
> +		$(SYSLIBS)
> +
> journal.o: $(srcdir)/../debugfs/journal.c
> 	$(E) "	CC $@"
> 	$(Q) $(CC) -c $(JOURNAL_CFLAGS) -I$(srcdir) \
> @@ -411,6 +423,10 @@ tst_ismounted: $(srcdir)/ismounted.c =
$(STATIC_LIBEXT2FS) $(DEPLIBCOM_ERR)
> 	$(CC) -o tst_ismounted $(srcdir)/ismounted.c -DDEBUG =
$(ALL_CFLAGS) \
> 		$(LIBCOM_ERR) $(SYSLIBS)
>=20
> +e2info.8: $(DEP_SUBSTITUTE) $(srcdir)/e2info.8.in
> +	$(E) "	SUBST $@"
> +	$(Q) $(SUBSTITUTE_UPTIME) $(srcdir)/e2info.8.in e2info.8
> +
> tune2fs.8: $(DEP_SUBSTITUTE) $(srcdir)/tune2fs.8.in
> 	$(E) "	SUBST $@"
> 	$(Q) $(SUBSTITUTE_UPTIME) $(srcdir)/tune2fs.8.in tune2fs.8
> @@ -844,3 +860,9 @@ recovery.o: $(srcdir)/../e2fsck/recovery.c =
$(srcdir)/../e2fsck/jfs_user.h \
>  $(top_srcdir)/lib/support/quotaio_tree.h \
>  $(top_srcdir)/lib/ext2fs/kernel-jbd.h =
$(top_srcdir)/lib/ext2fs/jfs_compat.h \
>  $(top_srcdir)/lib/ext2fs/kernel-list.h
> +e2info.o: $(srcdir)/e2info.c $(top_builddir)/lib/config.h \
> + $(top_builddir)/lib/dirpaths.h $(top_srcdir)/lib/ext2fs/ext2fs.h \
> + $(top_builddir)/lib/ext2fs/ext2_types.h =
$(top_srcdir)/lib/ext2fs/ext2_fs.h \
> + $(top_srcdir)/lib/ext2fs/ext3_extents.h =
$(top_srcdir)/lib/et/com_err.h \
> + $(top_srcdir)/lib/ext2fs/ext2_io.h =
$(top_builddir)/lib/ext2fs/ext2_err.h \
> + $(top_srcdir)/lib/ext2fs/ext2_ext_attr.h =
$(top_srcdir)/lib/ext2fs/bitops.h
> diff --git a/misc/e2info.8.in b/misc/e2info.8.in
> new file mode 100644
> index 0000000..c7f580f
> --- /dev/null
> +++ b/misc/e2info.8.in
> @@ -0,0 +1,64 @@
> +.\" -*- nroff -*-
> +.\" Copyright 2017 Oracle Inc.  All Rights Reserved.
> +.\" This file may be copied under the terms of the GNU Public =
License.
> +.\"
> +.\" Verbatim blocks taken from openssl req manpage content
> +.de Vb \" Begin verbatim text
> +.ft CW
> +.nf
> +.ne \\$1
> +..
> +.de Ve \" End verbatim text
> +.ft R
> +.fi
> +..
> +
> +.TH E2INFO 8 "@E2FSPROGS_MONTH@ @E2FSPROGS_YEAR@" "E2fsprogs version =
@E2FSPROGS_VERSION@"
> +.SH NAME
> +e2info \- Display information about a mounted ext4 filesystem
> +.SH SYNOPSIS
> +.B e2info
> +.I mount-point
> +.br
> +.B e2info \-V
> +.SH DESCRIPTION
> +Prints the filesystem geometry of an ext4 filesystem.  If the mounted
> +filesystem is an ext2 or ext3 filesystem mounted with the ext4 =
driver,
> +the geometry will be displayed.
> +.SH "EXAMPLES"
> +
> +Understanding e2info output.
> +.PP
> +Suppose one has the following "e2info /dev/sda" output:
> +.PP
> +.RS 2
> +.Vb
> +\&meta-data=3D/dev/loop0             isize=3D256    bgcount=3D14808 =
bgsize=3D32768 blks
> +\&         =3D                       attr=3D1       quota=3D0 =
pquota=3D0
> +\&         =3D                       crc=3D0        64bit=3D0 =
inlinedata=3D0 extents=3D1
> +\&         =3D                       flexbg=3D16
> +\&data     =3D                       bsize=3D4096   blocks=3D485198848 =
bg_iblocks=3D512
> +\&         =3D                       sunit=3D32     swidth=3D128 blks =
clustersize=3D0
> +\&         =3D                       encrypt=3D0
> +\&naming   =3D                       bsize=3D4096   largedir=3D0 =
ftype=3D1 nlink=3D1
> +\&log      =3D                       bsize=3D4096   blocks=3D32768
> +.Ve
> +.RE
> +.PP
> +
> +Here, the data section of the output indicates "bsize=3D4096",
> +meaning the data block size for this filesystem is 4096 bytes.
> +This section also shows "sunit=3D32 swidth=3D128 blks", which means
> +the stripe unit is 32*4096 bytes =3D 128 kibibytes and the stripe
> +width is 128*4096 bytes =3D 512 kibibytes.
> +A single stripe of this filesystem therefore consists
> +of four stripe units (128 blocks / 32 blocks per unit).
> +Note also that "flexbg=3D16", which means that this filesystem has
> +512MB flex block groups.
> +That is the upper limit of how much physical disk space can be mapped
> +into a file.
> +.SH SEE ALSO
> +.BR mkfs.ext4 (8),
> +.BR md (4),
> +.BR lvm (8),
> +.BR mount (8).
> diff --git a/misc/e2info.c b/misc/e2info.c
> new file mode 100644
> index 0000000..675f005
> --- /dev/null
> +++ b/misc/e2info.c
> @@ -0,0 +1,205 @@
> +/*
> + * Copyright (c) 2017 Oracle.
> + * All Rights Reserved.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it would be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write the Free Software =
Foundation,
> + * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> + */
> +#include "config.h"
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <string.h>
> +#include <libgen.h>
> +#include <unistd.h>
> +#include <sys/ioctl.h>
> +#include <sys/types.h>
> +#include <sys/stat.h>
> +#include <fcntl.h>
> +#include <errno.h>
> +#include <mntent.h>
> +#include <limits.h>
> +
> +#include "ext2fs/ext2_fs.h"
> +
> +#include "../version.h"
> +#include "support/nls-enable.h"
> +
> +static const char *progname =3D "e2info";
> +
> +static void
> +usage(void)
> +{
> +	fprintf(stderr, _(
> +"Usage: %s [options] mountpoint\n\n\
> +	-V          print version information\n"),
> +		progname);
> +	exit(2);
> +}
> +
> +#define PROC_MOUNTS	"/proc/mounts"
> +int
> +find_datadev(
> +	const char	*arg,
> +	char		*datadev,
> +	char		*mntpoint)
> +{
> +	struct mntent	*mnt;
> +	FILE		*mtp;
> +	char		*mtab_file;
> +	char		rmnt_fsname[PATH_MAX], rmnt_dir[PATH_MAX];
> +	struct stat	sbuf;
> +	dev_t		fd_dev;
> +
> +	if (stat(arg, &sbuf) < 0)
> +		return errno;
> +	/*
> +	 * We want to match st_rdev if the path provided is a device
> +	 * special file.  Otherwise we are looking for the the
> +	 * device id for the containing filesystem, in st_dev.
> +	 */
> +	if (S_ISBLK(sbuf.st_mode) || S_ISCHR(sbuf.st_mode))
> +		fd_dev =3D sbuf.st_rdev;
> +	else
> +		fd_dev =3D sbuf.st_dev;
> +
> +	mtab_file =3D PROC_MOUNTS;
> +	if (access(mtab_file, R_OK) !=3D 0)
> +		mtab_file =3D MOUNTED;
> +
> +	if ((mtp =3D setmntent(mtab_file, "r")) =3D=3D NULL)
> +		return ENOENT;
> +
> +	while ((mnt =3D getmntent(mtp)) !=3D NULL) {
> +		if (!realpath(mnt->mnt_dir, rmnt_dir))
> +			continue;
> +		if (!realpath(mnt->mnt_fsname, rmnt_fsname))
> +			continue;
> +
> +		if (stat(rmnt_fsname, &sbuf) < 0)
> +			continue;
> +		if (sbuf.st_rdev =3D=3D fd_dev) {
> +			strncpy(datadev, rmnt_fsname, PATH_MAX);
> +			strncpy(mntpoint, rmnt_dir, PATH_MAX);
> +			break;
> +		}
> +	}
> +	endmntent(mtp);
> +	return 0;
> +}
> +
> +int
> +main(int argc, char **argv)
> +{
> +	struct ext4_fsop_geom	geo;
> +	char			*progname;
> +	int			fd;
> +	int			c;
> +	int			attr_enabled;
> +	int			nlink_enabled;
> +	int			quota_enabled;
> +	int			projquota_enabled;
> +	int			metacrc_enabled;
> +	int			ftype_enabled;
> +	int			is_64bit;
> +	int			inlinedata_enabled;
> +	int			encrypt_enabled;
> +	int			largedir_enabled;
> +	int			extents_enabled;
> +	char			datadev[PATH_MAX];
> +	char			mntpoint[PATH_MAX];
> +
> +	progname =3D basename(argv[0]);
> +#ifdef ENABLE_NLS
> +	setlocale(LC_ALL, "");
> +	bindtextdomain(PACKAGE, LOCALEDIR);
> +	textdomain(PACKAGE);
> +#endif
> +
> +	while ((c =3D getopt(argc, argv, "V")) !=3D EOF) {
> +		switch (c) {
> +		case 'V':
> +			printf(_("%s version %s\n"), progname, VERSION);
> +			exit(0);
> +		case '?':
> +		default:
> +			usage();
> +		}
> +	}
> +	if (argc - optind !=3D 1)
> +		usage();
> +
> +	fd =3D open(argv[optind], O_RDONLY);
> +	if (fd < 0) {
> +		perror(argv[optind]);
> +		return 1;
> +	}
> +
> +	if (find_datadev(argv[optind], datadev, mntpoint)) {
> +		perror("find_datadev");
> +		strncpy(datadev, argv[optind], PATH_MAX);
> +		strncpy(mntpoint, argv[optind], PATH_MAX);
> +	}
> +
> +	close(fd);
> +	fd =3D open(mntpoint, O_RDONLY);
> +	if (fd < 0) {
> +		perror(mntpoint);
> +		return 1;
> +	}
> +
> +	/* get the current filesystem size & geometry */
> +	if (ioctl(fd, EXT4_IOC_FSGEOMETRY, &geo) < 0) {
> +		fprintf(stderr, _(
> +			"%s: cannot determine geometry of filesystem"
> +			" mounted at %s: %s\n"),
> +			progname, argv[optind], strerror(errno));
> +		exit(1);
> +	}
> +
> +	attr_enabled =3D geo.efg_flags & EXT4_FSOP_GEOM_FLAGS_ATTR ? 1 : =
0;
> +	nlink_enabled =3D geo.efg_flags & EXT4_FSOP_GEOM_FLAGS_NLINK ? 1 =
: 0;
> +	quota_enabled =3D geo.efg_flags & EXT4_FSOP_GEOM_FLAGS_QUOTA ? 1 =
: 0;
> +	projquota_enabled =3D geo.efg_flags & EXT4_FSOP_GEOM_FLAGS_PROJQ =
? 1 : 0;
> +	metacrc_enabled =3D geo.efg_flags & =
EXT4_FSOP_GEOM_FLAGS_META_CSUM ? 1 : 0;
> +	ftype_enabled =3D geo.efg_flags & EXT4_FSOP_GEOM_FLAGS_FTYPE ? 1 =
: 0;
> +	is_64bit =3D geo.efg_flags & EXT4_FSOP_GEOM_FLAGS_64BIT ? 1 : 0;
> +	inlinedata_enabled =3D geo.efg_flags & =
EXT4_FSOP_GEOM_FLAGS_INLINEDATA ? 1 : 0;
> +	encrypt_enabled =3D geo.efg_flags & EXT4_FSOP_GEOM_FLAGS_ENCRYPT =
? 1 : 0;
> +	largedir_enabled =3D geo.efg_flags & =
EXT4_FSOP_GEOM_FLAGS_LARGEDIR ? 1 : 0;
> +	extents_enabled =3D geo.efg_flags & EXT4_FSOP_GEOM_FLAGS_EXTENTS =
? 1 : 0;
> +
> +	printf(_(
> +	    "meta-data=3D%-22s isize=3D%-6u bgcount=3D%u bgsize=3D%u =
blks\n"
> +	    "         =3D%-22s attr=3D%-7u quota=3D%u pquota=3D%u\n"
> +	    "         =3D%-22s crc=3D%-8u 64bit=3D%u inlinedata=3D%u =
extents=3D%u\n"
> +	    "         =3D%-22s flexbg=3D%u\n"
> +	    "data     =3D%-22s bsize=3D%-6u blocks=3D%llu =
bg_iblocks=3D%u\n"
> +	    "         =3D%-22s sunit=3D%-6u swidth=3D%u blks =
clustersize=3D%u\n"
> +	    "         =3D%-22s encrypt=3D%u\n"
> +	    "naming   =3D%-22s bsize=3D%-6u largedir=3D%d ftype=3D%d =
nlink=3D%u\n"
> +	    "log      =3D%-22s bsize=3D%-6u blocks=3D%u\n"),
> +		datadev, geo.efg_inodesize, geo.efg_bgcount, =
geo.efg_bgblocks,
> +		"", attr_enabled, quota_enabled, projquota_enabled,
> +		"", metacrc_enabled, is_64bit, inlinedata_enabled,
> +			extents_enabled,
> +		"", geo.efg_flexbgsize,
> +		"", geo.efg_blocksize, (unsigned long =
long)geo.efg_blockcount,
> +			geo.efg_bg_iblocks,
> +		"", geo.efg_sunit, geo.efg_swidth, geo.efg_clustersize,
> +		"", encrypt_enabled,
> +		"", geo.efg_blocksize, largedir_enabled, ftype_enabled,
> +			nlink_enabled,
> +		"", geo.efg_blocksize, geo.efg_logblocks);
> +
> +	exit(0);
> +}
>=20


Cheers, Andreas






--Apple-Mail=_5629B9FC-A145-4B85-A4FD-DD1FD6EEF7BD
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFYuHdapIg59Q01vtYRAi/xAJ0cDFEItsXWdd+rOSUOh36DVJX+7gCgkcpX
fxyAWpHUa6t68wlB8RWW83s=
=Jjlf
-----END PGP SIGNATURE-----

--Apple-Mail=_5629B9FC-A145-4B85-A4FD-DD1FD6EEF7BD--
