Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793276938;
	b=vkngHNBMCfXSzqZYlSBTlmaYTlQiXV307KsJYfV3tqj02F42YozSejsnguLr36s/RqLR
	 Bpcmy7tb7UltxqHnnADCrIeXcQwyWIVibkFfKJ7e/ufhUh2MnnsKdsG4oSVxYI5d4mUim
	 m2+DtOQH4JW62llezFA6x+9RXEt+AuY9LypdIoIPcKVbYjmtB+py8ruR690/RrzOujYCv
	 Mss9vAEmlsi8SU4wRnUDBOtvh/ejjPE+al5iS207CYO7YILzi9+zsgwMtafHAwrtoP9yh
	 /k4+6O6wXxa9bSpVMcyRdG7KRR7K2GsSEoil0VIMr6INAu6uVwMG8PPDOn+P000+csw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793276938;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:
	 X-Google-Original-From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=Hp3kP48xuTrTKK7wCJLZCredy5L8Nv2jBeLHqVbKxMU=;
	b=Ffr82Qebq+Io45CoewUn7wyZN/V+ItLy0+izaUI54rQBXHNdfvo/uBH8GVhIP91s3rGK
	 p4d3OmXgP4NTD4vykevA9h7Z+ohRDZB+gG1ZTy4aHcMfcehI7XSnDDuVuh//l2C6ndlPK
	 0yWjZ2pyuWOBcFa/SME35pPr60oTO/DXlybjFVkBoN9npA1iH2kS5i0Ch781bMUN8hoTd
	 8uNj7hgG8uhrTtkgS0vWj/zzVN0g0RjAeFkIR/2Ij13dgt+DAPu06qhWOQOAUQQzRm31p
	 i2UEH08NwbVW337HNEfKJkDsox6gWgGMcuyMe0RYHJ9PgobvaxhkkF+Uhp8S902Oxzw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=dPZD38Ya;
	arc=none smtp.remote-ip=209.85.128.53
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F78A606A31E
	for <linux-ext4@vger.kernel.org>; Thu, 29 Oct 2026 12:28:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7F78A606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=dPZD38Ya
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4a20bde60a0so17054495e9.3
        for <linux-ext4@vger.kernel.org>; Thu, 29 Oct 2026 05:28:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793276937; x=1793881737; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Hp3kP48xuTrTKK7wCJLZCredy5L8Nv2jBeLHqVbKxMU=;
        b=dPZD38Ya+N1qL6Bx4BsBTFFGX6UOZ8SU3H0kgpPAk9eovl9tKFDNTYVgkGSCYjSKg1
         rFzfmId9gXd5pZ5sW8IO7BvG7ITPB331miwozTDi9yENS+RYheFC9KWe2cvFGDsvTtFD
         skmzQLr/uqoBLguDrhU9n76Mq8tfIEhXYjhycwGgsLXeroL3FT5JoZRGkTm4+Jlic+Og
         8euf3U0pSqo6hLnwXHwcldSjS7qDWQufh7SKJoNle1jX1aqzOl7U/kiBh0cWRP+oKfzF
         SRoF1oNvQQ3S4u38u+iVLIc7mRwDrKJSDYCidKUxEluBl8SkYixTak7+SP6bkfIwi2et
         nAug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793276937; x=1793881737;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Hp3kP48xuTrTKK7wCJLZCredy5L8Nv2jBeLHqVbKxMU=;
        b=u23qSojTnR1aPRM5Sk60JcsNQfrcw4sLDR4NUgoiyzVeBExCkLHOk5sJy/TG2rjOjp
         s4UfB0TQMryeSBXbOmP5iDNgnQwugPzu+5pKMF0Hv1KUfvB/Nr2Xcg8CW7cukAF0ZGa6
         3bAxXFmoVXPirfOA+OK3K1uMuLkFd2sgeC+O5k/PdCWBUvm8VgBqa+6D0V1kNJRBW9jS
         dFBqwoP7lxd7F4AWP65dy97UP67JqEQrn6y8O3/d2YnhoAdvuZJLGEPhPEEtc8RanGzh
         SGojeph2PWNWkRuegEmKrv7/bI2EaCCTcCe5F/Pqc8OLDGL5Y4L6+LVBR81I7/9xd3kV
         UBhQ==
X-Gm-Message-State: AFq9FYKKQv884vgEzrvk3cY6LIqjoAq8T8HhridK3o1icmw6n1sZiPxD
	WCg8kyFQCtduzhQovAdfywagaxq21sJIliGuqjG8m+aMGwjta9ns52UPGVsUOD8v
X-Gm-Gg: AYBFou0AM/8T8c26ThqEXUuP2QDO/EMSILbW7szdDwKMP390pXQfiqFx+un9GKBUGw8
	imMXrvMsHq0/H7VL9aCHygQ96Dd9EHyA7BbUNUYoaDAqfZ+gU0+Ppn7yLzYlsN7hGsalGGd9R1e
	2o/YzO1tSnmETDOQnjBAG3U/baSaCabIau2VWpqMnPtykObrb9/2wyOe1rmR0Eh59NCq9HnRKPD
	YffTNgGQyPXZtF+kKp5cBmkZ9SaH1etOr2D5AZ6rbLreYH3j4ZZ/t2QkVGqYiw2HQLSgBpRf5rm
	HTo6fm5bDkQQQwdIxsgCtFCA5OOwAp+gCpjqoVqvA89x2mJJ+240pDUSveIgAvdwJQS+H/OXuF2
	dGoMrStck6SbjlDoP5QczaaKx6azw6KNK7vLVlkI7+71Z+8CE/j2HPt0aRYIIAAZfzDgzqp+fdl
	V3buRbUE2dziopP98BaRbDgvtF97UqXwnLmE3eCROS2MqpHrJGEfjeWQkskAKvwwPddUgcNwuSw
	RADokwlQ8xEqexSZi41rF/2DWD5C7Pk8cyUIuz/svnAqApFqKiq+SrkyBIyfMXyCZoe0j9MnwRt
	+urHYqopiAa2Z9xryG6pVPdrr2btDSqeaIUxtBShWGGkZoDROhYwN1IMHhe43A==
X-Received: by 2002:a05:600c:810c:b0:4a1:fc98:1cb1 with SMTP id 5b1f17b1804b1-4a963d1b300mr111830615e9.2.1793276936718;
        Thu, 29 Oct 2026 05:28:56 -0700 (PDT)
Received: from Cluster2.powerhub ([2a0a:ef40:18b5:9e01:225:90ff:fefc:9ffe])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4aa7f7f50d3sm92477915e9.8.2026.10.29.05.28.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 05:28:56 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: fstests@vger.kernel.org
Cc: linux-ext4@vger.kernel.org,
	adilger.kernel@dilger.ca,
	ablagodarenko@thelustrecollective.com,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>
Subject: [RFC PATCH v5 4/8] ext4: add set_lufid utility
Date: Thu, 29 Oct 2026 12:28:35 +0000
Message-ID: <20261029122842.230704-5-ablagodarenko@thelustrecollective.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20261029122842.230704-1-ablagodarenko@thelustrecollective.com>
References: <20261029122842.230704-1-ablagodarenko@thelustrecollective.com>
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

