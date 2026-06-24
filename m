Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 454D03B83E0
	for <linux-ext4@vger.kernel.org>; Wed, 24 Jun 2026 13:50:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782309032; cv=none; b=sGGrP7z8nHCwaKpT5v3HDrTP/FDXmv6FAoiMemZK592plTXSSrIgEAhC8Xlk7E4ulCHCrGUlPWOk7oeHO9TQ+8Qk9maIoLWKPDLfjFQPB/LO9/PRRx6gEOwDHy00m5nzREHuac3WJegJnPzmOamHOTI0fSbbuWYVmmiNseac1LE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782309032; c=relaxed/simple;
	bh=L95y/L0zqkwZvK5cJHxrd8+7jhNZxLS71A4b5maTI10=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a7ZljRkOna1CfyZlTz93uooN7e3UXr4eqiJdDR0Tt5ajW/nT9Y9+vpY1vp/j9xjxpcOMy96pCqn6AMMol0YpMAmSjq1vxDse6vmE9gSYkYT/JMkPCcDQXD7hC4g9EPoRW4sLsQASHyyxxdSvstWG4nDQ/atTCIbeWFqDDiwxXuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kJH2G2h1; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kJH2G2h1"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-45ef56d9b67so913176f8f.2
        for <linux-ext4@vger.kernel.org>; Wed, 24 Jun 2026 06:50:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782309030; x=1782913830; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=j5mPC0biWTJmAmQdDWsPqJPlSwz9diBK+lOlcnIDpwU=;
        b=kJH2G2h11nK/CWmVCm7O1ZoLebdhz/5lgKVlplTy03UkKpa9SchyJRAkMrFmb1nMvY
         I8BYjfg/uEiRDKVwa47LkNHEyDFtia/AxhaHb4i2ZPeV6Bb0tyrG+gcWTg4SvclVkgTw
         kzksLd3CcvovqzjlZmhVLV5hcURjUlGAN+CZFG3c+RPv/0Cl9SfdpsetJbxnliF4R34X
         Bqp920wicvAC3zR9v4AA5j5WQeblIJrRWYr/AxGGSXCHTxdDpui2IQCwbWdRHdzdfgXh
         Zqk2LDki+cejzcnn9SqP/8iDsOicsbsQ1HpfWlShVDuWRO15AZhsqwe5+Sv7xtNW6nXq
         TnXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782309030; x=1782913830;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=j5mPC0biWTJmAmQdDWsPqJPlSwz9diBK+lOlcnIDpwU=;
        b=EYcuxdUBAw2bCjIB4kYAFJbyTVq1b2gYfxGKRT+0LuJp09WaLzD4iRoZzujzhJ2eJB
         SzLEEfyN4015Bzmc+q14KfxowY0QVeI2H5I3b9myw6PdhReUal2ZUCEoR6odyDBHjAEy
         g3+uN2ayxvTjQXYTFweKEQ2GGI0gSUvqaLm13M7Ng3YmqCbJncppv7iULkExNg1ZPluX
         azOXZrOYgLCzZyPUXJTcaG9wrg8+Jv86UzLK8JdO3t+k1EVNe/ObqaJgeL3TQQYPSf7I
         kT2weTXwynb+McqtUP43xWSZ+CeyW71Aw/U6QxtSKs9LZKgpO070td5LTctFh8G1Xh0E
         iENA==
X-Gm-Message-State: AOJu0Yw1Gp6Nk1nlYDuXTbhlbzI+WrhsYAgaX2IZ6SIKAnu3Plm81vev
	5jJpB2wuDEsXmKhzuPVn5cuGKWUD4xAck7J/5jejm7mLAGkxQ8tshuuW4SOIz8PbbWM=
X-Gm-Gg: AfdE7cmLSHoTj+b/9u/pVCg8Q3bWIZtFloDrFGqWfggWGu0P3nQdmwqvCtdIeRkFL0A
	3KEVWMcUqEt3buxdfQHtJSCOrujGO7tcyNUpXfaCvMyq+FKzcR02fgBC/qdtPF2gp933oQZmzwE
	msNvKBlzkOdgVJk3Juw3BEd1wHsOIjtPnitMrPbWZTPRHQApTpzEM95gpwEnPadan7bY5FuH4T4
	4ESXBsWh/xgmfwOZrjxGSdmcZ6MsoAJjJden6miesyLtPSN0MFpU9wGC2hZ4vbFMRWjmdniadNv
	F/V9dgDBCrJFdvViaxkBYSFZ6bR6btyFdep0+vVOPBEv4/MgvhF+fdF1lzvZlONo318tn3zupPk
	BU2mFkUyKR+A3XiOsoSyHZRHEzE8L7W5/syjPOKHiTmArcYFJ47NwolvWMNoPhWxtHvSZ66xVx6
	0CPIS1EXS0miQqLZWKnqCM4NunZDTFI7yDLbi+ARwu8fqdUUFq+6epdko=
X-Received: by 2002:a5d:6151:0:b0:460:6a83:222b with SMTP id ffacd0b85a97d-46c0ad2762amr4247569f8f.28.1782309029500;
        Wed, 24 Jun 2026 06:50:29 -0700 (PDT)
Received: from Cluster1.powerhub ([2a0a:ef40:8ee:1201:acf4:9ddd:6ede:2d9a])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-46c1e840eefsm7791658f8f.1.2026.06.24.06.50.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2026 06:50:29 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>
Subject: [RFC PATCH v3 4/6] ext4: add set_lufid utility
Date: Wed, 24 Jun 2026 09:49:55 -0400
Message-ID: <20260624134957.19209-5-ablagodarenko@thelustrecollective.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260624134957.19209-1-ablagodarenko@thelustrecollective.com>
References: <20260624134957.19209-1-ablagodarenko@thelustrecollective.com>
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
index 00000000..92af6c6d
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
+	name_len = strlen(filename) + 1;	/* +1 for NUL terminator */
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
+	strncpy(lufid_args.esl_name, filename, name_len - 1);
+	lufid_args.esl_name[name_len - 1] = '\0';
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

