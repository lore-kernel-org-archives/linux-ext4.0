From: Eric Biggers <ebiggers@google.com>
Subject: [PATCH 4/4] generic: test locking when setting encryption policy
Date: Thu, 17 Nov 2016 11:47:07 -0800
Message-ID: <1479412027-34416-5-git-send-email-ebiggers@google.com>
References: <1479412027-34416-1-git-send-email-ebiggers@google.com>
Cc: linux-ext4@vger.kernel.org, linux-f2fs@vger.kernel.org,
        "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Richard Weinberger <richard@nod.at>,
        David Gstir <david@sigma-star.at>,
        Eric Biggers <ebiggers@google.com>
To: fstests@vger.kernel.org
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <1479412027-34416-1-git-send-email-ebiggers@google.com>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This test tries to reproduce (with a moderate chance of success on ext4)
a race condition where a file could be created in a directory
concurrently to an encryption policy being set on that directory,
causing the directory to become corrupted.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 src/fscrypt_util.c    | 98 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/402     | 39 ++++++++++++++++++++
 tests/generic/402.out |  2 ++
 tests/generic/group   |  1 +
 4 files changed, 140 insertions(+)
 create mode 100755 tests/generic/402
 create mode 100644 tests/generic/402.out

diff --git a/src/fscrypt_util.c b/src/fscrypt_util.c
index 9428cb4..5ca0996 100644
--- a/src/fscrypt_util.c
+++ b/src/fscrypt_util.c
@@ -19,11 +19,13 @@
  * along with this program; if not, see <http://www.gnu.org/licenses/>.
  */
 
+#include <dirent.h>
 #include <errno.h>
 #include <fcntl.h>
 #include <inttypes.h>
 #include <linux/fs.h>
 #include <linux/keyctl.h>
+#include <pthread.h>
 #include <stdarg.h>
 #include <stdbool.h>
 #include <stdio.h>
@@ -97,6 +99,7 @@ usage(void)
 "    fscrypt_util rm_key KEYDESC\n"
 "    fscrypt_util set_policy KEYDESC DIR\n"
 "    fscrypt_util test_ioctl_validation DIR\n"
+"    fscrypt_util test_set_policy_locking DIR\n"
 );
 	exit(2);
 }
@@ -357,6 +360,100 @@ static int test_ioctl_validation(int argc, char **argv)
 	return 0;
 }
 
+struct subdir_thread_args {
+	pthread_cond_t cond;
+	pthread_mutex_t mutex;
+	char *subdir;
+	bool done;
+};
+
+static void *subdir_thrproc(void *arg)
+{
+	struct subdir_thread_args *args = arg;
+
+	pthread_mutex_lock(&args->mutex);
+	while (!args->done) {
+		pthread_cond_wait(&args->cond, &args->mutex);
+		mkdir(args->subdir, 0755);
+	}
+	pthread_mutex_unlock(&args->mutex);
+	return NULL;
+}
+
+/*
+ * Test that FS_IOC_SET_ENCRYPTION_POLICY is correctly serialized with regard to
+ * creation of new files in the directory.
+ *
+ * To test this we repeatedly attempt to create a subdirectory concurrently with
+ * setting an encryption policy on the parent directory.  After each attempt, we
+ * do readdir() on the directory.  readdir() should always succeed regardless of
+ * whether the directory ended up with an encryption policy or not.  But without
+ * the proper locking of the directory inode, on ext4 it sometimes failed with
+ * EUCLEAN, and the filesystem was also left in an inconsistent state for fsck.
+ */
+static int test_set_policy_locking(int argc, char **argv)
+{
+	const char *dir;
+	struct subdir_thread_args args;
+	pthread_t subdir_thread;
+	struct fscrypt_policy policy;
+	int i;
+
+	if (argc != 1)
+		usage();
+	dir = argv[0];
+
+	args.subdir = malloc(strlen(dir) + 8);
+	sprintf(args.subdir, "%s/subdir", dir);
+	pthread_cond_init(&args.cond, NULL);
+	pthread_mutex_init(&args.mutex, NULL);
+	args.done = false;
+
+	if (pthread_create(&subdir_thread, NULL, subdir_thrproc, &args) != 0)
+		die("Unable to create thread");
+
+	init_policy_default(&policy);
+
+	for (i = 0; i < 20000; i++) {
+		int fd;
+		DIR *d;
+
+		rmdir(args.subdir);
+		rmdir(dir);
+		mkdir(dir, 0755);
+		fd = open(dir, O_RDONLY);
+		pthread_mutex_lock(&args.mutex);
+		pthread_cond_signal(&args.cond);
+		pthread_mutex_unlock(&args.mutex);
+		if (ioctl(fd, FS_IOC_SET_ENCRYPTION_POLICY, &policy) != 0 &&
+		    errno != ENOTEMPTY) {
+			die_errno("Unexpected error from "
+				  "FS_IOC_SET_ENCRYPTION_POLICY");
+		}
+		d = fdopendir(fd);
+		if (!d)
+			die_errno("Unexpected fdopendir() error");
+		errno = 0;
+		while (readdir(d) != NULL)
+			;
+		if (errno != 0)
+			die_errno("Unexpected readdir() error");
+		closedir(d);
+	}
+
+	pthread_mutex_lock(&args.mutex);
+	args.done = true;
+	pthread_cond_signal(&args.cond);
+	pthread_mutex_unlock(&args.mutex);
+
+	if (pthread_join(subdir_thread, NULL) != 0)
+		die("Unable to join thread");
+
+	free(args.subdir);
+	printf("%s: test_set_policy_locking passed\n", dir);
+	return 0;
+}
+
 static const struct command {
 	const char *name;
 	int (*func)(int, char **);
@@ -365,6 +462,7 @@ static const struct command {
 	{"rm_key", rm_key},
 	{"set_policy", set_policy},
 	{"test_ioctl_validation", test_ioctl_validation},
+	{"test_set_policy_locking", test_set_policy_locking},
 	{NULL, NULL}
 };
 
diff --git a/tests/generic/402 b/tests/generic/402
new file mode 100755
index 0000000..e26c0c9
--- /dev/null
+++ b/tests/generic/402
@@ -0,0 +1,39 @@
+#!/bin/bash
+# FS QA Test generic/402
+#
+# The FS_IOC_SET_ENCRYPTION_POLICY ioctl must be correctly serialized with
+# regard to creation of new files in the directory.  Regression test for
+# 8906a8223ad4: "fscrypto: lock inode while setting encryption policy".
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
+echo "QA output created by $seq"
+
+. ./common/encrypt
+
+_begin_encryption_test
+
+cd $SCRATCH_MNT
+mkdir dir
+$FSCRYPT_UTIL test_set_policy_locking dir
+
+exit 0
diff --git a/tests/generic/402.out b/tests/generic/402.out
new file mode 100644
index 0000000..947e830
--- /dev/null
+++ b/tests/generic/402.out
@@ -0,0 +1,2 @@
+QA output created by 402
+dir: test_set_policy_locking passed
diff --git a/tests/generic/group b/tests/generic/group
index ab4edae..ed6b926 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -394,3 +394,4 @@
 389 auto quick acl
 400 auto quick encrypt
 401 auto quick encrypt
+402 auto encrypt
-- 
2.8.0.rc3.226.g39d4020
