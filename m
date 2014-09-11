From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 10/25] debugfs: create journal handling routines
Date: Thu, 11 Sep 2014 13:25:31 -0700
Message-ID: <20140911202531.GW10351@birch.djwong.org>
References: <20140908231135.25904.66591.stgit@birch.djwong.org>
 <20140908231242.25904.81768.stgit@birch.djwong.org>
 <20140911185343.GB8366@thunk.org>
 <20140911190349.GP10351@birch.djwong.org>
 <20140911201458.GC8366@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:29095 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753889AbaIKUZg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 11 Sep 2014 16:25:36 -0400
Content-Disposition: inline
In-Reply-To: <20140911201458.GC8366@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 11, 2014 at 04:14:58PM -0400, Theodore Ts'o wrote:
> On Thu, Sep 11, 2014 at 12:03:49PM -0700, Darrick J. Wong wrote:
> > Will that pick up debugfs/jfs_user.h, though?  I originally tried it this way
> > but gcc seemed to want to pull in the jfs_user.h from e2fsck/.
> 
> Yeah, I figured that out shortly after I sent the message.  The way I
> fixed it was a bit more involved, but I think it's cleaner.
> 
> Long run, what I want to do is to rename libquota to libsupport, and
> then move things like profile.c, recovery.c, revoke.c, etc. into that
> single directory, and then harmonize all of the ugly hacks that we
> have in various different versions of jfs_user.h.  Given that, what I
> did for now was to harmonize (as much as possible) debugfs/jfs_user.h
> and e2fsck/jfs_user.h, and there is now a single version of jfs_user.h
> in e2fsck.  We still have some customizations based on -DDEBUGFS, but
> we can clean that up later.

Ok, thanks for your help! :)

<snip>

> diff --git a/lib/ext2fs/Makefile.in b/lib/ext2fs/Makefile.in
> index 0f8b598..985c60f 100644
> --- a/lib/ext2fs/Makefile.in
> +++ b/lib/ext2fs/Makefile.in
> @@ -4,7 +4,10 @@ VPATH = @srcdir@
>  top_builddir = ../..
>  my_dir = lib/ext2fs
>  INSTALL = @INSTALL@
> -DEPEND_CFLAGS = -I$(top_srcdir)/debugfs
> +DEPEND_CFLAGS = -I$(top_srcdir)/debugfs -I$(srcdir)/../../e2fsck -DDEBUGFS
> +# This nastyness is needed because of jfs_user.h hackery; when we finally
> +# clean up this mess, we should be able to drop it
> +DEBUGFS_CFLAGS = $(ALL_CFLAGS) -I$(srcdir)/../../e2fsck -DDEBUGFS -DDEBUGFS

Probably not necessary to -DDEBUGFS twice here.

--D

>  
>  @MCONFIG@
>  
> @@ -19,7 +22,8 @@ MK_CMDS=	_SS_DIR_OVERRIDE=../ss ../ss/mk_cmds
>  DEBUG_OBJS= debug_cmds.o extent_cmds.o tst_cmds.o debugfs.o util.o \
>  	ncheck.o icheck.o ls.o lsdel.o dump.o set_fields.o logdump.o \
>  	htree.o unused.o e2freefrag.o filefrag.o extent_inode.o zap.o \
> -	xattrs.o quota.o tst_libext2fs.o create_inode.o
> +	xattrs.o quota.o tst_libext2fs.o create_inode.o journal.o \
> +	revoke.o recovery.o
>  
>  DEBUG_SRCS= debug_cmds.c extent_cmds.c tst_cmds.c \
>  	$(top_srcdir)/debugfs/debugfs.c \
> @@ -39,7 +43,10 @@ DEBUG_SRCS= debug_cmds.c extent_cmds.c tst_cmds.c \
>  	$(top_srcdir)/debugfs/quota.c \
>  	$(top_srcdir)/debugfs/xattrs.c \
>  	$(top_srcdir)/misc/e2freefrag.c \
> -	$(top_srcdir)/misc/create_inode.c
> +	$(top_srcdir)/misc/create_inode.c \
> +	$(top_srcdir)/debugfs/journal.c \
> +	$(top_srcdir)/e2fsck/revoke.c \
> +	$(top_srcdir)/e2fsck/recovery.c
>  
>  OBJS= $(DEBUGFS_LIB_OBJS) $(RESIZE_LIB_OBJS) $(E2IMAGE_LIB_OBJS) \
>  	$(TEST_IO_LIB_OBJS) \
> @@ -338,63 +345,75 @@ extent_cmds.c extent_cmds.h: $(top_srcdir)/debugfs/extent_cmds.ct
>  
>  debugfs.o: $(top_srcdir)/debugfs/debugfs.c
>  	$(E) "	CC $<"
> -	$(Q) $(CC) $(ALL_CFLAGS) -c $< -o $@
> +	$(Q) $(CC) $(DEBUGFS_CFLAGS) -c $< -o $@
>  
>  extent_inode.o: $(top_srcdir)/debugfs/extent_inode.c
>  	$(E) "	CC $<"
> -	$(Q) $(CC) $(ALL_CFLAGS) -c $< -o $@
> +	$(Q) $(CC) $(DEBUGFS_CFLAGS) -c $< -o $@
>  
>  util.o: $(top_srcdir)/debugfs/util.c
>  	$(E) "	CC $<"
> -	$(Q) $(CC) $(ALL_CFLAGS) -c $< -o $@
> +	$(Q) $(CC) $(DEBUGFS_CFLAGS) -c $< -o $@
>  
>  ncheck.o: $(top_srcdir)/debugfs/ncheck.c
>  	$(E) "	CC $<"
> -	$(Q) $(CC) $(ALL_CFLAGS) -c $< -o $@
> +	$(Q) $(CC) $(DEBUGFS_CFLAGS) -c $< -o $@
>  
>  icheck.o: $(top_srcdir)/debugfs/icheck.c
>  	$(E) "	CC $<"
> -	$(Q) $(CC) $(ALL_CFLAGS) -c $< -o $@
> +	$(Q) $(CC) $(DEBUGFS_CFLAGS) -c $< -o $@
>  
>  ls.o: $(top_srcdir)/debugfs/ls.c
>  	$(E) "	CC $<"
> -	$(Q) $(CC) $(ALL_CFLAGS) -c $< -o $@
> +	$(Q) $(CC) $(DEBUGFS_CFLAGS) -c $< -o $@
>  
>  lsdel.o: $(top_srcdir)/debugfs/lsdel.c
>  	$(E) "	CC $<"
> -	$(Q) $(CC) $(ALL_CFLAGS) -c $< -o $@
> +	$(Q) $(CC) $(DEBUGFS_CFLAGS) -c $< -o $@
>  
>  dump.o: $(top_srcdir)/debugfs/dump.c
>  	$(E) "	CC $<"
> -	$(Q) $(CC) $(ALL_CFLAGS) -c $< -o $@
> +	$(Q) $(CC) $(DEBUGFS_CFLAGS) -c $< -o $@
>  
>  set_fields.o: $(top_srcdir)/debugfs/set_fields.c
>  	$(E) "	CC $<"
> -	$(Q) $(CC) $(ALL_CFLAGS) -c $< -o $@
> +	$(Q) $(CC) $(DEBUGFS_CFLAGS) -c $< -o $@
>  
>  logdump.o: $(top_srcdir)/debugfs/logdump.c
>  	$(E) "	CC $<"
> -	$(Q) $(CC) $(ALL_CFLAGS) -c $< -o $@
> +	$(Q) $(CC) $(DEBUGFS_CFLAGS) -c $< -o $@
>  
>  htree.o: $(top_srcdir)/debugfs/htree.c
>  	$(E) "	CC $<"
> -	$(Q) $(CC) $(ALL_CFLAGS) -c $< -o $@
> +	$(Q) $(CC) $(DEBUGFS_CFLAGS) -c $< -o $@
>  
>  unused.o: $(top_srcdir)/debugfs/unused.c
>  	$(E) "	CC $<"
> -	$(Q) $(CC) $(ALL_CFLAGS) -c $< -o $@
> +	$(Q) $(CC) $(DEBUGFS_CFLAGS) -c $< -o $@
>  
>  zap.o: $(top_srcdir)/debugfs/zap.c
>  	$(E) "	CC $<"
> -	$(Q) $(CC) $(ALL_CFLAGS) -c $< -o $@
> +	$(Q) $(CC) $(DEBUGFS_CFLAGS) -c $< -o $@
>  
>  quota.o: $(top_srcdir)/debugfs/quota.c
>  	$(E) "	CC $<"
> -	$(Q) $(CC) $(ALL_CFLAGS) -c $< -o $@
> +	$(Q) $(CC) $(DEBUGFS_CFLAGS) -c $< -o $@
> +
> +journal.o: $(top_srcdir)/debugfs/journal.c
> +	$(E) "	CC $<"
> +	$(Q) $(CC) $(DEBUGFS_CFLAGS) -c $< -o $@
> +
> +revoke.o: $(top_srcdir)/e2fsck/revoke.c
> +	$(E) "	CC $<"
> +	$(Q) $(CC) $(DEBUGFS_CFLAGS) -c $< -o $@
> +
> +recovery.o: $(top_srcdir)/e2fsck/recovery.c
> +	$(E) "	CC $<"
> +	$(Q) $(CC) $(DEBUGFS_CFLAGS) -c $< -o $@
>  
>  xattrs.o: $(top_srcdir)/debugfs/xattrs.c
>  	$(E) "	CC $<"
> -	$(Q) $(CC) $(ALL_CFLAGS) -c $< -o $@
> +	$(Q) $(CC) $(DEBUGFS_CFLAGS) -c $< -o $@
>  
>  e2freefrag.o: $(top_srcdir)/misc/e2freefrag.c
>  	$(E) "	CC $<"
> @@ -1083,7 +1102,7 @@ debugfs.o: $(top_srcdir)/debugfs/debugfs.c $(top_builddir)/lib/config.h \
>   $(top_srcdir)/lib/e2p/e2p.h $(top_srcdir)/debugfs/../misc/nls-enable.h \
>   $(top_srcdir)/lib/quota/quotaio.h $(top_srcdir)/lib/quota/dqblk_v2.h \
>   $(top_srcdir)/lib/quota/quotaio_tree.h $(top_srcdir)/lib/../e2fsck/dict.h \
> - $(top_srcdir)/debugfs/../version.h $(top_srcdir)/debugfs/jfs_user.h \
> + $(top_srcdir)/debugfs/../version.h $(srcdir)/../../e2fsck/jfs_user.h \
>   $(srcdir)/kernel-jbd.h $(srcdir)/jfs_compat.h $(srcdir)/kernel-list.h
>  util.o: $(top_srcdir)/debugfs/util.c $(top_builddir)/lib/config.h \
>   $(top_builddir)/lib/dirpaths.h $(top_srcdir)/lib/ss/ss.h \
> @@ -1173,7 +1192,7 @@ logdump.o: $(top_srcdir)/debugfs/logdump.c $(top_builddir)/lib/config.h \
>   $(top_srcdir)/lib/e2p/e2p.h $(top_srcdir)/debugfs/../misc/nls-enable.h \
>   $(top_srcdir)/lib/quota/quotaio.h $(top_srcdir)/lib/quota/dqblk_v2.h \
>   $(top_srcdir)/lib/quota/quotaio_tree.h $(top_srcdir)/lib/../e2fsck/dict.h \
> - $(top_srcdir)/debugfs/jfs_user.h $(srcdir)/kernel-jbd.h \
> + $(srcdir)/../../e2fsck/jfs_user.h $(srcdir)/kernel-jbd.h \
>   $(srcdir)/jfs_compat.h $(srcdir)/kernel-list.h
>  htree.o: $(top_srcdir)/debugfs/htree.c $(top_builddir)/lib/config.h \
>   $(top_builddir)/lib/dirpaths.h $(top_srcdir)/debugfs/debugfs.h \
> @@ -1257,7 +1276,12 @@ e2freefrag.o: $(top_srcdir)/misc/e2freefrag.c $(top_builddir)/lib/config.h \
>   $(top_builddir)/lib/ext2fs/ext2_types.h $(srcdir)/ext2fs.h \
>   $(srcdir)/ext3_extents.h $(top_srcdir)/lib/et/com_err.h $(srcdir)/ext2_io.h \
>   $(top_builddir)/lib/ext2fs/ext2_err.h $(srcdir)/ext2_ext_attr.h \
> - $(srcdir)/bitops.h $(top_srcdir)/misc/e2freefrag.h
> + $(srcdir)/bitops.h $(top_srcdir)/misc/e2freefrag.h \
> + $(top_srcdir)/debugfs/debugfs.h $(top_srcdir)/lib/ss/ss.h \
> + $(top_builddir)/lib/ss/ss_err.h $(top_srcdir)/debugfs/../misc/create_inode.h \
> + $(top_srcdir)/lib/e2p/e2p.h $(top_srcdir)/debugfs/../misc/nls-enable.h \
> + $(top_srcdir)/lib/quota/quotaio.h $(top_srcdir)/lib/quota/dqblk_v2.h \
> + $(top_srcdir)/lib/quota/quotaio_tree.h $(top_srcdir)/lib/../e2fsck/dict.h
>  create_inode.o: $(top_srcdir)/misc/create_inode.c \
>   $(top_srcdir)/misc/create_inode.h $(top_srcdir)/lib/et/com_err.h \
>   $(top_srcdir)/lib/e2p/e2p.h $(srcdir)/ext2_fs.h \
> @@ -1265,3 +1289,22 @@ create_inode.o: $(top_srcdir)/misc/create_inode.c \
>   $(srcdir)/ext3_extents.h $(srcdir)/ext2_io.h \
>   $(top_builddir)/lib/ext2fs/ext2_err.h $(srcdir)/ext2_ext_attr.h \
>   $(srcdir)/bitops.h $(top_srcdir)/misc/nls-enable.h
> +journal.o: $(top_srcdir)/debugfs/journal.c $(top_builddir)/lib/config.h \
> + $(top_builddir)/lib/dirpaths.h $(srcdir)/../../e2fsck/jfs_user.h \
> + $(srcdir)/ext2_fs.h $(top_builddir)/lib/ext2fs/ext2_types.h \
> + $(srcdir)/ext2fs.h $(srcdir)/ext3_extents.h $(top_srcdir)/lib/et/com_err.h \
> + $(srcdir)/ext2_io.h $(top_builddir)/lib/ext2fs/ext2_err.h \
> + $(srcdir)/ext2_ext_attr.h $(srcdir)/bitops.h $(srcdir)/kernel-jbd.h \
> + $(srcdir)/jfs_compat.h $(srcdir)/kernel-list.h
> +revoke.o: $(top_srcdir)/e2fsck/revoke.c $(top_srcdir)/e2fsck/jfs_user.h \
> + $(srcdir)/ext2_fs.h $(top_builddir)/lib/ext2fs/ext2_types.h \
> + $(srcdir)/ext2fs.h $(srcdir)/ext3_extents.h $(top_srcdir)/lib/et/com_err.h \
> + $(srcdir)/ext2_io.h $(top_builddir)/lib/ext2fs/ext2_err.h \
> + $(srcdir)/ext2_ext_attr.h $(srcdir)/bitops.h $(srcdir)/kernel-jbd.h \
> + $(srcdir)/jfs_compat.h $(srcdir)/kernel-list.h
> +recovery.o: $(top_srcdir)/e2fsck/recovery.c $(top_srcdir)/e2fsck/jfs_user.h \
> + $(srcdir)/ext2_fs.h $(top_builddir)/lib/ext2fs/ext2_types.h \
> + $(srcdir)/ext2fs.h $(srcdir)/ext3_extents.h $(top_srcdir)/lib/et/com_err.h \
> + $(srcdir)/ext2_io.h $(top_builddir)/lib/ext2fs/ext2_err.h \
> + $(srcdir)/ext2_ext_attr.h $(srcdir)/bitops.h $(srcdir)/kernel-jbd.h \
> + $(srcdir)/jfs_compat.h $(srcdir)/kernel-list.h
> diff --git a/lib/ext2fs/ext2_err.et.in b/lib/ext2fs/ext2_err.et.in
> index 6b6d8b8..790d135 100644
> --- a/lib/ext2fs/ext2_err.et.in
> +++ b/lib/ext2fs/ext2_err.et.in
> @@ -521,4 +521,7 @@ ec	EXT2_ET_INODE_IS_GARBAGE,
>  ec	EXT2_ET_EA_BAD_VALUE_OFFSET,
>  	"Extended attribute has an invalid value offset"
>  
> +ec	EXT2_ET_JOURNAL_FLAGS_WRONG,
> +	"Journal flags inconsistent"
> +
>  	end
> diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
> index b4a9f84..d931fff 100644
> --- a/lib/ext2fs/ext2fs.h
> +++ b/lib/ext2fs/ext2fs.h
> @@ -282,6 +282,9 @@ struct struct_ext2_filsys {
>  
>  	/* Precomputed FS UUID checksum for seeding other checksums */
>  	__u32 csum_seed;
> +
> +	io_channel			journal_io;
> +	char				*journal_name;
>  };
>  
>  #if EXT2_FLAT_INCLUDES
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
