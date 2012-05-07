From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 5/5] Support systems without posix_memalign() and memalign()
Date: Mon,  7 May 2012 14:56:25 -0400
Message-ID: <1336416985-24605-6-git-send-email-tytso@mit.edu>
References: <1336416985-24605-1-git-send-email-tytso@mit.edu>
Cc: ksumrall@google.com, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:38757 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751053Ab2EGS42 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 7 May 2012 14:56:28 -0400
In-Reply-To: <1336416985-24605-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

MacOS 10.5 doesn't have posix_memalign() nor memalign(), but it does
have valloc().  The Android SDK would like to be built on MacOS 10.5,
so I've added support for a good-enough emulation of memalign()'s
functionality using valloc(), with an explicit test to make sure
valloc() is returning a pointer which is sufficiently aligned given
the requested alignment.  This won't work if you try to operate on a
file system with a 16k blocksize using an e2fsprogs built on MacOS
10.5 system, but it is good enough for the common case of 4k
blocksize file systems, and we will let the memory allocation fail in
the alignment is not good enough.

I've also added a unit test for ext2fs_get_memalign() so we can be
sure it's working as expected.  I've tested the code paths with
HAVE_POSIX_MEMALIGN defined, HAVE_POSIX_MEMALIGN undefined, and
HAVE_POSIX_MEMALIGN and HAVE_MEMALIGN undefined on an x86 Linux
system, and so I know the valloc() code path works OK.  The simplistic
(and less safe) patch at:

https://trac.macports.org/attachment/ticket/33692/patch-lib-ext2fs-inline.c.diff

Shows that using valloc() apparently works OK for MacOS 10.5 (but if
it doesn't the unit test will catch a problem).

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 lib/ext2fs/Makefile.in |    9 +++++++-
 lib/ext2fs/inline.c    |   56 ++++++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 62 insertions(+), 3 deletions(-)

diff --git a/lib/ext2fs/Makefile.in b/lib/ext2fs/Makefile.in
index 507a459..f9200fa 100644
--- a/lib/ext2fs/Makefile.in
+++ b/lib/ext2fs/Makefile.in
@@ -369,6 +369,11 @@ tst_extents: $(srcdir)/extent.c extent_dbg.c $(DEBUG_OBJS) $(DEPLIBSS) \
 		$(STATIC_LIBEXT2FS) $(LIBBLKID) $(LIBUUID) $(LIBCOM_ERR) \
 		-I $(top_srcdir)/debugfs
 
+tst_inline: $(srcdir)/inline.c $(STATIC_LIBEXT2FS) $(DEPLIBCOM_ERR)
+	$(E) "	LD $@"
+	$(Q) $(CC) -o tst_inline $(srcdir)/inline.c $(ALL_CFLAGS) -DDEBUG \
+		$(STATIC_LIBEXT2FS) $(LIBCOM_ERR)
+
 tst_csum: csum.c $(STATIC_LIBEXT2FS) $(DEPLIBCOM_ERR) \
 		$(top_srcdir)/lib/e2p/e2p.h
 	$(E) "	LD $@"
@@ -384,7 +389,8 @@ mkjournal: mkjournal.c $(STATIC_LIBEXT2FS) $(DEPLIBCOM_ERR)
 	$(Q) $(CC) -o mkjournal $(srcdir)/mkjournal.c -DDEBUG $(STATIC_LIBEXT2FS) $(LIBCOM_ERR) $(ALL_CFLAGS)
 
 check:: tst_bitops tst_badblocks tst_iscan tst_types tst_icount \
-    tst_super_size tst_types tst_inode_size tst_csum tst_crc32c tst_bitmaps
+    tst_super_size tst_types tst_inode_size tst_csum tst_crc32c tst_bitmaps \
+    tst_inline
 	LD_LIBRARY_PATH=$(LIB) DYLD_LIBRARY_PATH=$(LIB) ./tst_bitops
 	LD_LIBRARY_PATH=$(LIB) DYLD_LIBRARY_PATH=$(LIB) ./tst_badblocks
 	LD_LIBRARY_PATH=$(LIB) DYLD_LIBRARY_PATH=$(LIB) ./tst_iscan
@@ -393,6 +399,7 @@ check:: tst_bitops tst_badblocks tst_iscan tst_types tst_icount \
 	LD_LIBRARY_PATH=$(LIB) DYLD_LIBRARY_PATH=$(LIB) ./tst_super_size
 	LD_LIBRARY_PATH=$(LIB) DYLD_LIBRARY_PATH=$(LIB) ./tst_inode_size
 	LD_LIBRARY_PATH=$(LIB) DYLD_LIBRARY_PATH=$(LIB) ./tst_csum
+	LD_LIBRARY_PATH=$(LIB) DYLD_LIBRARY_PATH=$(LIB) ./tst_inline
 	LD_LIBRARY_PATH=$(LIB) DYLD_LIBRARY_PATH=$(LIB) ./tst_crc32c
 	LD_LIBRARY_PATH=$(LIB) DYLD_LIBRARY_PATH=$(LIB) \
 		./tst_bitmaps -f $(srcdir)/tst_bitmaps_cmds > tst_bitmaps_out
diff --git a/lib/ext2fs/inline.c b/lib/ext2fs/inline.c
index ad0c368..335db55 100644
--- a/lib/ext2fs/inline.c
+++ b/lib/ext2fs/inline.c
@@ -45,7 +45,7 @@ errcode_t ext2fs_get_memalign(unsigned long size,
 	errcode_t retval;
 	void **p = ptr;
 
-	if (align == 0)
+	if (align < 8)
 		align = 8;
 #ifdef HAVE_POSIX_MEMALIGN
 	retval = posix_memalign(p, align, size);
@@ -64,9 +64,61 @@ errcode_t ext2fs_get_memalign(unsigned long size,
 			return EXT2_ET_NO_MEMORY;
 	}
 #else
-#error memalign or posix_memalign must be defined!
+#ifdef HAVE_VALLOC
+	if (align > sizeof(long long))
+		*p = valloc(size);
+	else
+#endif
+		*p = malloc(size);
+	if ((unsigned long) *p & (align - 1)) {
+		free(*p);
+		*p = 0;
+	}
+	if (*p == 0)
+		return EXT2_ET_NO_MEMORY;
 #endif
 #endif
 	return 0;
 }
 
+#ifdef DEBUG
+static int isaligned(void *ptr, unsigned long align)
+{
+	return (((unsigned long) ptr & (align - 1)) == 0);
+}
+
+static errcode_t test_memalign(unsigned long align)
+{
+	void *ptr = 0;
+	errcode_t retval;
+
+	retval = ext2fs_get_memalign(32, align, &ptr);
+	if (!retval && !isaligned(ptr, align))
+		retval = EINVAL;
+	free(ptr);
+	printf("tst_memliagn(%lu): %s\n", align, 
+	       retval ? error_message(retval) : "OK");
+	return retval;
+}
+
+int main(int argc, char **argv)
+{
+	int err = 0;
+
+	if (test_memalign(4))
+		err++;
+	if (test_memalign(32))
+		err++;
+	if (test_memalign(1024))
+		err++;
+	if (test_memalign(4096))
+		err++;
+#if defined(HAVE_POSIX_MEMALIGN) || defined(HAVE_MEMALIGN)
+	if (test_memalign(16384))
+		err++;
+	if (test_memalign(32768))
+		err++;
+#endif
+	return err;
+}
+#endif
-- 
1.7.10.rc3

