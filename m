Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 654B63E638D
	for <linux-ext4@vger.kernel.org>; Mon, 27 Jul 2026 21:14:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785186857; cv=none; b=CWP4F5mUl10uHl7eShL4fnqk6rSBTlVuhuwEDRVRxPyMD37FHR6oA726Gxe2hwNUH+yl2rXmpsp3KX1/yom4AjRqhMJ8EahiFe4yY31CV0QvjgRuUdwL6EGIGuGwtzlrhIJgE1sOTbNp8HoXEHPCsaxD99rt5t8ywCQ86mevFuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785186857; c=relaxed/simple;
	bh=G058mSD40Pp1ClpzXE3Pf7TVCXHFh+B/A2DBsQXQ17c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uf124ij6d46wSmwPCA6tRk7XzazmYvbmM6QunkxQTULR4RApWIeBgqzWcnGrxw/JdWaC2K4GctDKSpzqVLE8n0eMDtdfzsC8lKxfA7rDVhbK1xHtb7jrneZxUcXtluJHeL9QQqkqKS9m7kI19iWhTI38cUjkdxjAyJgcD3/a9XM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JWfRpw/T; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JWfRpw/T"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-49550ec592cso2104415e9.0
        for <linux-ext4@vger.kernel.org>; Mon, 27 Jul 2026 14:14:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785186853; x=1785791653; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=yvqxEflleClii9lG7rJSLFCAGUePQRETM5YyTmDu+CE=;
        b=JWfRpw/TZfuA3i40gPTG+4HYoS47eaLIknSWw7fkNPs+JKFYN27/zC9RAq4ffGtPNU
         spOuiMnXdiRthy3YcUKsT0GrDYYn0dJA89p1N1fRjSZbHgPatju/QiVQwBx5CHL44QrG
         0G5+MwHUaaom3Z20L8P/oIGU5yNuxTAFM5sQfA1asB3vITb1d05X8DNvGbDd+LuRgYHF
         qmvtUNzwOMiUfJ1HYd5sMEHayqgCtB3XGXfoFZhGGNV1EWw2R394lxv/+4AozOk01QhC
         HfKzbbHwcoEMtSIXBvXXRK+B9LvhtI3ruxsmVwvNRS7dVgeZ8qOOmlvh6YdDqF9pKf73
         Ipbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785186853; x=1785791653;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=yvqxEflleClii9lG7rJSLFCAGUePQRETM5YyTmDu+CE=;
        b=nEpszfBg+ZCeNbrXs/mN7N2jiwEUlxVFWOVR7RX8lAmi1JDl+nBdSebRCVPmzkgwBL
         Bzn4w8wAspnN9EEaVz+XA2Gk9TTFmgXmCGHEcyIEl4wb+1ZMFoEOdwjXwSW1nNgcdKKN
         sBLU2u3OdMn0s4V6/RHP4PKA5Hex6f4ZQcSRGQnDmaBAzBNU4oEfQwpav/ypARBg2QtH
         +dFY6jpe0m07NxKvXRFPT+n6jX+D8fyCr0yY0+eR4oCFB81IiRrk+3FLNQIpyjjAUT2O
         vgVMWE2XNdDYgghDbvohg6hBejfbTRnkuLJTiWHHs+XQWscvDPE2ldHeF6b22AFzQBb3
         4K1g==
X-Gm-Message-State: AOJu0YykgCKS9NacMKCm9MJAcSZ0BWynsGuuDIbGxSkZSjw7XIFMax02
	7m7/nHoFQ2kv6ai0F5WfZi5VPB7SSQLJFw3ckvRdSBOZn0tGmhoWrwEcQoce/we7
X-Gm-Gg: AR+sD12AXNb75fb2py8eHANWRl8yX37yrm4TjenFqDlMlMXyPW286qN/G4kWBmkvSYj
	jwOm8qzriL9gdkcCDluYqg7iFxO49zo7xbENsGfNkL7kpbrBVFbjZYZxG1qgHL/1FjND8tBVuEp
	QBcjlIiPbLHiOMX827b3tdkiAwbW+BHVxOrAJvygiAQyHgjNAkhBc1HZXV8LfvVnbBAxeFA2v4/
	dsFyADmLshQ5i3qoshacchwyN3TwmXyTevK8LMD5DUwv41tcY9OPJ+VIU/Mo6GGR7EqXh/HgKzB
	w6F/q7FTOZDNT4elyXlzcPfGf9DO9+JkwC0+GSXfQ6THztEmDNIDglxMz5ag/Bwjws+FXgBVEJP
	G/FoHss3GxWl/j+ncTbyVprwuR6oO71Ip3Pdvn7LN1DIDrlx1ysdD+hclZFZ/xLFNGDaaRDyjPC
	nSa5XBtl6sRdk8U9znYvoyWvUc7NIs5Z7jsQ==
X-Received: by 2002:a05:6000:2dca:b0:47f:8cd3:4bed with SMTP id ffacd0b85a97d-47fb0324b18mr382600f8f.5.1785186852558;
        Mon, 27 Jul 2026 14:14:12 -0700 (PDT)
Received: from Cluster1.powerhub ([2a0a:ef40:18b5:9e01:f5de:1ef8:371:ee89])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f85c67339sm54987049f8f.31.2026.07.27.14.14.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 14:14:11 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>
Subject: [RFC PATCH v4 07/11] ext4: add set_lufid utility
Date: Mon, 27 Jul 2026 17:13:46 -0400
Message-ID: <20260727211353.19736-15-ablagodarenko@thelustrecollective.com>
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

