From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 06/39] misc: fix broken libmagic interaction with
 plausibility check
Date: Sat, 25 Oct 2014 13:57:01 -0700
Message-ID: <20141025205701.532.1427.stgit@birch.djwong.org>
References: <20141025205623.532.12119.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:43768 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752696AbaJYU5g (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 25 Oct 2014 16:57:36 -0400
In-Reply-To: <20141025205623.532.12119.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If we get as far as calling libmagic, return the correct error code so
that mkfs asks for confirmation if libmagic finds something and
doesn't ask if nothing is found.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 misc/plausible.c                     |    9 ++++++---
 tests/f_detect_junk/expect           |    6 +++---
 tests/f_detect_junk/expect.nodebugfs |    4 ++--
 tests/f_detect_junk/script           |    2 +-
 4 files changed, 12 insertions(+), 9 deletions(-)


diff --git a/misc/plausible.c b/misc/plausible.c
index 00bc6e2..1848a26 100644
--- a/misc/plausible.c
+++ b/misc/plausible.c
@@ -243,6 +243,7 @@ int check_plausibility(const char *device, int flags, int *ret_is_dev)
 	if ((flags & CHECK_FS_EXIST) && magic_library_available()) {
 		const char *msg;
 		magic_t mag;
+		int has_magic = 0;
 
 		mag = dl_magic_open(MAGIC_RAW | MAGIC_SYMLINK | MAGIC_DEVICES |
 				    MAGIC_ERROR | MAGIC_NO_CHECK_ELF |
@@ -250,11 +251,13 @@ int check_plausibility(const char *device, int flags, int *ret_is_dev)
 		dl_magic_load(mag, NULL);
 
 		msg = dl_magic_file(mag, device);
-		if (msg && strcmp(msg, "data") && strcmp(msg, "empty"))
-			printf(_("%s contains a `%s'\n"), device, msg);
+		if (msg && strcmp(msg, "data") && strcmp(msg, "empty")) {
+			printf(_("%s contains `%s' data\n"), device, msg);
+			has_magic = 1;
+		}
 
 		dl_magic_close(mag);
-		return 0;
+		return !has_magic;
 	}
 #endif
 
diff --git a/tests/f_detect_junk/expect b/tests/f_detect_junk/expect
index 57f7f89..f3300de 100644
--- a/tests/f_detect_junk/expect
+++ b/tests/f_detect_junk/expect
@@ -11,13 +11,13 @@ is corrupt, and you might try running e2fsck with an alternate superblock:
  or
     e2fsck -b 32768 <device>
 
-test.img contains a `PNG image data, 148 x 31, 8-bit/color RGBA, non-interlaced'
+test.img contains `PNG image data, 148 x 31, 8-bit/color RGBA, non-interlaced' data
 *** debugfs
 test.img: Bad magic number in super-block while opening filesystem
-test.img contains a `PNG image data, 148 x 31, 8-bit/color RGBA, non-interlaced'
+test.img contains `PNG image data, 148 x 31, 8-bit/color RGBA, non-interlaced' data
 *** tune2fs
 ../misc/tune2fs: Bad magic number in super-block while trying to open test.img
-test.img contains a `PNG image data, 148 x 31, 8-bit/color RGBA, non-interlaced'
+test.img contains `PNG image data, 148 x 31, 8-bit/color RGBA, non-interlaced' data
 *** mke2fs
 Creating filesystem with 16384 1k blocks and 4096 inodes
 Superblock backups stored on blocks: 
diff --git a/tests/f_detect_junk/expect.nodebugfs b/tests/f_detect_junk/expect.nodebugfs
index d9281a0..0d4ba54 100644
--- a/tests/f_detect_junk/expect.nodebugfs
+++ b/tests/f_detect_junk/expect.nodebugfs
@@ -11,11 +11,11 @@ is corrupt, and you might try running e2fsck with an alternate superblock:
  or
     e2fsck -b 32768 <device>
 
-test.img contains a `PNG image data, 148 x 31, 8-bit/color RGBA, non-interlaced'
+test.img contains `PNG image data, 148 x 31, 8-bit/color RGBA, non-interlaced' data
 *** debugfs
 *** tune2fs
 ../misc/tune2fs: Bad magic number in super-block while trying to open test.img
-test.img contains a `PNG image data, 148 x 31, 8-bit/color RGBA, non-interlaced'
+test.img contains `PNG image data, 148 x 31, 8-bit/color RGBA, non-interlaced' data
 *** mke2fs
 Creating filesystem with 16384 1k blocks and 4096 inodes
 Superblock backups stored on blocks: 
diff --git a/tests/f_detect_junk/script b/tests/f_detect_junk/script
index 8409fdd..3aebcd0 100644
--- a/tests/f_detect_junk/script
+++ b/tests/f_detect_junk/script
@@ -1,6 +1,6 @@
 #!/bin/bash
 
-if [ "$(grep -c 'define HAVE_MAGIC_H' $test_dir/../../lib/config.h)" -gt 0 ]; then
+if [ "$(grep -c 'define HAVE_MAGIC_H' ../lib/config.h)" -gt 0 ]; then
 
 FSCK_OPT=-fn
 IMAGE=$test_dir/image.bz2

