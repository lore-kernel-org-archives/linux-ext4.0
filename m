Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793713881;
	b=Q538xH6BuMCcUL8J8tOADQTwdGhHyyM9IF9ypNAc/WrxMZeiCxrM/gI3e61+AKmXSGfo
	 h4Pl+etPl9Z1KRbFq+B3AFIwfwpDoQArItBAxbYZXGVuZIb2VsT2gxP9nxoGS1YZz5t30
	 6JnPPQC6GbLRTZmudcLRd0RN901eM0FMkNPrMFfPSj8io943qIuOMnuqw7+KjxDye876q
	 iWxZqhbI3VSWDJ95wiy0olil4zyLNV1F8ZzWU4hjaDBzgbwaFbaC/NLzkpwUjDnhR8l7V
	 8swE4z3eVMFH+rsO5wYhd9kF7pEZDK6Opm+r1FH1s1TnpgFvKXvDYL5jrkI4poKn+uw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793713881;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:
	 X-Google-Original-From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=PXp20XL3Gp1jxPMTn0MCFAQ9adhBIzNFQfhJNEp9ekc=;
	b=VdWssTXGFrRm4BJpa9iKXndm+EIaYyNLc0MiXVmO9acPF9G7ULaKFhk3574e41FP1wxs
	 fE0d//tPGHWneKwG1XUqU6JrOa+7g5xWt4BLaCasCVtlW5wcdX9jYujpNwuneFZZWDnpb
	 PROshWw7fA4PK1Y1vrD4Glh3zyEA8QbAE2lYAa2qCZi3aVNn10cq1XWikaX7unK9Jk17w
	 K8mQxtY1bi2PttxvRGqP++VgVkM0bg8UtOGZuKqDAt1MMQSrCEiyrU4s76Rs7g7tXGrLl
	 pLi6VeU7gCXzalGtjgYxZjJ+rsFJPlA8p4mwv7lhCeSUyJvhDselR+aOVX0wt3ipgPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=yQeuLM5A;
	arc=none smtp.remote-ip=209.85.128.50
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60A1F6085093
	for <linux-ext4@vger.kernel.org>; Tue,  3 Nov 2026 13:51:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 60A1F6085093
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=yQeuLM5A
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4a218c463d1so28435135e9.0
        for <linux-ext4@vger.kernel.org>; Tue, 03 Nov 2026 05:51:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793713880; x=1794318680; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PXp20XL3Gp1jxPMTn0MCFAQ9adhBIzNFQfhJNEp9ekc=;
        b=yQeuLM5A4Fy/+MsAyJJA6AaYWq+mSHkK7nS0IQkQ3cKvke04mNTaUuhYfil7J5REHP
         zY+DtRriTHg7nuc42hy5XBGzBtwJEkf5waHUJM4xjXOUTc2BM/68QjOAlA2PfVWdnJ0D
         7Szazuhmyjzqcf0L09+gghBvUP1v8tLaJfZXNTnqSZVA5kn+QZ3bjm/08EALaHlouA4+
         axwC74n/I/B7Hq8S3fXHigbxFR/K08ZEBn7eH9oPIh8KjGohMsaC/nZU73XolWcy/zWZ
         46azwu0pWaPiwSSkxLiuhTfLuWR0puKq+L11feTLhtiKO/AooLwxINJghvjGtGeGaikp
         t7tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793713880; x=1794318680;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=PXp20XL3Gp1jxPMTn0MCFAQ9adhBIzNFQfhJNEp9ekc=;
        b=eBycP1iu3RPrm4LwG9NGY4dlKhjQvfYEbSzSOW7tBCHqAWr0nFWxzef/fuD7CzjT2D
         wSy9FWBHwlUqXccO2N6b5RX/4xMPitKdILr9ER9jRQZ1hQMHdIGBFY280baHXyJB+6hT
         39twSg4I04UAWJSZuEoYnouy1Uf5TYYUOzSXCZnd+hDAvufCIjED0wbVtes2NxoionDG
         SVESu7fLnR/oFUvSTIuCCNg/6IRZUXj1/DV6P70bA7kEgnqpTf+CKNeXUJ+CwMQ6Tfb9
         ScbNVjX5SxW47z+YEUYvdjuHGMNcdMo5HY0aTTZB0XI5gOAmNL48CTj0KhLQhF0m2lZi
         /W+w==
X-Gm-Message-State: APuU4Z8BAF2Y1fcuF1wXXs39Ie+fN8Mrt4RnSf0Vw8bA56n+yhgeZAOb
	/043FBBx8QSOOMT4s/sGxYtNOIWPtXmyj13XiI6OPxC7UZotwtlApSP2gsv0u0tBDKM=
X-Gm-Gg: AYBFou0pKficuL6M/Yt5TJ7W2698igTdsZ2RvgQ95pkubxJSu77BMV7gd7dc2JALzO3
	VpAGmW0qLqP3eyDS5AhqC2Zgl85w7KVJQG3kuN41sDCoo1+xqnNch4/qxeNqCy/R6hHB56hrbhs
	bIc5S47DAHD9yk24EKpucj5kCpVUQQdXQAeDMRaQwg5NebV24S10rE200llcBwN4VbPpv8wj+nl
	TcLQAKbApBOSBg09M9LROohdLYDa9wj/WG78HS1TQ1SyDA9Hmy90ssuO1T7z3Im7jIZA+LqbREp
	Bey5RniJqye8h0vlO4PSESuQuDM4Pjet5XmkIVEB3WcTLA8tsPHwwJ/Fhf0bNHE4CJpPBBCS6Rf
	Mx0IenPDl0S7eYvqmwID0MixQxx/oKU681l0x7qDK+yG3W2MLfqzG6TJfexSaXUGoka8K4mkaIS
	OT8GdnR8VIBRTp9z/49+hGoTcvepPI3EXKeS191V4Plb9ZOY5XRJ00L82F87jC5oxv/OuQ7Bx6f
	ikEfJ8k/cbNS6xBspOli0qdNAPNVDTMnJH6KVttiBY/meXfTpLRCCWSxtosR5QTsEm24xezz8CC
	cdR82093VngRDJsGF1UmDqzR1DMa6NYdNjWlkO20qBKerY89qj9TLvh2sXgJIwEyyCdTm09EAUA
	gQJr8Iw==
X-Received: by 2002:a05:600c:64c5:b0:4a2:150f:1613 with SMTP id 5b1f17b1804b1-4ac17a367edmr306727295e9.7.1793713879775;
        Tue, 03 Nov 2026 05:51:19 -0800 (PST)
Received: from Cluster2.powerhub ([2a0a:ef40:18b5:9e01:225:90ff:fefc:9ffe])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b2a96fc87fsm55320335e9.12.2026.11.03.05.51.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 05:51:19 -0800 (PST)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: fstests@vger.kernel.org
Cc: linux-ext4@vger.kernel.org,
	adilger.kernel@dilger.ca,
	ablagodarenko@thelustrecollective.com,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>
Subject: [RFC PATCH v6 5/8] ext4/066: verify LUFID dirdata operations
Date: Tue,  3 Nov 2026 13:51:01 +0000
Message-ID: <20261103135106.610169-6-ablagodarenko@thelustrecollective.com>
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

Test ext4 LUFID set/get operations on dirdata fields. This test
verifies that the EXT4_IOC_SET_LUFID ioctl can be used
to attach LUFID data to a directory entry and that `debugfs ls -lD`
can read this data.

Verification uses `debugfs ls -lD` to check for `fid:` markers,
indicating the presence of LUFID data in directory entries.

Signed-off-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>
---
 tests/ext4/066     | 159 +++++++++++++++++++++++++++++++++++++++++++++
 tests/ext4/066.out |   4 ++
 2 files changed, 163 insertions(+)
 create mode 100755 tests/ext4/066
 create mode 100644 tests/ext4/066.out

diff --git a/tests/ext4/066 b/tests/ext4/066
new file mode 100755
index 00000000..979d9f1e
--- /dev/null
+++ b/tests/ext4/066
@@ -0,0 +1,159 @@
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
+	local ino_lo
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
+	ino_lo=$((inode & 0xffffffff))
+	ver_lo=$((version & 0xffffffff))
+	ver_hi=$(((version >> 32) & 0xffffffff))
+
+	# Match lu_fid cast semantics: set_lufid stores u32 words in native memory
+	# order; debugfs reads lu_fid fields and prints f_seq/f_oid/f_ver.
+	# ext4 inode numbers are 32-bit so f_seq fits in 8 hex chars; avoid a
+	# 16-char $((16#...)) that would overflow for values >= 0x8000000000.
+	seq_hex="$(_u32_to_le_hex "$ino_lo")"
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
+$SET_LUFID_PROG $SCRATCH_MNT/lufid_test testfile.txt >>$seqres.full
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
2.52.0

