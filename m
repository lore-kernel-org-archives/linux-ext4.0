From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] libext2fs: use HAVE_FSTAT64 instead of HAVE_STAT64 for ext2fs_stat()
Date: Thu, 10 Nov 2011 07:40:30 -0500
Message-ID: <1320928830-1296-1-git-send-email-tytso@mit.edu>
Cc: 647245@bugs.debian.org, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:37372 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751987Ab1KJMkd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 10 Nov 2011 07:40:33 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Commit 6b56f3d92d introduced the use of HAVE_STAT64 without arranging
that it be defined in configure.in.  Previously ext4.h used
HAVE_OPEN64, but apparently there are (broken) platforms that have
open64() but not stat64().  Go figure.

We do need to consistently use a single test for ext2fs_stat(),
ext2fs_fstat(), and struct ext2fs_struct_stat, or we could end up
passing a struct stat64 to a fstat() system call, or some such.  I've
elected to use HAVE_FSTAT64 because: (a) it's already defined in the
configure script, and (b) if we ever come across a really broken
platform that defines fstat64() but not stat64(), we can always
emulate stat64() using open64() followed by a fstat64().

This commit fixed a bug whose symptoms were that mke2fs would not work
if given a file > 2GB on 32-bit platforms.

Addresses-Debian-Bug: #647245

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 lib/ext2fs/ext2fs.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index d90c1ee..4de20c9 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -604,7 +604,7 @@ typedef struct ext2_icount *ext2_icount_t;
 #define EXT2FS_NUM_B2C(fs, blks)	(((blks) + EXT2FS_CLUSTER_MASK(fs)) >> \
 					 (fs)->cluster_ratio_bits)
 
-#if defined(HAVE_STAT64) && !defined(__OSX_AVAILABLE_BUT_DEPRECATED)
+#if defined(HAVE_FSTAT64) && !defined(__OSX_AVAILABLE_BUT_DEPRECATED)
 typedef struct stat64 ext2fs_struct_stat;
 #else
 typedef struct stat ext2fs_struct_stat;
@@ -1697,7 +1697,7 @@ _INLINE_ int ext2fs_open_file(const char *pathname, int flags, mode_t mode)
 
 _INLINE_ int ext2fs_stat(const char *path, ext2fs_struct_stat *buf)
 {
-#if defined(HAVE_STAT64) && !defined(__OSX_AVAILABLE_BUT_DEPRECATED)
+#if defined(HAVE_FSTAT64) && !defined(__OSX_AVAILABLE_BUT_DEPRECATED)
 	return stat64(path, buf);
 #else
 	return stat(path, buf);
@@ -1706,7 +1706,7 @@ _INLINE_ int ext2fs_stat(const char *path, ext2fs_struct_stat *buf)
 
 _INLINE_ int ext2fs_fstat(int fd, ext2fs_struct_stat *buf)
 {
-#if defined(HAVE_STAT64) && !defined(__OSX_AVAILABLE_BUT_DEPRECATED)
+#if defined(HAVE_FSTAT64) && !defined(__OSX_AVAILABLE_BUT_DEPRECATED)
 	return fstat64(fd, buf);
 #else
 	return fstat(fd, buf);
-- 
1.7.4.1.22.gec8e1.dirty

