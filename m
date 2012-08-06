From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Exciting :-( adventures in metadata checksumming
Date: Mon, 6 Aug 2012 12:47:00 -0400
Message-ID: <20120806164700.GA7896@thunk.org>
References: <20120804221217.GE4724@thunk.org>
 <20120804224139.23096.qmail@science.horizon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: George Spelvin <linux@horizon.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:43284 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756712Ab2HFQrF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 6 Aug 2012 12:47:05 -0400
Content-Disposition: inline
In-Reply-To: <20120804224139.23096.qmail@science.horizon.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Aug 04, 2012 at 06:41:39PM -0400, George Spelvin wrote:
> > commit 037b728b8a6a775e9a5e03fd24b1008d633c1cb4
> > Author: Theodore Ts'o <tytso@mit.edu>
> > Date:   Sat Aug 4 16:56:55 2012 -0400
> >
> >     Put ELF_OTHER_LIBS in the right place for the linker
> 
> Thanks for the update.  That produces (following your procedure from
> the previous e-mail exactly, modulo directory names) a *different* error...

Oops.  Sorry, I screwed up that last patch, because I forgot that we
were in the elfshared directory.  Since I had comerr-dev, et. al.,
installed, I didn't notice because I was just linking against the
system libraries.  Thanks for testing and pointing out this!

Here's a replacement patch which should work; I've tested it after
deleting comerr-dev, e2fslibs-dev, etc., and it works, so I'm pretty
confident I got it right this time.

Regards,

						- Ted

commit d5aa6a82b37a0e78d8882601e6ad9da9d9dcb4da
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Sat Aug 4 16:56:55 2012 -0400

    Put ELF_OTHER_LIBS in the right place for the linker
    
    Commit a7c17431b9 attempted to fix a problem where the system
    libraries might get used instead of local libraries for things like
    -lcom_err.  It tried to accomplish this by moving $(ELF_OTHER_LIBS) to
    before $(LDFLAGS).
    
    Unfortunately, this was the wrong fix; $(ELF_OTHER_LIBS) *MUST* be
    after the object files, or the linker might not pull in the necessary
    library and not include it into the DT_NEEDED section of the shared
    library.  The proper fix is to add a -L$(LIB) before $(LDFLAGS), and
    then remove the -L option from all of the ELF_OTHER_LIBS definitions
    in the library Makefiles.
    
    Addresses-Sourceforge-Bug: #3554345
    
    Cc: Olivier Blin <olivier.blin@softathome.com>
    Reported-by:  Mike Frysinger <vapier@gentoo.org>
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

diff --git a/lib/Makefile.elf-lib b/lib/Makefile.elf-lib
index c66281c..78479d3 100644
--- a/lib/Makefile.elf-lib
+++ b/lib/Makefile.elf-lib
@@ -24,8 +24,9 @@ image:		$(ELF_LIB)
 
 $(ELF_LIB): $(OBJS)
 	$(E) "	GEN_ELF_SOLIB $(ELF_LIB)"
-	$(Q) (cd elfshared; $(CC) --shared -o $(ELF_LIB) $(ELF_OTHER_LIBS) \
-		$(LDFLAGS) -Wl,-soname,$(ELF_SONAME) $(OBJS))
+	$(Q) (cd elfshared; $(CC) --shared -o $(ELF_LIB) \
+		-L$(top_builddir)/../lib $(LDFLAGS) \
+		-Wl,-soname,$(ELF_SONAME) $(OBJS) $(ELF_OTHER_LIBS))
 	$(Q) $(MV) elfshared/$(ELF_LIB) .
 	$(Q) $(RM) -f ../$(ELF_LIB) ../$(ELF_IMAGE).so ../$(ELF_SONAME)
 	$(Q) (cd ..; $(LN) $(LINK_BUILD_FLAGS) \
diff --git a/lib/Makefile.solaris-lib b/lib/Makefile.solaris-lib
index 66f2b4c..5990be8 100644
--- a/lib/Makefile.solaris-lib
+++ b/lib/Makefile.solaris-lib
@@ -24,8 +24,9 @@ image:		$(ELF_LIB)
 
 $(ELF_LIB): $(OBJS)
 	$(E) "	GEN_ELF_SOLIB $(ELF_LIB)"
-	$(Q) (cd elfshared; $(CC) --shared -o $(ELF_LIB) $(ELF_OTHER_LIBS) \
-		$(LDFLAGS) -Wl,-h,$(ELF_SONAME) $(OBJS))
+	$(Q) (cd elfshared; $(CC) --shared -o $(ELF_LIB) \
+		-L$(top_builddir)/../lib $(LDFLAGS) \
+		-Wl,-h,$(ELF_SONAME) $(OBJS) $(ELF_OTHER_LIBS))
 	$(Q) $(MV) elfshared/$(ELF_LIB) .
 	$(Q) $(RM) -f ../$(ELF_LIB) ../$(ELF_IMAGE).so ../$(ELF_SONAME)
 	$(Q) (cd ..; $(LN) $(LINK_BUILD_FLAGS) \
diff --git a/lib/blkid/Makefile.in b/lib/blkid/Makefile.in
index f23a137..0ec8564 100644
--- a/lib/blkid/Makefile.in
+++ b/lib/blkid/Makefile.in
@@ -36,7 +36,7 @@ ELF_SO_VERSION = 1
 ELF_IMAGE = libblkid
 ELF_MYDIR = blkid
 ELF_INSTALL_DIR = $(root_libdir)
-ELF_OTHER_LIBS = -L../.. -luuid
+ELF_OTHER_LIBS = -luuid
 
 BSDLIB_VERSION = 2.0
 BSDLIB_IMAGE = libblkid
diff --git a/lib/ext2fs/Makefile.in b/lib/ext2fs/Makefile.in
index 0d9ac21..fc196fb 100644
--- a/lib/ext2fs/Makefile.in
+++ b/lib/ext2fs/Makefile.in
@@ -180,7 +180,7 @@ ELF_SO_VERSION = 2
 ELF_IMAGE = libext2fs
 ELF_MYDIR = ext2fs
 ELF_INSTALL_DIR = $(root_libdir)
-ELF_OTHER_LIBS = -L../.. -lcom_err
+ELF_OTHER_LIBS = -lcom_err
 
 BSDLIB_VERSION = 2.1
 BSDLIB_IMAGE = libext2fs
diff --git a/lib/quota/Makefile.in b/lib/quota/Makefile.in
index 2851eac..720befd 100644
--- a/lib/quota/Makefile.in
+++ b/lib/quota/Makefile.in
@@ -31,7 +31,7 @@ LIBDIR= quota
 #ELF_IMAGE = libquota
 #ELF_MYDIR = quota
 #ELF_INSTALL_DIR = $(root_libdir)
-#ELF_OTHER_LIBS = -L../.. -lext2fs
+#ELF_OTHER_LIBS = -lext2fs
 
 #BSDLIB_VERSION = 1.0
 #BSDLIB_IMAGE = libquota
diff --git a/lib/ss/Makefile.in b/lib/ss/Makefile.in
index 19413cc..c396f2d 100644
--- a/lib/ss/Makefile.in
+++ b/lib/ss/Makefile.in
@@ -20,7 +20,7 @@ ELF_SO_VERSION = 2
 ELF_IMAGE = libss
 ELF_MYDIR = ss
 ELF_INSTALL_DIR = $(root_libdir)
-ELF_OTHER_LIBS = -L../.. -lcom_err $(DLOPEN_LIB)
+ELF_OTHER_LIBS = -lcom_err $(DLOPEN_LIB)
 
 BSDLIB_VERSION = 1.0
 BSDLIB_IMAGE = libss
