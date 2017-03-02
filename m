From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/3] e2info: create a tool to display ext4 fs geometry
 online
Date: Thu, 2 Mar 2017 13:50:18 -0800
Message-ID: <20170302215018.GH5266@birch.djwong.org>
References: <148843032650.21733.13980225191301375698.stgit@birch.djwong.org>
 <148843033922.21733.4922683685279348093.stgit@birch.djwong.org>
 <0AA96991-8F69-4004-BAC8-8C1DBB8368E0@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1050.oracle.com ([141.146.126.70]:16922 "EHLO
        aserp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750941AbdCBXPg (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 2 Mar 2017 18:15:36 -0500
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69])
        by aserp1050.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v22LpTEX000502
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-ext4@vger.kernel.org>; Thu, 2 Mar 2017 21:51:29 GMT
Content-Disposition: inline
In-Reply-To: <0AA96991-8F69-4004-BAC8-8C1DBB8368E0@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Mar 02, 2017 at 12:49:46PM -0700, Andreas Dilger wrote:
> On Mar 1, 2017, at 9:52 PM, Darrick J. Wong <darrick.wong@oracle.com> wrote:
> > 
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Create e2info, which reports the fs geometry of an online ext4 filesystem.
> 
> Besides providing a place to call the new EXT4_IOC_FSGEOMETRY ioctl, I
> don't see how this is much different from "dumpe2fs -h"?

Eh, screw it, I'm walking away from this whole FSGEOMETRY ioctl patchset.
Too much uphill friction, insufficient motivation...

--D

> 
> Cheers, Andreas
> 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> > configure            |    4 +
> > configure.ac         |    3 +
> > lib/ext2fs/ext2_fs.h |   34 ++++++++
> > misc/Makefile.in     |   30 ++++++-
> > misc/e2info.8.in     |   64 ++++++++++++++++
> > misc/e2info.c        |  205 ++++++++++++++++++++++++++++++++++++++++++++++++++
> > 6 files changed, 336 insertions(+), 4 deletions(-)
> > create mode 100644 misc/e2info.8.in
> > create mode 100644 misc/e2info.c
> > 
> > 
> > diff --git a/configure b/configure
> > index 5f7b429..b553da1 100755
> > --- a/configure
> > +++ b/configure
> > @@ -642,6 +642,7 @@ root_prefix
> > UNIX_CMT
> > CYGWIN_CMT
> > LINUX_CMT
> > +E2INFO_CMT
> > UNI_DIFF_OPTS
> > SEM_INIT_LIB
> > FUSE_CMT
> > @@ -13663,13 +13664,16 @@ fi
> > { $as_echo "$as_me:${as_lineno-$LINENO}: result: $UNI_DIFF_OPTS" >&5
> > $as_echo "$UNI_DIFF_OPTS" >&6; }
> > 
> > +E2INFO_CMT="#"
> > case "$host_os" in
> > linux*)
> > 
> > $as_echo "#define HAVE_EXT2_IOCTLS 1" >>confdefs.h
> > 
> > +	E2INFO_CMT=
> > 	;;
> > esac
> > +
> > LINUX_CMT="#"
> > CYGWIN_CMT="#"
> > UNIX_CMT=
> > diff --git a/configure.ac b/configure.ac
> > index 9da7b86..bf613fd 100644
> > --- a/configure.ac
> > +++ b/configure.ac
> > @@ -1260,11 +1260,14 @@ AC_SUBST(UNI_DIFF_OPTS)
> > dnl
> > dnl We use the EXT2 ioctls only under Linux
> > dnl
> > +E2INFO_CMT="#"
> > case "$host_os" in
> > linux*)
> > 	AC_DEFINE(HAVE_EXT2_IOCTLS, 1, [Define to 1 if Ext2 ioctls present])
> > +	E2INFO_CMT=
> > 	;;
> > esac
> > +AC_SUBST(E2INFO_CMT)
> > dnl
> > dnl OS-specific uncomment control
> > dnl
> > diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
> > index 27a7d3a..bad7648 100644
> > --- a/lib/ext2fs/ext2_fs.h
> > +++ b/lib/ext2fs/ext2_fs.h
> > @@ -372,6 +372,40 @@ struct ext4_new_group_input {
> > #define EXT4_IOC_GROUP_ADD		_IOW('f', 8,struct ext4_new_group_input)
> > #define EXT4_IOC_RESIZE_FS		_IOW('f', 16, __u64)
> > 
> > +/* ext4 fs geometry. */
> > +struct ext4_fsop_geom {
> > +	__u32		efg_blocksize;	/* filesystem (data) block size */
> > +	__u32		efg_bgblocks;	/* fsblocks in an AG		*/
> > +	__u32		efg_bgcount;	/* number of allocation groups	*/
> > +	__u32		efg_logblocks;	/* fsblocks in the log		*/
> > +	__u32		efg_resvblocks;	/* number of reserved blocks	*/
> > +	__u32		efg_inodesize;	/* inode size in bytes		*/
> > +	__u32		efg_bg_iblocks;	/* inode blocks per AG		*/
> > +	__u32		efg_flags;	/* superblock version flags	*/
> > +	__u64		efg_inodecount;	/* inode count			*/
> > +	__u64		efg_blockcount;	/* fsblocks in filesystem	*/
> > +	unsigned char	efg_uuid[16];	/* unique id of the filesystem	*/
> > +	__u32		efg_sunit;	/* stripe unit, fsblocks	*/
> > +	__u32		efg_swidth;	/* stripe width, fsblocks	*/
> > +	__u32		efg_clustersize;/* fs cluster size		*/
> > +	__u32		efg_flexbgsize;	/* number of bg's in a flexbg	*/
> > +	__u64		efg_resv[6];
> > +};
> > +
> > +#define EXT4_FSOP_GEOM_FLAGS_ATTR	0x00001	/* extended attr in use	 */
> > +#define EXT4_FSOP_GEOM_FLAGS_NLINK	0x00002	/* 32-bit nlink values	 */
> > +#define EXT4_FSOP_GEOM_FLAGS_QUOTA	0x00004	/* quotas enabled	 */
> > +#define EXT4_FSOP_GEOM_FLAGS_PROJQ	0x00008	/* project quotas	 */
> > +#define EXT4_FSOP_GEOM_FLAGS_META_CSUM	0x00010	/* metadata checksums	 */
> > +#define EXT4_FSOP_GEOM_FLAGS_FTYPE	0x00020	/* inode directory types */
> > +#define EXT4_FSOP_GEOM_FLAGS_64BIT	0x00040	/* 64-bit support	 */
> > +#define EXT4_FSOP_GEOM_FLAGS_INLINEDATA	0x00080	/* inline data		 */
> > +#define EXT4_FSOP_GEOM_FLAGS_ENCRYPT	0x00100	/* encrypted files	 */
> > +#define EXT4_FSOP_GEOM_FLAGS_LARGEDIR	0x00200	/* large directories	 */
> > +#define EXT4_FSOP_GEOM_FLAGS_EXTENTS	0x00400	/* extents		 */
> > +
> > +#define EXT4_IOC_FSGEOMETRY		_IOR ('f', 19, struct ext4_fsop_geom)
> > +
> > /*
> >  * Structure of an inode on the disk
> >  */
> > diff --git a/misc/Makefile.in b/misc/Makefile.in
> > index 467c15d..311aa57 100644
> > --- a/misc/Makefile.in
> > +++ b/misc/Makefile.in
> > @@ -32,14 +32,19 @@ INSTALL = @INSTALL@
> > 
> > @FUSE_CMT@FUSE_PROG= fuse2fs
> > 
> > +@E2INFO_CMT@E2INFO_PROG= e2info
> > +@E2INFO_CMT@E2INFO_MAN= e2info.8
> > +
> > SPROGS=		mke2fs badblocks tune2fs dumpe2fs $(BLKID_PROG) logsave \
> > 			$(E2IMAGE_PROG) @FSCK_PROG@ e2undo
> > USPROGS=	mklost+found filefrag e2freefrag $(UUIDD_PROG) \
> > -			$(E4DEFRAG_PROG) $(E4CRYPT_PROG) $(FUSE_PROG)
> > +			$(E4DEFRAG_PROG) $(E4CRYPT_PROG) $(FUSE_PROG) \
> > +			$(E2INFO_PROG)
> > SMANPAGES=	tune2fs.8 mklost+found.8 mke2fs.8 dumpe2fs.8 badblocks.8 \
> > 			e2label.8 $(FINDFS_MAN) $(BLKID_MAN) $(E2IMAGE_MAN) \
> > 			logsave.8 filefrag.8 e2freefrag.8 e2undo.8 \
> > -			$(UUIDD_MAN) $(E4DEFRAG_MAN) $(E4CRYPT_MAN) @FSCK_MAN@
> > +			$(UUIDD_MAN) $(E4DEFRAG_MAN) $(E4CRYPT_MAN) @FSCK_MAN@ \
> > +			$(E2INFO_MAN)
> > FMANPAGES=	mke2fs.conf.5 ext4.5
> > 
> > UPROGS=		chattr lsattr @UUID_CMT@ uuidgen
> > @@ -68,6 +73,7 @@ E4CRYPT_OBJS=   e4crypt.o
> > E2FREEFRAG_OBJS= e2freefrag.o
> > E2FUZZ_OBJS=	e2fuzz.o
> > FUSE2FS_OBJS=	fuse2fs.o journal.o recovery.o revoke.o
> > +E2INFO_OBJS=	e2info.o
> > 
> > PROFILED_TUNE2FS_OBJS=	profiled/tune2fs.o profiled/util.o
> > PROFILED_MKLPF_OBJS=	profiled/mklost+found.o
> > @@ -90,8 +96,9 @@ PROFILED_E2FREEFRAG_OBJS= profiled/e2freefrag.o
> > PROFILED_E2UNDO_OBJS=	profiled/e2undo.o
> > PROFILED_E4DEFRAG_OBJS=	profiled/e4defrag.o
> > PROFILED_E4CRYPT_OBJS=	profiled/e4crypt.o
> > -PROFILED_FUSE2FS_OJBS=	profiled/fuse2fs.o profiled/journal.o \
> > +PROFILED_FUSE2FS_OBJS=	profiled/fuse2fs.o profiled/journal.o \
> > 			profiled/recovery.o profiled/revoke.o
> > +PROFILED_E2INFO_OBJS=	profiled/e2info.o
> > 
> > SRCS=	$(srcdir)/tune2fs.c $(srcdir)/mklost+found.c $(srcdir)/mke2fs.c $(srcdir)/mk_hugefiles.c \
> > 		$(srcdir)/chattr.c $(srcdir)/lsattr.c $(srcdir)/dumpe2fs.c \
> > @@ -102,7 +109,7 @@ SRCS=	$(srcdir)/tune2fs.c $(srcdir)/mklost+found.c $(srcdir)/mke2fs.c $(srcdir)/
> > 		$(srcdir)/e2freefrag.c $(srcdir)/create_inode.c \
> > 		$(srcdir)/fuse2fs.c \
> > 		$(srcdir)/../debugfs/journal.c $(srcdir)/../e2fsck/revoke.c \
> > -		$(srcdir)/../e2fsck/recovery.c
> > +		$(srcdir)/../e2fsck/recovery.c $(srcdir)/e2info.c
> > 
> > LIBS= $(LIBEXT2FS) $(LIBCOM_ERR) $(LIBSUPPORT)
> > DEPLIBS= $(LIBEXT2FS) $(DEPLIBCOM_ERR) $(DEPLIBSUPPORT)
> > @@ -391,6 +398,11 @@ fuse2fs: $(FUSE2FS_OBJS) $(DEPLIBS) $(DEPLIBBLKID) $(DEPLIBUUID) \
> > 		$(LIBFUSE) $(LIBBLKID) $(LIBUUID) $(LIBEXT2FS) $(LIBINTL) \
> > 		$(CLOCK_GETTIME_LIB) $(SYSLIBS)
> > 
> > +e2info: $(E2INFO_OBJS) $(DEPLIBS)
> > +	$(E) "	LD $@"
> > +	$(Q) $(CC) $(ALL_LDFLAGS) -o e2info $(E2INFO_OBJS) $(LIBINTL) \
> > +		$(SYSLIBS)
> > +
> > journal.o: $(srcdir)/../debugfs/journal.c
> > 	$(E) "	CC $@"
> > 	$(Q) $(CC) -c $(JOURNAL_CFLAGS) -I$(srcdir) \
> > @@ -411,6 +423,10 @@ tst_ismounted: $(srcdir)/ismounted.c $(STATIC_LIBEXT2FS) $(DEPLIBCOM_ERR)
> > 	$(CC) -o tst_ismounted $(srcdir)/ismounted.c -DDEBUG $(ALL_CFLAGS) \
> > 		$(LIBCOM_ERR) $(SYSLIBS)
> > 
> > +e2info.8: $(DEP_SUBSTITUTE) $(srcdir)/e2info.8.in
> > +	$(E) "	SUBST $@"
> > +	$(Q) $(SUBSTITUTE_UPTIME) $(srcdir)/e2info.8.in e2info.8
> > +
> > tune2fs.8: $(DEP_SUBSTITUTE) $(srcdir)/tune2fs.8.in
> > 	$(E) "	SUBST $@"
> > 	$(Q) $(SUBSTITUTE_UPTIME) $(srcdir)/tune2fs.8.in tune2fs.8
> > @@ -844,3 +860,9 @@ recovery.o: $(srcdir)/../e2fsck/recovery.c $(srcdir)/../e2fsck/jfs_user.h \
> >  $(top_srcdir)/lib/support/quotaio_tree.h \
> >  $(top_srcdir)/lib/ext2fs/kernel-jbd.h $(top_srcdir)/lib/ext2fs/jfs_compat.h \
> >  $(top_srcdir)/lib/ext2fs/kernel-list.h
> > +e2info.o: $(srcdir)/e2info.c $(top_builddir)/lib/config.h \
> > + $(top_builddir)/lib/dirpaths.h $(top_srcdir)/lib/ext2fs/ext2fs.h \
> > + $(top_builddir)/lib/ext2fs/ext2_types.h $(top_srcdir)/lib/ext2fs/ext2_fs.h \
> > + $(top_srcdir)/lib/ext2fs/ext3_extents.h $(top_srcdir)/lib/et/com_err.h \
> > + $(top_srcdir)/lib/ext2fs/ext2_io.h $(top_builddir)/lib/ext2fs/ext2_err.h \
> > + $(top_srcdir)/lib/ext2fs/ext2_ext_attr.h $(top_srcdir)/lib/ext2fs/bitops.h
> > diff --git a/misc/e2info.8.in b/misc/e2info.8.in
> > new file mode 100644
> > index 0000000..c7f580f
> > --- /dev/null
> > +++ b/misc/e2info.8.in
> > @@ -0,0 +1,64 @@
> > +.\" -*- nroff -*-
> > +.\" Copyright 2017 Oracle Inc.  All Rights Reserved.
> > +.\" This file may be copied under the terms of the GNU Public License.
> > +.\"
> > +.\" Verbatim blocks taken from openssl req manpage content
> > +.de Vb \" Begin verbatim text
> > +.ft CW
> > +.nf
> > +.ne \\$1
> > +..
> > +.de Ve \" End verbatim text
> > +.ft R
> > +.fi
> > +..
> > +
> > +.TH E2INFO 8 "@E2FSPROGS_MONTH@ @E2FSPROGS_YEAR@" "E2fsprogs version @E2FSPROGS_VERSION@"
> > +.SH NAME
> > +e2info \- Display information about a mounted ext4 filesystem
> > +.SH SYNOPSIS
> > +.B e2info
> > +.I mount-point
> > +.br
> > +.B e2info \-V
> > +.SH DESCRIPTION
> > +Prints the filesystem geometry of an ext4 filesystem.  If the mounted
> > +filesystem is an ext2 or ext3 filesystem mounted with the ext4 driver,
> > +the geometry will be displayed.
> > +.SH "EXAMPLES"
> > +
> > +Understanding e2info output.
> > +.PP
> > +Suppose one has the following "e2info /dev/sda" output:
> > +.PP
> > +.RS 2
> > +.Vb
> > +\&meta-data=/dev/loop0             isize=256    bgcount=14808 bgsize=32768 blks
> > +\&         =                       attr=1       quota=0 pquota=0
> > +\&         =                       crc=0        64bit=0 inlinedata=0 extents=1
> > +\&         =                       flexbg=16
> > +\&data     =                       bsize=4096   blocks=485198848 bg_iblocks=512
> > +\&         =                       sunit=32     swidth=128 blks clustersize=0
> > +\&         =                       encrypt=0
> > +\&naming   =                       bsize=4096   largedir=0 ftype=1 nlink=1
> > +\&log      =                       bsize=4096   blocks=32768
> > +.Ve
> > +.RE
> > +.PP
> > +
> > +Here, the data section of the output indicates "bsize=4096",
> > +meaning the data block size for this filesystem is 4096 bytes.
> > +This section also shows "sunit=32 swidth=128 blks", which means
> > +the stripe unit is 32*4096 bytes = 128 kibibytes and the stripe
> > +width is 128*4096 bytes = 512 kibibytes.
> > +A single stripe of this filesystem therefore consists
> > +of four stripe units (128 blocks / 32 blocks per unit).
> > +Note also that "flexbg=16", which means that this filesystem has
> > +512MB flex block groups.
> > +That is the upper limit of how much physical disk space can be mapped
> > +into a file.
> > +.SH SEE ALSO
> > +.BR mkfs.ext4 (8),
> > +.BR md (4),
> > +.BR lvm (8),
> > +.BR mount (8).
> > diff --git a/misc/e2info.c b/misc/e2info.c
> > new file mode 100644
> > index 0000000..675f005
> > --- /dev/null
> > +++ b/misc/e2info.c
> > @@ -0,0 +1,205 @@
> > +/*
> > + * Copyright (c) 2017 Oracle.
> > + * All Rights Reserved.
> > + *
> > + * This program is free software; you can redistribute it and/or
> > + * modify it under the terms of the GNU General Public License as
> > + * published by the Free Software Foundation.
> > + *
> > + * This program is distributed in the hope that it would be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + *
> > + * You should have received a copy of the GNU General Public License
> > + * along with this program; if not, write the Free Software Foundation,
> > + * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> > + */
> > +#include "config.h"
> > +#include <stdio.h>
> > +#include <stdlib.h>
> > +#include <string.h>
> > +#include <libgen.h>
> > +#include <unistd.h>
> > +#include <sys/ioctl.h>
> > +#include <sys/types.h>
> > +#include <sys/stat.h>
> > +#include <fcntl.h>
> > +#include <errno.h>
> > +#include <mntent.h>
> > +#include <limits.h>
> > +
> > +#include "ext2fs/ext2_fs.h"
> > +
> > +#include "../version.h"
> > +#include "support/nls-enable.h"
> > +
> > +static const char *progname = "e2info";
> > +
> > +static void
> > +usage(void)
> > +{
> > +	fprintf(stderr, _(
> > +"Usage: %s [options] mountpoint\n\n\
> > +	-V          print version information\n"),
> > +		progname);
> > +	exit(2);
> > +}
> > +
> > +#define PROC_MOUNTS	"/proc/mounts"
> > +int
> > +find_datadev(
> > +	const char	*arg,
> > +	char		*datadev,
> > +	char		*mntpoint)
> > +{
> > +	struct mntent	*mnt;
> > +	FILE		*mtp;
> > +	char		*mtab_file;
> > +	char		rmnt_fsname[PATH_MAX], rmnt_dir[PATH_MAX];
> > +	struct stat	sbuf;
> > +	dev_t		fd_dev;
> > +
> > +	if (stat(arg, &sbuf) < 0)
> > +		return errno;
> > +	/*
> > +	 * We want to match st_rdev if the path provided is a device
> > +	 * special file.  Otherwise we are looking for the the
> > +	 * device id for the containing filesystem, in st_dev.
> > +	 */
> > +	if (S_ISBLK(sbuf.st_mode) || S_ISCHR(sbuf.st_mode))
> > +		fd_dev = sbuf.st_rdev;
> > +	else
> > +		fd_dev = sbuf.st_dev;
> > +
> > +	mtab_file = PROC_MOUNTS;
> > +	if (access(mtab_file, R_OK) != 0)
> > +		mtab_file = MOUNTED;
> > +
> > +	if ((mtp = setmntent(mtab_file, "r")) == NULL)
> > +		return ENOENT;
> > +
> > +	while ((mnt = getmntent(mtp)) != NULL) {
> > +		if (!realpath(mnt->mnt_dir, rmnt_dir))
> > +			continue;
> > +		if (!realpath(mnt->mnt_fsname, rmnt_fsname))
> > +			continue;
> > +
> > +		if (stat(rmnt_fsname, &sbuf) < 0)
> > +			continue;
> > +		if (sbuf.st_rdev == fd_dev) {
> > +			strncpy(datadev, rmnt_fsname, PATH_MAX);
> > +			strncpy(mntpoint, rmnt_dir, PATH_MAX);
> > +			break;
> > +		}
> > +	}
> > +	endmntent(mtp);
> > +	return 0;
> > +}
> > +
> > +int
> > +main(int argc, char **argv)
> > +{
> > +	struct ext4_fsop_geom	geo;
> > +	char			*progname;
> > +	int			fd;
> > +	int			c;
> > +	int			attr_enabled;
> > +	int			nlink_enabled;
> > +	int			quota_enabled;
> > +	int			projquota_enabled;
> > +	int			metacrc_enabled;
> > +	int			ftype_enabled;
> > +	int			is_64bit;
> > +	int			inlinedata_enabled;
> > +	int			encrypt_enabled;
> > +	int			largedir_enabled;
> > +	int			extents_enabled;
> > +	char			datadev[PATH_MAX];
> > +	char			mntpoint[PATH_MAX];
> > +
> > +	progname = basename(argv[0]);
> > +#ifdef ENABLE_NLS
> > +	setlocale(LC_ALL, "");
> > +	bindtextdomain(PACKAGE, LOCALEDIR);
> > +	textdomain(PACKAGE);
> > +#endif
> > +
> > +	while ((c = getopt(argc, argv, "V")) != EOF) {
> > +		switch (c) {
> > +		case 'V':
> > +			printf(_("%s version %s\n"), progname, VERSION);
> > +			exit(0);
> > +		case '?':
> > +		default:
> > +			usage();
> > +		}
> > +	}
> > +	if (argc - optind != 1)
> > +		usage();
> > +
> > +	fd = open(argv[optind], O_RDONLY);
> > +	if (fd < 0) {
> > +		perror(argv[optind]);
> > +		return 1;
> > +	}
> > +
> > +	if (find_datadev(argv[optind], datadev, mntpoint)) {
> > +		perror("find_datadev");
> > +		strncpy(datadev, argv[optind], PATH_MAX);
> > +		strncpy(mntpoint, argv[optind], PATH_MAX);
> > +	}
> > +
> > +	close(fd);
> > +	fd = open(mntpoint, O_RDONLY);
> > +	if (fd < 0) {
> > +		perror(mntpoint);
> > +		return 1;
> > +	}
> > +
> > +	/* get the current filesystem size & geometry */
> > +	if (ioctl(fd, EXT4_IOC_FSGEOMETRY, &geo) < 0) {
> > +		fprintf(stderr, _(
> > +			"%s: cannot determine geometry of filesystem"
> > +			" mounted at %s: %s\n"),
> > +			progname, argv[optind], strerror(errno));
> > +		exit(1);
> > +	}
> > +
> > +	attr_enabled = geo.efg_flags & EXT4_FSOP_GEOM_FLAGS_ATTR ? 1 : 0;
> > +	nlink_enabled = geo.efg_flags & EXT4_FSOP_GEOM_FLAGS_NLINK ? 1 : 0;
> > +	quota_enabled = geo.efg_flags & EXT4_FSOP_GEOM_FLAGS_QUOTA ? 1 : 0;
> > +	projquota_enabled = geo.efg_flags & EXT4_FSOP_GEOM_FLAGS_PROJQ ? 1 : 0;
> > +	metacrc_enabled = geo.efg_flags & EXT4_FSOP_GEOM_FLAGS_META_CSUM ? 1 : 0;
> > +	ftype_enabled = geo.efg_flags & EXT4_FSOP_GEOM_FLAGS_FTYPE ? 1 : 0;
> > +	is_64bit = geo.efg_flags & EXT4_FSOP_GEOM_FLAGS_64BIT ? 1 : 0;
> > +	inlinedata_enabled = geo.efg_flags & EXT4_FSOP_GEOM_FLAGS_INLINEDATA ? 1 : 0;
> > +	encrypt_enabled = geo.efg_flags & EXT4_FSOP_GEOM_FLAGS_ENCRYPT ? 1 : 0;
> > +	largedir_enabled = geo.efg_flags & EXT4_FSOP_GEOM_FLAGS_LARGEDIR ? 1 : 0;
> > +	extents_enabled = geo.efg_flags & EXT4_FSOP_GEOM_FLAGS_EXTENTS ? 1 : 0;
> > +
> > +	printf(_(
> > +	    "meta-data=%-22s isize=%-6u bgcount=%u bgsize=%u blks\n"
> > +	    "         =%-22s attr=%-7u quota=%u pquota=%u\n"
> > +	    "         =%-22s crc=%-8u 64bit=%u inlinedata=%u extents=%u\n"
> > +	    "         =%-22s flexbg=%u\n"
> > +	    "data     =%-22s bsize=%-6u blocks=%llu bg_iblocks=%u\n"
> > +	    "         =%-22s sunit=%-6u swidth=%u blks clustersize=%u\n"
> > +	    "         =%-22s encrypt=%u\n"
> > +	    "naming   =%-22s bsize=%-6u largedir=%d ftype=%d nlink=%u\n"
> > +	    "log      =%-22s bsize=%-6u blocks=%u\n"),
> > +		datadev, geo.efg_inodesize, geo.efg_bgcount, geo.efg_bgblocks,
> > +		"", attr_enabled, quota_enabled, projquota_enabled,
> > +		"", metacrc_enabled, is_64bit, inlinedata_enabled,
> > +			extents_enabled,
> > +		"", geo.efg_flexbgsize,
> > +		"", geo.efg_blocksize, (unsigned long long)geo.efg_blockcount,
> > +			geo.efg_bg_iblocks,
> > +		"", geo.efg_sunit, geo.efg_swidth, geo.efg_clustersize,
> > +		"", encrypt_enabled,
> > +		"", geo.efg_blocksize, largedir_enabled, ftype_enabled,
> > +			nlink_enabled,
> > +		"", geo.efg_blocksize, geo.efg_logblocks);
> > +
> > +	exit(0);
> > +}
> > 
> 
> 
> Cheers, Andreas
> 
> 
> 
> 
> 
