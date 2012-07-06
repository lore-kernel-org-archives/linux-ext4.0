From: Andreas Dilger <adilger@whamcloud.com>
Subject: [PATCH] build: add generated files to .gitignore
Date: Thu,  5 Jul 2012 19:44:51 -0600
Message-ID: <1341539091-97716-1-git-send-email-adilger@whamcloud.com>
Cc: linux-ext4@vger.kernel.org, Andreas Dilger <adilger@whamcloud.com>,
	Andreas Dilger <adilger@dilger.ca>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:7452 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756235Ab2GFBox (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 5 Jul 2012 21:44:53 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Add a batch of files/wildcards to the list of ignored files, so
that "git status" does not show so many files that should be ignored.
The "*.dSYM" directories are generated during building on MacOS.

Signed-off-by: Andreas Dilger <adilger@dilger.ca>
---
 .gitignore | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/.gitignore b/.gitignore
index 588c9e7..328df77 100644
--- a/.gitignore
+++ b/.gitignore
@@ -5,12 +5,16 @@ build.static
 FILES
 ^core
 *~
-.pc
 patches
 Makefile
+*.bak
+*.dSYM
 *.o
 *.orig
+*.pc
+*.rej
 *.swp
+00[0-9][1-9]*.patch
 MCONFIG
 asm_types.h
 config.log
@@ -53,6 +57,7 @@ lib/blkid/subdirs
 lib/blkid/test_probe
 lib/blkid/tests/*.ok
 lib/blkid/tests/*.out
+lib/blkid/tests/tmp
 lib/blkid/tst_cache
 lib/blkid/tst_dev
 lib/blkid/tst_devname
@@ -64,6 +69,8 @@ lib/blkid/tst_resolve
 lib/blkid/tst_save
 lib/blkid/tst_tag
 lib/blkid/tst_types
+lib/config.h
+lib/dirpaths.h
 lib/e2p/e2p.pc
 lib/e2p/libe2p.a
 lib/e2p/subdirs
@@ -73,17 +80,25 @@ lib/et/com_err.pc
 lib/et/compile_et
 lib/et/libcom_err.a
 lib/et/subdirs
+lib/ext2fs/crc32c_table.h
 lib/ext2fs/ext2_err.c
 lib/ext2fs/ext2_err.et
 lib/ext2fs/ext2_err.h
 lib/ext2fs/ext2_types.h
 lib/ext2fs/ext2fs.pc
+lib/ext2fs/gen_crc32ctable
 lib/ext2fs/libext2fs.a
 lib/ext2fs/subdirs
 lib/ext2fs/tst_badblocks
+lib/ext2fs/tst_bitmaps
+lib/ext2fs/tst_bitmaps_cmd.c
+lib/ext2fs/tst_bitmaps_out
 lib/ext2fs/tst_bitops
 lib/ext2fs/tst_csum
+lib/ext2fs/tst_crc32c
 lib/ext2fs/tst_icount
+lib/ext2fs/tst_inline
+lib/ext2fs/tst_inode_size
 lib/ext2fs/tst_iscan
 lib/ext2fs/tst_super_size
 lib/ext2fs/tst_types
@@ -91,8 +106,11 @@ lib/libblkid.a
 lib/libcom_err.a
 lib/libe2p.a
 lib/libext2fs.a
+lib/libquota.a
 lib/libss.a
 lib/libuuid.a
+lib/quota/libquota.a
+lib/quota/subdirs
 lib/ss/libss.a
 lib/ss/mk_cmds
 lib/ss/ss.pc
@@ -153,10 +171,12 @@ misc/lsattr.1
 misc/mke2fs
 misc/mke2fs.8
 misc/mke2fs.conf.5
+misc/mke2fs.conf
 misc/mklost+found
 misc/mklost+found.8
 misc/prof_err.c
 misc/prof_err.h
+misc/profile.h
 misc/tune2fs
 misc/tune2fs.8
 misc/uuidd
-- 
1.7.11.1

