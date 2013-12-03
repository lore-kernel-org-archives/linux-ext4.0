From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: Patch of adding utility to check the status of MMP
Date: Tue, 3 Dec 2013 12:39:24 -0800
Message-ID: <20131203203924.GD9541@birch.djwong.org>
References: <CAPTn0cBpAptAc_jE=E71nxY4mvHwxh1GtDaBk4i0pWvW99+_cQ@mail.gmail.com>
 <CAPTn0cDwGHcA7v2WtKFFEPcYh=uHpBu50YL31XAdEXCe1oLh7g@mail.gmail.com>
 <20131113205911.GC10269@birch.djwong.org>
 <CAPTn0cBe03jMxnBnBdmA1UJDnTTL1sJyZ+c91qCHv6_vaVvYdw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Shuichi Ihara <sihara@ddn.com>
To: Li Xi <pkuelelixi@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:30358 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754988Ab3LCUjc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 Dec 2013 15:39:32 -0500
Content-Disposition: inline
In-Reply-To: <CAPTn0cBe03jMxnBnBdmA1UJDnTTL1sJyZ+c91qCHv6_vaVvYdw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Nov 28, 2013 at 09:37:33AM +0800, Li Xi wrote:
> Thanks a lot for your review and feedback! I've updated the patch
> which fixes the defects that you pointed out. Would you please have a
> lot at it again?
> 
> Thanks,
> Li Xi

This needs a changelog.  The introductory message you sent with the v1 patch
would be a good basis for that.

Also, when you produce multiple drafts of a patch, it helps us reviewers a lot
to state what changed in that particular revision, e.g.

"v2: Fix spelling errors, clean up ext2fs_foo() flag handling."

> Signed-off-by: Li Xi <lixi@ddn.com>
> ---
> Index: e2fsprogs.git/e2fsprogs.spec.in
> ===================================================================
> --- e2fsprogs.git.orig/e2fsprogs.spec.in
> +++ e2fsprogs.git/e2fsprogs.spec.in
> @@ -132,6 +132,7 @@ exit 0
>  %{_root_sbindir}/mkfs.ext4dev
>  %{_root_sbindir}/resize2fs
>  %{_root_sbindir}/tune2fs
> +%{_root_sbindir}/mmpstatus
>  %{_sbindir}/filefrag
>  %{_sbindir}/mklost+found
>  %{_sbindir}/e2freefrag
> @@ -180,6 +181,7 @@ exit 0
>  %{_mandir}/man8/tune2fs.8*
>  %{_mandir}/man8/filefrag.8*
>  %{_mandir}/man8/e2freefrag.8*
> +%{_mandir}/man8/mmpstatus.8*
> 
>  %files devel
>  %defattr(-,root,root)
> Index: e2fsprogs.git/misc/mmpstatus.8.in
> ===================================================================
> --- /dev/null
> +++ e2fsprogs.git/misc/mmpstatus.8.in
> @@ -0,0 +1,58 @@
> +.\" -*- nroff -*-
> +.\" This file may be copied under the terms of the GNU Public License.
> +.\"
> +.TH MMPSTATUS 8 "@E2FSPROGS_MONTH@ @E2FSPROGS_YEAR@" "E2fsprogs
> version @E2FSPROGS_VERSION@"
> +.SH NAME
> +mmpstatus \- Check MMP status of an ext4 file system
> +.SH SYNOPSIS
> +.B mmpstatus
> +[
> +.B \-c | \--check
> +]
> +[
> +.B \-n | \--nodename
> +]
> +.I [filesys]
> +.SH DESCRIPTION
> +.B mmpstatus
> +is used to check MMP status of an ext4 file system.
> +.I filesys
> +can be a device name (e.g.
> +.IR /dev/hdc1 ", " /dev/sdb2 ),
> +or an ext4 label or UUID specifier (e.g.
> +UUID=8868abf6-88c5-4a83-98b8-bfc24057f7bd or LABEL=root).
> +The
> +.B mmpstatus
> +program checks whether it is safe to mount the file system without taking
> +the risk of mounting it more than once.
> +.PP
> +MMP (multiple-mount protection) is a feature which protects
> +the file system from being mounted simultaneously to more than one node.
> +It is NOT safe to mount a file system when one of the following condition
> +is true:

"either of the following conditions is true" 

s/one/either/ and s/condition/conditions/

(iirc it's never possible to have both #1 and #2 at the same time, which
'either' implies)

> +.br
> +\    1. The MMP shows that fsck is running on the file system.
> +.br
> +\    2. The MMP are being updated by some node.
> +.br
> +The
> +.B mmpstatus
> +program might wait for some time to see whether MMP is updated by any node
> +during this period.
> +.PP
> +Normaly, the exit code returned by

"Normally"

Hey wait, I complained about this /last/ time!

> +.B mmpstatus
> +is 0 when it is safe to mount the filesystem, 1 when it is NOT safe to mount
> +the filesystem, and -1 on failure. When
> +.B \-i
> +flag is specified, the exit code
> +is 0 on success, -1 on failure.
> +.SH OPTIONS
> +.TP
> +.B \-i,
> +Display the MMP field values rather than check them.
> +.SH SEE ALSO
> +.BR debugfs (8),
> +.BR dumpe2fs (8),
> +.BR tune2fs (8),
> +.BR fsck (8)
> Index: e2fsprogs.git/misc/Makefile.in
> ===================================================================
> --- e2fsprogs.git.orig/misc/Makefile.in
> +++ e2fsprogs.git/misc/Makefile.in
> @@ -27,12 +27,12 @@ INSTALL = @INSTALL@
>  @BLKID_CMT@FINDFS_MAN= findfs.8
> 
>  SPROGS=        mke2fs badblocks tune2fs dumpe2fs $(BLKID_PROG) logsave \
> -            $(E2IMAGE_PROG) @FSCK_PROG@ e2undo
> +            $(E2IMAGE_PROG) @FSCK_PROG@ @MMPSTATUS_PROG@ e2undo
>  USPROGS=    mklost+found filefrag e2freefrag $(UUIDD_PROG) $(E4DEFRAG_PROG)
>  SMANPAGES=    tune2fs.8 mklost+found.8 mke2fs.8 dumpe2fs.8 badblocks.8 \
>              e2label.8 $(FINDFS_MAN) $(BLKID_MAN) $(E2IMAGE_MAN) \
>              logsave.8 filefrag.8 e2freefrag.8 e2undo.8 \
> -            $(UUIDD_MAN) $(E4DEFRAG_MAN) @FSCK_MAN@
> +            $(UUIDD_MAN) $(E4DEFRAG_MAN) @FSCK_MAN@ @MMPSTATUS_MAN@
>  FMANPAGES=    mke2fs.conf.5
> 
>  UPROGS=        chattr lsattr @UUID_CMT@ uuidgen
> @@ -51,6 +51,7 @@ DUMPE2FS_OBJS=    dumpe2fs.o
>  BADBLOCKS_OBJS=    badblocks.o
>  E2IMAGE_OBJS=    e2image.o
>  FSCK_OBJS=    fsck.o base_device.o ismounted.o
> +MMPSTATUS_OBJS=    mmpstatus.o
>  BLKID_OBJS=    blkid.o
>  FILEFRAG_OBJS=    filefrag.o
>  E2UNDO_OBJS=  e2undo.o
> @@ -70,6 +71,7 @@ PROFILED_BADBLOCKS_OBJS=    profiled/badblo
>  PROFILED_E2IMAGE_OBJS=    profiled/e2image.o
>  PROFILED_FSCK_OBJS=    profiled/fsck.o profiled/base_device.o \
>              profiled/ismounted.o
> +PROFILED_MMPSTATUS_OBJS=profiled/mmpstatus.o
>  PROFILED_BLKID_OBJS=    profiled/blkid.o
>  PROFILED_FILEFRAG_OBJS=    profiled/filefrag.o
>  PROFILED_E2FREEFRAG_OBJS= profiled/e2freefrag.o
> @@ -82,7 +84,8 @@ SRCS=    $(srcdir)/tune2fs.c $(srcdir)/mklo
>          $(srcdir)/uuidgen.c $(srcdir)/blkid.c $(srcdir)/logsave.c \
>          $(srcdir)/filefrag.c $(srcdir)/base_device.c \
>          $(srcdir)/ismounted.c $(srcdir)/../e2fsck/profile.c \
> -        $(srcdir)/e2undo.c $(srcdir)/e2freefrag.c
> +        $(srcdir)/e2undo.c $(srcdir)/e2freefrag.c \
> +        $(srcdir)/mmpstatus.c
> 
>  LIBS= $(LIBEXT2FS) $(LIBCOM_ERR)
>  DEPLIBS= $(LIBEXT2FS) $(DEPLIBCOM_ERR)
> @@ -300,6 +303,16 @@ fsck.profiled: $(FSCK_OBJS) $(PROFILED_D
>      $(Q) $(CC) $(ALL_LDFLAGS) -g -pg -o fsck.profiled $(PROFILED_FSCK_OBJS) \
>          $(PROFILED_LIBBLKID) $(LIBINTL)
> 
> +mmpstatus: $(MMPSTATUS_OBJS) $(DEPLIBBLKID)
> +    $(E) "    LD $@"
> +    $(Q) $(CC) $(ALL_LDFLAGS) -o mmpstatus $(MMPSTATUS_OBJS) $(LIBBLKID) \
> +        $(LIBINTL) $(LIBS)
> +
> +mmpstatus.profiled: $(MMPSTATUS_OBJS) $(PROFILED_DEPLIBBLKID)
> +    $(E) "    LD $@"
> +    $(Q) $(CC) $(ALL_LDFLAGS) -g -pg -o mmpstatus.profiled \
> +        $(PROFILED_MMPSTATUS_OBJS) $(PROFILED_LIBBLKID) $(LIBINTL)
> +
>  badblocks: $(BADBLOCKS_OBJS) $(DEPLIBS)
>      $(E) "    LD $@"
>      $(Q) $(CC) $(ALL_LDFLAGS) -o badblocks $(BADBLOCKS_OBJS) $(LIBS) $(LIBINTL)
> @@ -384,6 +397,10 @@ badblocks.8: $(DEP_SUBSTITUTE) $(srcdir)
>      $(E) "    SUBST $@"
>      $(Q) $(SUBSTITUTE_UPTIME) $(srcdir)/badblocks.8.in badblocks.8
> 
> +mmpstatus.8: $(DEP_SUBSTITUTE) $(srcdir)/mmpstatus.8.in
> +    $(E) "    SUBST $@"
> +    $(Q) $(SUBSTITUTE_UPTIME) $(srcdir)/mmpstatus.8.in mmpstatus.8
> +
>  fsck.8: $(DEP_SUBSTITUTE) $(srcdir)/fsck.8.in
>      $(E) "    SUBST $@"
>      $(Q) $(SUBSTITUTE_UPTIME) $(srcdir)/fsck.8.in fsck.8
> @@ -575,7 +592,8 @@ clean:
>          e2undo.profiled mke2fs.profiled dumpe2fs.profiled \
>          logsave.profiled filefrag.profiled uuidgen.profiled \
>          uuidd.profiled e2image.profiled mke2fs.conf \
> -        profiled/*.o \#* *.s *.o *.a *~ core gmon.out
> +        mmpstatus.profiled profiled/*.o \#* *.s *.o *.a *~ core \
> +        gmon.out
> 
>  mostlyclean: clean
>  distclean: clean
> @@ -644,6 +662,9 @@ badblocks.o: $(srcdir)/badblocks.c $(top
>  fsck.o: $(srcdir)/fsck.c $(top_builddir)/lib/config.h \
>   $(top_builddir)/lib/dirpaths.h $(top_srcdir)/version.h \
>   $(srcdir)/nls-enable.h $(srcdir)/fsck.h
> +mmpstatus.o: $(srcdir)/mmpstatus.c $(top_builddir)/lib/config.h \
> + $(top_builddir)/lib/dirpaths.h $(top_srcdir)/version.h \
> + $(srcdir)/nls-enable.h $(top_srcdir)/lib/ext2fs/ext2fs.h
>  util.o: $(srcdir)/util.c $(top_builddir)/lib/config.h \
>   $(top_builddir)/lib/dirpaths.h $(top_srcdir)/lib/et/com_err.h \
>   $(top_srcdir)/lib/e2p/e2p.h $(top_srcdir)/lib/ext2fs/ext2_fs.h \
> Index: e2fsprogs.git/misc/mmpstatus.c
> ===================================================================
> --- /dev/null
> +++ e2fsprogs.git/misc/mmpstatus.c
> @@ -0,0 +1,103 @@
> +/*
> + * mmpstatus.c --- check MMP status of an ext4 file system
> + *
> + * Copyright (C) 2013 DataDirect Networks, Inc.
> + *
> + * %Begin-Header%
> + * This file may be redistributed under the terms of the GNU Public
> + * License.

Just to pick nits -- do you mean GPLv2 (like the rest of e2fsprogs)?  You might
want to state explicitly which version of the license you want, particularly
since you called out v2 last time. :)

In general, people assume that no version number implies v1, though I'm sure
lawyer types could twist that omission to mean just about anything.

> + * %End-Header%
> + */
> +
> +#include <stdio.h>
> +#include <unistd.h>
> +#include <stdlib.h>
> +#include <assert.h>
> +#include <time.h>
> +#include <getopt.h>
> +#include <sys/time.h>
> +#include "ext2fs/ext2fs.h"
> +#include "blkid/blkid.h"
> +#include "../version.h"
> +#include "nls-enable.h"
> +
> +/*
> + * return 1 when MMP is being updated,
> + * 0 if not, and -1 on falure
> +*/
> +int main (int argc, char ** argv)
> +{
> +    char        *device;
> +    int        open_flags = EXT2_FLAG_64BITS;
> +    ext2_filsys    filesystem = NULL;
> +    int        retval;
> +    const char    *usage =
> +        "usage: %s [-i] device";
> +    int c;
> +    int info = 0;
> +    const char *debug_prog_name = "mmpstatus";

I should also complain about the use of 4-spaces instead of tabs.  Most of
libext2fs and the more heavily used utilities use tabs.

I'm not entirely sure what whitespace/indentation standards we're supposed to
use; I usually run my patches through kernel checkpatch.pl and fix the problems
that it complains about, if they aren't spread all over the e2fsprogs source.

(That said, there are other parts of the e2fsprogs source that use spaces...)

> +
> +    add_error_table(&et_ext2_error_table);
> +    fprintf(stderr, "%s %s (%s)\n", debug_prog_name,
> +        E2FSPROGS_VERSION, E2FSPROGS_DATE);
> +    while ((c = getopt(argc, argv, "i")) != EOF) {
> +        switch (c) {
> +        case 'i':
> +            info++;
> +            break;
> +        default:
> +            com_err(argv[0], 0, usage, debug_prog_name);
> +            return -1;
> +        }
> +    }
> +
> +    if (optind != argc - 1) {
> +        com_err(argv[0], 0, usage, debug_prog_name);
> +        return -1;
> +    }
> +
> +    device = blkid_get_devname(NULL, argv[optind], NULL);
> +    if (device == NULL) {
> +        com_err(argv[0], 0, _("Unable to resolve '%s'"), device);
> +        return -1;
> +    }
> +
> +    retval = ext2fs_open(device, open_flags, 0, 0,
> +                 unix_io_manager, &filesystem);
> +    if (retval) {
> +        com_err(argv[0], retval, _("while trying to open %s"),
> +            device);
> +        retval = -1;
> +        goto out_free_device;
> +    }
> +
> +    if (info) {
> +        retval = ext2fs_mmp_dump(filesystem);
> +        if (retval) {
> +            com_err(argv[0], retval, _("while trying to dump %s"),
> +                device);
> +        }
> +    } else {
> +        retval = ext2fs_mmp_start(filesystem);
> +        switch (retval) {
> +        case EXT2_ET_MMP_FAILED:
> +            com_err(argv[0], retval,
> +                _("while checking MMP status of %s"), device);
> +            retval = 1;
> +            break;
> +        case 0:
> +            com_err(argv[0], 0, "device '%s' is not used now\n",
> +                device);
> +            break;
> +        default:
> +            com_err(argv[0], retval,
> +                _("while checking MMP status of %s"), device);
> +            retval = -1;
> +            break;
> +        }
> +    }
> +    ext2fs_close(filesystem);
> +out_free_device:
> +    free(device);
> +    return retval;
> +}
> Index: e2fsprogs.git/configure.in
> ===================================================================
> --- e2fsprogs.git.orig/configure.in
> +++ e2fsprogs.git/configure.in
> @@ -718,6 +718,32 @@ esac]
>  AC_SUBST(FSCK_PROG)
>  AC_SUBST(FSCK_MAN)
>  dnl
> +dnl See whether to install the `mmpstatus' program
> +dnl
> +AC_ARG_ENABLE([mmpstatus],
> +[  --enable-mmpstatus           build mmpstatus program],
> +[if test "$enableval" = "no"
> +then
> +    MMPSTATUS_PROG='' MMPSTATUS_MAN=''
> +    AC_MSG_RESULT([Not building mmpstatus])
> +else
> +    MMPSTATUS_PROG=mmpstatus MMPSTATUS_MAN=mmpstatus.8
> +    AC_MSG_RESULT([Building mmpstatus])
> +fi]
> +,
> +[case "$host_os" in
> +  gnu*)
> +    MMPSTATUS_PROG='' MMPSTATUS_MAN=''
> +    AC_MSG_RESULT([Not building mmpstatus by default])
> +    ;;
> +  *)
> +    MMPSTATUS_PROG=mmpstatus MMPSTATUS_MAN=mmpstatus.8
> +    AC_MSG_RESULT([Building mmpstatus by default])
> +esac]
> +)
> +AC_SUBST(MMPSTATUS_PROG)
> +AC_SUBST(MMPSTATUS_MAN)
> +dnl
>  dnl See whether to install the `e2initrd-helper' program
>  dnl
>  AC_ARG_ENABLE([e2initrd-helper],
> Index: e2fsprogs.git/debugfs/debugfs.c
> ===================================================================
> --- e2fsprogs.git.orig/debugfs/debugfs.c
> +++ e2fsprogs.git/debugfs/debugfs.c
> @@ -2316,50 +2316,12 @@ try_again:
>  void do_dump_mmp(int argc EXT2FS_ATTR((unused)), char *argv[])
>  {
>  #if CONFIG_MMP
> -    struct ext2_super_block *sb;
> -    struct mmp_struct *mmp_s;
> -    time_t t;
> -    errcode_t retval = 0;
> -
> +    int retval;
>      if (check_fs_open(argv[0]))
>          return;
> -
> -    sb  = current_fs->super;
> -    if (sb->s_mmp_block <= sb->s_first_data_block ||
> -        sb->s_mmp_block >= ext2fs_blocks_count(sb)) {
> -        com_err(argv[0], EXT2_ET_MMP_BAD_BLOCK, "while dumping it.\n");
> -        return;
> -    }
> -
> -    if (current_fs->mmp_buf == NULL) {
> -        retval = ext2fs_get_mem(current_fs->blocksize,
> -                    &current_fs->mmp_buf);
> -        if (retval) {
> -            com_err(argv[0], retval, "allocating MMP buffer.\n");
> -            return;
> -        }
> -    }
> -
> -    mmp_s = current_fs->mmp_buf;
> -
> -    retval = ext2fs_mmp_read(current_fs, current_fs->super->s_mmp_block,
> -                 current_fs->mmp_buf);
> -    if (retval) {
> -        com_err(argv[0], retval, "reading MMP block.\n");
> -        return;
> -    }
> -
> -    t = mmp_s->mmp_time;
> -    fprintf(stdout, "block_number: %llu\n", current_fs->super->s_mmp_block);
> -    fprintf(stdout, "update_interval: %d\n",
> -        current_fs->super->s_mmp_update_interval);
> -    fprintf(stdout, "check_interval: %d\n", mmp_s->mmp_check_interval);
> -    fprintf(stdout, "sequence: %08x\n", mmp_s->mmp_seq);
> -    fprintf(stdout, "time: %lld -- %s", mmp_s->mmp_time, ctime(&t));
> -    fprintf(stdout, "node_name: %s\n", mmp_s->mmp_nodename);
> -    fprintf(stdout, "device_name: %s\n", mmp_s->mmp_bdevname);
> -    fprintf(stdout, "magic: 0x%x\n", mmp_s->mmp_magic);
> -    fprintf(stdout, "checksum: 0x%08x\n", mmp_s->mmp_checksum);

Odd.  This file has tabs in it, but even the "-" parts of the diff have spaces.
Did something eat the tabs?  That might explain a few things.

> +    retval = ext2fs_mmp_dump(current_fs);
> +    if (retval)
> +        com_err(argv[0], retval, "while dumping it.\n");

So long as ext2fs_mmp_dump() can return EXT2_ET_OP_NOT_SUPPORTED, why not just
call the library function and com_err whatever errors it returns?  In other
words, I think we can drop the #if CONFIG_MMP in this function.

Also, you might want to clarify the error message parameter to get rid of the
pronoun "it" which may some day end up in some scenario where "it" becomes
ambiguous -- "while dumping MMP block.\n" is clear about which component had an
error.

>  #else
>      fprintf(stdout, "MMP is unsupported, please recompile with "
>                      "--enable-mmp\n");
> Index: e2fsprogs.git/lib/ext2fs/ext2fs.h
> ===================================================================
> --- e2fsprogs.git.orig/lib/ext2fs/ext2fs.h
> +++ e2fsprogs.git/lib/ext2fs/ext2fs.h
> @@ -1468,6 +1468,7 @@ errcode_t ext2fs_symlink(ext2_filsys fs,
>  /* mmp.c */
>  errcode_t ext2fs_mmp_read(ext2_filsys fs, blk64_t mmp_blk, void *buf);
>  errcode_t ext2fs_mmp_write(ext2_filsys fs, blk64_t mmp_blk, void *buf);
> +errcode_t ext2fs_mmp_dump(ext2_filsys fs);
>  errcode_t ext2fs_mmp_clear(ext2_filsys fs);
>  errcode_t ext2fs_mmp_init(ext2_filsys fs);
>  errcode_t ext2fs_mmp_start(ext2_filsys fs);
> Index: e2fsprogs.git/lib/ext2fs/mmp.c
> ===================================================================
> --- e2fsprogs.git.orig/lib/ext2fs/mmp.c
> +++ e2fsprogs.git/lib/ext2fs/mmp.c
> @@ -19,7 +19,7 @@
>  #include <unistd.h>
>  #endif
>  #include <sys/time.h>
> -
> +#include <time.h>
>  #include <sys/types.h>
>  #include <sys/stat.h>
>  #include <fcntl.h>
> @@ -259,6 +259,52 @@ out:
>  #endif
>  }
> 
> +errcode_t ext2fs_mmp_dump(ext2_filsys fs)
> +{
> +#ifdef CONFIG_MMP
> +    struct ext2_super_block *sb;
> +    struct mmp_struct *mmp_s;
> +    time_t t;
> +    errcode_t retval = 0;
> +
> +    sb  = fs->super;
> +    if (sb->s_mmp_block <= sb->s_first_data_block ||
> +        sb->s_mmp_block >= ext2fs_blocks_count(sb)) {
> +        return EXT2_ET_MMP_BAD_BLOCK;
> +    }
> +
> +    if (fs->mmp_buf == NULL) {
> +        retval = ext2fs_get_mem(fs->blocksize,
> +                    &fs->mmp_buf);
> +        if (retval)
> +            return retval;
> +    }
> +
> +    mmp_s = fs->mmp_buf;
> +
> +    retval = ext2fs_mmp_read(fs, fs->super->s_mmp_block,
> +                 fs->mmp_buf);
> +    if (retval)
> +        return retval;
> +
> +    t = mmp_s->mmp_time;
> +    fprintf(stdout, "block_number: %llu\n", fs->super->s_mmp_block);
> +    fprintf(stdout, "update_interval: %d\n",
> +        fs->super->s_mmp_update_interval);
> +    fprintf(stdout, "check_interval: %d\n", mmp_s->mmp_check_interval);
> +    fprintf(stdout, "sequence: %08x\n", mmp_s->mmp_seq);
> +    fprintf(stdout, "time: %lld -- %s", mmp_s->mmp_time, ctime(&t));
> +    fprintf(stdout, "node_name: %s\n", mmp_s->mmp_nodename);
> +    fprintf(stdout, "device_name: %s\n", mmp_s->mmp_bdevname);
> +    fprintf(stdout, "magic: 0x%x\n", mmp_s->mmp_magic);
> +    fprintf(stdout, "checksum: 0x%08x\n", mmp_s->mmp_checksum);
> +
> +    return 0;
> +#else
> +    return EXT2_ET_OP_NOT_SUPPORTED;
> +#endif
> +}
> +
>  /*
>   * Make sure that the fs is not mounted or being fsck'ed while opening the fs.
>   */
> 
> 2013/11/14 Darrick J. Wong <darrick.wong@oracle.com>:
> > On Wed, Nov 13, 2013 at 08:07:35PM +0800, Li Xi wrote:
> >> Hi all,
> >>
> >> MMP feature of ext4 really helps us a lot to avoid mounting file
> >> system more than once, especailly when using ext4 as the basis of a
> >> distributed file sytem, e.g. Lustre. However, lack of a userspace
> >> utility to check the status of MMP makes it diffcult to utilize this
> >> feature to make failover decisions. We tried to write a script to do
> >> so by parsing the output of debugfs command. But this solution is not
> >> very straight forward. In order to check the sequence and checksum
> >> correctly, the script has to embed a lot of value definition, which
> >> could be error prone.
> >>
> >> Finally, we decided to add a new command in the e2fsprogs. With that
> >> command, a server is able to check the current MMP state of a device
> >> so that it can decide whether to take over the file system service
> >> from aother server. I think the patch might helps other use cases too.
> >>
> >> The attachment is the patch.
> >>
> >> Thanks,
> >> Li  Xi
> >
> > Please add a signed-off-by line.
> >
> > Also /me grumps about patch-as-attachment; inline is less cutting and pasting
> > for review. :)
> >
> >> Index: e2fsprogs.git/e2fsprogs.spec.in
> >> ===================================================================
> >> --- e2fsprogs.git.orig/e2fsprogs.spec.in
> >> +++ e2fsprogs.git/e2fsprogs.spec.in
> >> @@ -132,6 +132,7 @@ exit 0
> >>  %{_root_sbindir}/mkfs.ext4dev
> >>  %{_root_sbindir}/resize2fs
> >>  %{_root_sbindir}/tune2fs
> >> +%{_root_sbindir}/mmpstatus
> >>  %{_sbindir}/filefrag
> >>  %{_sbindir}/mklost+found
> >>  %{_sbindir}/e2freefrag
> >> @@ -180,6 +181,7 @@ exit 0
> >>  %{_mandir}/man8/tune2fs.8*
> >>  %{_mandir}/man8/filefrag.8*
> >>  %{_mandir}/man8/e2freefrag.8*
> >> +%{_mandir}/man8/mmpstatus.8*
> >>
> >>  %files devel
> >>  %defattr(-,root,root)
> >> Index: e2fsprogs.git/misc/mmpstatus.8.in
> >> ===================================================================
> >> --- /dev/null
> >> +++ e2fsprogs.git/misc/mmpstatus.8.in
> >> @@ -0,0 +1,56 @@
> >> +.\" -*- nroff -*-
> >> +.\" This file may be copied under the terms of the GNU Public License.
> >> +.\"
> >> +.TH MMPSTATUS 8 "@E2FSPROGS_MONTH@ @E2FSPROGS_YEAR@" "E2fsprogs version @E2FSPROGS_VERSION@"
> >> +.SH NAME
> >> +mmpstatus \- Check MMP status of an ext4 file system
> >> +.SH SYNOPSIS
> >> +.B mmpstatus
> >> +[
> >> +.B \-c | \--check
> >> +]
> >> +[
> >> +.B \-n | \--nodename
> >> +]
> >> +.I [filesys]
> >> +.SH DESCRIPTION
> >> +.B mmpstatus
> >> +is used to check MMP status of an ext4 file system.
> >> +.I filesys
> >> +can be a device name (e.g.
> >> +.IR /dev/hdc1 ", " /dev/sdb2 ),
> >> +or an ext4 label or UUID specifier (e.g.
> >> +UUID=8868abf6-88c5-4a83-98b8-bfc24057f7bd or LABEL=root).
> >> +Normaly, the
> >
> > "Normally" (there are several of these)
> >
> >> +.B mmpstatus
> >> +program checks whether it is safe to mount the file system without taking
> >> +the risk of mounting it more than once.
> >> +.PP
> >> +MMP (multiple-mount protection) is a feature which protects
> >> +the file system from being mounted simultaneously to more than one node.
> >> +It is NOT safe to mount a file system when one of the following condition
> >> +is true:
> >> +.br
> >> +\    1. The MMP shows that fsck is running on the file system.
> >> +.br
> >> +\    2. The MMP are being updated by some node.
> >> +.br
> >> +The
> >> +.B mmpstatus
> >> +program might wait for some time to see whether MMP is updated by any node
> >> +during this period.
> >> +.PP
> >> +Normaly, The exit code returned by
> >> +.B mmpstatus
> >> +is 0 when it is safe to mount the filesystem, 1 when it is NOT safe to mount
> >> +the filesystem, and -1 on failure. When
> >> +.B \-i
> >> +flag is specified, the exit code
> >> +is 0 on success, -1 on failure.
> >> +.SH OPTIONS
> >> +.TP
> >> +.B \-i,
> >> +print out the MMP informantion rather than check it.
> >
> > "information"
> >
> >> +.SH SEE ALSO
> >> +.BR fstab (5),
> >> +.BR fsck (8),
> >> Index: e2fsprogs.git/misc/Makefile.in
> >> ===================================================================
> >> --- e2fsprogs.git.orig/misc/Makefile.in
> >> +++ e2fsprogs.git/misc/Makefile.in
> >> @@ -27,12 +27,12 @@ INSTALL = @INSTALL@
> >>  @BLKID_CMT@FINDFS_MAN= findfs.8
> >>
> >>  SPROGS=              mke2fs badblocks tune2fs dumpe2fs $(BLKID_PROG) logsave \
> >> -                     $(E2IMAGE_PROG) @FSCK_PROG@ e2undo
> >> +                     $(E2IMAGE_PROG) @FSCK_PROG@ @MMPSTATUS_PROG@ e2undo
> >>  USPROGS=     mklost+found filefrag e2freefrag $(UUIDD_PROG) $(E4DEFRAG_PROG)
> >>  SMANPAGES=   tune2fs.8 mklost+found.8 mke2fs.8 dumpe2fs.8 badblocks.8 \
> >>                       e2label.8 $(FINDFS_MAN) $(BLKID_MAN) $(E2IMAGE_MAN) \
> >>                       logsave.8 filefrag.8 e2freefrag.8 e2undo.8 \
> >> -                     $(UUIDD_MAN) $(E4DEFRAG_MAN) @FSCK_MAN@
> >> +                     $(UUIDD_MAN) $(E4DEFRAG_MAN) @FSCK_MAN@ @MMPSTATUS_MAN@
> >>  FMANPAGES=   mke2fs.conf.5
> >>
> >>  UPROGS=              chattr lsattr @UUID_CMT@ uuidgen
> >> @@ -51,6 +51,7 @@ DUMPE2FS_OBJS=      dumpe2fs.o
> >>  BADBLOCKS_OBJS=      badblocks.o
> >>  E2IMAGE_OBJS=        e2image.o
> >>  FSCK_OBJS=   fsck.o base_device.o ismounted.o
> >> +MMPSTATUS_OBJS=      mmpstatus.o
> >>  BLKID_OBJS=  blkid.o
> >>  FILEFRAG_OBJS=       filefrag.o
> >>  E2UNDO_OBJS=  e2undo.o
> >> @@ -70,6 +71,7 @@ PROFILED_BADBLOCKS_OBJS=    profiled/badblo
> >>  PROFILED_E2IMAGE_OBJS=       profiled/e2image.o
> >>  PROFILED_FSCK_OBJS=  profiled/fsck.o profiled/base_device.o \
> >>                       profiled/ismounted.o
> >> +PROFILED_MMPSTATUS_OBJS=profiled/mmpstatus.o
> >>  PROFILED_BLKID_OBJS= profiled/blkid.o
> >>  PROFILED_FILEFRAG_OBJS=      profiled/filefrag.o
> >>  PROFILED_E2FREEFRAG_OBJS= profiled/e2freefrag.o
> >> @@ -82,7 +84,8 @@ SRCS=       $(srcdir)/tune2fs.c $(srcdir)/mklo
> >>               $(srcdir)/uuidgen.c $(srcdir)/blkid.c $(srcdir)/logsave.c \
> >>               $(srcdir)/filefrag.c $(srcdir)/base_device.c \
> >>               $(srcdir)/ismounted.c $(srcdir)/../e2fsck/profile.c \
> >> -             $(srcdir)/e2undo.c $(srcdir)/e2freefrag.c
> >> +             $(srcdir)/e2undo.c $(srcdir)/e2freefrag.c \
> >> +             $(srcdir)/mmpstatus.c
> >>
> >>  LIBS= $(LIBEXT2FS) $(LIBCOM_ERR)
> >>  DEPLIBS= $(LIBEXT2FS) $(DEPLIBCOM_ERR)
> >> @@ -300,6 +303,16 @@ fsck.profiled: $(FSCK_OBJS) $(PROFILED_D
> >>       $(Q) $(CC) $(ALL_LDFLAGS) -g -pg -o fsck.profiled $(PROFILED_FSCK_OBJS) \
> >>               $(PROFILED_LIBBLKID) $(LIBINTL)
> >>
> >> +mmpstatus: $(MMPSTATUS_OBJS) $(DEPLIBBLKID)
> >> +     $(E) "  LD $@"
> >> +     $(Q) $(CC) $(ALL_LDFLAGS) -o mmpstatus $(MMPSTATUS_OBJS) $(LIBBLKID) \
> >> +             $(LIBINTL) $(LIBS)
> >> +
> >> +mmpstatus.profiled: $(MMPSTATUS_OBJS) $(PROFILED_DEPLIBBLKID)
> >> +     $(E) "  LD $@"
> >> +     $(Q) $(CC) $(ALL_LDFLAGS) -g -pg -o mmpstatus.profiled \
> >> +             $(PROFILED_MMPSTATUS_OBJS) $(PROFILED_LIBBLKID) $(LIBINTL)
> >> +
> >>  badblocks: $(BADBLOCKS_OBJS) $(DEPLIBS)
> >>       $(E) "  LD $@"
> >>       $(Q) $(CC) $(ALL_LDFLAGS) -o badblocks $(BADBLOCKS_OBJS) $(LIBS) $(LIBINTL)
> >> @@ -384,6 +397,10 @@ badblocks.8: $(DEP_SUBSTITUTE) $(srcdir)
> >>       $(E) "  SUBST $@"
> >>       $(Q) $(SUBSTITUTE_UPTIME) $(srcdir)/badblocks.8.in badblocks.8
> >>
> >> +mmpstatus.8: $(DEP_SUBSTITUTE) $(srcdir)/mmpstatus.8.in
> >> +     $(E) "  SUBST $@"
> >> +     $(Q) $(SUBSTITUTE_UPTIME) $(srcdir)/mmpstatus.8.in mmpstatus.8
> >> +
> >>  fsck.8: $(DEP_SUBSTITUTE) $(srcdir)/fsck.8.in
> >>       $(E) "  SUBST $@"
> >>       $(Q) $(SUBSTITUTE_UPTIME) $(srcdir)/fsck.8.in fsck.8
> >> @@ -575,7 +592,8 @@ clean:
> >>               e2undo.profiled mke2fs.profiled dumpe2fs.profiled \
> >>               logsave.profiled filefrag.profiled uuidgen.profiled \
> >>               uuidd.profiled e2image.profiled mke2fs.conf \
> >> -             profiled/*.o \#* *.s *.o *.a *~ core gmon.out
> >> +             mmpstatus.profiled profiled/*.o \#* *.s *.o *.a *~ core \
> >> +             gmon.out
> >>
> >>  mostlyclean: clean
> >>  distclean: clean
> >> @@ -644,6 +662,9 @@ badblocks.o: $(srcdir)/badblocks.c $(top
> >>  fsck.o: $(srcdir)/fsck.c $(top_builddir)/lib/config.h \
> >>   $(top_builddir)/lib/dirpaths.h $(top_srcdir)/version.h \
> >>   $(srcdir)/nls-enable.h $(srcdir)/fsck.h
> >> +mmpstatus.o: $(srcdir)/mmpstatus.c $(top_builddir)/lib/config.h \
> >> + $(top_builddir)/lib/dirpaths.h $(top_srcdir)/version.h \
> >> + $(srcdir)/nls-enable.h $(top_srcdir)/lib/ext2fs/ext2fs.h
> >>  util.o: $(srcdir)/util.c $(top_builddir)/lib/config.h \
> >>   $(top_builddir)/lib/dirpaths.h $(top_srcdir)/lib/et/com_err.h \
> >>   $(top_srcdir)/lib/e2p/e2p.h $(top_srcdir)/lib/ext2fs/ext2_fs.h \
> >> Index: e2fsprogs.git/misc/mmpstatus.c
> >> ===================================================================
> >> --- /dev/null
> >> +++ e2fsprogs.git/misc/mmpstatus.c
> >> @@ -0,0 +1,120 @@
> >> +/*
> >> + * GPL HEADER START
> >> + *
> >> + * DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS FILE HEADER.
> >> + *
> >> + * This program is free software; you can redistribute it and/or modify
> >> + * it under the terms of the GNU General Public License version 2 only,
> >> + * as published by the Free Software Foundation.
> >> + *
> >> + * This program is distributed in the hope that it will be useful, but
> >> + * WITHOUT ANY WARRANTY; without even the implied warranty of
> >> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> >> + * General Public License version 2 for more details (a copy is included
> >> + * in the LICENSE file that accompanied this code).
> >> + *
> >> + * You should have received a copy of the GNU General Public License
> >> + * version 2 along with this program; if not, write to the
> >> + * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
> >> + * Boston, MA 021110-1307, USA
> >> + *
> >> + * GPL HEADER END
> >> + */
> >> +/*
> >> + * Copyright (C) 2013 DataDirect Networks, Inc.
> >> + */
> >> +
> >> +#include <stdio.h>
> >> +#include <unistd.h>
> >> +#include <stdlib.h>
> >> +#include <assert.h>
> >> +#include <time.h>
> >> +#include <getopt.h>
> >> +#include <sys/time.h>
> >> +#include "ext2fs/ext2fs.h"
> >> +#include "blkid/blkid.h"
> >> +#include "../version.h"
> >> +#include "nls-enable.h"
> >> +
> >> +/*
> >> + * return 1 when MMP is being updated,
> >> + * 0 if not, and -1 on falure
> >> +*/
> >> +int main (int argc, char ** argv)
> >> +{
> >> +     char            *device;
> >> +     int             open_flags = 0;
> >> +     blk64_t         superblock = 0;
> >> +     blk64_t         blocksize = 0;
> >> +     ext2_filsys     filesystem = NULL;
> >> +     int             retval;
> >> +     const char      *usage =
> >> +             "usage: %s [-i] device";
> >> +     const char      *opt_string = "i";
> >> +     int c;
> >> +     int info = 0;
> >> +     const char *debug_prog_name = "mmpstatus";
> >> +
> >> +     add_error_table(&et_ext2_error_table);
> >> +     fprintf(stderr, "%s %s (%s)\n", debug_prog_name,
> >> +             E2FSPROGS_VERSION, E2FSPROGS_DATE);
> >> +     while ((c = getopt(argc, argv, opt_string)) != EOF) {
> >
> > Probably fine to use the bare string "i" instead of opt_string here.
> >
> >> +             switch (c) {
> >> +             case 'i':
> >> +                     info++;
> >> +                     break;
> >> +             default:
> >> +                     com_err(argv[0], 0, usage, debug_prog_name);
> >> +                     return -1;
> >> +             }
> >> +     }
> >> +
> >> +     if (optind != argc - 1) {
> >> +             com_err(argv[0], 0, usage, debug_prog_name);
> >> +             return -1;
> >> +     }
> >> +
> >> +     device = blkid_get_devname(NULL, argv[optind], NULL);
> >> +     if (device == NULL) {
> >> +             com_err(argv[0], 0, _("Unable to resolve '%s'"), device);
> >> +             return -1;
> >> +     }
> >> +
> >> +     retval = ext2fs_open(device, open_flags, superblock, blocksize,
> >> +                       unix_io_manager, &filesystem);
> >
> > You might want at least open_flags |= EXT2_FLAG_64BITS, because bigalloc FSes
> > require features that get turned on with that flag, and will fail the open call
> > if the flag isn't there.
> >
> > Also I could whine about argument size mismatches for superblock and blocksize;
> > technically, both parameters are 32-bits yet the variables being passed in
> > are 64 bits.  Block size will never need 64 bits, and the ext2fs_open3() call
> > to fix superblock hasn't gone in yet.  Also, both variables are permanently
> > zero, so you could just open code them and let the compiler figure it out.
> >
> >> +     if (retval) {
> >> +             com_err(argv[0], retval, _("while trying to open %s"),
> >> +                     device);
> >> +             retval = -1;
> >> +             goto out_free_device;
> >> +     }
> >> +
> >> +     if (info) {
> >> +             retval = ext2fs_mmp_dump(filesystem);
> >> +             if (retval) {
> >> +                     com_err(argv[0], retval, _("while trying to dump %s"),
> >> +                             device);
> >> +             }
> >> +     } else {
> >> +             retval = ext2fs_mmp_start(filesystem);
> >> +             switch (retval) {
> >> +             case EXT2_ET_MMP_FAILED:
> >> +                     com_err(argv[0], retval,
> >> +                             _("while checking MMP status of %s"), device);
> >> +                     retval = 1;
> >> +                     break;
> >> +             case 0:
> >> +                     com_err(argv[0], 0, "device '%s' is not used now\n",
> >> +                             device);
> >> +                     break;
> >> +             default:
> >> +                     com_err(argv[0], retval,
> >> +                             _("while checking MMP status of %s"), device);
> >> +                     retval = -1;
> >
> > Picking nits here, but 'break'?
> >
> >> +             }
> >> +     }
> >> +     ext2fs_close(filesystem);
> >> +out_free_device:
> >> +     free(device);
> >> +     return retval;
> >> +}
> >> Index: e2fsprogs.git/configure.in
> >> ===================================================================
> >> --- e2fsprogs.git.orig/configure.in
> >> +++ e2fsprogs.git/configure.in
> >> @@ -718,6 +718,32 @@ esac]
> >>  AC_SUBST(FSCK_PROG)
> >>  AC_SUBST(FSCK_MAN)
> >>  dnl
> >> +dnl See whether to install the `mmpstatus' program
> >> +dnl
> >> +AC_ARG_ENABLE([mmpstatus],
> >> +[  --enable-mmpstatus           build mmpstatus program],
> >> +[if test "$enableval" = "no"
> >> +then
> >> +     MMPSTATUS_PROG='' MMPSTATUS_MAN=''
> >> +     AC_MSG_RESULT([Not building mmpstatus])
> >> +else
> >> +     MMPSTATUS_PROG=mmpstatus MMPSTATUS_MAN=mmpstatus.8
> >> +     AC_MSG_RESULT([Building mmpstatus])
> >> +fi]
> >> +,
> >> +[case "$host_os" in
> >> +  gnu*)
> >> +    MMPSTATUS_PROG='' MMPSTATUS_MAN=''
> >> +    AC_MSG_RESULT([Not mmpstatus by default])
> >
> > "Not building mmpstatus"?
> >
> >> +    ;;
> >> +  *)
> >> +    MMPSTATUS_PROG=mmpstatus MMPSTATUS_MAN=mmpstatus.8
> >> +    AC_MSG_RESULT([Building mmpstatus by default])
> >> +esac]
> >> +)
> >> +AC_SUBST(MMPSTATUS_PROG)
> >> +AC_SUBST(MMPSTATUS_MAN)
> >> +dnl
> >>  dnl See whether to install the `e2initrd-helper' program
> >>  dnl
> >>  AC_ARG_ENABLE([e2initrd-helper],
> >> Index: e2fsprogs.git/debugfs/debugfs.c
> >> ===================================================================
> >> --- e2fsprogs.git.orig/debugfs/debugfs.c
> >> +++ e2fsprogs.git/debugfs/debugfs.c
> >> @@ -2315,54 +2315,15 @@ try_again:
> >>
> >>  void do_dump_mmp(int argc EXT2FS_ATTR((unused)), char *argv[])
> >>  {
> >> +     int retval;
> >>  #if CONFIG_MMP
> >> -     struct ext2_super_block *sb;
> >> -     struct mmp_struct *mmp_s;
> >> -     time_t t;
> >> -     errcode_t retval = 0;
> >> -
> >>       if (check_fs_open(argv[0]))
> >>               return;
> >> -
> >> -     sb  = current_fs->super;
> >> -     if (sb->s_mmp_block <= sb->s_first_data_block ||
> >> -         sb->s_mmp_block >= ext2fs_blocks_count(sb)) {
> >> -             com_err(argv[0], EXT2_ET_MMP_BAD_BLOCK, "while dumping it.\n");
> >> -             return;
> >> -     }
> >> -
> >> -     if (current_fs->mmp_buf == NULL) {
> >> -             retval = ext2fs_get_mem(current_fs->blocksize,
> >> -                                     &current_fs->mmp_buf);
> >> -             if (retval) {
> >> -                     com_err(argv[0], retval, "allocating MMP buffer.\n");
> >> -                     return;
> >> -             }
> >> -     }
> >> -
> >> -     mmp_s = current_fs->mmp_buf;
> >> -
> >> -     retval = ext2fs_mmp_read(current_fs, current_fs->super->s_mmp_block,
> >> -                              current_fs->mmp_buf);
> >> -     if (retval) {
> >> -             com_err(argv[0], retval, "reading MMP block.\n");
> >> -             return;
> >> -     }
> >> -
> >> -     t = mmp_s->mmp_time;
> >> -     fprintf(stdout, "block_number: %llu\n", current_fs->super->s_mmp_block);
> >> -     fprintf(stdout, "update_interval: %d\n",
> >> -             current_fs->super->s_mmp_update_interval);
> >> -     fprintf(stdout, "check_interval: %d\n", mmp_s->mmp_check_interval);
> >> -     fprintf(stdout, "sequence: %08x\n", mmp_s->mmp_seq);
> >> -     fprintf(stdout, "time: %lld -- %s", mmp_s->mmp_time, ctime(&t));
> >> -     fprintf(stdout, "node_name: %s\n", mmp_s->mmp_nodename);
> >> -     fprintf(stdout, "device_name: %s\n", mmp_s->mmp_bdevname);
> >> -     fprintf(stdout, "magic: 0x%x\n", mmp_s->mmp_magic);
> >> -     fprintf(stdout, "checksum: 0x%08x\n", mmp_s->mmp_checksum);
> >> -#else
> >> -     fprintf(stdout, "MMP is unsupported, please recompile with "
> >> -                     "--enable-mmp\n");
> >> +#endif
> >> +     retval = ext2fs_mmp_dump(current_fs);
> >> +#if CONFIG_MMP
> >> +     if (retval)
> >> +             com_err(argv[0], retval, "while dumping it.\n");
> >>  #endif
> >>  }
> >>
> >> Index: e2fsprogs.git/lib/ext2fs/ext2fs.h
> >> ===================================================================
> >> --- e2fsprogs.git.orig/lib/ext2fs/ext2fs.h
> >> +++ e2fsprogs.git/lib/ext2fs/ext2fs.h
> >> @@ -1468,6 +1468,7 @@ errcode_t ext2fs_symlink(ext2_filsys fs,
> >>  /* mmp.c */
> >>  errcode_t ext2fs_mmp_read(ext2_filsys fs, blk64_t mmp_blk, void *buf);
> >>  errcode_t ext2fs_mmp_write(ext2_filsys fs, blk64_t mmp_blk, void *buf);
> >> +errcode_t ext2fs_mmp_dump(ext2_filsys fs);
> >>  errcode_t ext2fs_mmp_clear(ext2_filsys fs);
> >>  errcode_t ext2fs_mmp_init(ext2_filsys fs);
> >>  errcode_t ext2fs_mmp_start(ext2_filsys fs);
> >> Index: e2fsprogs.git/lib/ext2fs/mmp.c
> >> ===================================================================
> >> --- e2fsprogs.git.orig/lib/ext2fs/mmp.c
> >> +++ e2fsprogs.git/lib/ext2fs/mmp.c
> >> @@ -19,7 +19,7 @@
> >>  #include <unistd.h>
> >>  #endif
> >>  #include <sys/time.h>
> >> -
> >> +#include <time.h>
> >>  #include <sys/types.h>
> >>  #include <sys/stat.h>
> >>  #include <fcntl.h>
> >> @@ -259,6 +259,54 @@ out:
> >>  #endif
> >>  }
> >>
> >> +errcode_t ext2fs_mmp_dump(ext2_filsys fs)
> >> +{
> >> +#ifdef CONFIG_MMP
> >> +     struct ext2_super_block *sb;
> >> +     struct mmp_struct *mmp_s;
> >> +     time_t t;
> >> +     errcode_t retval = 0;
> >> +
> >> +     sb  = fs->super;
> >> +     if (sb->s_mmp_block <= sb->s_first_data_block ||
> >> +         sb->s_mmp_block >= ext2fs_blocks_count(sb)) {
> >> +             return EXT2_ET_MMP_BAD_BLOCK;
> >> +     }
> >> +
> >> +     if (fs->mmp_buf == NULL) {
> >> +             retval = ext2fs_get_mem(fs->blocksize,
> >> +                                     &fs->mmp_buf);
> >> +             if (retval)
> >> +                     return retval;
> >> +     }
> >> +
> >> +     mmp_s = fs->mmp_buf;
> >> +
> >> +     retval = ext2fs_mmp_read(fs, fs->super->s_mmp_block,
> >> +                              fs->mmp_buf);
> >> +     if (retval)
> >> +             return retval;
> >> +
> >> +     t = mmp_s->mmp_time;
> >> +     fprintf(stdout, "block_number: %llu\n", fs->super->s_mmp_block);
> >> +     fprintf(stdout, "update_interval: %d\n",
> >> +             fs->super->s_mmp_update_interval);
> >> +     fprintf(stdout, "check_interval: %d\n", mmp_s->mmp_check_interval);
> >> +     fprintf(stdout, "sequence: %08x\n", mmp_s->mmp_seq);
> >> +     fprintf(stdout, "time: %lld -- %s", mmp_s->mmp_time, ctime(&t));
> >> +     fprintf(stdout, "node_name: %s\n", mmp_s->mmp_nodename);
> >> +     fprintf(stdout, "device_name: %s\n", mmp_s->mmp_bdevname);
> >> +     fprintf(stdout, "magic: 0x%x\n", mmp_s->mmp_magic);
> >> +     fprintf(stdout, "checksum: 0x%08x\n", mmp_s->mmp_checksum);
> >> +
> >> +     return 0;
> >> +#else
> >> +     fprintf(stdout, "MMP is unsupported, please recompile with "
> >> +                     "--enable-mmp\n");
> >> +     return EXT2_ET_OP_NOT_SUPPORTED;
> >
> > I wonder, maybe this function should simply return the error code and let the
> > caller decide if it wants to print out an error?  (And, maybe do that on
> > stderr?)
> >
> > <shrug> It's a matter of taste, though I'd rather my error messages show up
> > on stderr.
> >
> > --D
> >> +#endif
> >> +}
> >> +
> >>  /*
> >>   * Make sure that the fs is not mounted or being fsck'ed while opening the fs.
> >>   */
