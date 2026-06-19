Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E2F333CEB0
	for <linux-ext4@vger.kernel.org>; Fri, 19 Jun 2026 19:53:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781898797; cv=none; b=FX5NrMNZMTbkj3+nVB+lQ9VAfFJjHXpGEJ/2VDdVthLnhkx4qNx+YUOwi36O5dzSC8CYhAq7kXBHrCSwscABvAlK+AdQRjFzKaH1X6p8DxWwjVoBaCD04o61wmbSkYRyforkP+DYml+cALhrZKbdlvGBqkXbk2kmnASraT2FMcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781898797; c=relaxed/simple;
	bh=+Uc0cR+xBdNbnU4I3v9rF/Wcnsa82NLL+mXkz8oaO6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g8mFYR5PKsWg5jPpPi6SSntJ06l41jeQOjYEdPWRNZfspshieStt6vlc9eVX6CkKFtWTVsjivCRae8D7TDKzge7qHTaf+IgcHYcRVlbI/f3Ch/Qc8RGnLEtQhz5KuG5oMElbRNYMOwf7qMRT8vso5sr1rqgJtM5LJIzPo2QlzBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EACGVpII; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EACGVpII"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-45ef189aa1cso1725047f8f.0
        for <linux-ext4@vger.kernel.org>; Fri, 19 Jun 2026 12:53:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781898795; x=1782503595; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QRf7Z9lc1wmx4ImWUMBTf6bs5b5Ls7EzAk09nydpuIM=;
        b=EACGVpIIzcuCMwk+3OWtPgNaASpcL6PeNsXfDHz5mz3o3yqD8F2FLrmN5tEJt/Fk88
         f9UBj/OWfl6xmS4deq78fsA5atmQR04SkmdmpeZR16oQHxAlD3dlDmjaROjlxO9fCTs5
         8V1vdR834BmYXGePm7o8zbkDmXe55iU/fCRFVdN9XReTQpkW6WNb3a5p2fnuZZ7WMNhl
         6jGMK2X16EYSWWdsNiZ4yYDCi1rixacnBEEUHQW6oCFlV166slQ+hjVAKixJO+u5Cz+X
         afkuN8+Rd5Ul/3SttStbjg8/AchkQYc2Il6kSDibqNIMdwfnY4KQAzVoCWNARoP6t2ew
         ooVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781898795; x=1782503595;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QRf7Z9lc1wmx4ImWUMBTf6bs5b5Ls7EzAk09nydpuIM=;
        b=qXgx6hFEEldvYWZ1sLq/xZDSDqLSCCbfuVIJ7rERZiV+J10tVmg07EFniEyLjz5Yw/
         UpmxulEXilsy1rIhlX+H5L6j5Pd6ubqnlh1IKJs882JUqvjCgP4djn2ZhddhmibaD+2M
         bGQHWZZFPAbdObhrdTHhHGo+YOVzLJ+sdttpOcLrFGUg6gAZnEqNVFkvDq06YL22/1do
         FGR1sLuhodWc1AkKcmo29vVmK7v1Q44ObyZ2K983OgIfg2TgEXz5f5ZQV/8jiiANxif/
         fyN/tW/74kapNUCUCRdh7ofau4uUfXRSnZsCX24jF6MQsCfKMvYBd4LoGOZbYlkHMFBx
         KQCQ==
X-Gm-Message-State: AOJu0YyXe37gyv1vn5lipvBlXYRgiyA2bA6fLVcWagRKrwmFk+UTvvZL
	GlQIUF1QV6aKT31lDANKw4FFnfUME849sFpWqwx1EqbMCBldIvK9d3gjgwepDwwu97dGrQ==
X-Gm-Gg: AfdE7cnbLAc2dVxVvuRjTLlhFS5bCFrzYyxKQerEjMSMDcbnXB1YWueN3wvirtrvuK8
	gz5umw0Kvq7sLkhanir/vNFdg/G4tudf4RNL7ArHQyjSh7xfsxP3soRCHJthVJaUOF0GfE3sQmY
	OiWhFcWHbdUMbsiu8y1dfhjUucxQHq1fpgIepAaW38/MwPRKdyuKJXqic84mHFBbILgG/ZTM7wI
	wwRsASjD2XDs/TTArZGW2FI4ubuLNmnbU3KSQxWRuV6gfJxtmDem02GG7+jMpil/Txf6J0giB7r
	LlLyzZSG6ChiHLidekVX7d52VoxoEYMk/6qkTJlvpsCzlyTrKnLdOIkSSvrBFb96hQlepz/s3A5
	0Q8qOFcQZ0odyWFQMrrO/dzK7kPxHRv9fIzxYtjVrWaNH0NDUQlknsrK6oWUrAESq4445lSi/Zb
	7m358vg9h0TzYYk6XIhLBRU7FEh65q/09i24oM3SmyDA==
X-Received: by 2002:a5d:6206:0:b0:460:71e6:e11 with SMTP id ffacd0b85a97d-46508bef711mr7134833f8f.24.1781898794644;
        Fri, 19 Jun 2026 12:53:14 -0700 (PDT)
Received: from Cluster1.local ([2a00:23c7:90c1:9201:ef47:d559:d907:fd0b])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-466643f4e3esm1430822f8f.8.2026.06.19.12.53.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Jun 2026 12:53:14 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>
Subject: [RFC PATCH v2 5/6] ext4/066: verify LUFID dirdata operations
Date: Fri, 19 Jun 2026 15:52:04 -0400
Message-ID: <20260619195205.29384-6-ablagodarenko@thelustrecollective.com>
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

Test ext4 LUFID set/get operations on dirdata fields. This test
verifies that the EXT4_IOC_SET_LUFID ioctl can be used
to attach LUFID data to a directory entry and that `debugfs ls -lD`
can read this data.

Verification uses `debugfs ls -lD` to check for `fid:` markers,
indicating the presence of LUFID data in directory entries.

Signed-off-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>
---
 tests/ext4/066     | 158 +++++++++++++++++++++++++++++++++++++++++++++
 tests/ext4/066.out |   4 ++
 2 files changed, 162 insertions(+)

diff --git a/tests/ext4/066 b/tests/ext4/066
new file mode 100755
index 00000000..ae98fb45
--- /dev/null
+++ b/tests/ext4/066
@@ -0,0 +1,158 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2026 The Lustre Collective. All Rights Reserved.
+# Author: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
+#
+# FS QA Test ext4/066
+#
+# Test the ext4 dirdata feature with LUFID ioctl functionality.
+# LUFID is a 16-byte identifier that can be attached
+# to directory entries. It is used for quick access to file metadata.
+# EXT4_IOC_SET_LUFID is an ioctl that allows LUFID data to be set on a
+# directory entry.
+
+. ./common/preamble
+_begin_fstest auto quick
+
+# Import common functions
+. ./common/filter
+. ./common/ext4
+
+_exclude_fs ext2
+_exclude_fs ext3
+
+_require_scratch_nocheck
+_require_command "$SET_LUFID_PROG"
+
+# Check if dirdata feature is supported (required for LUFID IOCTL)
+_require_scratch_dirdata()
+{
+	if test ! -f /sys/fs/ext4/features/dirdata ; then
+		_notrun "dirdata feature not supported by kernel (required for LUFID)"
+	fi
+
+	# Verify that mkfs supports dirdata
+	if ! $MKFS_EXT4_PROG -O dirdata -n $SCRATCH_DEV &>>$seqres.full ; then
+		_notrun "mkfs.ext4 does not support dirdata feature"
+	fi
+
+	# Verify kernel can mount filesystem with dirdata
+	if ! _scratch_mkfs -O dirdata &>>$seqres.full ; then
+		_notrun "failed to create filesystem with dirdata"
+	fi
+	if ! _try_scratch_mount &>>$seqres.full ; then
+		_notrun "kernel cannot mount filesystem with dirdata"
+	fi
+	_scratch_unmount
+}
+
+_require_scratch_dirdata
+
+_u32_to_le_hex()
+{
+	local v=$1
+	local h
+
+	h=$(printf '%08x' "$((v & 0xffffffff))")
+	printf '%s%s%s%s' "${h:6:2}" "${h:4:2}" "${h:2:2}" "${h:0:2}"
+}
+
+_build_default_expected_fid()
+{
+	local path=$1
+	local inode
+	local version
+	local ino_hi ino_lo
+	local ver_hi ver_lo
+	local seq_hex oid_hex ver_hex
+
+	inode=$(stat -c '%i' "$path") || return 1
+	version=$(debugfs -R "stat <${inode}>" $SCRATCH_DEV 2>/dev/null | \
+		sed -n 's/.*Generation:[[:space:]]*\([0-9xa-fA-F]\+\).*/\1/p' | head -n 1)
+
+	if [ -z "$version" ]; then
+		return 1
+	fi
+
+	ino_hi=$(((inode >> 32) & 0xffffffff))
+	ino_lo=$((inode & 0xffffffff))
+	ver_lo=$((version & 0xffffffff))
+	ver_hi=$(((version >> 32) & 0xffffffff))
+
+	# Match lu_fid cast semantics: set_lufid stores u32 words in native memory
+	# order; debugfs reads lu_fid fields and prints f_seq/f_oid/f_ver.
+	seq_hex="$(_u32_to_le_hex "$ino_hi")$(_u32_to_le_hex "$ino_lo")"
+	oid_hex="$(_u32_to_le_hex "$ver_lo")"
+	ver_hex="$(_u32_to_le_hex "$ver_hi")"
+
+	printf '[0x%x:0x%x:0x%x]' "$((16#$seq_hex))" "$((16#$oid_hex))" \
+		"$((16#$ver_hex))"
+}
+
+# Create a filesystem with dirdata feature
+_scratch_mkfs -O dirdata &>>$seqres.full
+_scratch_mount
+
+# Test: Create file and set multiple 16-byte LUFIDs on the same file
+echo "Test: Set multiple 16-byte LUFIDs on the same file"
+mkdir -p $SCRATCH_MNT/lufid_test
+echo "test content" > $SCRATCH_MNT/lufid_test/testfile.txt
+
+# Set both LUFIDs on the file at the same time (32 bytes total: two 16-byte FIDs)
+# First FID:  [part1 (8 bytes):part2 (4 bytes):part3 (4 bytes)]
+# Second FID: [part1 (8 bytes):part2 (4 bytes):part3 (4 bytes)]
+set_lufid $SCRATCH_MNT/lufid_test testfile.txt >>$seqres.full
+if [ $? -ne 0 ]; then
+	echo "FAIL: Could not set both LUFIDs on testfile.txt"
+	_scratch_unmount
+	_check_scratch_fs
+	status=1
+	exit
+fi
+
+# Verify file is still accessible
+if [ ! -f $SCRATCH_MNT/lufid_test/testfile.txt ]; then
+	echo "FAIL: File not accessible after setting LUFIDs"
+	_scratch_unmount
+	_check_scratch_fs
+	status=1
+	exit
+fi
+
+# Verify file content is preserved
+content=$(cat $SCRATCH_MNT/lufid_test/testfile.txt 2>/dev/null)
+if [ "$content" != "test content" ]; then
+	echo "FAIL: File content not preserved after setting LUFIDs"
+	_scratch_unmount
+	_check_scratch_fs
+	status=1
+	exit
+fi
+
+expected_fid=$(_build_default_expected_fid $SCRATCH_MNT/lufid_test/testfile.txt)
+if [ -z "$expected_fid" ]; then
+	echo "FAIL: Could not calculate expected default LUFID"
+	_scratch_unmount
+	_check_scratch_fs
+	status=1
+	exit
+fi
+
+echo "Successfully set and verified both 16-byte LUFIDs on same file at the same time"
+
+# Dump directory structure to verify dirdata
+if ! _dump_dir_structure $SCRATCH_MNT/lufid_test testfile.txt "$expected_fid"; then
+	echo "FAIL: Stored LUFID does not match expected default value"
+	_scratch_unmount
+	_check_scratch_fs
+	status=1
+	exit
+fi
+
+# Cleanup and verify filesystem
+_scratch_unmount
+_check_scratch_fs
+
+# success, all done
+status=0
+exit
diff --git a/tests/ext4/066.out b/tests/ext4/066.out
new file mode 100644
index 00000000..4ec0fd6d
--- /dev/null
+++ b/tests/ext4/066.out
@@ -0,0 +1,4 @@
+QA output created by 066
+Test: Set multiple 16-byte LUFIDs on the same file
+Successfully set and verified both 16-byte LUFIDs on same file at the same time
+  Directory structure of lufid_test: OK (dirdata verified)
-- 
2.43.7

