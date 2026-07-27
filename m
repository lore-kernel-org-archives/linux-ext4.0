Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 638B53F660E
	for <linux-ext4@vger.kernel.org>; Mon, 27 Jul 2026 21:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785186850; cv=none; b=ddENf1EJDdCE1qObzsPLCRCf70/ayCO5Dh+0rdMUvbzozKfj2F5RSXR6Wl5cDKxK/ru3Sz5dXSTBizOWg/iVbJGL4jikCjvh8koz2DXnRzTXFQjn3Jd4pj7z8kcfer5gF/HsiChzoa57t5ZpeAtoaYQOtll7aQXQeZ7lnzu0yE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785186850; c=relaxed/simple;
	bh=G058mSD40Pp1ClpzXE3Pf7TVCXHFh+B/A2DBsQXQ17c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qqqHOOEpG3OIn1pBFbkJzpr/vXMNR/42s8mIBi0iMk7zkaMcDxHdc675oshwJqLTbPC/i55m2ZBfYyyMOppnCaKH0aSQlGzdR4oGcjWehj4ovccRG6BsY2ZU0qXppT9dnEXyp54w5nRYA1quy0cQJkRviEvYCEtvouBUOyCdG0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XOQFHZng; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XOQFHZng"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-47f92e3c14bso2872938f8f.0
        for <linux-ext4@vger.kernel.org>; Mon, 27 Jul 2026 14:14:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785186847; x=1785791647; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=yvqxEflleClii9lG7rJSLFCAGUePQRETM5YyTmDu+CE=;
        b=XOQFHZngwLqEMmLAtd8oHnP0NsDFwkOSpAQLfu45YK7sR5P1i4QADY4iOULrZC+SzH
         jizyEyZaMt+wiYLzGd+uJRjrWSTJ3FWU+CWpSHieVlaOUt6Ga739tPDRrk4rQpSMrLy8
         puhCbt22v2kBvwUBuV19gT1eV2wevakko/R//LM9rklzzxBskuNmk0cReCoo6u80kuqK
         DeP3CzZ4Z+Nuxxr7P1YTJlOtk/BAfApdMAgZY2tt+cVokpk9Sb38Wm3QAyTv480dYSTD
         AcbPEHbE1QH5Emi35knyRv/1Q7pQWLlgkBVMjCOUD2F0bzUzHJppxDbX47CSsqbILxj3
         hxwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785186847; x=1785791647;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=yvqxEflleClii9lG7rJSLFCAGUePQRETM5YyTmDu+CE=;
        b=ZWhRRvR3Rs/5D/jIbAbrORk9aEvB+Xgg43uaPlN3c7kI+yDUfoBpeMZrY9ljjZPLgJ
         1KfvmXQT/4PsHVRqjrhglEIyBNHImuezM+hJL8LTaLIZyu0WwlWrVIo4XNYx/ocOURvl
         thtM3VpcJbmref4eINEcGOmuHZ6kdY2Im9yeLH3hStRN2dA/k2WpZPc8pKTXJrMPepG0
         zX0nrhGObUAmpCsc1dNsCm0Fk2qRVBVE2T+Zsla8W/GfJ2GezMsuUdNqOOUuo0elEPnB
         8t+1j0TLytAeJUhxnz7HH18bBIhi/oiaqezdDSn65amTADXJ1ci/bS2tH0E/CxcQVV4p
         GHEA==
X-Gm-Message-State: AOJu0YyloEJoKWa3HRPPVl8OrpMN1/HsASs1h5NGqnL2VcCAZd/LLeki
	ftrrmet+2Wu+Mu1WeV5NgCTVAE3RBZGG7dqbRrRbI5n5WYGdDrqkJ5Fm2q6fXEJu
X-Gm-Gg: AR+sD11UtISLULbMQY56HI0TR+EOhz5bs2Cnf/DpvTNb6MAt3R41OqnUSG9q1PaLWle
	cwb6ORXae1WVz53bQdmbQ82ebIrr7BcIgBC8vK+w46pZZpxs13QFcJHmrYe7joZhSOSbKV9ogsA
	Uj+62ZFqfmn05XaD6kLMuETXKmT9wUWUTRnOKoP1CsWuB6hEK8VtZskNC0E/ES2KJH4gV0fN7LJ
	RPsU2i+xiKDo04b+c0WNvBlyIrFdK3osQnaQtx3VNZ33vUqZFJeb7bl62h2aeIIsj6h1AToPJ0C
	1FgPsWjTEdEUVau3mgbs3kT9TNDW5n9FwZcjY4PXIznnQ69r/3XMEA8LAkkJfiGSnbo1AAxZzTJ
	nybT8TsvwaeVOEi2lmDZ0m0d6yXHQ7v1SWQ9p/EQRzAD5oqvq11Fvi0pw+htx/Sw+tfMFOxTZ0C
	KpOHLXpnE8gBqYgTkQGwb+jjIdMmVvWzdhCg==
X-Received: by 2002:a05:6000:1ac9:b0:47f:703b:1851 with SMTP id ffacd0b85a97d-47f9feba310mr13053316f8f.59.1785186846561;
        Mon, 27 Jul 2026 14:14:06 -0700 (PDT)
Received: from Cluster1.powerhub ([2a0a:ef40:18b5:9e01:f5de:1ef8:371:ee89])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f85c67339sm54987049f8f.31.2026.07.27.14.14.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 14:14:05 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>
Subject: [RFC PATCH v4 4/8] ext4: add set_lufid utility
Date: Mon, 27 Jul 2026 17:13:40 -0400
Message-ID: <20260727211353.19736-9-ablagodarenko@thelustrecollective.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260727211353.19736-1-ablagodarenko@thelustrecollective.com>
References: <20260727211353.19736-1-ablagodarenko@thelustrecollective.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Artem Blagodarenko <artem.blagodarenko@gmail.com>

EXT4 provides the EXT4_IOC_SET_LUFID ioctl, which allows setting
or replacing the LUFID dirdata field for an existing directory entry.

The set_lufid utility uses this ioctl and accepts a directory path,
directory entry name, and LUFID value as arguments.

This utility is used by subsequent dirdata-related tests.

Signed-off-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>
---
 common/config   |   1 +
 src/Makefile    |   2 +-
 src/set_lufid.c | 196 ++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 198 insertions(+), 1 deletion(-)

diff --git a/common/config b/common/config
index d5299d5b..a19e1d7e 100644
--- a/common/config
+++ b/common/config
@@ -210,6 +210,7 @@ export LVM_PROG="$(type -P lvm)"
 export LSATTR_PROG="$(type -P lsattr)"
 export CHATTR_PROG="$(type -P chattr)"
 export DEBUGFS_PROG="$(type -P debugfs)"
+export SET_LUFID_PROG="$(type -P set_lufid || echo $here/src/set_lufid)"
 export UUIDGEN_PROG="$(type -P uuidgen)"
 export KEYCTL_PROG="$(type -P keyctl)"
 export XZ_PROG="$(type -P xz)"
diff --git a/src/Makefile b/src/Makefile
index 31ac43b2..a1f161b0 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -36,7 +36,7 @@ LINUX_TARGETS = xfsctl bstat t_mtab getdevicesize preallo_rw_pattern_reader \
 	fscrypt-crypt-util bulkstat_null_ocount splice-test chprojid_fail \
 	detached_mounts_propagation ext4_resize t_readdir_3 splice2pipe \
 	uuid_ioctl t_snapshot_deleted_subvolume fiemap-fault min_dio_alignment \
-	rw_hint fs-monitor
+	rw_hint fs-monitor set_lufid
 
 EXTRA_EXECS = dmerror fill2attr fill2fs fill2fs_check scaleread.sh \
 	      btrfs_crc32c_forged_name.py popdir.pl popattr.py \
diff --git a/src/set_lufid.c b/src/set_lufid.c
new file mode 100644
index 00000000..d9da680a
--- /dev/null
+++ b/src/set_lufid.c
@@ -0,0 +1,196 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * set_lufid.c --- Set LUFID on a directory entry using IOCTL
+ *
+ * Copyright (C) 2026 The Lustre Collective. All Rights Reserved.
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+#include <fcntl.h>
+#include <dirent.h>
+#include <sys/ioctl.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <errno.h>
+#include <libgen.h>
+#include <stdint.h>
+#include <linux/fs.h>
+
+/* Structure for EXT4_IOC_SET_LUFID - should match kernel definition */
+struct ext4_dirdata_fid {
+	__u8 edf_data_len;
+	char edf_data[255];
+} __attribute__((packed));
+
+struct ext4_set_lufid {
+        __u8 esl_name_len;
+        char esl_name[255 + 1];
+        union {
+                char esl_data[1 + 255];
+                struct ext4_dirdata_fid esl_edf;
+        };
+} __attribute__((packed));
+
+#ifndef EXT4_IOC_SET_LUFID
+#define EXT4_IOC_SET_LUFID	_IOW('f', 47, struct ext4_set_lufid)
+#endif
+
+static void usage(const char *prog)
+{
+	fprintf(stderr, "Usage: %s DIRECTORY FILENAME [LUFID]\n", prog);
+	fprintf(stderr, "  DIRECTORY: path to the directory containing the FILENAME\n");
+	fprintf(stderr, "  FILENAME:  name of the file to set LUFID on\n");
+	fprintf(stderr, "  LUFID: data to attach (generated if not passed)\n");
+	exit(1);
+}
+
+static void dump_lufid_payload(const char *data, int len)
+{
+	int i;
+
+	printf("LUFID payload length: %d bytes\n", len);
+	printf("LUFID payload hex:");
+	for (i = 0; i < len; i++)
+		printf(" %02x", (unsigned char)data[i]);
+	printf("\n");
+}
+
+static int build_default_lufid(int dir_fd, const char *dir_path, const char *filename,
+			       uint32_t fid[5])
+{
+	int file_fd;
+	unsigned long ver = 0;
+	struct stat st;
+
+	/* Build an IGIF-style default payload from inode + version. */
+	file_fd = openat(dir_fd, filename, O_RDONLY | O_CLOEXEC);
+	if (file_fd < 0) {
+		fprintf(stderr, "Error opening %s/%s: %s\n",
+			dir_path, filename, strerror(errno));
+		return -1;
+	}
+
+	if (fstat(file_fd, &st) < 0) {
+		fprintf(stderr, "Error stating %s/%s: %s\n",
+			dir_path, filename, strerror(errno));
+		close(file_fd);
+		return -1;
+	}
+
+	fid[0] = (uint32_t)(st.st_ino >> 32);
+	fid[1] = (uint32_t)st.st_ino;
+
+	if (ioctl(file_fd, FS_IOC_GETVERSION, &ver) < 0) {
+		fprintf(stderr, "Error calling EXT4_IOC_GETVERSION for %s/%s: %s\n",
+			dir_path, filename, strerror(errno));
+		close(file_fd);
+		return -1;
+	}
+
+	fid[2] = (uint32_t)ver;
+	fid[3] = (uint32_t)(ver >> 32);
+
+	close(file_fd);
+	return 0;
+}
+
+int main(int argc, char *argv[])
+{
+	const char *dir_path;
+	const char *filename;
+	const char *lufid_data;
+	DIR *dirp;
+	int fd;
+	int name_len, data_len;
+	struct ext4_set_lufid lufid_args;
+	struct stat st;
+	uint32_t fid[4];
+	int rc;
+
+	if (argc < 2) {
+		usage(argv[0]);
+	}
+
+	dir_path = argv[1];
+	filename = argv[2];
+	name_len = strlen(filename);
+
+	if (name_len == 0 || name_len > 255) {
+		fprintf(stderr, "Error: Invalid filename length: %d (must be 1-256 with NUL)\n",
+			name_len);
+		return 1;
+	}
+
+	/* Check if directory exists and is a directory */
+	if (stat(dir_path, &st) < 0) {
+		fprintf(stderr, "Error accessing %s: %s\n", dir_path, strerror(errno));
+		return 1;
+	}
+
+	if (!S_ISDIR(st.st_mode)) {
+		fprintf(stderr, "Error: %s is not a directory\n", dir_path);
+		return 1;
+	}
+
+	/* Open the directory */
+	dirp = opendir(dir_path);
+	if (!dirp) {
+		fprintf(stderr, "Error opening directory %s: %s\n", dir_path, strerror(errno));
+		return 1;
+	}
+
+	fd = dirfd(dirp);
+	if (fd < 0) {
+		fprintf(stderr, "Error getting directory fd: %s\n", strerror(errno));
+		closedir(dirp);
+		return 1;
+	}
+
+	if (argc > 3) {
+		lufid_data = argv[3];
+		data_len = strlen(lufid_data);
+	} else {
+		rc = build_default_lufid(fd, dir_path, filename, fid);
+		if (rc) {
+			fprintf(stderr, "Error getting lufid for %s/%s\n",
+				dir_path, filename);
+			closedir(dirp);
+			return 1;
+		}
+		lufid_data = (char *)fid;
+		data_len = sizeof(fid);
+	}
+
+	if (data_len == 0 || data_len > 255) {
+		fprintf(stderr, "Error: Invalid LUFID data length: %d (must be 1-255)\n",
+			data_len);
+		closedir(dirp);
+		return 1;
+	}
+
+	/* Prepare LUFID data */
+	memset(&lufid_args, 0, sizeof(lufid_args));
+	lufid_args.esl_name_len = name_len;
+	lufid_args.esl_edf.edf_data_len = data_len;
+	/* Ensure filename is properly NUL-terminated at the correct position */
+	strncpy(lufid_args.esl_name, filename, name_len);
+	lufid_args.esl_name[name_len] = '\0';
+	memcpy(lufid_args.esl_edf.edf_data, lufid_data, data_len);
+
+	/* Call the ioctl */
+	if (ioctl(fd, EXT4_IOC_SET_LUFID, &lufid_args)) {
+		fprintf(stderr, "Error calling EXT4_IOC_SET_LUFID for %s/%s: %s\n",
+			dir_path, filename, strerror(errno));
+		closedir(dirp);
+		return 1;
+	}
+
+	closedir(dirp);
+	printf("Successfully set LUFID  on %s in directory %s\n", filename, dir_path);
+	dump_lufid_payload(lufid_args.esl_edf.edf_data, data_len);
+
+	return 0;
+}
-- 
2.43.7

