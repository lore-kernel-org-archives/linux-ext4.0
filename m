Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B93D5348C65
	for <linux-ext4@vger.kernel.org>; Fri, 19 Jun 2026 19:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781898797; cv=none; b=eAL5IErqgUASQMwtK440lxYS8cx9xAr1w/VH2zEQ2I76cxnWw5F4F1K7vfHfyGvFy6aTXXSxOAP0IiJedjUhEa9seQqcvt2n2rHdQkITu9LCRtBkE0Vlt0kTqdUtPOYdYcMaC220Th/npatVXhDulk8iDbxHhLIsxxmWXYSSAdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781898797; c=relaxed/simple;
	bh=ZsVJBLPclyXP/TeUlMsWmfUeGBfj0cenDVSlzvOaWAc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GK/I0+1V5if8HgeauYyQf317wIVZvf8dzq2MeyGaYJLSqmp+BXwHjm88lB+rmjdrsrt9Ub0nv/7Wu+Ffw8HNNKTaVU4+w9u6IyG6lniCBFyYPw7FZNxJfjqzyeS9p6xPpSkB4r5pmxeo+uK747NyrTF6TPgvtkg+UHR9mpsNpWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NzHlXxbl; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NzHlXxbl"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-45fd461e4a5so1900825f8f.0
        for <linux-ext4@vger.kernel.org>; Fri, 19 Jun 2026 12:53:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781898794; x=1782503594; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2xSoDmuCx7KpjcfrZhW1yQFQXnigKCWkvdcP7uQhtTM=;
        b=NzHlXxbl1CoIc7s0Up4L/NXfKRud4DnRmryhx9RxuBrjGYnsK9TphwDfI3K3oRuAkM
         Y/FKnfetrg/SifDvxs2J+OGdSrp0VERgst8PERrkQGO041p1FCyrB5lMrBaMYWHRxu6/
         Vt9lPIiL7JQieOuZAKuPvH3HWUo9Aum+bVQJ527beHqy25OS65N2Ll3Q+bGEN8aPVCNM
         y2vh/TcAdJJ8jv0uZwTtLW4wMtWSFaiEsug/EE8bfaD09T1AcK9SFYOFQdIKTdZza2xh
         pZrc0BcJM7BnoXxp00G6WDb/ffbsyK/gALmviivRTy3PrJT6hP2isiIFYIfwrHW0lkj4
         3+KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781898794; x=1782503594;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2xSoDmuCx7KpjcfrZhW1yQFQXnigKCWkvdcP7uQhtTM=;
        b=SecWCJB59w2dw/cdC9Zy2K2Pq/gFZ141KF8fe7hAPC1QEk2dvr57rd/5NvB7tsA7i2
         TGpWvoHXdPMh1tpI6nyaGD1trDXeB6VyFxGF64Dhmrw/NOvqbhcx8PYrCuU4yGYi3ez8
         OTb+UeyOxH53bNk8GDyPXj28sxvX+6I76ilPjIyvfpd31Tf+eGG8sRqJGs6uFlXrHkgn
         wS4autHh1kUKKdui10ninFK5TdrJbtVbF2iw5W1q6eiPmTyNGJ68Kxyy5ii8pQMv1wFn
         bch0wlqs35plcZgh2h4Dsq5FyA2XVOeYRPTLaAVknkviJq+nK6wGi96idmLQCATQ0ZSI
         I8sA==
X-Gm-Message-State: AOJu0Yyud8btvRHHVHNeQ77l3RqTqpr7QsHpzJZqbujZ5zxVp0PyK2CP
	wg+Jtzb1P0lCrggdeS12ZDGEcfdkRggeIBoypvAUjlVnhoSsyGdV98bE6NT96Zsjr8aC0g==
X-Gm-Gg: AfdE7ckRDf5w9xrBgfp1AlfrqF/8w5ZljMZK0BR3qzJ2pQCrrZ7nL/JqP9zyKsY8TZ8
	S7vQAvNuw8iOBC5E+k/4Doi/PV+B+0Nfr641eBBkXAnJ2ANltPV+ny+GcWDqRjWZkgVRHAEbvVs
	q4JT/SsiW0J2E7eBGR1DrjKYLEsZFaOrZphhy5FZKeYfoEeNBT3dGkSPYaCo6waVGYd4gSOu1Tq
	dJ7qXEpUj3ga80YIugWTcLuuZ6eUysiWL9eOwSJGxvjG2alQM/KLF0BGSPDVxGJydfQbr/dMFKD
	E9kBC0CsXB9Kdds/+JxquC9/xtXXVOv/7qd6R6ln2Agk+GKe945sUEYU3uBkU2I01KV0hIPBhgh
	jkSPy7B1ZaXZ+ODTeqMJ93EBnZaO+oaJMkkVt8L8ViK9WxELiPI/zI/oFi/w7zOfw9jnfwx40lq
	Fj2GIMOcpJ/NUUfexCbwJQ2nRanodzV8GzqzNTe6IKTGNQjpLTAeX/
X-Received: by 2002:a05:6000:4705:b0:460:2d57:fcf2 with SMTP id ffacd0b85a97d-4656c1b8b6bmr6507659f8f.10.1781898794089;
        Fri, 19 Jun 2026 12:53:14 -0700 (PDT)
Received: from Cluster1.local ([2a00:23c7:90c1:9201:ef47:d559:d907:fd0b])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-466643f4e3esm1430822f8f.8.2026.06.19.12.53.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Jun 2026 12:53:13 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>
Subject: [RFC PATCH v2 4/6] ext4: add set_lufid utility
Date: Fri, 19 Jun 2026 15:52:03 -0400
Message-ID: <20260619195205.29384-5-ablagodarenko@thelustrecollective.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260619195205.29384-1-ablagodarenko@thelustrecollective.com>
References: <20260619195205.29384-1-ablagodarenko@thelustrecollective.com>
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
index 8468a600..2ca23207 100644
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
index 00000000..2e75939a
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
+		data_len = strlen(lufid_data) + 1;
+	} else {
+		rc = build_default_lufid(fd, dir_path, filename, fid);
+		if (rc) {
+			fprintf(stderr, "Error getting lufid for %s/%s\n",
+				dir_path, filename);
+			closedir(dirp);
+			return 1;
+		}
+		lufid_data = (char *)fid;
+		data_len = sizeof(fid) + 1;
+	}
+
+	if (data_len == 0 || data_len > 255) {
+		fprintf(stderr, "Error: Invalid LUFID data length: %d (must be 1-256 with NUL)\n",
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

