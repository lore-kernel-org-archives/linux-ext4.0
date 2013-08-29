From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: resize2fs: Memory allocation failed while trying to resize
Date: Thu, 29 Aug 2013 19:24:37 -0400
Message-ID: <20130829232437.GA3200@thunk.org>
References: <CA+3zgmtOoDGSGQrk4k3QNuAkgpoDgF+xUkFT5qY9cKKS76MiQQ@mail.gmail.com>
 <521F710E.7000409@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tim <elatllat@gmail.com>, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:51657 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753050Ab3H2XYm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 29 Aug 2013 19:24:42 -0400
Content-Disposition: inline
In-Reply-To: <521F710E.7000409@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Aug 29, 2013 at 11:04:30AM -0500, Eric Sandeen wrote:
> You might use gdb, or an instrumented resize2fs, to find out which memory
> allocation is failing and/or where the memory allocations are going.
> The sad truth may just be that 256M + 512M swap isn't going to do the
> trick.

You might try applying the following patch to the e2fsprogs sources,
compiling it with "make CFLAGS=-g" so debuging information is enabled,
and optimizations are disabled, and then running resize2fs under gdb,
after setting a breakpoint at the function, ext2fs_breakpoint().  That
will tell us where it's crashing, which might be of academic interest,
but as Eric has said (and as I have commented on the Ubuntu launchpad
website), it may be extremely unrealistic to expect this to work.

Oh, also try running resize2fs with the options "-p -d 31" and
redirect the output to a file.  This will give us more information
about how far it got before it ran out of memory.

Cheers,

					- Ted

diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index ff088bb..58074ea 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -1462,6 +1462,8 @@ extern int ext2fs_open_file(const char *pathname, int flags, mode_t mode);
 extern int ext2fs_stat(const char *path, ext2fs_struct_stat *buf);
 extern int ext2fs_fstat(int fd, ext2fs_struct_stat *buf);
 
+extern void ext2fs_breakpoint(void);
+
 /*
  * The actual inlined functions definitions themselves...
  *
@@ -1489,8 +1491,10 @@ _INLINE_ errcode_t ext2fs_get_mem(unsigned long size, void *ptr)
 	void *pp;
 
 	pp = malloc(size);
-	if (!pp)
+	if (!pp) {
+		ext2fs_breakpoint();
 		return EXT2_ET_NO_MEMORY;
+	}
 	memcpy(ptr, &pp, sizeof (pp));
 	return 0;
 }
@@ -1500,8 +1504,10 @@ _INLINE_ errcode_t ext2fs_get_memzero(unsigned long size, void *ptr)
 	void *pp;
 
 	pp = malloc(size);
-	if (!pp)
+	if (!pp) {
+		ext2fs_breakpoint();
 		return EXT2_ET_NO_MEMORY;
+	}
 	memset(pp, 0, size);
 	memcpy(ptr, &pp, sizeof(pp));
 	return 0;
@@ -1554,8 +1560,10 @@ _INLINE_ errcode_t ext2fs_resize_mem(unsigned long EXT2FS_ATTR((unused)) old_siz
 	 * with C99 strict type aliasing rules. */
 	memcpy(&p, ptr, sizeof(p));
 	p = realloc(p, size);
-	if (!p)
+	if (!p) {
+		ext2fs_breakpoint();
 		return EXT2_ET_NO_MEMORY;
+	}
 	memcpy(ptr, &p, sizeof(p));
 	return 0;
 }
diff --git a/lib/ext2fs/inline.c b/lib/ext2fs/inline.c
index eef3dda..9ab1c67 100644
--- a/lib/ext2fs/inline.c
+++ b/lib/ext2fs/inline.c
@@ -37,6 +37,10 @@
 #define INCLUDE_INLINE_FUNCS
 #include "ext2fs.h"
 
+void ext2fs_breakpoint(void)
+{
+}
+
 /*
  * We used to define this as an inline, but since we are now using
  * autoconf-defined #ifdef's, we need to export this as a
