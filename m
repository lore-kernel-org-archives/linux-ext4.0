From: Eric Biggers <ebiggers@google.com>
Subject: [PATCH 3/4] generic: test encrypted file access
Date: Thu, 17 Nov 2016 11:47:06 -0800
Message-ID: <1479412027-34416-4-git-send-email-ebiggers@google.com>
References: <1479412027-34416-1-git-send-email-ebiggers@google.com>
Cc: linux-ext4@vger.kernel.org, linux-f2fs@vger.kernel.org,
        "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Richard Weinberger <richard@nod.at>,
        David Gstir <david@sigma-star.at>,
        Eric Biggers <ebiggers@google.com>
To: fstests@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pg0-f51.google.com ([74.125.83.51]:35728 "EHLO
        mail-pg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753565AbcKQTsd (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 17 Nov 2016 14:48:33 -0500
Received: by mail-pg0-f51.google.com with SMTP id p66so94419107pga.2
        for <linux-ext4@vger.kernel.org>; Thu, 17 Nov 2016 11:48:33 -0800 (PST)
In-Reply-To: <1479412027-34416-1-git-send-email-ebiggers@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Test accessing encrypted files with and without the encryption key.
Access with the key is more of a sanity check, whereas access without
the key should result in some particular behaviors.

As noted in the comment, as currently written this test is expected to
fail on ext4 pre-4.8 and f2fs pre-4.6.  This could be avoided by using
the filesystem-specific key prefix instead of the generic one, but I'd
prefer to have the tests use the generic prefix.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 tests/generic/401     | 133 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/401.out |   2 +
 tests/generic/group   |   1 +
 3 files changed, 136 insertions(+)
 create mode 100755 tests/generic/401
 create mode 100644 tests/generic/401.out

diff --git a/tests/generic/401 b/tests/generic/401
new file mode 100755
index 0000000..f224852
--- /dev/null
+++ b/tests/generic/401
@@ -0,0 +1,133 @@
+#!/bin/bash
+# FS QA Test generic/401
+#
+# Test accessing encrypted files and directories, both with and without the
+# encryption key.
+#
+# This is *not* intended to fully test all the encrypted I/O paths.  To do that
+# you'd need to run all the xfstests with encryption enabled.
+#
+# Also, this is expected to fail on ext4 pre-4.8 and f2fs pre-4.6 because it
+# assumes the common key naming convention ("fscrypt:" instead of "ext4:" or
+# "f2fs:"), which wasn't added until those versions.
+#
+#-----------------------------------------------------------------------
+# Copyright (C) 2016 Google, Inc.
+#
+# Author: Eric Biggers <ebiggers@google.com>
+#
+# This program is free software; you can redistribute it and/or modify
+# it under the terms of the GNU General Public License as published by
+# the Free Software Foundation; either version 2 of the License, or
+# (at your option) any later version.
+#
+# This program is distributed in the hope that it will be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, see <http://www.gnu.org/licenses/>.
+#-----------------------------------------------------------------------
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+here=`pwd`
+echo "QA output created by $seq"
+
+. ./common/encrypt
+
+_begin_encryption_test
+
+cd $SCRATCH_MNT
+
+mkdir edir ref_dir
+keydesc=$($FSCRYPT_UTIL gen_key)
+$FSCRYPT_UTIL set_policy $keydesc edir > /dev/null
+for dir in edir ref_dir; do
+	touch $dir/empty > /dev/null
+	$XFS_IO_PROG -t -f -c "pwrite 0 4k" $dir/a > /dev/null
+	$XFS_IO_PROG -t -f -c "pwrite 0 33k" $dir/abcdefghijklmnopqrstuvwxyz > /dev/null
+	maxname=$(yes | head -255 | tr -d '\n') # 255 character filename
+	$XFS_IO_PROG -t -f -c "pwrite 0 1k" $dir/$maxname > /dev/null
+	ln -s a $dir/symlink
+	ln -s abcdefghijklmnopqrstuvwxyz $dir/symlink2
+	ln -s $maxname $dir/symlink3
+	mkdir $dir/subdir
+	mkdir $dir/subdir/subsubdir
+done
+# Diff encrypted directory with unencrypted reference directory
+diff -r edir ref_dir
+# Cycle mount and diff again
+cd $here
+_scratch_cycle_mount
+cd $SCRATCH_MNT
+diff -r edir ref_dir
+
+# Now try accessing the files without the encryption key.
+# It should still be possible to list the directory and remove files.
+# But filenames should be encrypted, and it should not be possible to read
+# regular files or to create new files or subdirectories.
+cd $here
+_scratch_unmount
+$FSCRYPT_UTIL rm_key $keydesc
+_scratch_mount
+cd $SCRATCH_MNT
+if [ $(ls edir | wc -l) -ne 8 ]; then
+	echo "Wrong number of files"
+	exit 1
+fi
+if [ -e edir/empty -o -e edir/symlink ]; then
+	echo "Filenames were not encrypted!"
+	exit 1
+fi
+if [ $(find edir -mindepth 2 -maxdepth 2 -type d | wc -l) -ne 1 ]; then
+	echo "Wrong number of subdirs"
+	exit 1
+fi
+cat $(find edir -maxdepth 1 -type f | head -1) 2>tmp
+if ! egrep -q 'Required key not available' tmp; then
+	echo "Reading encrypted file w/o key didn't fail with ENOKEY"
+	cat tmp
+	exit 1
+fi
+ls -l edir > /dev/null # should succeed
+
+# There are some inconsistencies in which error codes are returned on different
+# kernel versions and filesystems when trying to create a file or subdirectory
+# without access to the parent directory's encryption key.  Furthermore, on some
+# kernels correctly encoded filenames cause a different error (EACCES instead of
+# ENOENT) because these names make it though ->lookup() and fail in ->create()
+# or ->mkdir() instead.  For now we just accept multiple error codes.
+
+$XFS_IO_PROG -f edir/newfile &> tmp
+if ! egrep -q 'Permission denied|No such file or directory' tmp; then
+	echo "Creating file w/o key (unencoded) didn't fail with EACCES or ENOENT"
+	cat tmp
+	exit 1
+fi
+mkdir edir/newdir &> tmp
+if ! egrep -q 'Permission denied|No such file or directory' tmp; then
+	echo "Creating dir w/o key (unencoded) didn't fail with EACCES or ENOENT"
+	cat tmp
+	exit 1
+fi
+$XFS_IO_PROG -f edir/0123456789abcdef &> tmp
+if ! egrep -q 'Permission denied|Operation not permitted' tmp; then
+	echo "Creating file w/o key (encoded) didn't fail with EACCES or EPERM"
+	cat tmp
+	exit 1
+fi
+mkdir edir/0123456789abcdef &> tmp
+if ! egrep -q 'Permission denied|Operation not permitted' tmp; then
+	echo "Creating dir w/o key (encoded) didn't fail with EACCES or EPERM"
+	cat tmp
+	exit 1
+fi
+
+rm -r edir # should succeed
+[ -e edir ] && echo "Directory wasn't deleted!"
+
+echo "Silence is golden."
+
+exit 0
diff --git a/tests/generic/401.out b/tests/generic/401.out
new file mode 100644
index 0000000..3625570
--- /dev/null
+++ b/tests/generic/401.out
@@ -0,0 +1,2 @@
+QA output created by 401
+Silence is golden.
diff --git a/tests/generic/group b/tests/generic/group
index cf89f06..ab4edae 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -393,3 +393,4 @@
 388 auto log metadata
 389 auto quick acl
 400 auto quick encrypt
+401 auto quick encrypt
-- 
2.8.0.rc3.226.g39d4020

