From: Palmer Dabbelt <palmer@dabbelt.com>
Subject: [PATCH] Rename copy_file_range to _copy_file_range
Date: Thu, 28 Dec 2017 18:18:28 -0800
Message-ID: <20171229021828.5661-1-palmer@dabbelt.com>
Cc: patches@groups.riscv.org, Palmer Dabbelt <palmer@dabbelt.com>
To: linux-ext4@vger.kernel.org, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:32991 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751345AbdL2CTH (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 28 Dec 2017 21:19:07 -0500
Received: by mail-pf0-f196.google.com with SMTP id y89so21640585pfk.0
        for <linux-ext4@vger.kernel.org>; Thu, 28 Dec 2017 18:19:07 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

As of 2.27, glibc will have a copy_file_range library call to wrap the
new copy_file_range system call.  This conflicts with the function in
misc/create_inode.c, which this patch renames _copy_file_range.

Full disclosure: I found this when building e2fsprogs for RISC-V with a
glibc-2.27 prerelease, so it's very possible I screwed something up
here.  Here's the relevant glibc commit:

    commit bad7a0c81f501fbbcc79af9eaa4b8254441c4a1f
    Author: Florian Weimer <fweimer@redhat.com>
    Date:   Fri Dec 22 10:55:40 2017 +0100

        copy_file_range: New function to copy file data

        The semantics are based on the Linux system call, but a very close
        emulation in user space is provided.
    ...
    diff --git a/posix/unistd.h b/posix/unistd.h
    index 32b0f4898fd2..65317c79fd39 100644
    --- a/posix/unistd.h
    +++ b/posix/unistd.h
    @@ -1105,7 +1105,12 @@ extern int lockf64 (int __fd, int __cmd, __off64_t __len) __wur;
            do __result = (long int) (expression);                                \
            while (__result == -1L && errno == EINTR);                            \
            __result; }))
    -#endif
    +
    +/* Copy LENGTH bytes from INFD to OUTFD.  */
    +ssize_t copy_file_range (int __infd, __off64_t *__pinoff,
    +                        int __outfd, __off64_t *__poutoff,
    +                        size_t __length, unsigned int __flags);
    +#endif /* __USE_GNU */

Signed-off-by: Palmer Dabbelt <palmer@dabbelt.com>
---
 misc/create_inode.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/misc/create_inode.c b/misc/create_inode.c
index a07f8328e5f9..94fa13f8b3d0 100644
--- a/misc/create_inode.c
+++ b/misc/create_inode.c
@@ -398,9 +398,9 @@ static ssize_t my_pread(int fd, void *buf, size_t count, off_t offset)
 }
 #endif /* !defined HAVE_PREAD64 && !defined HAVE_PREAD */
 
-static errcode_t copy_file_range(ext2_filsys fs, int fd, ext2_file_t e2_file,
-				 off_t start, off_t end, char *buf,
-				 char *zerobuf)
+static errcode_t _copy_file_range(ext2_filsys fs, int fd, ext2_file_t e2_file,
+				  off_t start, off_t end, char *buf,
+				  char *zerobuf)
 {
 	off_t off, bpos;
 	ssize_t got, blen;
@@ -472,8 +472,8 @@ static errcode_t try_lseek_copy(ext2_filsys fs, int fd, struct stat *statbuf,
 
 		data_blk = data & ~(fs->blocksize - 1);
 		hole_blk = (hole + (fs->blocksize - 1)) & ~(fs->blocksize - 1);
-		err = copy_file_range(fs, fd, e2_file, data_blk, hole_blk, buf,
-				      zerobuf);
+		err = _copy_file_range(fs, fd, e2_file, data_blk, hole_blk, buf,
+				       zerobuf);
 		if (err)
 			return err;
 
@@ -523,9 +523,9 @@ static errcode_t try_fiemap_copy(ext2_filsys fs, int fd, ext2_file_t e2_file,
 			goto out;
 		for (i = 0, ext = ext_buf; i < fiemap_buf->fm_mapped_extents;
 		     i++, ext++) {
-			err = copy_file_range(fs, fd, e2_file, ext->fe_logical,
-					      ext->fe_logical + ext->fe_length,
-					      buf, zerobuf);
+			err = _copy_file_range(fs, fd, e2_file, ext->fe_logical,
+					       ext->fe_logical + ext->fe_length,
+					       buf, zerobuf);
 			if (err)
 				goto out;
 		}
@@ -576,8 +576,8 @@ static errcode_t copy_file(ext2_filsys fs, int fd, struct stat *statbuf,
 		goto out;
 #endif
 
-	err = copy_file_range(fs, fd, e2_file, 0, statbuf->st_size, buf,
-			      zerobuf);
+	err = _copy_file_range(fs, fd, e2_file, 0, statbuf->st_size, buf,
+			       zerobuf);
 out:
 	ext2fs_free_mem(&zerobuf);
 	ext2fs_free_mem(&buf);
-- 
2.13.6
