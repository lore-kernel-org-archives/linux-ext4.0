From: Palmer Dabbelt <palmer@dabbelt.com>
Subject: [PATCH v2] Rename copy_file_range to copy_file_chunk
Date: Fri, 29 Dec 2017 10:19:51 -0800
Message-ID: <20171229181951.24886-1-palmer@dabbelt.com>
References: <20171229035539.GB11757@thunk.org>
Cc: patches@groups.riscv.org, Palmer Dabbelt <palmer@dabbelt.com>
To: linux-ext4@vger.kernel.org, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pl0-f67.google.com ([209.85.160.67]:42791 "EHLO
        mail-pl0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751748AbdL2SU0 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 29 Dec 2017 13:20:26 -0500
Received: by mail-pl0-f67.google.com with SMTP id bd8so23342514plb.9
        for <linux-ext4@vger.kernel.org>; Fri, 29 Dec 2017 10:20:26 -0800 (PST)
In-Reply-To: <20171229035539.GB11757@thunk.org>
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

Changes since v1:

* The new name is now copy_file_chunk instead of _copy_file_range.

Signed-off-by: Palmer Dabbelt <palmer@dabbelt.com>
---
 misc/create_inode.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/misc/create_inode.c b/misc/create_inode.c
index a07f8328e5f9..51d25f8fb005 100644
--- a/misc/create_inode.c
+++ b/misc/create_inode.c
@@ -398,7 +398,7 @@ static ssize_t my_pread(int fd, void *buf, size_t count, off_t offset)
 }
 #endif /* !defined HAVE_PREAD64 && !defined HAVE_PREAD */
 
-static errcode_t copy_file_range(ext2_filsys fs, int fd, ext2_file_t e2_file,
+static errcode_t copy_file_chunk(ext2_filsys fs, int fd, ext2_file_t e2_file,
 				 off_t start, off_t end, char *buf,
 				 char *zerobuf)
 {
@@ -472,7 +472,7 @@ static errcode_t try_lseek_copy(ext2_filsys fs, int fd, struct stat *statbuf,
 
 		data_blk = data & ~(fs->blocksize - 1);
 		hole_blk = (hole + (fs->blocksize - 1)) & ~(fs->blocksize - 1);
-		err = copy_file_range(fs, fd, e2_file, data_blk, hole_blk, buf,
+		err = copy_file_chunk(fs, fd, e2_file, data_blk, hole_blk, buf,
 				      zerobuf);
 		if (err)
 			return err;
@@ -523,7 +523,7 @@ static errcode_t try_fiemap_copy(ext2_filsys fs, int fd, ext2_file_t e2_file,
 			goto out;
 		for (i = 0, ext = ext_buf; i < fiemap_buf->fm_mapped_extents;
 		     i++, ext++) {
-			err = copy_file_range(fs, fd, e2_file, ext->fe_logical,
+			err = copy_file_chunk(fs, fd, e2_file, ext->fe_logical,
 					      ext->fe_logical + ext->fe_length,
 					      buf, zerobuf);
 			if (err)
@@ -576,7 +576,7 @@ static errcode_t copy_file(ext2_filsys fs, int fd, struct stat *statbuf,
 		goto out;
 #endif
 
-	err = copy_file_range(fs, fd, e2_file, 0, statbuf->st_size, buf,
+	err = copy_file_chunk(fs, fd, e2_file, 0, statbuf->st_size, buf,
 			      zerobuf);
 out:
 	ext2fs_free_mem(&zerobuf);
-- 
2.13.6
