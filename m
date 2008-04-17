From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 1/5] Fix tst_extents build
Date: Thu, 17 Apr 2008 16:58:22 -0400
Message-ID: <20080417205822.GI3063@mit.edu>
References: <1207623660-1088-1-git-send-email-sandeen@redhat.com> <1207623660-1088-2-git-send-email-sandeen@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:35749 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754171AbYDQWPk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 17 Apr 2008 18:15:40 -0400
Content-Disposition: inline
In-Reply-To: <1207623660-1088-2-git-send-email-sandeen@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Apr 07, 2008 at 10:00:56PM -0500, Eric Sandeen wrote:
> tst_extents needs libdl & libuuid to build, for me
> 
> @@ -312,7 +312,7 @@ tst_extents: $(srcdir)/extent.c extent_dbg.c $(DEBUG_OBJS) $(LIBSS) $(LIBE2P) $(
>  	@$(CC) -o tst_extents $(srcdir)/extent.c extent_dbg.c \
>  		$(ALL_CFLAGS) -DDEBUG $(DEBUG_OBJS) $(LIBSS) $(LIBE2P) \
>  		$(LIBUUID) $(STATIC_LIBEXT2FS) $(LIBBLKID) $(LIBCOM_ERR) \
> -		-I $(top_srcdir)/debugfs
> +		-I $(top_srcdir)/debugfs -ldl -luuid

Thanks for pointing this out; my development environment I always
build with elf shared libraries enabled, so I didn't notice this
problem.

$(LIBUUID) was already included, but in the wrong place.  So it was
just a matter of reordering the library link order.

This is the fixed I ultimately checked in.

						- Ted

commit daf7a6e5d1621d4d84feabedb286e23dc5ad7dbb
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Thu Apr 17 16:54:24 2008 -0400

    Fix tst_extents build when building w/o dynamic libraries
    
    $(LIBSS) should automatically include @DLOPEN_LIB@ so the right thing
    happens for programs that need to use the ss library.
    
    Reorder the library link order for tst_extents since the blkid library
    uses libuuid functions.
    
    Thanks to Eric Sandeen for pointing this problem out!
    
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

diff --git a/MCONFIG.in b/MCONFIG.in
index 8cd2ccf..80ddbd8 100644
--- a/MCONFIG.in
+++ b/MCONFIG.in
@@ -72,7 +72,7 @@ DEVMAPPER_LIBS = @DEVMAPPER_LIBS@
 STATIC_DEVMAPPER_LIBS = @STATIC_DEVMAPPER_LIBS@
 
 LIB = $(top_builddir)/lib
-LIBSS = $(LIB)/libss@LIB_EXT@
+LIBSS = $(LIB)/libss@LIB_EXT@ @DLOPEN_LIB@
 LIBCOM_ERR = $(LIB)/libcom_err@LIB_EXT@
 LIBE2P = $(LIB)/libe2p@LIB_EXT@
 LIBEXT2FS = $(LIB)/libext2fs@LIB_EXT@
@@ -82,7 +82,7 @@ LIBINTL = @LIBINTL@
 DEPLIBUUID = $(LIB)/libuuid@LIB_EXT@
 DEPLIBBLKID = $(LIB)/libblkid@LIB_EXT@
 
-STATIC_LIBSS = $(LIB)/libss@STATIC_LIB_EXT@
+STATIC_LIBSS = $(LIB)/libss@STATIC_LIB_EXT@ @DLOPEN_LIB@
 STATIC_LIBCOM_ERR = $(LIB)/libcom_err@STATIC_LIB_EXT@
 STATIC_LIBE2P = $(LIB)/libe2p@STATIC_LIB_EXT@
 STATIC_LIBEXT2FS = $(LIB)/libext2fs@STATIC_LIB_EXT@
@@ -91,7 +91,7 @@ STATIC_LIBBLKID = $(LIB)/libblkid@STATIC_LIB_EXT@ $(STATIC_DEVMAPPER_LIBS)
 DEPSTATIC_LIBUUID = $(LIB)/libuuid@STATIC_LIB_EXT@
 DEPSTATIC_LIBBLKID = $(LIB)/libblkid@STATIC_LIB_EXT@
 
-PROFILED_LIBSS = $(LIB)/libss@PROFILED_LIB_EXT@
+PROFILED_LIBSS = $(LIB)/libss@PROFILED_LIB_EXT@ @DLOPEN_LIB@
 PROFILED_LIBCOM_ERR = $(LIB)/libcom_err@PROFILED_LIB_EXT@
 PROFILED_LIBE2P = $(LIB)/libe2p@PROFILED_LIB_EXT@
 PROFILED_LIBEXT2FS = $(LIB)/libext2fs@PROFILED_LIB_EXT@
diff --git a/debugfs/Makefile.in b/debugfs/Makefile.in
index bdba326..cb3efcb 100644
--- a/debugfs/Makefile.in
+++ b/debugfs/Makefile.in
@@ -8,7 +8,6 @@ VPATH = @srcdir@
 top_builddir = ..
 my_dir = debugfs
 INSTALL = @INSTALL@
-DLOPEN_LIB = @DLOPEN_LIB@
 
 @MCONFIG@
 
@@ -26,7 +25,7 @@ SRCS= debug_cmds.c $(srcdir)/debugfs.c $(srcdir)/util.c $(srcdir)/ls.c \
 	$(srcdir)/htree.c $(srcdir)/unused.c
 
 LIBS= $(LIBEXT2FS) $(LIBE2P) $(LIBSS) $(LIBCOM_ERR) $(LIBBLKID) \
-	$(LIBUUID) $(DLOPEN_LIB)
+	$(LIBUUID)
 DEPLIBS= $(LIBEXT2FS) $(LIBE2P) $(LIBSS) $(LIBCOM_ERR) $(DEPLIBBLKID) $(DEPLIBUUID)
 
 .c.o:
diff --git a/lib/ext2fs/Makefile.in b/lib/ext2fs/Makefile.in
index 677e2d6..b5f67e6 100644
--- a/lib/ext2fs/Makefile.in
+++ b/lib/ext2fs/Makefile.in
@@ -305,7 +305,7 @@ tst_extents: $(srcdir)/extent.c extent_dbg.c $(DEBUG_OBJS) $(LIBSS) $(LIBE2P) $(
 	@echo "	LD $@"
 	@$(CC) -o tst_extents $(srcdir)/extent.c extent_dbg.c \
 		$(ALL_CFLAGS) -DDEBUG $(DEBUG_OBJS) $(LIBSS) $(LIBE2P) \
-		$(LIBUUID) $(STATIC_LIBEXT2FS) $(LIBBLKID) $(LIBCOM_ERR) \
+		$(STATIC_LIBEXT2FS) $(LIBBLKID) $(LIBUUID) $(LIBCOM_ERR) \
 		-I $(top_srcdir)/debugfs
 
 tst_csum: tst_csum.c csum.c $(STATIC_LIBEXT2FS)
