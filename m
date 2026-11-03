Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793713881;
	b=v6keSDHx1uDVcZrfsegcWfgjGdGk/7yjSFv22vqziQME64lA0kX2TdriQLkNEA3XxLFG
	 1cg//Y5D9QJnjmn7ch8PvjBSb4mm+IDDu7Rj1ailS7bLiQDi5NRVDdMunEchq6lIINCE9
	 TE0TwAWWElwf0xMtntkngPyIQrA3dlmOXssJouHnvn5HNiPJ6FwAqNKBcsfXFTekdG/H8
	 6VwLL5dqEt+qK2qGAygF/9Rd5rK3uDx1h1hmQnZerApI6+3/6rVMVW430UUwaGl7glv76
	 2zsYpTBNrIH5qoMI6nQfGadlaNpZgZqr7Db/3oR8BhTEfRbfkNPvWlSX1Fx9r1Puvag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793713881;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:
	 X-Google-Original-From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=Hp3kP48xuTrTKK7wCJLZCredy5L8Nv2jBeLHqVbKxMU=;
	b=dDMFpZXfbBMxMTrilFbUduTCKcGRRlNBUxf6uIPyPlfFyHo2QGrsjWFDEdvewO5uwp1G
	 f8hx0GhbrKvdPgbV0purwSbSrK2QVZorfN7qpGA46FB98VeSMQejsmd+jUZIiN6bg9Nor
	 K7mD62kBBqiQoJohtFJ4juMo50NFvVj8Mz/dDAn8vMMN+5oj35D3l53pN309yR/OjsPqE
	 RCw7C/EbLysN6dB4LCV2BFtZIJGTrx85j8K35JDap88+jgrGyUfhN6+vUSQuqW++IE3gc
	 PeBdGcsEOmfaoaenwrD1zJ7zyFY6uzyr3BQoS/7GMlwljMmI05fvyiuDs5Q7nJZWmAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=mwpAiwG4;
	arc=none smtp.remote-ip=209.85.128.43
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3E5B608508C
	for <linux-ext4@vger.kernel.org>; Tue,  3 Nov 2026 13:51:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A3E5B608508C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=mwpAiwG4
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4a215e64962so38753465e9.1
        for <linux-ext4@vger.kernel.org>; Tue, 03 Nov 2026 05:51:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793713879; x=1794318679; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Hp3kP48xuTrTKK7wCJLZCredy5L8Nv2jBeLHqVbKxMU=;
        b=mwpAiwG4+u9182LIGWvwmdDWBa3DQICh2YzzG0hCB1MST77g7LNIKAsN40ZLbyvZyX
         azKD28rle7uqSsWXSzr+xgczbZrSlbKwsqTE4NTYlFoHG4RRVm2UAnZ/VDQ0d3+MXtFu
         q9T1H7k4mYI0j6yGkTs/WJnKzR5JojMgcGwtsTKbIIKcGV5mOj8EydoGW2nQ2lFht9S6
         hptEajmjC3E0NzLX+zdu2w+/g9kqkNbLZGH7QHLorzCvyp1kRFNsn2mwNZLMdDNQWnWQ
         DCrEQi8vXOgJ1bKBbkkj9A8vtJXW7GtLG/40qag4SxOAnv392ArlzrSRJB4PnOlQn9Cl
         NVNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793713879; x=1794318679;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Hp3kP48xuTrTKK7wCJLZCredy5L8Nv2jBeLHqVbKxMU=;
        b=Q7rPYrsWa4DUqecc3SnCfhy+3tNwSbgv9Udooygu+6WC7+0zYaR9Fcm2ciSUTjiMKd
         0zE+CuytmU2X7VHIbaazy8n0UCTQbmMzTLFoR3ASI+THq8nZNDwFthtqSqOrUZXOEEqW
         N2pleOueTvgoE6oa1uGuDPVpP3sYjKXbxDskBgSev2xZXDY2KlPZdpk29A6DT3MrIzA8
         0qlHUXHRN8h4Z3Jf5LhxttD9C0utvbOcr/oMFtgE9lQ8qnl0zHNX5lapEnZKaxfriBUu
         tentfU/dWpjAFi7vrF8VfbZ4My+2m5kgyYCNnp6/zx0Ol4UoNOwpG4uxp2SLRPIyAnkn
         cuiw==
X-Gm-Message-State: APuU4Z9hX9Wlk+KTEb3zr9gx7igNdMCmUHu+cDFI/Ibpqi8OhpyyoYDM
	uQpPP2671rtoWUlqsU6Fjmx5J9wFvDjVg2Jx9YT5h7JmbT1w5xGOQRPebQBJNY/Z6eY=
X-Gm-Gg: AYBFou1S2QkApvC56uxq2Cm11H6n6i5bYVvVFvdIs9/SBtnfhMqrwz+A0rkzoFkpEkW
	RGyfLxuYaQlZwxAkqHBtWDQ49TD1NDmfGlHZCc5TYYerxKZuvwr3zkfkBXOSHMnUxdVUGZmTZo9
	UW7dGbDV2xcOdMd6gQkqednKmGC8g7/GKZvJ+nF0y0l3KqlOkJH1U5DLr1Vsv3hL0rW0MCIz92m
	WqFUnFVNHbnJ/AmEjXf0z1CXIybvDWArZsOKVYmmpN4wuAMhMr0gfmQjBKr+3lyxHNarKZWHiZp
	sZbdPgGGyffm+wLe+/KOyQKAuMYeC5mJZ4asgXG1weGyrRffcpMBXx38AEVPoRl0YQizlApQlPZ
	o+ltYPF9P0KPLFPl7WX63//XlINE+ItbGhfY+zg20QDRWFOkC5EmA8P/KhTzp2q+jQkosPKEKCM
	Aggq+1rUDYrZKdGoNz9LpqgjP1sqCYdbHFVVaqTMDYG0x2aQi4mxZtMDixJK3Sgi9FSEbTZGozo
	senS5N3maSHLnu2Q4Uqhx7kF38q9VeMp3HHWCys42O5o/D6K6azAY7abGlYRJpsz2kjeYyEzkNb
	MXgRneRsdiib0ajOvVfSR30ShJYuTQS3zbXex2jLCQBOEuFrb+aGXcbQZKJ1Xg==
X-Received: by 2002:a05:600c:5397:b0:4a4:4d57:8462 with SMTP id 5b1f17b1804b1-4ac18b7e65bmr297316825e9.24.1793713879003;
        Tue, 03 Nov 2026 05:51:19 -0800 (PST)
Received: from Cluster2.powerhub ([2a0a:ef40:18b5:9e01:225:90ff:fefc:9ffe])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b2a96fc87fsm55320335e9.12.2026.11.03.05.51.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 05:51:18 -0800 (PST)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: fstests@vger.kernel.org
Cc: linux-ext4@vger.kernel.org,
	adilger.kernel@dilger.ca,
	ablagodarenko@thelustrecollective.com,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>
Subject: [RFC PATCH v6 4/8] ext4: add set_lufid utility
Date: Tue,  3 Nov 2026 13:51:00 +0000
Message-ID: <20261103135106.610169-5-ablagodarenko@thelustrecollective.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20261103135106.610169-1-ablagodarenko@thelustrecollective.com>
References: <20261103135106.610169-1-ablagodarenko@thelustrecollective.com>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
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
 create mode 100644 src/set_lufid.c

diff --git a/common/config b/common/config
index 69e5d833..e0cd9ccd 100644
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
index eaf0621f..fd70f407 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -37,7 +37,7 @@ LINUX_TARGETS = xfsctl bstat t_mtab getdevicesize preallo_rw_pattern_reader \
 	detached_mounts_propagation ext4_resize t_readdir_3 splice2pipe \
 	uuid_ioctl t_snapshot_deleted_subvolume fiemap-fault min_dio_alignment \
 	rw_hint btrfs_ioctl refluxfs xfs-exchange-to-eof \
-	xfs-exchange-to-dirty-eof xfs-swapext-reflink
+	xfs-exchange-to-dirty-eof xfs-swapext-reflink set_lufid
 
 EXTRA_EXECS = dmerror fill2attr fill2fs fill2fs_check scaleread.sh \
 	      btrfs_crc32c_forged_name.py popdir.pl popattr.py \
diff --git a/src/set_lufid.c b/src/set_lufid.c
new file mode 100644
index 00000000..42fc5a6d
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
+			       uint32_t fid[4])
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
2.52.0

