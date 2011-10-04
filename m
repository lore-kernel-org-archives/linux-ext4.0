From: Ted Ts'o <tytso@mit.edu>
Subject: Re: e2fsprogs: use ALL_CFLAGS to build gen_crc32ctable
Date: Mon, 3 Oct 2011 23:02:32 -0400
Message-ID: <20111004030232.GA28372@thunk.org>
References: <4E89DF57.90806@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:45602 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753502Ab1JDDCe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 3 Oct 2011 23:02:34 -0400
Content-Disposition: inline
In-Reply-To: <4E89DF57.90806@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 03, 2011 at 06:14:15AM -0000, Eric Sandeen wrote:
> With just BUILD_CFLAGS this we don't get the right include
> paths (i.e. within the tree) to build the gen_crc32ctable binary.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

We can't use ALL_CFLAGS because in the cross compilation case, it
might contain some compiler directives that make sense for the target
platform, but not for the host platform.  BUILD_CFLAGS is specifically
designed for this case.  For programs like gen_crc32ctable that need
to compiled and run on the host OS, you have to do the following so
the right thing happens when you are cross-compiling e2fsprogs (yes,
there are people who do this!):

gen_crc32ctable: $(srcdir)/gen_crc32ctable.c
	$(E) "	CC $@"
	$(Q) $(BUILD_CC) $(BUILD_CFLAGS) -o gen_crc32ctable \
		$(srcdir)/gen_crc32ctable.c

Note the use of $(BUILD_CC) instead of $(CC).

The better fix is to note that gen_crc32ctable doesn't actually need
anything from ext2fs.h, and move that #include to crc32c.c.

	      		    	      - Ted

commit 8232f2ddaece256afd323eb5a289a5ec1b7fbd1a
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Mon Oct 3 22:49:45 2011 -0400

    libext2fs: move #include "ext2fs.h" from crc32c_defs.h to crc32c.c
    
    The byte swap functions which are defined in ext2fs.h are only needed
    by crc32.c, and not by gen_crc32ctable.c.  The gen_crc32ctable program
    needs to be compiled on the host OS, where ext2fs.h may not be
    present.  So move the use of the header function to crc32c.c, to avoid
    compilation problems.
    
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

diff --git a/lib/ext2fs/crc32c.c b/lib/ext2fs/crc32c.c
index 65bca5c..6be4336 100644
--- a/lib/ext2fs/crc32c.c
+++ b/lib/ext2fs/crc32c.c
@@ -40,6 +40,23 @@
 #define PTR_ALIGN(p, a)		((typeof(p))ALIGN((unsigned long)(p), (a)))
 #include "crc32c_defs.h"
 
+#include "ext2fs.h"
+#ifdef WORDS_BIGENDIAN
+#define __constant_cpu_to_le32(x) ___constant_swab32((x))
+#define __constant_cpu_to_be32(x) (x)
+#define __be32_to_cpu(x) (x)
+#define __cpu_to_be32(x) (x)
+#define __cpu_to_le32(x) (ext2fs_cpu_to_le32((x)))
+#define __le32_to_cpu(x) (ext2fs_le32_to_cpu((x)))
+#else
+#define __constant_cpu_to_le32(x) (x)
+#define __constant_cpu_to_be32(x) ___constant_swab32((x))
+#define __be32_to_cpu(x) (ext2fs_be32_to_cpu((x)))
+#define __cpu_to_be32(x) (ext2fs_cpu_to_be32((x)))
+#define __cpu_to_le32(x) (x)
+#define __le32_to_cpu(x) (x)
+#endif
+
 #if CRC_LE_BITS > 8
 # define tole(x) (__force uint32_t) __constant_cpu_to_le32(x)
 #else
diff --git a/lib/ext2fs/crc32c_defs.h b/lib/ext2fs/crc32c_defs.h
index ced4f67..023f2c0 100644
--- a/lib/ext2fs/crc32c_defs.h
+++ b/lib/ext2fs/crc32c_defs.h
@@ -42,23 +42,6 @@
 		(((uint32_t)(x) & (uint32_t)0xff000000UL) >> 24)))
 
 
-#include "ext2fs.h"
-#ifdef WORDS_BIGENDIAN
-#define __constant_cpu_to_le32(x) ___constant_swab32((x))
-#define __constant_cpu_to_be32(x) (x)
-#define __be32_to_cpu(x) (x)
-#define __cpu_to_be32(x) (x)
-#define __cpu_to_le32(x) (ext2fs_cpu_to_le32((x)))
-#define __le32_to_cpu(x) (ext2fs_le32_to_cpu((x)))
-#else
-#define __constant_cpu_to_le32(x) (x)
-#define __constant_cpu_to_be32(x) ___constant_swab32((x))
-#define __be32_to_cpu(x) (ext2fs_be32_to_cpu((x)))
-#define __cpu_to_be32(x) (ext2fs_cpu_to_be32((x)))
-#define __cpu_to_le32(x) (x)
-#define __le32_to_cpu(x) (x)
-#endif
