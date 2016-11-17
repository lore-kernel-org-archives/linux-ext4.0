From: Eric Biggers <ebiggers@google.com>
Subject: [PATCH 1/4] generic: add utilities for testing filesystem encryption
Date: Thu, 17 Nov 2016 11:47:04 -0800
Message-ID: <1479412027-34416-2-git-send-email-ebiggers@google.com>
References: <1479412027-34416-1-git-send-email-ebiggers@google.com>
Cc: linux-ext4@vger.kernel.org, linux-f2fs@vger.kernel.org,
        "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Richard Weinberger <richard@nod.at>,
        David Gstir <david@sigma-star.at>,
        Eric Biggers <ebiggers@google.com>
To: fstests@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pf0-f178.google.com ([209.85.192.178]:36053 "EHLO
        mail-pf0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753959AbcKQTsn (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 17 Nov 2016 14:48:43 -0500
Received: by mail-pf0-f178.google.com with SMTP id 189so50547155pfz.3
        for <linux-ext4@vger.kernel.org>; Thu, 17 Nov 2016 11:48:29 -0800 (PST)
In-Reply-To: <1479412027-34416-1-git-send-email-ebiggers@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Add utilities for testing the filesystem-level encryption feature
currently supported by ext4 and f2fs.  Tests will be able to source
common/encrypt and call _begin_encryption_test to set up an
encryption-capable filesystem on the scratch device, or skip the test
when not supported.

A program fscrypt_util is also added to expose filesystem
encryption-related commands to shell scripts.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 .gitignore         |   1 +
 common/encrypt     |  89 ++++++++++++++++
 src/Makefile       |   2 +-
 src/fscrypt_util.c | 306 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 397 insertions(+), 1 deletion(-)
 create mode 100755 common/encrypt
 create mode 100644 src/fscrypt_util.c

diff --git a/.gitignore b/.gitignore
index 915d2d8..7040f67 100644
--- a/.gitignore
+++ b/.gitignore
@@ -54,6 +54,7 @@
 /src/fill
 /src/fill2
 /src/fs_perms
+/src/fscrypt_util
 /src/fssum
 /src/fstest
 /src/fsync-tester
diff --git a/common/encrypt b/common/encrypt
new file mode 100755
index 0000000..599d16f
--- /dev/null
+++ b/common/encrypt
@@ -0,0 +1,89 @@
+#!/bin/bash
+#
+# Common functions for testing filesystem-level encryption
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
+. ./common/rc
+
+# Begin an encryption test.  This creates the scratch filesystem with encryption
+# enabled and mounts it, or skips the test if encryption isn't supported.
+_begin_encryption_test() {
+
+	_supported_os Linux
+	_supported_fs ext4 f2fs
+
+	# We use a dedicated test program 'fscrypt_util' for making API calls
+	# related to encryption.  We aren't using 'e4crypt' because 'e4crypt' is
+	# currently ext4-specific, and with a test program we can easily include
+	# test-only commands and other functionality or behavior that wouldn't
+	# make sense in a real program.
+	_require_test_program fscrypt_util
+
+	# The 'test_dummy_encryption' mount option interferes with trying to use
+	# encryption for real.  So skip the real encryption tests if the
+	# 'test_dummy_encryption' mount option was specified.
+	if echo "$MOUNT_OPTIONS" | grep -q "test_dummy_encryption"; then
+		_notrun "Dummy encryption is on; skipping real encryption tests"
+	fi
+
+	# Make a filesystem on the scratch device with the encryption feature
+	# enabled.  If this fails then probably the userspace tools (e.g.
+	# e2fsprogs or f2fs-tools) are too old to understand encryption.
+	_require_scratch
+	if ! _scratch_mkfs_encrypted >/dev/null; then
+		_notrun "$FSTYP userspace tools do not support encryption"
+	fi
+
+	# Try to mount the filesystem.  If this fails then probably the kernel
+	# isn't aware of encryption.
+	if ! _scratch_mount &> /dev/null; then
+		_notrun "kernel is unaware of $FSTYP encryption feature"
+	fi
+
+	# The kernel may be aware of encryption without supporting it.  For
+	# example, for ext4 this is the case with kernels configured with
+	# CONFIG_EXT4_FS_ENCRYPTION=n.  Detect support for encryption by trying
+	# to set an encryption policy.  (For ext4 we could instead check for the
+	# presence of /sys/fs/ext4/features/encryption, but this is broken on
+	# some older kernels and is ext4-specific anyway.)
+	mkdir $SCRATCH_MNT/tmpdir
+	if src/fscrypt_util set_policy 0000111122223333 $SCRATCH_MNT/tmpdir \
+		2>&1 >/dev/null |
+		egrep -q 'Inappropriate ioctl for device|Operation not supported'
+	then
+		_notrun "kernel does not support $FSTYP encryption"
+	fi
+	rmdir $SCRATCH_MNT/tmpdir
+}
+
+_scratch_mkfs_encrypted() {
+	case $FSTYP in
+	ext4)
+		# ext4 encryption requires block size = PAGE_SIZE.
+		MKFS_OPTIONS="-O encrypt -b $(getconf PAGE_SIZE)" _scratch_mkfs
+		;;
+	*)
+		MKFS_OPTIONS="-O encrypt" _scratch_mkfs
+		;;
+	esac
+}
+
+FSCRYPT_UTIL=`pwd`/src/fscrypt_util
diff --git a/src/Makefile b/src/Makefile
index dd51216..0b91402 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -21,7 +21,7 @@ LINUX_TARGETS = xfsctl bstat t_mtab getdevicesize preallo_rw_pattern_reader \
 	stale_handle pwrite_mmap_blocked t_dir_offset2 seek_sanity_test \
 	seek_copy_test t_readdir_1 t_readdir_2 fsync-tester nsexec cloner \
 	renameat2 t_getcwd e4compact test-nextquota punch-alternating \
-	attr-list-by-handle-cursor-test listxattr
+	attr-list-by-handle-cursor-test listxattr fscrypt_util
 
 SUBDIRS =
 
diff --git a/src/fscrypt_util.c b/src/fscrypt_util.c
new file mode 100644
index 0000000..de63667
--- /dev/null
+++ b/src/fscrypt_util.c
@@ -0,0 +1,306 @@
+/*
+ * fscrypt_util.c - test utility for filesystem-level encryption
+ *
+ * Copyright (C) 2016 Google, Inc.
+ *
+ * Author: Eric Biggers <ebiggers@google.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <errno.h>
+#include <fcntl.h>
+#include <inttypes.h>
+#include <linux/fs.h>
+#include <linux/keyctl.h>
+#include <stdarg.h>
+#include <stdbool.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/ioctl.h>
+#include <sys/stat.h>
+#include <sys/syscall.h>
+#include <sys/types.h>
+#include <time.h>
+#include <unistd.h>
+
+/*
+ * Declare the encryption policy structure and the ioctl numbers if they weren't
+ * already declared in linux/fs.h.
+ */
+#ifndef FS_IOC_SET_ENCRYPTION_POLICY
+#define FS_KEY_DESCRIPTOR_SIZE  8
+
+struct fscrypt_policy {
+	__u8 version;
+	__u8 contents_encryption_mode;
+	__u8 filenames_encryption_mode;
+	__u8 flags;
+	__u8 master_key_descriptor[FS_KEY_DESCRIPTOR_SIZE];
+} __attribute__((packed));
+
+#define FS_IOC_SET_ENCRYPTION_POLICY	_IOR('f', 19, struct fscrypt_policy)
+#define FS_IOC_GET_ENCRYPTION_PWSALT	_IOW('f', 20, __u8[16])
+#define FS_IOC_GET_ENCRYPTION_POLICY	_IOW('f', 21, struct fscrypt_policy)
+#endif /* FS_IOC_SET_ENCRYPTION_POLICY */
+
+
+/*
+ * As of Linux 4.9, some parts of the userspace API (flags, modes, and key
+ * format) are not yet exposed by linux/fs.h.  So we may need to declare them
+ * even if linux/fs.h declares the ioctl numbers.
+ */
+#ifndef FS_ENCRYPTION_MODE_AES_256_XTS
+#define FS_POLICY_FLAGS_PAD_4		0x00
+#define FS_POLICY_FLAGS_PAD_8		0x01
+#define FS_POLICY_FLAGS_PAD_16		0x02
+#define FS_POLICY_FLAGS_PAD_32		0x03
+#define FS_POLICY_FLAGS_PAD_MASK	0x03
+#define FS_POLICY_FLAGS_VALID		0x03
+
+#define FS_ENCRYPTION_MODE_INVALID	0
+#define FS_ENCRYPTION_MODE_AES_256_XTS	1
+#define FS_ENCRYPTION_MODE_AES_256_GCM	2
+#define FS_ENCRYPTION_MODE_AES_256_CBC	3
+#define FS_ENCRYPTION_MODE_AES_256_CTS	4
+
+#define FS_MAX_KEY_SIZE			64
+
+#define FS_KEY_DESC_PREFIX		"fscrypt:"
+#define FS_KEY_DESC_PREFIX_SIZE		8
+
+struct fscrypt_key {
+	__u32 mode;
+	__u8 raw[FS_MAX_KEY_SIZE];
+	__u32 size;
+} __attribute__((packed));
+#endif /* FS_ENCRYPTION_MODE_AES_256_XTS */
+
+static void __attribute__((noreturn))
+usage(void)
+{
+	fprintf(stderr,
+"Usage:\n"
+"    fscrypt_util gen_key\n"
+"    fscrypt_util rm_key KEYDESC\n"
+"    fscrypt_util set_policy KEYDESC DIR\n"
+);
+	exit(2);
+}
+
+static void __attribute__((noreturn, format(printf,1,2)))
+die(const char *format, ...)
+{
+	va_list va;
+
+	va_start(va, format);
+	vfprintf(stderr, format, va);
+	fputc('\n', stderr);
+	va_end(va);
+
+	exit(1);
+}
+
+static void __attribute__((noreturn, format(printf,1,2)))
+die_errno(const char *format, ...)
+{
+	va_list va;
+	int err = errno;
+
+	va_start(va, format);
+	vfprintf(stderr, format, va);
+	fprintf(stderr, ": %s\n", strerror(err));
+	va_end(va);
+
+	exit(1);
+}
+
+/*
+ * Sanity check: given a directory file descriptor on which we just set the
+ * encryption policy @expected, it should be possible to get the same policy
+ * back from the kernel using FS_IOC_GET_ENCRYPTION_POLICY.
+ */
+static void verify_policy(const char *dir, int fd,
+			  const struct fscrypt_policy *expected)
+{
+	struct fscrypt_policy actual;
+
+	memset(&actual, 0xFF, sizeof(actual));
+
+	if (ioctl(fd, FS_IOC_GET_ENCRYPTION_POLICY, &actual) < 0)
+		die_errno("%s: FS_IOC_GET_ENCRYPTION_POLICY failed", dir);
+
+	if (memcmp(&actual, expected, sizeof(actual)) != 0)
+		die("%s: encryption policy did not survive round-trip", dir);
+}
+
+/* Initialize a 'struct fscrypt_policy' */
+static void init_policy(struct fscrypt_policy *policy, const char *keydesc_str)
+{
+	unsigned long long keydesc;
+	char *tmp;
+	int i;
+
+	memset(policy, 0, sizeof(*policy));
+	policy->contents_encryption_mode = FS_ENCRYPTION_MODE_AES_256_XTS;
+	policy->filenames_encryption_mode = FS_ENCRYPTION_MODE_AES_256_CTS;
+	policy->flags = FS_POLICY_FLAGS_PAD_16;
+
+	keydesc = strtoull(keydesc_str, &tmp, 16);
+	if (tmp == keydesc_str || *tmp != '\0')
+		die("Invalid keydesc: %s", keydesc_str);
+
+	for (i = 0; i < FS_KEY_DESCRIPTOR_SIZE; i++) {
+		policy->master_key_descriptor[i] = keydesc >> 56;
+		keydesc <<= 8;
+	}
+}
+
+static void init_policy_default(struct fscrypt_policy *policy)
+{
+	init_policy(policy, "0000111122223333");
+}
+
+/*
+ * Generate a "random" fscrypt key and add it to the session keyring, identified
+ * by a "random" key descriptor.  Afterwards print out the key descriptor.
+ *
+ * Note that this is not secure at all and must only be used for testing!  Also,
+ * we are using the common key naming conventiion ("fscrypt:" instead of "ext4:"
+ * or "f2fs:"), which is only supported by 4.8+ kernels for ext4 and 4.6+
+ * kernels for f2fs.
+ */
+static int gen_key(int argc, char **argv)
+{
+	char keyname[FS_KEY_DESC_PREFIX_SIZE +
+		     (FS_KEY_DESCRIPTOR_SIZE * 2) + 1];
+	struct fscrypt_key key;
+	int32_t ringid;
+	int i;
+
+	if (argc != 0)
+		usage();
+
+	srand(time(NULL));
+
+	memset(&key, 0, sizeof(key));
+	key.size = FS_MAX_KEY_SIZE;
+	for (i = 0; i < FS_MAX_KEY_SIZE; i++)
+		key.raw[i] = rand() & 0xFF;
+
+	strcpy(keyname, FS_KEY_DESC_PREFIX);
+	for (i = 0; i < FS_KEY_DESCRIPTOR_SIZE; i++) {
+		sprintf(&keyname[FS_KEY_DESC_PREFIX_SIZE + i*2],
+			"%02x", rand() & 0xFF);
+	}
+
+	ringid = syscall(__NR_keyctl, KEYCTL_GET_KEYRING_ID,
+			 KEY_SPEC_SESSION_KEYRING, 0);
+	if (ringid == -1)
+		die_errno("Unable to find session keyring");
+
+	if (syscall(__NR_add_key, "logon", keyname, &key, sizeof(key),
+		    ringid) == -1)
+		die_errno("Unable to add key to session keyring");
+
+	printf("%s\n", keyname + FS_KEY_DESC_PREFIX_SIZE);
+	return 0;
+}
+
+/* Remove a fscrypt key from the session keyring */
+static int rm_key(int argc, char **argv)
+{
+	const char *keydesc_str;
+	char *keyname;
+	int32_t keyid;
+
+	if (argc != 1)
+		usage();
+	keydesc_str = argv[0];
+
+	keyname = malloc(FS_KEY_DESCRIPTOR_SIZE + strlen(keydesc_str) + 1);
+	sprintf(keyname, "%s%s", FS_KEY_DESC_PREFIX, keydesc_str);
+
+	keyid = syscall(__NR_keyctl, KEYCTL_SEARCH, KEY_SPEC_SESSION_KEYRING,
+			"logon", keyname, 0);
+	if (keyid == -1)
+		die_errno("Unable to find key %s\n", keyname);
+
+	if (syscall(__NR_keyctl, KEYCTL_UNLINK, keyid,
+		    KEY_SPEC_SESSION_KEYRING) == -1)
+		die_errno("Unable to unlink key %s\n", keyname);
+
+	free(keyname);
+	return 0;
+}
+
+/* Command to expose FS_IOC_SET_ENCRYPTION_POLICY to shell scripts */
+static int set_policy(int argc, char **argv)
+{
+	const char *keydesc_str;
+	const char *dir;
+	struct fscrypt_policy policy;
+	int fd;
+
+	if (argc != 2)
+		usage();
+	keydesc_str = argv[0];
+	dir = argv[1];
+
+	init_policy(&policy, keydesc_str);
+
+	fd = open(dir, O_RDONLY);
+	if (fd < 0)
+		die_errno("%s: Unable to open", dir);
+
+	if (ioctl(fd, FS_IOC_SET_ENCRYPTION_POLICY, &policy) < 0)
+		die_errno("%s: Unable to set encryption policy", dir);
+
+	verify_policy(dir, fd, &policy);
+	close(fd);
+
+	printf("%s: Successfully assigned encryption key %s\n", dir,
+	       keydesc_str);
+	return 0;
+}
+
+static const struct command {
+	const char *name;
+	int (*func)(int, char **);
+} commands[] = {
+	{"gen_key", gen_key},
+	{"rm_key", rm_key},
+	{"set_policy", set_policy},
+	{NULL, NULL}
+};
+
+int main(int argc, char **argv)
+{
+	const char *cmdname;
+	const struct command *cmd;
+
+	if (argc < 2)
+		usage();
+
+	cmdname = argv[1];
+	argc -= 2;
+	argv += 2;
+
+	for (cmd = commands; cmd->name != NULL; cmd++)
+		if (strcmp(cmdname, cmd->name) == 0)
+			return cmd->func(argc, argv);
+
+	usage();
+}
-- 
2.8.0.rc3.226.g39d4020

