From: Eric Biggers <ebiggers@google.com>
Subject: [PATCH 2/4] generic: test setting and getting encryption policies
Date: Thu, 17 Nov 2016 11:47:05 -0800
Message-ID: <1479412027-34416-3-git-send-email-ebiggers@google.com>
References: <1479412027-34416-1-git-send-email-ebiggers@google.com>
Cc: linux-ext4@vger.kernel.org, linux-f2fs@vger.kernel.org,
        "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Richard Weinberger <richard@nod.at>,
        David Gstir <david@sigma-star.at>,
        Eric Biggers <ebiggers@google.com>
To: fstests@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pg0-f53.google.com ([74.125.83.53]:33612 "EHLO
        mail-pg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753552AbcKQTsb (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 17 Nov 2016 14:48:31 -0500
Received: by mail-pg0-f53.google.com with SMTP id 3so94547606pgd.0
        for <linux-ext4@vger.kernel.org>; Thu, 17 Nov 2016 11:48:31 -0800 (PST)
In-Reply-To: <1479412027-34416-1-git-send-email-ebiggers@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Several kernel bugs were recently fixed regarding the constraints for
setting encryption policies.  Add tests for these cases and a few more.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 src/fscrypt_util.c    | 82 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/400     | 88 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/400.out | 24 ++++++++++++++
 tests/generic/group   |  1 +
 4 files changed, 195 insertions(+)
 create mode 100755 tests/generic/400
 create mode 100644 tests/generic/400.out

diff --git a/src/fscrypt_util.c b/src/fscrypt_util.c
index de63667..9428cb4 100644
--- a/src/fscrypt_util.c
+++ b/src/fscrypt_util.c
@@ -96,6 +96,7 @@ usage(void)
 "    fscrypt_util gen_key\n"
 "    fscrypt_util rm_key KEYDESC\n"
 "    fscrypt_util set_policy KEYDESC DIR\n"
+"    fscrypt_util test_ioctl_validation DIR\n"
 );
 	exit(2);
 }
@@ -276,6 +277,86 @@ static int set_policy(int argc, char **argv)
 	return 0;
 }
 
+/*
+ * Test that the kernel does basic validation of the arguments to
+ * FS_IOC_SET_ENCRYPTION_POLICY and FS_IOC_GET_ENCRYPTION_POLICY.
+ */
+static int test_ioctl_validation(int argc, char **argv)
+{
+	const char *dir;
+	int fd;
+	struct fscrypt_policy policy;
+
+	if (argc != 1)
+		usage();
+	dir = argv[0];
+
+	fd = open(dir, O_RDONLY);
+	if (fd < 0)
+		die_errno("%s: Unable to open", dir);
+
+	/* trying to get encryption policy for unencrypted file */
+	if (ioctl(fd, FS_IOC_GET_ENCRYPTION_POLICY, NULL) != -1 ||
+	    (errno != ENODATA && errno != ENOENT)) {
+		die("expected FS_IOC_GET_ENCRYPTION_POLICY to fail with "
+		    "ENODATA or ENOENT when unencrypted file specified");
+	}
+
+	/* invalid pointer */
+	if (ioctl(fd, FS_IOC_SET_ENCRYPTION_POLICY, NULL) != -1 ||
+	    errno != EFAULT) {
+		die("expected FS_IOC_SET_ENCRYPTION_POLICY to fail with "
+		    "EFAULT when invalid pointer specified");
+	}
+
+	/* invalid flags */
+	init_policy_default(&policy);
+	policy.flags = 0xFF;
+	if (ioctl(fd, FS_IOC_SET_ENCRYPTION_POLICY, &policy) != -1 ||
+	    errno != EINVAL) {
+		die("expected FS_IOC_SET_ENCRYPTION_POLICY to fail with "
+		    "EINVAL when invalid flags specified");
+	}
+
+	/* invalid encryption modes */
+	init_policy_default(&policy);
+	policy.contents_encryption_mode = 0xFF;
+	policy.filenames_encryption_mode = 0xFF;
+	if (ioctl(fd, FS_IOC_SET_ENCRYPTION_POLICY, &policy) != -1 ||
+	    errno != EINVAL) {
+		die("expected FS_IOC_SET_ENCRYPTION_POLICY to fail with "
+		    "EINVAL when invalid encryption modes specified");
+	}
+
+	/* invalid policy version */
+	init_policy_default(&policy);
+	policy.version = 0xFF;
+	if (ioctl(fd, FS_IOC_SET_ENCRYPTION_POLICY, &policy) != -1 ||
+	    errno != EINVAL) {
+		die("expected FS_IOC_SET_ENCRYPTION_POLICY to fail with "
+		    "EINVAL when invalid policy version specified");
+	}
+
+	/* success case */
+	init_policy_default(&policy);
+	if (ioctl(fd, FS_IOC_SET_ENCRYPTION_POLICY, &policy) != 0)
+		die_errno("expected FS_IOC_SET_ENCRYPTION_POLICY to succeed");
+
+	verify_policy(dir, fd, &policy);
+
+	/* invalid pointer (get) */
+	if (ioctl(fd, FS_IOC_GET_ENCRYPTION_POLICY, NULL) != -1 ||
+	    errno != EFAULT) {
+		die("expected FS_IOC_GET_ENCRYPTION_POLICY to fail with "
+		    "EFAULT when invalid pointer specified");
+	}
+
+	close(fd);
+
+	printf("%s: test_ioctl_validation passed\n", dir);
+	return 0;
+}
+
 static const struct command {
 	const char *name;
 	int (*func)(int, char **);
@@ -283,6 +364,7 @@ static const struct command {
 	{"gen_key", gen_key},
 	{"rm_key", rm_key},
 	{"set_policy", set_policy},
+	{"test_ioctl_validation", test_ioctl_validation},
 	{NULL, NULL}
 };
 
diff --git a/tests/generic/400 b/tests/generic/400
new file mode 100755
index 0000000..b077612
--- /dev/null
+++ b/tests/generic/400
@@ -0,0 +1,88 @@
+#!/bin/bash
+# FS QA Test generic/400
+#
+# Test setting and getting encryption policies.
+#
+# This test only exercises the ioctls; it does not set up encryption keys.
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
+_require_user
+_begin_encryption_test
+
+cd $SCRATCH_MNT
+
+# Should be able to set an encryption policy on an empty directory
+echo -e "\n*** Setting encryption policy on empty directory ***"
+mkdir empty_dir
+$FSCRYPT_UTIL set_policy 0000111122223333 empty_dir
+
+# Should be able to set the same policy again, but not a different one
+echo -e "\n*** Setting same encryption policy again ***"
+$FSCRYPT_UTIL set_policy 0000111122223333 empty_dir
+$FSCRYPT_UTIL set_policy 4444555566667777 empty_dir
+
+# Should *not* be able to set an encryption policy on a nonempty directory
+echo -e "\n*** Setting encryption policy on nonempty directory ***"
+mkdir nonempty_dir
+touch nonempty_dir/file
+$FSCRYPT_UTIL set_policy 0000111122223333 nonempty_dir
+
+# Should *not* be able to set an encryption policy on a nondirectory file, even
+# an empty one.  Regression test for 002ced4be642: "fscrypto: only allow setting
+# encryption policy on directories".
+echo -e "\n*** Setting encryption policy on nondirectory ***"
+touch nondirectory
+$FSCRYPT_UTIL set_policy 0000111122223333 nondirectory
+
+# Should *not* be able to set an encryption policy on another user's directory.
+# Regression test for 163ae1c6ad62: "fscrypto: add authorization check for
+# setting encryption policy".
+echo -e "\n*** Setting encryption policy on another user's directory ***"
+mkdir unauthorized_dir
+su $qa_user -c "$FSCRYPT_UTIL set_policy 0000111122223333 unauthorized_dir"
+
+# Should *not* be able to set an encryption policy on a directory on a
+# filesystem mounted readonly.  Regression test for ba63f23d69a3: "fscrypto:
+# require write access to mount to set encryption policy".  Test both a regular
+# readonly filesystem and a read-write filesystem remounted with "ro,bind",
+# which creates a readonly mount for a read-write filesystem.
+echo -e "\n*** Setting encryption policy on readonly filesystem ***"
+mkdir readonly_mnt_dir
+_scratch_mount -o ro,remount
+$FSCRYPT_UTIL set_policy 0000111122223333 readonly_mnt_dir
+_scratch_mount -o rw,remount
+_scratch_mount -o remount,ro,bind
+$FSCRYPT_UTIL set_policy 0000111122223333 readonly_mnt_dir
+_scratch_mount -o rw,remount
+
+# Test basic validation of set_policy / get_policy ioctl arguments
+echo -e "\n*** ioctl validation ***"
+mkdir validation_dir
+$FSCRYPT_UTIL test_ioctl_validation validation_dir
+
+exit 0
diff --git a/tests/generic/400.out b/tests/generic/400.out
new file mode 100644
index 0000000..dbae79d
--- /dev/null
+++ b/tests/generic/400.out
@@ -0,0 +1,24 @@
+QA output created by 400
+
+*** Setting encryption policy on empty directory ***
+empty_dir: Successfully assigned encryption key 0000111122223333
+
+*** Setting same encryption policy again ***
+empty_dir: Successfully assigned encryption key 0000111122223333
+empty_dir: Unable to set encryption policy: Invalid argument
+
+*** Setting encryption policy on nonempty directory ***
+nonempty_dir: Unable to set encryption policy: Directory not empty
+
+*** Setting encryption policy on nondirectory ***
+nondirectory: Unable to set encryption policy: Invalid argument
+
+*** Setting encryption policy on another user's directory ***
+unauthorized_dir: Unable to set encryption policy: Permission denied
+
+*** Setting encryption policy on readonly filesystem ***
+readonly_mnt_dir: Unable to set encryption policy: Read-only file system
+readonly_mnt_dir: Unable to set encryption policy: Read-only file system
+
+*** ioctl validation ***
+validation_dir: test_ioctl_validation passed
diff --git a/tests/generic/group b/tests/generic/group
index 08007d7..cf89f06 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -392,3 +392,4 @@
 387 auto clone
 388 auto log metadata
 389 auto quick acl
+400 auto quick encrypt
-- 
2.8.0.rc3.226.g39d4020

